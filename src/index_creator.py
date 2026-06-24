"""
This module defines the methods to create an index of the courses (markdown files)
"""

from config import MD_COURSES_DIR, COURSE_INDEX, INDEX_REPOSITORY, EMBEDDING_MODEL, LLM_ENDPOINT, NB_COURSES_TOPK, NB_SECTIONS_TOPK, COURSES_TO_IGNORE
import os
import json
from typing import Dict, List
from langchain_core.documents import Document
from langchain_community.vectorstores import FAISS
import kg_query
import math
from urllib.parse import urlparse
import re


class SentenceTransformerEmbeddings:
    """Wrapper exposing SentenceTransformer to a LangChain-style embedding interface."""

    def __init__(self, model_name: str):
        from sentence_transformers import SentenceTransformer

        self.model = SentenceTransformer(model_name)

    def embed_documents(self, texts: list[str]) -> list[list[float]]:
        embeddings = self.model.encode(texts, show_progress_bar=False, convert_to_numpy=True)
        return embeddings.tolist()

    def embed_query(self, text: str) -> list[float]:
        embedding = self.model.encode(text, show_progress_bar=False, convert_to_numpy=True)
        return embedding.tolist()


class IndexCreator:
    """
    This class defines the methods to create an index of the courses (markdown files)
    """
    def __init__(self, model_name: str = None):
        """Load the index if exists or create a new one.
        Args:
            model_name: Override the embedding model from config. Uses a model-specific index directory (index_MODELNAME).
        """
        self.embedding_model_name = model_name or EMBEDDING_MODEL
        index_repo = f"index_{self.embedding_model_name}" if model_name else INDEX_REPOSITORY
        self.index_repository = index_repo
        self.index_name = index_repo + "/" + COURSE_INDEX
        self.index_meta_path = os.path.join(index_repo, f"{COURSE_INDEX}_meta.json")
        self.index = None
        self.section_to_notions: Dict[str, List[str]] = {}
        self.embedding_provider = None
        self.nbchunks_per_course = {}

        self.course_names: Dict[str, str] = {}
        self.notion_labels: Dict[str, str] = {}

        self.embedding_model = self._load_embedding_model()

        if self._is_index_compatible():
            try:
                self.index = FAISS.load_local(folder_path=self.index_repository, index_name=COURSE_INDEX, embeddings=self.embedding_model, allow_dangerous_deserialization=True)
                print(f"Loaded existing index (provider={self.embedding_provider}, model={self.embedding_model_name})")
            except Exception:
                print("Index files corrupted, rebuilding...")
                self._reset_index_files()
                self.index_courses()
        else:
            existing_meta = None
            if os.path.exists(self.index_meta_path):
                with open(self.index_meta_path, "r") as f:
                    existing_meta = json.load(f)
            if existing_meta:
                print(f"Index was built with provider={existing_meta.get('embedding_provider')}, model={existing_meta.get('embedding_model')} "
                      f"but current is provider={self.embedding_provider}, model={self.embedding_model_name}. Rebuilding...")
                self._reset_index_files()
            else:
                print("No existing index found. Creating a new one...")
            self.index_courses()

    def _load_embedding_model(self):
        """Load the embedding model."""
        if self.embedding_model_name == "mistral-embed":
            self.embedding_provider = "mistral"
            try:
                from langchain_mistralai import MistralAIEmbeddings
                return MistralAIEmbeddings(model=self.embedding_model_name, api_key=os.getenv("MISTRAL_API_KEY", ""))
            except ModuleNotFoundError:
                raise ImportError("langchain_mistralai is required to use mistral-embed. Install it or use another EMBEDDING_MODEL.")

        try:
            self.embedding_provider = "sentence_transformers"
            return SentenceTransformerEmbeddings(self.embedding_model_name)
        except ModuleNotFoundError:
            self.embedding_provider = "ollama"
            try:
                from langchain_ollama import OllamaEmbeddings
                return OllamaEmbeddings(model=self.embedding_model_name, base_url=self._resolve_ollama_base_url(), num_ctx=512)
            except ModuleNotFoundError:
                raise ImportError(
                    "Neither sentence_transformers nor langchain_ollama are installed. "
                    "Install one of them or set EMBEDDING_MODEL to a supported local model."
                )

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
            meta.get("embedding_provider") == self.embedding_provider
            and meta.get("embedding_model") == self.embedding_model_name
        )

    def _reset_index_files(self) -> None:
        """Remove existing FAISS index files so the index can be rebuilt cleanly."""
        for suffix in ["faiss", "pkl"]:
            index_file = os.path.join(self.index_repository, f"{COURSE_INDEX}.{suffix}")
            if os.path.exists(index_file):
                os.remove(index_file)
        if os.path.exists(self.index_meta_path):
            os.remove(self.index_meta_path)
        
    def _load_kg_metadata(self) -> None:
        """Fetch course names and notion labels from the KG (once)."""
        if not self.course_names:
            for cid, clabel in kg_query.get_all_courses():
                self.course_names[cid] = clabel
        if not self.notion_labels:
            for nid, nlabel in kg_query.get_all_notions():
                self.notion_labels[nid] = nlabel

    def index_course(self, course_path: str) -> None:
        """
        Index a course (markdown file) section by section by adding it to the FAISS index.
        Each chunk is enriched with KG metadata: course name, attached notions (id + label + weight).
        Args:
            course_path (str): The path to the markdown file of the course.
        """
        self._load_kg_metadata()
        notion_weights = kg_query.get_cached_notion_weights()
        if not self.section_to_notions:
            self.section_to_notions = kg_query.get_notions_and_sections()

        course_id = os.path.basename(course_path).replace(".md", "")
        course_name = self.course_names.get(course_id, course_id)
        course_notions = notion_weights.get(course_id, {})
        notion_metadata = [
            {"id": nid, "label": self.notion_labels.get(nid, nid), "weight": weight}
            for nid, weight in sorted(course_notions.items(), key=lambda item: item[1], reverse=True)
        ]

        with open(course_path, "r") as f:
            content = f.read()
            section_chunks = self._chunk_markdown_by_section(content)
            docs = []
            for idx, (section_id, chunk) in enumerate(section_chunks):
                section_notions = [
                    {"id": nid, "label": self.notion_labels.get(nid, nid), "weight": course_notions.get(nid, 0.0)}
                    for nid in self.section_to_notions.get(section_id, [])
                ]
                chunk_notions = section_notions if section_notions else notion_metadata
                docs.append(
                    Document(
                        page_content=chunk,
                        metadata={
                            "source": course_path,
                            "course_id": course_id,
                            "course_name": course_name,
                            "chunk": idx,
                            "section_id": section_id,
                            "notions": chunk_notions,
                        },
                    )
                )
            if self.index is None:
                self.index = FAISS.from_documents(docs, self.embedding_model)
            else:
                self.index.add_documents(docs)
            self.nbchunks_per_course[course_id] = len(docs)

    def _chunk_text(self, text: str, chunk_size: int = 500, overlap: int = 50) -> list[str]:
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

    def _chunk_markdown_by_section(self, text: str, chunk_size: int = 500, overlap: int = 50) -> list[tuple[str, str]]:
        """Chunk markdown by section headings and preserve section IDs."""
        sections = []
        current_section = "root"
        current_text = []
        for line in text.splitlines(keepends=True):
            heading_match = re.match(r'^(#{2,})\s*(.+)$', line)
            if heading_match:
                if current_text:
                    sections.append((current_section, ''.join(current_text)))
                current_section = heading_match.group(2).strip()
                current_text = [line]
            else:
                current_text.append(line)
        if current_text:
            sections.append((current_section, ''.join(current_text)))

        chunks = []
        for section_id, section_text in sections:
            if len(section_text) <= chunk_size:
                chunks.append((section_id, section_text))
                continue
            start = 0
            while start < len(section_text):
                end = min(start + chunk_size, len(section_text))
                chunks.append((section_id, section_text[start:end]))
                if end == len(section_text):
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
            os.makedirs(self.index_repository, exist_ok=True)
            self.index.save_local(folder_path=self.index_repository, index_name=COURSE_INDEX)
            with open(self.index_meta_path, "w") as meta_file:
                json.dump(
                    {
                        "embedding_provider": self.embedding_provider,
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
        index_results = self.index.similarity_search_with_score(query, ks)
        for section in index_results:
            #do not consider the test-intermediate courses in the results
            if section[0].metadata and "source" in section[0].metadata:
                cs = section[0].metadata["source"][len(MD_COURSES_DIR)+1:].replace(".md", "")
                if cs not in COURSES_TO_IGNORE:
                    if cs not in results:
                        results[cs] = 0
                    results[cs] = max(results[cs], section[1])
       
        for cs in results:
            nb_chunks = self.get_course_chunk_count(cs)
            results[cs] /= nb_chunks #normalize by k to get an average similarity score per course
        
        results = dict(sorted(results.items(), key=lambda item: item[1], reverse=True)[:k])          
        return results


def print_index_summary(indexer: "IndexCreator"):
    print(f"\n=== Index Summary ===")
    print(f"Index path: {indexer.index_name}")
    print(f"Embedding model: {indexer.embedding_model_name}")
    print(f"Embedding provider: {indexer.embedding_provider}")

    if indexer.index is not None:
        all_docs = list(indexer.index.docstore._dict.values())
        print(f"Total indexed chunks: {len(all_docs)}")

        if not indexer.nbchunks_per_course:
            for doc in all_docs:
                cid = doc.metadata.get("course_id", "")
                indexer.nbchunks_per_course[cid] = indexer.nbchunks_per_course.get(cid, 0) + 1

        print(f"\n=== Courses and Associated Notions ===")
        notion_weights = kg_query.get_cached_notion_weights()
        indexer._load_kg_metadata()

        for course_id in sorted(notion_weights.keys()):
            course_name = indexer.course_names.get(course_id)
            nb_chunks = indexer.nbchunks_per_course.get(course_id, 0)
            notions = notion_weights[course_id]
            header = f"\n  [{course_id}] {course_name}" if course_name else f"\n  [{course_id}]"
            print(f"{header}  ({nb_chunks} chunks)")
            for nid, weight in sorted(notions.items(), key=lambda x: x[1], reverse=True):
                nlabel = indexer.notion_labels.get(nid, nid)
                print(f"    - {nid} ({nlabel}): {weight:.4f}")
    else:
        print("No index has been created.")


if __name__ == "__main__":
    indexer = IndexCreator()
    print_index_summary(indexer)
