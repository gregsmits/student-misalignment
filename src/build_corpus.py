"""
Build an extended evaluation corpus by generating misaligned query-course pairs.
For each aligned query, finds courses at prerequisite distance >= 2 from the
query's aligned course and creates misaligned entries.
"""

import csv
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))

import kg_query
from config import COURSES_TO_IGNORE

ALIGNED_CORPUS = os.path.join(os.path.dirname(__file__), "..", "data", "queries", "aligned_queries.csv")
MIN_PREREQUISITE_DISTANCE = 2


def load_aligned_queries(filepath: str) -> list[dict]:
    rows = []
    with open(filepath, "r") as f:
        reader = csv.reader(f, delimiter=";")
        for row in reader:
            if len(row) < 4:
                continue
            rows.append({
                "timestamp": row[0],
                "query": row[1],
                "course": row[2].strip(),
                "misalignment": row[3].strip(),
            })
    return rows


def find_distant_courses(course_id: str, min_distance: int = MIN_PREREQUISITE_DISTANCE) -> list[tuple[str, int]]:
    """Find courses that come after course_id in the curriculum at distance >= min_distance."""
    dependents = kg_query.get_dependent_courses_ids_with_distances(course_id)
    return [
        (cid, dist) for cid, dist in dependents.items()
        if dist >= min_distance and cid not in COURSES_TO_IGNORE
    ]


if __name__ == "__main__":
    queries = load_aligned_queries(ALIGNED_CORPUS)
    print(f"Loaded {len(queries)} aligned queries.\n")

    print(f"{'QUERY':<80} | {'ALIGNED COURSE':<35} | {'MISALIGNED COURSE':<35} | DIST")
    print("-" * 190)

    misaligned_count = 0
    for q in queries:
        distant = find_distant_courses(q["course"])
        for cid, dist in sorted(distant, key=lambda x: x[1]):
            print(f"{q['query'][:80]:<80} | {q['course']:<35} | {cid:<35} | {dist}")
            misaligned_count += 1

    print(f"\nGenerated {misaligned_count} misaligned pairs from {len(queries)} aligned queries.")
