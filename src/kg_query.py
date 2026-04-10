"""This module provides functions to retrieve data from the KG
"""
from neo4j import GraphDatabase
from config import logger, NEO4J_USER, NEO4J_PASSWORD, NEO4J_URL
import os




def get_driver()->GraphDatabase.driver:
    """Create and return a Neo4j driver instance."""
   
    try:
        driver = GraphDatabase.driver(
            NEO4J_URL,
            auth=(NEO4J_USER, NEO4J_PASSWORD)
        )
        return driver
    except Exception as e:
        logger.error(f"Failed to connect to Neo4j: {e}")
        logger.error("Please check your Neo4j connection settings and that the environnement variables are set.")
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
    
if __name__ == "__main__":

    course_id = "practice_jpa"  # Example course ID
    prereq_courses = get_prerequisite_courses_ids_with_distances(course_id)
    print(f"Prerequisite courses for {course_id}: {prereq_courses}")

    course_to_sections = get_sections_and_courses()
    print(f"Sections for {course_id}: {course_to_sections.get(course_id, [])}")

    section_to_notions = get_notions_and_sections()
    for section in course_to_sections.get(course_id, []):
        print(f"Notions for section {section}: {section_to_notions.get(section, [])}")

    