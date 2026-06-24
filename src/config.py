"""
Module to store configuration values
"""
import logging
import os

#Indexing parameters
INDEX_REPOSITORY="index"
COURSE_INDEX="courses_index"
NOTION_INDEX="notions_index"
#COMPARED_EMBEDDING_MODELS=["qwen3-embedding","nomic-embed-text", "mistral-embed","all-MiniLM"] 
EMBEDDING_MODEL = "qwen3-embedding"
MODEL_STORAGE="/Users/smits/.ollama/models"

#Data files
MD_COURSES_DIR = "data/courses"
CORPUS_QUESTION_ALIGNMENT= "data/queries/questions_resources_expert.csv"
CORPUS_QUESTION_KC_MAPPING= "data/queries/questions_resources_KC_expert.csv"


CHAT_MODEL = "qwen3:latest"#"llama3"#"mistral-small"#"qwen3:latest" #replace with the chat model you want to use
LLM_ENDPOINT = "http://127.0.0.1:11434/api/chat"#"https://api.mistral.ai/v1/chat/completions"#"http://127.0.0.1:11434/api/chat"

TEMPERATURE=1
MAXTOKENS=2048

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

logger.setLevel(logging.WARNING)

#NEO4J CREDENTIALS
NEO4J_USER="neo4j"
NEO4J_PASSWORD="neo4jpwd"
NEO4J_URL="bolt://127.0.0.1:7687"

#Hyperparameters
NB_COURSES_TOPK = 3
NB_SECTIONS_TOPK = 10
NB_NOTIONS_TOPK = 15


COURSES_TO_IGNORE = ['unknown','test_intermediaire_part1','test_intermediaire_part2']