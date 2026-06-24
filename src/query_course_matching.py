"""
Experiment: evaluate query-course matching.
For each query, retrieves the top-k matching courses from the FAISS index
and compares against the expert ground truth using Hit@k and NDCG@k.
"""

from index_creator import IndexCreator
from query_corpus_loader import QueryLoader
from config import CORPUS_QUESTION_ALIGNMENT
from tqdm import tqdm
import sys


def calculate_hit_rate(gt: list[str], results: dict[str, float], k: int) -> float:
    hits = sum(1 for course in list(results.keys())[:k] if course in gt)
    return hits / len(gt) if gt else 0.0


def calculate_ndcg_at(gt: list[str], results: dict[str, float], k: int) -> float:
    dcg = 0.0
    idcg = 0.0
    ranked_results = list(results.items())[:k]
    for i in range(min(k, len(ranked_results))):
        if ranked_results[i][0] in gt:
            dcg += 1 / (i + 1)
    for i in range(min(k, len(gt))):
        idcg += 1 / (i + 1)
    return dcg / idcg if idcg > 0 else 0.0


def get_most_matching_course(query: str, indexer: IndexCreator) -> str:
    results = indexer.get_topk_matching_course(query)
    if results:
        return max(results, key=results.get)
    return None


def evaluate_query_course_matching(indexer: IndexCreator, query_loader: QueryLoader, debug: bool = False, fault: bool = False) -> dict:
    """Returns dict with mean_hit, std_hit, mean_ndcg, std_ndcg, n."""
    queries = query_loader.load_queries()
    hit_rates = []
    ndcg_scores = []

    for query in tqdm(queries, desc="Query-course matching"):
        results = indexer.get_topk_matching_course(query['query'])
        gt = query['course']
        k = len(results)

        hit = calculate_hit_rate(gt, results, k)
        ndcg = calculate_ndcg_at(gt, results, k)
        hit_rates.append(hit)
        ndcg_scores.append(ndcg)

        matched = set(results.keys()) & set(gt)
        show = debug or (fault and len(matched) == 0)
        if show:
            print(f"\n  Query: {query['query']}")
            print(f"    GT courses:    {', '.join(gt)}")
            print(f"    Top-{k} results: {', '.join(f'{c} ({s:.4f})' for c, s in results.items())}")
            print(f"    Matches:       {', '.join(sorted(matched)) if matched else '(none)'}")
            print(f"    Hit@{k}={hit:.4f}  NDCG@{k}={ndcg:.4f}")

    n = len(hit_rates)
    if n == 0:
        print("No queries evaluated.")
        return {"mean_hit": 0.0, "std_hit": 0.0, "mean_ndcg": 0.0, "std_ndcg": 0.0, "n": 0}

    mean_hit = sum(hit_rates) / n
    mean_ndcg = sum(ndcg_scores) / n
    std_hit = (sum((x - mean_hit) ** 2 for x in hit_rates) / n) ** 0.5
    std_ndcg = (sum((x - mean_ndcg) ** 2 for x in ndcg_scores) / n) ** 0.5

    return {"mean_hit": mean_hit, "std_hit": std_hit, "mean_ndcg": mean_ndcg, "std_ndcg": std_ndcg, "n": n}


if __name__ == "__main__":
    debug = "--debug" in sys.argv
    fault = "--fault" in sys.argv

    indexer = IndexCreator()
    query_loader = QueryLoader(CORPUS_QUESTION_ALIGNMENT)

    metrics = evaluate_query_course_matching(indexer, query_loader, debug=debug, fault=fault)
    print(f"\n=== Query-Course Matching Results ({metrics['n']} queries) ===")
    print(f"  Hit rate:  {metrics['mean_hit']:.4f} ± {metrics['std_hit']:.4f}")
    print(f"  NDCG:      {metrics['mean_ndcg']:.4f} ± {metrics['std_ndcg']:.4f}")
