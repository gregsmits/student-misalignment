"""This module provides functions to retrieve data from the KG
"""
from config import logger, NEO4J_USER, NEO4J_PASSWORD, NEO4J_URL
import os
import math


def get_driver():
    """Create and return a Neo4j driver instance."""
    try:
        from neo4j import GraphDatabase
    except ModuleNotFoundError as exc:
        raise ImportError("The neo4j package is required to query the knowledge graph. Install it with `pip install neo4j`.") from exc

    try:
        driver = GraphDatabase.driver(
            NEO4J_URL,
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        return driver
    except Exception as e:
        logger.error(f"Failed to connect to Neo4j: {e}")
        logger.error("Please check your Neo4j connection settings and that the environment variables are set.")
        raise


def get_prerequisite_courses_ids_with_distances( course_id: str) -> dict[str, int]:
    """
    Retrieve prerequisite course IDs and their corresponding notion IDs and weights.
    
    Args:
        neo4j_driver: Neo4j driver instance
        course_id: The ID of the course for which to retrieve prerequisites

    Returns:
        A dictionary mapping prerequisite course IDs to their distance wrt. course_id.
    """
    neo4j_driver = get_driver()
    #prerequisite course ids and their distance to the course_id
    with neo4j_driver.session() as session:
        result = session.run("""
            MATCH (prereq:Course)-[:PREREQUISITE*1..]->(c:Course {id: $course_id})
            RETURN prereq.id AS prereq_id, length(shortestPath((prereq)-[:PREREQUISITE*1..]->(c))) AS distance
        """, course_id=course_id)
        prereq_ids = {record["prereq_id"]: record["distance"] for record in result} 
        prereq_ids[course_id] = 0 #add the course itself as a prerequisite with distance 0  
    return prereq_ids


def get_sections_and_courses() -> dict[str, list[str]] :
    """
    Retrieve the section IDs associated with a given course ID.
    
    Args:
        neo4j_driver: Neo4j driver instance
        course_id: The ID of the course for which to retrieve sections

    Returns:
        A set of section IDs associated with the course.
    """
    neo4j_driver = get_driver()
    course_to_sections: dict[str, list[str]] = {}
    with neo4j_driver.session() as session:
        CxS_result = session.run("""
            MATCH (c:Course)-[:has_section]->(s:Section)
            RETURN 
              c.id AS course_id, 
              s.label AS section_id
        """)    
        for record in CxS_result:
            cid = record["course_id"]
            sid = record["section_id"]
            if cid not in course_to_sections:
                course_to_sections[cid] = []
            course_to_sections[cid].append(sid)
    return course_to_sections


def get_notions_and_sections() -> dict[str, list[str]] :
    """
    Retrieve the notion IDs associated with a given section ID.
    
    Args:
        neo4j_driver: Neo4j driver instance
        section_id: The ID of the section for which to retrieve notions

    Returns:
        A set of notion IDs associated with the section.
    """
    section_to_notions: dict[str, list[str]] = {}
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        SxN_result = session.run("""
            MATCH (s:Section)-[:has_notion]->(n:Notion)
            RETURN 
              s.label AS section_id, 
              n.id AS notion_id
        """)    
        for record in SxN_result:
            sid = record["section_id"]
            nid = record["notion_id"]
            if sid not in section_to_notions:
                section_to_notions[sid] = []
            section_to_notions[sid].append(nid)
    return section_to_notions

def get_all_notions() -> set[str] :
    """
    Retrieve all notion IDs and label from the KG.
    
    Args:
        neo4j_driver: Neo4j driver instance
    Returns:
        A set of all notion IDs in the KG.
    """
    all_notions = set()
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        result = session.run("""
            MATCH (n:Notion)
            RETURN n.id AS notion_id, n.label AS notion_label
        """)    
        for record in result:
            nid = record["notion_id"]
            nlabel = record["notion_label"]
            all_notions.add((nid, nlabel))
    return all_notions

def get_all_courses() -> set[str] :
    """
    Retrieve all course IDs and label from the KG.
    
    Args:
        neo4j_driver: Neo4j driver instance
    Returns:
        A set of all course IDs in the KG.
    """
    all_courses = set()
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        result = session.run("""
            MATCH (c:Course)
            RETURN c.id AS course_id, c.label AS course_label
        """)    
        for record in result:
            cid = record["course_id"]
            clabel = record["course_label"]
            all_courses.add((cid, clabel))
    return all_courses
    
def get_notion_weights_for_course(course_id: str) -> dict[str, float]:
    """Retrieve the weighted notions for a given course from the KG.
    Returns:
        A dict mapping notion_id to its weight for this course.
    """
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        result = session.run("""
            MATCH (c:Course {id: $course_id})-[r:has_weighted_notion]->(n:Notion)
            RETURN n.id AS notion_id, r.weight AS weight
        """, course_id=course_id)
        return {record["notion_id"]: record["weight"] for record in result}


def get_all_notion_weights() -> dict[str, dict[str, float]]:
    """Retrieve all weighted notions for all courses from the KG.
    Returns:
        A dict mapping course_id to {notion_id: weight}.
    """
    neo4j_driver = get_driver()
    weights: dict[str, dict[str, float]] = {}
    with neo4j_driver.session() as session:
        result = session.run("""
            MATCH (c:Course)-[r:has_weighted_notion]->(n:Notion)
            RETURN c.id AS course_id, n.id AS notion_id, r.weight AS weight
        """)
        for record in result:
            cid = record["course_id"]
            if cid not in weights:
                weights[cid] = {}
            weights[cid][record["notion_id"]] = record["weight"]
    return weights


_cached_notion_weights: dict[str, dict[str, float]] = {}

def get_cached_notion_weights() -> dict[str, dict[str, float]]:
    """Retrieve all notion weights from the KG (module-level cache)."""
    global _cached_notion_weights
    if not _cached_notion_weights:
        _cached_notion_weights = get_all_notion_weights()

    return _cached_notion_weights


def course_to_notions(course_id: str, top_k: int = 5) -> dict[str, float]:
    """Given a course ID, return notions and their weights from the KG."""
    course_weights = get_notion_weights_for_course(course_id)
    return dict(sorted(course_weights.items(), key=lambda x: x[1], reverse=True)[:top_k])


def courses_to_notions(course_ids: list[str], top_k: int = 5) -> dict[str, float]:
    """Given a list of course IDs, return the merged notions and their weights from the KG."""
    notion_weights = get_cached_notion_weights()
    ret = {}
    for cid in course_ids:
        for notion, weight in notion_weights.get(cid, {}).items():
            ret[notion] = max(ret.get(notion, 0), weight)
    return dict(sorted(ret.items(), key=lambda x: x[1], reverse=True)[:top_k])


def compute_notions_weight_by_course(debug: bool = False) -> dict[str, dict[str, float]]:
    """Compute the notion weights for each course based on KG structure (TKF * IKCF, as per ECTEL paper).

    Args:
        debug: If True, print detailed computation steps.

    Returns:
        A dictionary mapping course_id to {notion_id: weight}.
    """
    course_to_sections = get_sections_and_courses()
    section_to_notions = get_notions_and_sections()

    notions_weights: dict[str, dict[str, float]] = {}
    import random
    for cid in course_to_sections.keys():  # Iterate over each course
        course_notions = set()
        alpha = 1 #to create a gap between the current course and its direct prerequisites
        for sec in course_to_sections[cid]:
            for nid in section_to_notions.get(sec, []):
                course_notions.add(nid)

        if debug:
            print(f"\nCourse {cid}: {len(course_to_sections[cid])} sections, {len(course_notions)} notions")

        for nid in course_notions:
            #number of sections in the course that link to the notion 
            nb_sections_linked = sum(
                1 for sec in course_to_sections[cid] if nid in section_to_notions.get(sec, [])
            )
            #number of notions linked to the current course that link
            nb_notions_linked = sum(
                1 for sec in course_to_sections[cid] for n in section_to_notions.get(sec, []) if n in course_notions
            )
            kcf = nb_sections_linked / nb_notions_linked if nb_notions_linked > 0 else 0.0

            if debug:
                print(f"  {nid}: sections_linked={nb_sections_linked}, total_notion_links={nb_notions_linked}, KCF={kcf:.4f}")

            if cid not in notions_weights:
                notions_weights[cid] = {}

            prereq_courses = get_prerequisite_courses_ids_with_distances(cid)
        
            numikcf = 0
            denikcf = 1.0
            for pc in prereq_courses:
                #check if the notion is covered by the prerequisite course
                covers = any(nid in section_to_notions.get(sec, {}) for sec in course_to_sections.get(pc, []))
                if covers:
                    numikcf += prereq_courses[pc]
                denikcf += prereq_courses[pc]

            ikcf = alpha * math.log(2 - numikcf / denikcf, 2)
            weight = kcf * ikcf

            if debug:
                print(f"    prereqs={list(prereq_courses.keys())}, numikcf={numikcf}, denikcf={denikcf:.1f}, IKCF={ikcf:.4f}, weight={weight:.4f}")

            notions_weights[cid][nid] = weight

    return notions_weights


def store_weights_in_kg(notions_weights: dict[str, dict[str, float]]) -> None:
    """Write computed weights into the KG as has_weighted_notion relationships and save Cypher to notions_weights.cypher."""
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        for cid, notions in notions_weights.items():
            for nid, weight in notions.items():
                session.run("""
                    MATCH (c:Course {id: $cid}), (n:Notion {id: $nid})
                    MERGE (c)-[r:has_weighted_notion]->(n)
                    SET r.weight = $weight
                """, cid=cid, nid=nid, weight=weight)

    cypher_path = os.path.join(os.path.dirname(__file__), "..", "data", "kg", "notions_weights.cypher")
    cypher_path = os.path.normpath(cypher_path)

    lines = ["// Computed notion weights per course (generated by kg_query.py)"]
    for cid in sorted(notions_weights):
        for nid, weight in sorted(notions_weights[cid].items(), key=lambda x: x[1], reverse=True):
            lines.append(
                f"MATCH (c:Course {{id: '{cid}'}}), (n:Notion {{id: '{nid}'}}) "
                f"MERGE (c)-[r:has_weighted_notion]->(n) SET r.weight = {weight:.6f};"
            )

    #save the Cypher commands to a separate file for later use
    cypher_path = os.path.join(os.path.dirname(__file__), "..", "data", "kg", "notions_weights.cypher")
    cypher_path = os.path.normpath(cypher_path)
    with open(cypher_path, "w") as f:
        f.write("\n".join(lines) + "\n")

    print(f"Wrote {sum(len(v) for v in notions_weights.values())} weight entries to KG and {cypher_path}")


def reload_kg_data(debug: bool = False) -> None:
    """
    delete the content of the KG and reload it from the Cypher files in data/kg
    """
    neo4j_driver = get_driver()
    with neo4j_driver.session() as session:
        #delete all nodes and relationships
        session.run("MATCH (n) DETACH DELETE n")
        if debug:
            print("Deleted all nodes and relationships in the KG.")
        import re
        kg_dir = os.path.join(os.path.dirname(__file__), "..", "data", "kg")
        for filename in sorted(os.listdir(kg_dir)):
            if filename.endswith(".cypher"):
                cypher_path = os.path.join(kg_dir, filename)
                with open(cypher_path, "r") as f:
                    content = f.read()
                statements = [s.strip() for s in content.split(";") if s.strip()]
                for stmt in statements:
                    clean = re.sub(r"//.*", "", stmt).strip()
                    if not clean:
                        continue
                    session.run(stmt)
                if debug:
                    print(f"Executed {len(statements)} statements from {filename}.")


if __name__ == "__main__":
    import sys
    debug = "--debug" in sys.argv


    if 1:# to compute notion weights and generate the Cypher file to store them in the KG
        print("Computing notion weights from KG structure...")
        weights = compute_notions_weight_by_course(debug=debug)    
        store_weights_in_kg(weights)

    if 1: # to reload the KG from the Cypher files in data/kg
        print("Reloading KG data from Cypher files...")
        reload_kg_data(debug=debug)

    # test get weights for a specific course and notion
    if 1:
        test_course_id = 'practice_indexation'
        test_notion_id = "Conc.26"
        weights = get_notion_weights_for_course(test_course_id)
        if test_notion_id in weights:
            print(f"Weight of notion {test_notion_id} for course {test_course_id}: {weights[test_notion_id]:.4f}")
        else:
            print(f"Notion {test_notion_id} not found for course {test_course_id}.")
