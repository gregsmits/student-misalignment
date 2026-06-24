"""
Experiment: evaluate KC extraction methods against expert-annotated ground truth.
Compares all strategies from kc_extractor.py using Hit@k and NDCG@k.
"""

from index_creator import IndexCreator
from nlp_courses_kg_indexer import NLP_Courses_KG_Indexer
from kc_extractor import extract_kcs, STRATEGIES
from config import CORPUS_QUESTION_KC_MAPPING
import kg_query
from tqdm import tqdm
import time
import re


def load_kc_corpus(filepath: str) -> list[dict]:
    """Parse the KC mapping corpus (alternating lines: query row, then KC=[...] row)."""
    queries = []
    with open(filepath, "r") as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].strip()
        # skip header and empty lines
        if not line or line.startswith("timestamp;") or line.startswith("KCTYPES="):
            i += 1
            continue
        # query line: timestamp;question;course1;course2;course3
        parts = line.split(";")
        if len(parts) < 3:
            i += 1
            continue
        query_text = parts[1]
        courses = [c.strip() for c in parts[2:] if c.strip()]
        # next line should be KC=[...]
        i += 1
        if i < len(lines):
            kc_line = lines[i].strip()
            kc_match = re.match(r'KC=\[(.+)\]', kc_line)
            if kc_match:
                kc_labels = [kc.strip() for kc in kc_match.group(1).split(",")]
                queries.append({
                    "query": query_text,
                    "courses": courses,
                    "kc_labels": kc_labels,
                })
        i += 1
    return queries


def build_label_to_id_map() -> dict[str, str]:
    """Build a mapping from notion label (lowercased) to notion id from the KG."""
    label_to_id = {}
    for nid, nlabel in kg_query.get_all_notions():
        label_to_id[nlabel.strip().lower()] = nid
    return label_to_id


def build_id_to_label_map() -> dict[str, str]:
    """Build a mapping from notion id to notion label from the KG."""
    id_to_label = {}
    for nid, nlabel in kg_query.get_all_notions():
        id_to_label[nid] = nlabel.strip().lower()
    return id_to_label


def calculate_hit_rate(gt: set[str], results: list[str], k: int) -> float:
    top_k = results[:k]
    hits = sum(1 for r in top_k if r in gt)
    return hits / len(gt) if gt else 0.0


def calculate_ndcg_at(gt: set[str], results: list[str], k: int) -> float:
    dcg = 0.0
    for i, r in enumerate(results[:k]):
        if r in gt:
            dcg += 1.0 / (i + 1)
    idcg = sum(1.0 / (i + 1) for i in range(min(k, len(gt))))
    return dcg / idcg if idcg > 0 else 0.0


def evaluate_method(
    method: str,
    queries: list[dict],
    id_to_label: dict[str, str],
    indexer: IndexCreator,
    nlp_indexer: NLP_Courses_KG_Indexer,
    k: int,
    debug: bool = False,
) -> tuple[float, float, float, float, float]:
    """Evaluate a single method at a given k. Returns (mean_hit, std_hit, mean_ndcg, std_ndcg, mean_time)."""
    hit_rates = []
    ndcg_scores = []
    total_time = 0.0

    for q in tqdm(queries, desc=f"{method} @{k}", leave=False):
        gt_labels = set(label.strip().lower() for label in q["kc_labels"])

        start = time.time()
        extracted = extract_kcs(q["query"], method, indexer=indexer, nlp_indexer=nlp_indexer)
        total_time += time.time() - start

        if extracted is None:
            if debug:
                print(f"\n  Query: {q['query']}")
                print(f"    GT KCs:        {', '.join(sorted(gt_labels))}")
                print(f"    Extracted KCs: (none — extraction failed)")
            continue

        ranked = sorted(extracted.items(), key=lambda x: x[1], reverse=True)
        ranked_labels = [id_to_label.get(nid, nid).lower() for nid, _ in ranked]

        hit = calculate_hit_rate(gt_labels, ranked_labels, k)
        ndcg = calculate_ndcg_at(gt_labels, ranked_labels, k)
        hit_rates.append(hit)
        ndcg_scores.append(ndcg)

        if debug:
            matched = gt_labels & set(ranked_labels[:k])
            print(f"\n  Query: {q['query']}")
            print(f"    GT KCs:        {', '.join(sorted(gt_labels))}")
            print(f"    Extracted KCs: {', '.join(f'{label} ({w:.4f})' for (nid, w), label in zip(ranked[:k], ranked_labels[:k]))}")
            print(f"    Matches:       {', '.join(sorted(matched)) if matched else '(none)'}")
            print(f"    Hit@{k}={hit:.4f}  NDCG@{k}={ndcg:.4f}")

    n = len(hit_rates)
    if n == 0:
        return (0.0, 0.0, 0.0, 0.0, 0.0)

    mean_hit = sum(hit_rates) / n
    mean_ndcg = sum(ndcg_scores) / n
    std_hit = (sum((x - mean_hit) ** 2 for x in hit_rates) / n) ** 0.5
    std_ndcg = (sum((x - mean_ndcg) ** 2 for x in ndcg_scores) / n) ** 0.5
    mean_time = total_time / n
    return (mean_hit, std_hit, mean_ndcg, std_ndcg, mean_time)


if __name__ == "__main__":
    import sys
    DEBUG = "--debug" in sys.argv

    print("Loading index and KG metadata...")
    indexer = IndexCreator()
    nlp_indexer = NLP_Courses_KG_Indexer()
    id_to_label = build_id_to_label_map()

    print(f"Loading KC corpus from {CORPUS_QUESTION_KC_MAPPING}...")
    queries = load_kc_corpus(CORPUS_QUESTION_KC_MAPPING)
    print(f"Loaded {len(queries)} queries with expert KC annotations.\n")

    methods = list(STRATEGIES.keys())
    Ks = [4, 7, 10]

    results = {}
    for method in methods:
        for k in Ks:
            print(f"Evaluating: {method} @ K={k}")
            metrics = evaluate_method(method, queries, id_to_label, indexer, nlp_indexer, k, debug=DEBUG)
            results[(method, k)] = metrics
            mean_hit, std_hit, mean_ndcg, std_ndcg, mean_time = metrics
            print(f"  Hit@{k} = {mean_hit:.4f} ± {std_hit:.4f}  |  NDCG@{k} = {mean_ndcg:.4f} ± {std_ndcg:.4f}  |  Time = {mean_time:.4f}s")
        print()

    print("\n" + "=" * 80)
    print("Summary table")
    print("=" * 80)
    header = f"{'Method':<40}"
    for k in Ks:
        header += f" | {'Hit@'+str(k):>10} {'NDCG@'+str(k):>10}"
    print(header)
    print("-" * len(header))
    for method in methods:
        row = f"{method:<40}"
        for k in Ks:
            m = results[(method, k)]
            row += f" | {m[0]:>10.4f} {m[2]:>10.4f}"
        print(row)
