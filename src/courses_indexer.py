"""
This module defines the methods to create an index of the courses (markdown files)
"""

from config import MD_COURSES_DIR, COURSE_INDEX, INDEX_REPOSITORY, EMBEDDING_MODEL, LLM_ENDPOINT, NB_COURSES_TOPK, NB_SECTIONS_TOPK, MISTRAL_API_KEY
import os
import json
from langchain_core.documents import Document
from langchain_community.vectorstores import FAISS
from langchain_ollama import OllamaEmbeddings
from langchain_mistralai import MistralAIEmbeddings
import kg_query
import math
from urllib.parse import urlparse

class CoursesIndexer:
    """
    This class defines the methods to create an index of the courses (markdown files)
    """
    def __init__(self):
        """Load the index if exists or create a new one.
        """
        self.index_name = INDEX_REPOSITORY + "/" + COURSE_INDEX
        self.index_meta_path = os.path.join(INDEX_REPOSITORY, f"{COURSE_INDEX}_meta.json")
        self.index = None
        self.notions_weights = {}
        self.embedding_model_name = EMBEDDING_MODEL 
        self.nbchunks_per_course = {} #to store the number of chunks for each course to compute an average similarity score per course when retrieving the topk matching courses for a query

        # if not MISTRAL_API_KEY:
        #     raise ValueError("MISTRAL_API_KEY is not set. Please export it in your environment.")

        if EMBEDDING_MODEL == "mistral-embed":
            self.embedding_model = MistralAIEmbeddings(
                    model=EMBEDDING_MODEL,
                    api_key=MISTRAL_API_KEY,
                )
        else:
            self.embedding_model = OllamaEmbeddings(
                model=self.embedding_model_name,
                base_url=self._resolve_ollama_base_url(),
            )
        
        try:
            self.index = FAISS.load_local(folder_path=INDEX_REPOSITORY, index_name=COURSE_INDEX, embeddings=self.embedding_model, allow_dangerous_deserialization=True)
        except Exception:
            print(f"Index does not exist or error")
            print("Creating a new index...")
            self.index_courses()

    def _resolve_ollama_base_url(self) -> str:
        """Resolve Ollama base URL from env or configured endpoint."""
        base_url = os.getenv("OLLAMA_BASE_URL")
        if base_url:
            return base_url.rstrip("/")

        # Reuse configured endpoint by stripping path, e.g. /api/chat -> host URL.
        parsed = urlparse(LLM_ENDPOINT)
        if parsed.scheme and parsed.netloc:
            return f"{parsed.scheme}://{parsed.netloc}"

        return "http://127.0.0.1:11434"

    def compute_notions_weigth_by_course(self):
        """
        Compute the notion weights based on the number of courses they are linked to, as per ECTEL paper.
        Returns:
            A dictionary mapping course_id to a dictionary of notion_id and its corresponding weight.
        """

        # build a course-to-section matrix
        course_to_sections: Dict[str, List[str]] = kg_query.get_sections_and_courses()

        #build a section-to-notion matrix
        section_to_notions: Dict[str, List[str]] = kg_query.get_notions_and_sections()

        #Compute the weights for each notion linked to each course
        for cids in course_to_sections.keys():
            #get all notions of this course
            course_notions = set()
            for sec in course_to_sections[cids]:
                for nid in section_to_notions.get(sec, []):
                    course_notions.add(nid)
            
            #count tkf for each notion of this course
            # logger.info(f"Course {cids}")
            for nid in course_notions:
                

                #number of sections of this course linked to the notion
                nb_sections_linked = sum(
                    1 for sec in course_to_sections[cids] if nid in section_to_notions.get(sec, [])
                )
                #number of notions linked to the course
                nb_notions_linked = sum(
                    1 for sec in course_to_sections[cids] for n in section_to_notions.get(sec, []) if n in course_notions
                )
                kcf = nb_sections_linked / nb_notions_linked if nb_notions_linked > 0 else 0.0
                # logger.info(f"\t-Course {cids} has {nb_sections_linked} sections linked to notion {nid} over {len(course_to_sections[cids])} sections")
                # logger.info(f"\t-Course {cids} has tkf {kcf:.4f} for notion {nid}")
                if cids not in self.notions_weights:
                    self.notions_weights[cids] = {}
                
                #compute itkcf
                #get prerequisite courses of this course
                prereq_courses = kg_query.get_prerequisite_courses_ids_with_distances(cids)
                numikcf = 0
                denikcf = 1.0
                for pc in prereq_courses.keys():
                    covers = nid in self.notions_weights.get(pc, {})
                    if covers:
                        numikcf += prereq_courses[pc]
                    denikcf += prereq_courses[pc]

                ikcf = math.log(2 - numikcf / denikcf, 2)
                #final weight is tkf * itkcf
                self.notions_weights[cids][nid] = kcf * ikcf

    def get_course_chunk_count(self, course_id: str) -> int:
        """Get the number of chunks for a specific course."""
        # to retrieve the chunk count for the given course ID.
        if self.index is not None:
            all_docs = self.index.docstore._dict.values()
            return len([
                doc for doc in all_docs
                if os.path.basename(doc.metadata.get("source", "")).replace(".md", "") == course_id
            ])
        raise ValueError(f"Course ID {course_id} not found in index metadata.")

    def _is_index_compatible(self) -> bool:
        """Check whether persisted index metadata matches current embedding settings."""
        if not os.path.exists(self.index_meta_path):
            return False

        try:
            with open(self.index_meta_path, "r") as meta_file:
                meta = json.load(meta_file)
        except Exception:
            return False

        return (
            meta.get("embedding_provider") == "ollama"
            and meta.get("embedding_model") == self.embedding_model_name
        )

    def _reset_index_files(self) -> None:
        """Remove existing FAISS index files so the index can be rebuilt cleanly."""
        for suffix in ["faiss", "pkl"]:
            index_file = os.path.join(INDEX_REPOSITORY, f"{COURSE_INDEX}.{suffix}")
            if os.path.exists(index_file):
                os.remove(index_file)
        if os.path.exists(self.index_meta_path):
            os.remove(self.index_meta_path)
        
    def index_course(self, course_path: str) -> None:
        """
        Index a course (markdown file) section by sectionby adding it to the FAISS index.
        Args:
            course_path (str): The path to the markdown file of the course.
        Returns:
            None
        """
        #split markdown file into sections and add each section to the FAISS index
        with open(course_path, "r") as f:
            content = f.read()
            chunks = self._chunk_text(content)
            docs = [
                Document(
                    page_content=chunk,
                    metadata={"source": course_path, "chunk": idx},
                )
                for idx, chunk in enumerate(chunks)
            ]
            # FAISS must be bootstrapped from at least one document.
            if self.index is None:
                self.index = FAISS.from_documents(docs, self.embedding_model)
            else:
                self.index.add_documents(docs)
            self.nbchunks_per_course[os.path.basename(course_path).replace(".md", "")] = len(chunks)

    def _chunk_text(self, text: str, chunk_size: int = 3000, overlap: int = 300) -> list[str]:
        """Split a large text into overlapping chunks to fit embedding API limits."""
        if len(text) <= chunk_size:
            return [text]

        chunks = []
        start = 0
        while start < len(text):
            end = min(start + chunk_size, len(text))
            chunks.append(text[start:end])
            if end == len(text):
                break
            start = max(0, end - overlap)
        return chunks

    def index_courses(self) :
        """
        Create a FAISS index for every course (markdown file) in the courses directory.
        Chunks the course content and adds it to the FAISS index. A chunk is a section of the course content that is less than 512 tokens. 
        The index is stored in a file defined by COURSES_FAISS_INDEX_FILE.   
        Returns:
        """
        indexed_count = 0
        try:
            for root, dirs, files in os.walk(MD_COURSES_DIR):
                for file in files:
                    if file.endswith(".md"):
                        print(f"Indexing course: {file}")
                        self.index_course(os.path.join(root, file))
                        indexed_count += 1
        except KeyboardInterrupt:
            print("Indexing interrupted; saving partial index...")

        if self.index is not None:
            os.makedirs(INDEX_REPOSITORY, exist_ok=True)
            self.index.save_local(folder_path=INDEX_REPOSITORY, index_name=COURSE_INDEX)
            with open(self.index_meta_path, "w") as meta_file:
                json.dump(
                    {
                        "embedding_provider": "ollama",
                        "embedding_model": self.embedding_model_name,
                    },
                    meta_file,
                )
            print(f"Indexed {indexed_count} markdown files and saved index to {self.index_name}")
        else:
            print("No markdown files found to index; no index files were created.")
        
    def get_topk_matching_course(self, query: str, k: int=NB_COURSES_TOPK) -> dict[str, float]:
        """
        Get the top k matching courses for a given query.
        Args:
            query (str): The query to search for.
            k (int): The number of top matching courses to return.
        Returns:
            list: A list of tuples containing the course ID and its corresponding similarity score.
        """        
        results = {}
        ks = NB_SECTIONS_TOPK if NB_COURSES_TOPK is not None else 10

        for course in self.index.similarity_search_with_score(query, ks):
            if course[0].metadata and "source" in course[0].metadata:
                cs = course[0].metadata["source"][len(MD_COURSES_DIR)+1:].replace(".md", "")
                if cs not in results:
                    results[cs] = 0
                results[cs] += course[1]
        for cs in results:
            nb_chunks = self.get_course_chunk_count(cs)
            results[cs] /= nb_chunks #normalize by k to get an average similarity score per course    
        
        results = dict(sorted(results.items(), key=lambda item: item[1], reverse=True)[:k])          
        return results

    def query_to_notions(self, query : str, notion_weights: dict[str, dict[str, float]], top_k: int = 5) -> dict[str, float]:
        """
        Given a query and the notion weights, return the top_k notions that are most relevant to the query.
        Args:
            query: The input query string.
            notion_weights: A dictionary mapping course_id to a dictionary of notion_id and its corresponding weight.
            top_k: The number of top notions to return.
        Returns:
            A dictionary mapping notion_id to its corresponding weight, sorted by weight in descending order.
        """
        if len(notion_weights) == 0:
            notion_weights = self.compute_notions_weigth_by_course()
        results = self.get_topk_matching_course(query)
        notions = {}
        for course in results:
            for notion, weight in self.notions_weights.get(course, {}).items():
                if notion not in notions:
                    notions[notion] = 0
                notions[notion] = max(notions[notion], weight * results[course])     #weight the notion by the course similarity score
        return dict(sorted(notions.items(), key=lambda x: x[1], reverse=True)[:top_k])  

    def course_to_notions(self, course_id: str, top_k: int = 5) -> dict[str, float]:
        """
        Given a course ID, return the notions associated with that course and their corresponding weights.
        Args:
            course_id: The ID of the course.
            top_k: The number of top notions to return.
        Returns:
            A dictionary mapping notion_id to its corresponding weight for the given course.
        """
        if len(self.notions_weights) == 0:
            self.compute_notions_weigth_by_course()
        return dict(sorted(self.notions_weights.get(course_id, {}).items(), key=lambda x: x[1], reverse=True)[:top_k])

    def courses_to_notions(self, course_ids: list[str], top_k: int = 5) -> dict[str, dict[str, float]]:
        """
        Given a list of course IDs, return the notions associated with those courses and their corresponding weights.
        Args:
            course_ids: A list of course IDs.
            top_k: The number of top notions to return for each course.
        Returns:
            A dictionary mapping course_id to a dictionary of notion_id and its corresponding weight for each given course ID.
        """
        ret = {}
        if len(self.notions_weights) == 0:
            self.compute_notions_weigth_by_course()
        for n in course_ids:
            for notion, weight in self.notions_weights.get(n, {}).items():
                ret[notion] = max(ret[notion], weight) if notion in ret else weight
        
        return dict(sorted(ret.items(), key=lambda x: x[1], reverse=True)[:top_k])

    def fuzzy_jacquard_similarity(self, kcq: dict[str, float], kcc: dict[str, float]) -> float:
        """Calculate the fuzzy Jacquard similarity between two sets of key concepts.
        Args:
            kcq: A dictionary mapping notion_id to its corresponding weight for the query.
            kcc: A dictionary mapping notion_id to its corresponding weight for the course.
        Returns:
            A float value representing the fuzzy Jacquard similarity between the two sets of key concepts.
        """
        intersection = sum(min(kcq.get(n, 0), kcc.get(n, 0)) for n in set(kcq) & set(kcc))
        union = sum(max(kcq.get(n, 0), kcc.get(n, 0)) for n in set(kcq) | set(kcc))
        return intersection / union if union > 0 else 0.0

    def quantify_alignment(self, query_kcs: dict[str, float], course_ids: list[str]) -> float:
        """Quantify the alignment between a query defined by its key concepts the kcs lists of the courses judged as relevant by the expert to answer the query
        Args:
            query_kcs: A dictionary mapping notion_id to its corresponding weight for the query.
            course_ids: A list of course IDs for which to quantify alignment.
        Returns:
            A float value representing the alignment score between the query and the course.
        """
        ret = None
        if len(self.notions_weights) == 0:
            self.compute_notions_weigth_by_course()
        #most matching course
        maxcourse=None
        maxsim=-1
        allcourses = kg_query.get_all_courses()
        for cid, label in allcourses:
            kcc = self.course_to_notions(cid)
            sim = self.fuzzy_jacquard_similarity(query_kcs, kcc)

            if maxcourse is None or sim > maxsim:
                maxcourse = cid
                maxsim = sim 
        #print(f"Most similar course to the query is {maxcourse} with similarity {maxsim:.4f}")

        for course_id in course_ids:
            alignwithongoingcourse = self.fuzzy_jacquard_similarity(query_kcs, self.notions_weights.get(course_id, {}))
            dist_prereq = kg_query.get_prerequisite_courses_ids_with_distances(course_id)
           # print(f"Prerequisite courses and distances for course {course_id}: {dist_prereq}")
            dist_prereq_maxcourse = kg_query.get_prerequisite_courses_ids_with_distances(maxcourse)
           # print(f"Prerequisite courses and distances for most similar course {maxcourse}: {dist_prereq_maxcourse}")
            prepos = None
            if maxcourse in dist_prereq:
             #   print(f"Distance between course {course_id} and most similar course {maxcourse} is {dist_prereq[maxcourse]}")
                prepos =  (- dist_prereq[maxcourse]/max(dist_prereq.values())) if dist_prereq[maxcourse] > 0 else 0
            elif course_id in dist_prereq_maxcourse:
               # print(f"Distance between most similar course {maxcourse} and course {course_id} is {dist_prereq_maxcourse[course_id]}")
                prepos = ( dist_prereq_maxcourse[course_id]/max(dist_prereq_maxcourse.values())) if dist_prereq_maxcourse[course_id] > 0 else 0

            if prepos is not None:
                misalign = prepos * math.fabs(alignwithongoingcourse -self.fuzzy_jacquard_similarity(query_kcs, self.notions_weights.get(maxcourse, {})))    
                ret = min(ret,misalign) if ret is not None else misalign
       # print(f"Alignment scores for query and courses {course_ids}: {ret}")
        return ret

if __name__ == "__main__":
    indexer = CoursesIndexer()
    indexer.compute_notions_weigth_by_course()
    testquery = "Un exemple de code Spring JPa pour définir une classe entité stp."

    results = indexer.get_topk_matching_course(testquery)
    print(f"Top {len(results)} matching courses for query: '{testquery}'")
    for course, score in results.items():
        print(f"{course} (score: {score:.4f})")
    
    # print(f"Top {len(results)} matching courses for query: '{testquery}'")
    # idx = 0
    # ordered_results = dict(sorted(results.items(), key=lambda item: item[1], reverse=True))
    # for course, score in ordered_results.items():
    #     idx += 1
    #     print(f"{idx}. {course} (score: {score:.4f})")

    # for course_id, notions in indexer.notions_weights.items():
    #     print(f"Course {course_id}:")
    #     for notion_id, weight in notions.items():
    #         print(f"\tNotion {notion_id}: weight {weight:.4f}")

    kcq = indexer.query_to_notions(testquery, indexer.notions_weights, top_k=10)
    print(f"Key concepts extracted from the query '{testquery}':")
    for notion_id, weight in kcq.items():
        print(f"\tNotion {notion_id}: weight {weight:.4f}")
    course="practice_jpa_advanced"
    ret = indexer.quantify_alignment(kcq, [course])
    if ret is not None:
        print(f"Alignment score for query '{testquery}' and course '{course}': {ret:.4f}")
    else:
        print(f"query {testquery} not related with {course}")