"""
Module to store configuration values
"""
import logging
import os

#Data files
MD_COURSES_DIR = "data/courses"
QUERIES_FILE = "data/queries/questions_resources_expert.csv"

#FAISS index file
INDEX_REPOSITORY="index"
COURSE_INDEX="courses_index"

#EMBEDDING MODEL
EMBEDDING_MODEL = "mistral-embed"#"qwen3-embedding:latest" #replace with the embedding model you want to use, e.g. "mistral-embed" or "nomic-embed-text"
CHAT_MODEL = "mistral-small"#"qwen3:latest"#"qwen3:latest" #replace with the chat model you want to use, e.g. "mistral-chat" or "nomic-arc"
LLM_ENDPOINT = "https://api.mistral.ai/v1/chat/completions"#"http://127.0.0.1:11434/api/chat"
MISTRAL_API_KEY = "QzGH6E6N3WRMVzJBbpVy5152WjoehgdN"#MISTRAL KEY available 30 days
# MISTRAL_ENDPOINT = "https://api.mistral.ai/v1/chat/completions"
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
