"""
Experiment: evaluate whether a student's query is aligned with the ongoing courses.
Two approaches:
  1. KG-based: extract KCs from the query via the FAISS index, then quantify alignment using the KG structure.
  2. LLM-based: prompt the CHAT_MODEL (zero-shot, few-shot, chain-of-thought, self-reflection) to classify alignment.
Metrics: recall, precision, F1-score.
"""

from index_creator import IndexCreator
from query_corpus_loader import QueryLoader
from kc_extractor import extract_kcs_kg_based
from config import CORPUS_QUESTION_ALIGNMENT, ALIGNMENT_THRESHOLD, LLM_ENDPOINT, CHAT_MODEL, TEMPERATURE, logger
from tqdm import tqdm
import requests
import json
import sys
import kg_query
import math


def fuzzy_jacquard_similarity(kcq: dict[str, float], kcc: dict[str, float]) -> float:
    """Calculate the fuzzy Jacquard similarity between two sets of key concepts."""
    intersection = sum(min(kcq.get(n, 0), kcc.get(n, 0)) for n in set(kcq) & set(kcc))
    union = sum(max(kcq.get(n, 0), kcc.get(n, 0)) for n in set(kcq) | set(kcc))
    return intersection / union if union > 0 else 0.0


def call_llm(prompt: str) -> str:
    """Call the Ollama chat API and return the raw text response."""
    data = {
        "model": CHAT_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "format": "json",
        "stream": False,
        "options": {"temperature": TEMPERATURE},
    }
    try:
        resp = requests.post(LLM_ENDPOINT, json=data, timeout=120)
        if resp.status_code != 200:
            logger.error(f"LLM API error {resp.status_code}: {resp.text}")
            return ""
        return resp.json().get("message", {}).get("content", "")
    except Exception as e:
        logger.error(f"LLM call failed: {e}")
        return ""


def parse_llm_alignment(raw: str) -> bool | None:
    """Parse the LLM JSON response to extract the alignment decision."""
    try:
        parsed = json.loads(raw)
        answer = parsed.get("aligned", parsed.get("result", parsed.get("answer", "")))
        if isinstance(answer, bool):
            return answer
        answer = str(answer).strip().lower()
        if answer in ("oui", "yes", "true", "aligned", "1"):
            return True
        if answer in ("non", "no", "false", "misaligned", "0"):
            return False
    except Exception:
        pass
    return None


# -- Method 1: KG-based alignment --

def quantify_alignment(query: str, ongoing_courses: list[str], indexer: IndexCreator, debug: bool = False) -> float:
    """Quantify alignment between a query and ongoing courses using gradual inclusion.
    Returns the maximum over ongoing courses of the degree to which the query KCs
    are included in the course KCs (through its sections). Result in [0, 1].
    """
    kcq = extract_kcs_kg_based(query, indexer)

    if debug:
        print(f"Extracted KCs for query '{query}':")
        for kc in kcq:
            info = kg_query.get_notion_by_id(kc)
            label = info["label"] if info else "Unknown"
            print(f"  KC: {kc} ({label}), weight={kcq[kc]:.4f}")
            
    if not kcq:
        return ValueError("No KCs extracted from the query. Cannot quantify alignment.")

    sum_kcq = sum(kcq.values())

    #Maximum inclusion in ongoing courses
    max_inclusion = 0.0
    max_inclusion_course = None
    notcompared=True
    for course_id in ongoing_courses:
        kcc = kg_query.get_notion_weights_for_course(course_id)
        if len(kcc) == 0:
            print(f"  No KCs found for course {course_id}, skipping.") if debug else None
            continue
        else:
            print(f"  KCs for course {course_id}: {kcc}") if debug else None
            notcompared=False
        inclusion = sum(min(kcq[n], kcc.get(n, 0.0)) for n in kcq) / sum_kcq

        if debug:
            print(f"  Course {course_id} : inclusion={inclusion:.4f}")
            for kc in kcc:
                if kc in kcq:
                    info = kg_query.get_notion_by_id(kc)
                    label = info["label"] if info else "Unknown"
                    print(f"    KC: {kc} ({label}), query_weight={kcq[kc]:.4f}, course_weight={kcc[kc]:.4f}, min={min(kcq[kc], kcc[kc]):.4f}")
        if inclusion > max_inclusion:
            max_inclusion_course = course_id
            max_inclusion = inclusion

    #maximum inclusion in all courses
    all_courses = kg_query.get_all_courses()
    max_inclustion_all_courses = 0.0
    max_inclusion_all_courses_course = None
    for course_id in all_courses: 
        if course_id in ongoing_courses:
            continue  # Already considered
        kcc = kg_query.get_notion_weights_for_course(course_id)
        if len(kcc) == 0:
            continue
        inclusion = sum(min(kcq[n], kcc.get(n, 0.0)) for n in kcq) / sum_kcq
        if inclusion > max_inclustion_all_courses:
            max_inclusion_all_courses = inclusion
            max_inclusion_all_courses_course = course_id

    #check prerequisite position between max_inclusion_course and max_inclusion_all_courses_course
    prepos = 0
    
    if max_inclusion_course and max_inclusion_all_courses_course:
        if max_inclusion_course == max_inclusion_all_courses_course:
            prepos = 0
        else:
            #get prerequisites for max_inclusion_all_courses_course
            

            prereqs2 = kg_query.get_prerequisite_courses_ids_with_distances(max_inclusion_course)
            if max_inclusion_course_all_courses_course in prereqs:
                prepos = -((prereqs2[max_inclusion_all_courses_course]) / max(prereqs2.values()))
            else:
                prereqs = kg_query.get_prerequisite_courses_ids_with_distances(max_inclusion_all_courses_course)
                if max_inclusion_course in prereqs:
                    prepos = (prereqs[max_inclusion_course]) / max(prereqs.values())
                else:
                    return None

    res = prepos * abs(max_inclusion - max_inclustion_all_courses)
    print(f"  Max inclusion in ongoing courses: {max_inclusion:.4f} (course: {max_inclusion_course})") if debug else None
    print(f"  Max inclusion in all courses: {max_inclustion_all_courses:.4f} (course: {max_inclusion_all_courses_course})") if debug else None
    print(f"  Prerequisite position factor: {prepos:.4f}") if debug else None   
    print(f"  Final alignment score: {res:.4f}") if debug else None
    return res


# -- Method 2: LLM-based alignment --

def _build_system_context(ongoing_courses: list[str]) -> str:
    courses_str = ", ".join(ongoing_courses)
    return (
        f"Tu es un assistant pédagogique. Les cours actuellement suivis par l'étudiant sont : {courses_str}. "
        f"Tu dois déterminer si la question posée par l'étudiant est en lien avec ces cours (aligned) ou hors sujet (misaligned)."
    )


def detect_misalignment_llm_zeroshot(query: str, ongoing_courses: list[str]) -> bool | None:
    """Zero-shot: ask the LLM directly.
    returns oui, non, adv"""
    context = _build_system_context(ongoing_courses)
    prompt = (
        f"{context}\n\n"
        f"Question de l'étudiant : \"{query}\"\n\n"
        f"La question est-elle en lien avec les cours en cours ? "
        f"Réponds en JSON : {{\"aligned\": true}} ou {{\"aligned\": false}}"
    )
    return parse_llm_alignment(call_llm(prompt))


def detect_misalignment_llm_fewshot(query: str, ongoing_courses: list[str]) -> bool | None:
    """Few-shot: provide examples before asking."""
    context = _build_system_context(ongoing_courses)
    prompt = (
        f"{context}\n\n"
        f"Voici des exemples :\n"
        f"- Question : \"Comment définir une entité JPA ?\" → {{\"aligned\": true}}\n"
        f"- Question : \"Quel est le meilleur restaurant près du campus ?\" → {{\"aligned\": false}}\n"
        f"- Question : \"Comment fonctionne @ManyToOne ?\" → {{\"aligned\": true}}\n"
        f"- Question : \"Peux-tu m'expliquer la relativité générale ?\" → {{\"aligned\": false}}\n\n"
        f"Question de l'étudiant : \"{query}\"\n\n"
        f"Réponds en JSON : {{\"aligned\": true}} ou {{\"aligned\": false}}"
    )
    return parse_llm_alignment(call_llm(prompt))


def detect_misalignment_llm_cot(query: str, ongoing_courses: list[str]) -> bool | None:
    """Chain-of-thought: ask the LLM to reason step by step."""
    context = _build_system_context(ongoing_courses)
    prompt = (
        f"{context}\n\n"
        f"Question de l'étudiant : \"{query}\"\n\n"
        f"Raisonne étape par étape :\n"
        f"1. Identifie le sujet principal de la question.\n"
        f"2. Compare-le aux thèmes des cours en cours.\n"
        f"3. Conclus si la question est alignée ou non.\n\n"
        f"Donne ta réponse finale en JSON : {{\"aligned\": true/false, \"reasoning\": \"...\"}}"
    )
    return parse_llm_alignment(call_llm(prompt))


def detect_misalignment_llm_self_reflection(query: str, ongoing_courses: list[str]) -> bool | None:
    """Self-reflection: ask the LLM to answer, then reconsider."""
    context = _build_system_context(ongoing_courses)
    prompt = (
        f"{context}\n\n"
        f"Question de l'étudiant : \"{query}\"\n\n"
        f"Étape 1 : Donne une première réponse sur l'alignement de la question avec les cours.\n"
        f"Étape 2 : Réfléchis à nouveau. Y a-t-il un lien indirect que tu aurais manqué ? "
        f"Le sujet pourrait-il être un prérequis ou une extension des cours en cours ?\n"
        f"Étape 3 : Donne ta réponse finale.\n\n"
        f"N'inclus pas ton raisonnement dans la réponse. "
        f"Réponds uniquement en JSON : {{\"aligned\": true/false}}"
    )
    return parse_llm_alignment(call_llm(prompt))


STRATEGIES = {
    "KG-based": None,
    # "LLM zero-shot": detect_misalignment_llm_zeroshot,
    # "LLM few-shot": detect_misalignment_llm_fewshot,
    # "LLM chain-of-thought": detect_misalignment_llm_cot,
    # "LLM self-reflection": detect_misalignment_llm_self_reflection,
}


# -- Evaluation --

def evaluate_misalignment(
    method: str,
    query_loader: QueryLoader,
    indexer: IndexCreator = None,
    debug: bool = False,
) -> dict:
    """Evaluate a misalignment detection method. Returns dict with recall, precision, f1, and confusion counts."""
    queries = query_loader.load_queries()
    tp, fp, tn, fn = 0, 0, 0, 0
    
    
    for query in tqdm(queries, desc=method):
        ongoing_courses = query["course"]
        gt_aligned = query["misalignment"].strip()
        predicted_aligned = None
    
        print(f"\n*******\nEvaluating query: \"{query['query'][:80]}\" with ongoing courses: {ongoing_courses}") if debug else None

        if method == "KG-based":
            try:
                alignment_score = quantify_alignment(query["query"], ongoing_courses, indexer, debug=debug)
                if alignment_score == 0:
                    predicted_aligned = "non"
                elif alignment_score > 0:
                    predicted_aligned = "adv"
                else:
                    predicted_aligned = "oui"

            except ValueError as e:
                printf(f"Error for query {query} : {e}")
                continue
        else:
            llm_fn = STRATEGIES[method]
            predicted_aligned = llm_fn(query["query"], ongoing_courses)#should return oui, non, adv or None

        print(f"Predicted aligned: {predicted_aligned}, Ground truth aligned: {gt_aligned}") if debug else None

     
        accurate_mis = 0
        accurate_align = 0
        accurate_adv = 0
        nb_oui
        if predicted_aligned is not None:
            if predicted_aligned and gt_aligned:
               
                if gt_aligned == "oui":
                    accuracy_oui += 1
                elif gt_aligned == "non":
                    accuracy_non += 1
                else:
                    accuracy_adv += 1

    recall = tp / (tp + fn) if (tp + fn) > 0 else 0.0
    precision = tp / (tp + fp) if (tp + fp) > 0 else 0.0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0.0

    return {"recall": recall, "precision": precision, "f1": f1, "tp": tp, "fp": fp, "tn": tn, "fn": fn}


if __name__ == "__main__":
    debug = "--debug" in sys.argv

    if 1:
        METHOD = None#"kg-based"  # or None to run all the methods
        QUERY= "Quelle annotation JPA permet de modifier le nom de la colonne qui mappe un attribut d'une entité?"
        ONGOING_COURSES = ["lecture_jpa"]

    indexer = IndexCreator()

    if METHOD is not None:
        #just evaluate one method on one query
       print( quantify_alignment(QUERY, ONGOING_COURSES, indexer, debug=debug))
    

    else:
        query_loader = QueryLoader(CORPUS_QUESTION_ALIGNMENT)

        methods = list(STRATEGIES.keys())
        results = {}

        for method in methods:
            print(f"\n{'='*60}")
            print(f"Evaluating: {method}")
            print(f"{'='*60}")
            metrics = evaluate_misalignment(method, query_loader, indexer=indexer, debug=debug)
            results[method] = metrics
            print(f"  Recall: {metrics['recall']:.4f}  Precision: {metrics['precision']:.4f}  F1: {metrics['f1']:.4f}")
            print(f"  TP={metrics['tp']}  FP={metrics['fp']}  TN={metrics['tn']}  FN={metrics['fn']}")

        print(f"\n{'='*60}")
        print("Misalignment Detection — Summary")
        print(f"{'='*60}")
        print(f"{'Method':<25} | {'Recall':>8} | {'Precision':>9} | {'F1':>8}")
        print("-" * 60)
        for method in methods:
            m = results[method]
            print(f"{method:<25} | {m['recall']:>8.4f} | {m['precision']:>9.4f} | {m['f1']:>8.4f}")
