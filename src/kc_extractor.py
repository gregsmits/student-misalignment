"""
KC (Key Concept / Notion) extraction strategies.
Each function takes a query string and returns a dict[str, float] mapping notion_id to weight.
"""

from index_creator import IndexCreator
from nlp_courses_kg_indexer import NLP_Courses_KG_Indexer
import kg_query
from config import NB_SECTIONS_TOPK

def extract_kcs_kg_based2(query: str, indexer: IndexCreator, top_k: int = 15, debug = False) -> dict[str, float]:
    """Extract KCs using the FAISS index and the KG"""
    results = indexer.get_topk_matching_course(query)
    notion_weights = kg_query.get_cached_notion_weights()
    notions = {}

    print(f"Query: {query}") if debug else None
    for section in results:
        print(f"- Matching section: {section}, Weight: {results[section]}") if debug else None
        print(f"\t - Notion weights for section {section}: {notion_weights.get(section, {})}") if debug else None
        for notion, weight in notion_weights.get(section, {}).items():
            if notion not in notions:
                notions[notion] = 0
            notions[notion] = max(notions[notion], weight * results[section])
    res = dict(sorted(notions.items(), key=lambda x: x[1], reverse=True)[:top_k])

    #display the top-k notions (id and label) for the query if debug is enabled
    for notion_id, weight in res.items():
        notion_info = kg_query.get_notion_by_id(notion_id)
        label = notion_info["label"] if notion_info else "Unknown"
        print(f"  Notion: {notion_id} ({label}), Weight: {weight:.4f}") if debug else None
    return res


def extract_kcs_kg_based(query: str, indexer: IndexCreator, debug = False) -> dict[str, float]:
    """Extract KCs using the FAISS index and the KG.
    1. Retrieve top-k matching sections from the FAISS index.
    2. For each section, get the notions attached to it in the KG.
    3. For each notion in a section, its score is min(section_mapping_score, notion_weight_in_course).
    4. The final weight of a notion is the max score over all sections.
    """
    sections = indexer.get_topk_matching_sections(query)

    if debug:
        print(f"Query: \"{query}\"")

    notions: dict[str, float] = {}
    for (course_id, section_id), mapping_score in sections.items():
        #get the notions attached to the section
        section_notion = kg_query.get_notions_for_section(section_id, course_id)
        print(f"  Section: {section_id} (Course: {course_id}), Mapping score: {mapping_score:.4f}") if debug else None
        print(f"    Notions for section {section_id}: {section_notion}") if debug else None

        for notion, notion_weight in section_notion.items():
            notion_score = min(mapping_score, notion_weight)
            if notion not in notions:
                notions[notion] = 0.0
            notions[notion] = max(notions[notion], notion_score)
            print(f"    Notion: {notion}, Notion weight: {notion_weight:.4f}, Notion score: {notion_score:.4f}") if debug else None

    # Sort notions by weight and return the top-k
    sorted_notions = dict(sorted(notions.items(), key=lambda x: x[1], reverse=True)[:NB_SECTIONS_TOPK])
    print(f"  Top-{NB_SECTIONS_TOPK} notions: {sorted_notions}") if debug else None
    return sorted_notions

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
    "KG-based": extract_kcs_kg_based,
    "NLP-based string similarity": extract_kcs_nlp_string_similarity,
    #"NLP-based prompt": extract_kcs_nlp_prompt,
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
        return extract_kcs_kg_based(query, indexer, debug=debug)
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

    query = "Quelle annotation JPA permet de modifier le nom de la colonne qui mappe un attribut d'une entité?"
  
    method = "KG-based"
    kcs = extract_kcs(query, method, indexer=indexer, debug=debug)
