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
from config import CORPUS_QUESTION_ALIGNMENT, LLM_ENDPOINT, CHAT_MODEL, TEMPERATURE, logger
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

def detect_misalignment_kg(query: str, ongoing_courses: list[str], indexer: IndexCreator, debug: bool = False) -> bool | None:
    """Detect misalignment using the KG-based approach.
    Extracts KCs from the query via the FAISS index, finds the most similar course in the KG,
    then computes a misalignment score based on prerequisite distance and KC overlap.
    Returns True if aligned (score == 0), False if misaligned, None if undetermined.
    """
    kcq = extract_kcs_kg_based(query, indexer, top_k=15)
    if len(kcq) == 0:
        print(f"No KCs extracted for query \"{query}\". Unable to determine alignment.") if debug else None
        return 666  # Undetermined

    print(f"Extracted KCs for query '{query}': {kcq}") if debug else None

    maxcourse = None
    maxsim = -1
    for cid, label in kg_query.get_all_courses():
        kcc = kg_query.course_to_notions(cid)
        sim = fuzzy_jacquard_similarity(kcq, kcc)
        if maxcourse is None or sim > maxsim:
            maxcourse = cid
            maxsim = sim

    dist_prereq_max = kg_query.get_prerequisite_courses_ids_with_distances(maxcourse)
    
    print(f"  Most similar course: {maxcourse} (sim={maxsim:.4f})") if debug else None
    print(f"\t - Prerequisite distances for {maxcourse}: {dist_prereq_max}") if debug else None
    misalign = None
    for course_id in ongoing_courses:
        course_kcs = kg_query.course_to_notions(course_id)
        print(f"  Comparing with ongoing course {course_id}: KCs={course_kcs}") if debug else None

        align_ongoing = fuzzy_jacquard_similarity(kcq, course_kcs)
        if align_ongoing == 0:
            print(f"  No KC overlap with {course_id}, skipping.") if debug else None
            continue

        dist_prereq = kg_query.get_prerequisite_courses_ids_with_distances(course_id)
        
        prepos = None
        if maxcourse in dist_prereq:
            prepos = (- dist_prereq[maxcourse] / max(dist_prereq.values())) if dist_prereq[maxcourse] > 0 else 0
        elif course_id in dist_prereq_max:
            prepos = (dist_prereq_max[course_id] / max(dist_prereq_max.values())) if dist_prereq_max[course_id] > 0 else 0

        print(f"  Course {course_id}: align={align_ongoing:.4f}, prepos={prepos}") if debug else None

        if prepos is not None:
            score = prepos * math.fabs(align_ongoing - fuzzy_jacquard_similarity(kcq, kg_query.course_to_notions(maxcourse)))
            misalign = score if misalign is None or (misalign != 0 and score < misalign) else misalign 
            
        print(f"  Current misalignment score: {misalign}") if debug else None

    print(f"  Misalignment score: {misalign}") if debug else None

    #return true in cas of alignment
    return misalign is not None or misalign == 0.0


# -- Method 2: LLM-based alignment --

def _build_system_context(ongoing_courses: list[str]) -> str:
    courses_str = ", ".join(ongoing_courses)
    return (
        f"Tu es un assistant pédagogique. Les cours actuellement suivis par l'étudiant sont : {courses_str}. "
        f"Tu dois déterminer si la question posée par l'étudiant est en lien avec ces cours (aligned) ou hors sujet (misaligned)."
    )


def detect_misalignment_llm_zeroshot(query: str, ongoing_courses: list[str]) -> bool | None:
    """Zero-shot: ask the LLM directly."""
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
    
    
    for query in tqdm(queries[:30], desc=method):
        ongoing_courses = query["course"]
        gt_aligned = query["misalignment"].strip() == "non"

        print(f"\n*******\nEvaluating query: \"{query['query'][:80]}\" with ongoing courses: {ongoing_courses}") if debug else None

        if method == "KG-based":
            predicted_aligned = detect_misalignment_kg(query["query"], ongoing_courses, indexer, debug=debug) != 0.0
        else:
            llm_fn = STRATEGIES[method]
            predicted_aligned = llm_fn(query["query"], ongoing_courses)

        print(f"Predicted aligned: {predicted_aligned}, Ground truth aligned: {gt_aligned}") if debug else None

        if predicted_aligned == 666:
            continue  # Skip if the prediction is undetermined (None)
        #for adv handling
        
        

        if predicted_aligned and gt_aligned:
            tp += 1
        elif predicted_aligned and not gt_aligned:
            print(f"  [FP] \"{query['query'][:80]}\" → predicted=aligned, gt=misaligned") if debug else None
            fp += 1
        elif not predicted_aligned and gt_aligned:
            print(f"  [FN] \"{query['query'][:80]}\" → predicted=misaligned, gt=aligned") if debug else None    
            fn += 1
        else:
            tn += 1

        if debug:
            status = "OK" if (predicted_aligned == gt_aligned) else "WRONG"
            print(f"  [{status}] \"{query['query'][:80]}\" → predicted={'aligned' if predicted_aligned else 'misaligned'}, gt={'aligned' if gt_aligned else 'misaligned'}")

    recall = tp / (tp + fn) if (tp + fn) > 0 else 0.0
    precision = tp / (tp + fp) if (tp + fp) > 0 else 0.0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0.0

    return {"recall": recall, "precision": precision, "f1": f1, "tp": tp, "fp": fp, "tn": tn, "fn": fn}


if __name__ == "__main__":
    debug = "--debug" in sys.argv

    
       
    indexer = IndexCreator()
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
