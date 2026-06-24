"""
Experiment: evaluate whether queries are mapped to the correct course using the FAISS index.
Measures accuracy (at least one ground-truth course in the top-k results).
"""

from index_creator import IndexCreator
from query_corpus_loader import QueryLoader
from config import CORPUS_QUESTION_ALIGNMENT
from tqdm import tqdm
import sys


def evaluate_query_course_matching(indexer: IndexCreator, query_loader: QueryLoader, k: int = 3, debug: bool = False):
    """Evaluate query-to-course matching accuracy.

    A query is considered correctly matched if at least one of the ground-truth courses
    appears in the top-k results returned by the FAISS index.

    Returns:
        A dict with accuracy, total, and correct counts.
    """
    queries = query_loader.load_queries()
    correct = 0
    total = 0

    for query in tqdm(queries, desc=f"Query-course matching @{k}"):
        results = indexer.get_topk_matching_course(query['query'], k=k)
        gt = query['course']
        matched = set(results.keys()) & set(gt)
        hit = len(matched) > 0
        if hit:
            correct += 1
        total += 1

        if debug:
            status = "HIT" if hit else "MISS"
            print(f"\n  [{status}] {query['query']}")
            print(f"    GT courses:  {', '.join(gt)}")
            print(f"    Top-{k}:      {', '.join(f'{c} ({s:.4f})' for c, s in results.items())}")
            if matched:
                print(f"    Matches:     {', '.join(sorted(matched))}")

    accuracy = correct / total if total > 0 else 0.0
    return {"accuracy": accuracy, "correct": correct, "total": total}


DEBUG = True

if __name__ == "__main__":
    debug = DEBUG or "--debug" in sys.argv

    indexer = IndexCreator()
    query_loader = QueryLoader(CORPUS_QUESTION_ALIGNMENT)

    Ks = [1, 3, 5]

    print(f"\n=== Query-Course Matching Accuracy ({len(query_loader.queries)} queries) ===")
    for k in Ks:
        result = evaluate_query_course_matching(indexer, query_loader, k=k, debug=debug)
        print(f"  Accuracy@{k}: {result['accuracy']:.4f}  ({result['correct']}/{result['total']})")
