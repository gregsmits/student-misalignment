"""
KC (Key Concept / Notion) extraction strategies.
Each function takes a query string and returns a dict[str, float] mapping notion_id to weight.
"""

from index_creator import IndexCreator
from nlp_courses_kg_indexer import NLP_Courses_KG_Indexer
import kg_query


def extract_kcs_kg_based(query: str, indexer: IndexCreator, top_k: int = 15, debug = False) -> dict[str, float]:
    """Extract KCs using the FAISS index and the KG"""
    results = indexer.get_topk_matching_course(query)
    print(f"Top {top_k} matching courses for query \"{query}\": {results}") if debug else None
    notion_weights = kg_query.get_cached_notion_weights()
    for course in results:
        print(f"Course: {course}, Weight: {results[course]}") if debug else None
        print(f"Notion weights for course {course}: {notion_weights.get(course, {})}") if debug else None
    notions = {}

    for course in results:
        print(f"Course: {course}, Weight: {results[course]}") if debug else None
        print(f"Notion weights for course {course}: {notion_weights.get(course, {})}") if debug else None
        for notion, weight in notion_weights.get(course, {}).items():
            if notion not in notions:
                notions[notion] = 0
            notions[notion] = max(notions[notion], weight * results[course])
    res = dict(sorted(notions.items(), key=lambda x: x[1], reverse=True)[:top_k])
    print(f"Top {top_k} notions for query \"{query}\": {res}") if debug else None
    return res

def extract_kcs_nlp_string_similarity(query: str, nlp_indexer: NLP_Courses_KG_Indexer) -> dict[str, float]:
    """Extract KCs via fuzzy string matching between query and notion labels."""
    return nlp_indexer.query_to_notions_string_search(query)


def extract_kcs_nlp_prompt(query: str, nlp_indexer: NLP_Courses_KG_Indexer) -> dict[str, float]:
    """Extract KCs via a direct LLM prompt."""
    return nlp_indexer.query_to_notions_prompt_based(query, mode="default")


def extract_kcs_nlp_prompt_cot(query: str, nlp_indexer: NLP_Courses_KG_Indexer) -> dict[str, float]:
    """Extract KCs via an LLM prompt with chain-of-thought reasoning."""
    return nlp_indexer.query_to_notions_prompt_based(query, mode="cot")


def extract_kcs_nlp_prompt_self_reflection(query: str, nlp_indexer: NLP_Courses_KG_Indexer) -> dict[str, float]:
    """Extract KCs via an LLM prompt with self-reflection."""
    return nlp_indexer.query_to_notions_prompt_based(query, mode="self-reflection")


STRATEGIES = {
    #"KG-based": extract_kcs_kg_based,
    #"NLP-based string similarity": extract_kcs_nlp_string_similarity,
    "NLP-based prompt": extract_kcs_nlp_prompt,
    # "NLP-based prompt with CoT": extract_kcs_nlp_prompt_cot,
    # "NLP-based prompt with self-reflection": extract_kcs_nlp_prompt_self_reflection,
}


def extract_kcs(query: str, method: str, indexer: IndexCreator = None, nlp_indexer: NLP_Courses_KG_Indexer = None, top_k: int = 15, debug: bool = False) -> dict[str, float]:
    """Dispatch KC extraction to the chosen strategy.
    Args:
        query: The student query.
        method: One of the keys in STRATEGIES.
        indexer: Required for "KG-based".
        nlp_indexer: Required for NLP-based methods.
        top_k: Number of top notions (only used by KG-based).
        debug: Whether to print debug information.
    Returns:
        A dict mapping notion_id to weight, or None on failure.
    """
    if method == "KG-based":
        return extract_kcs_kg_based(query, indexer, top_k=top_k, debug=debug)
    elif method in STRATEGIES:
        return STRATEGIES[method](query, nlp_indexer)
    else:
        raise ValueError(f"Unknown KC extraction method: {method}. Available: {list(STRATEGIES.keys())}")


if __name__ == "__main__":
    #chekck debug mode
    import sys
    debug = False
    if "--debug" in sys.argv:
        debug = True
    # Example usage
    from index_creator import IndexCreator
    from nlp_courses_kg_indexer import NLP_Courses_KG_Indexer

    indexer = IndexCreator()
    nlp_indexer = NLP_Courses_KG_Indexer()

    query = "Qu'est-ce qu'une architecture 2-tiers ?"
  
    method = "KG-based"
    kcs = extract_kcs(query, method, indexer=indexer, debug=debug)
    print(f"Extracted KCs using {method}: {kcs}")