import kg_query
from fuzzysearch import find_near_matches
from config import NB_NOTIONS_TOPK, LLM_ENDPOINT, CHAT_MODEL, logger, TEMPERATURE, MAXTOKENS
import requests
import json

class NLP_Courses_KG_Indexer:
    
    def query_to_notions_string_search(self, query : str) -> dict[str, float]:
        """
        Given a query, return the top_k notions that are most relevant to the query.
        Args:
            query: The input query string.
            top_k: The number of top notions to return.
        Returns:
            A dictionary mapping notion_id to its corresponding weight, sorted by weight in descending order.
        """
        all_notions = kg_query.get_all_notions()
        results = {}
        for id,label in all_notions:
            if find_near_matches(label, query, max_l_dist=len(label)//8):
                results[id] = 1.0 #if the notion label is in the query, we consider it as relevant with a weight of 1.0
        # Sort by weight in descending order and return top_k
        return dict(sorted(results.items(), key=lambda x: x[1], reverse=True)[:NB_NOTIONS_TOPK])

    def call_llm_api(self, prompt: str) -> dict:
        """
        Call the Ollama chat API with the given prompt and return the response.
        Args:
            prompt: The input prompt string to send to the LLM API.
        Returns:
            The response from the LLM API as a dict.
        """
        data = {
            "model": CHAT_MODEL,
            "messages": [
                {"role": "user", "content": prompt}
            ],
            "format": "json",
            "stream": False,
            "options": {
                "temperature": TEMPERATURE,
            },
        }

        try:
            response = requests.post(LLM_ENDPOINT, json=data)
            if response.status_code != 200:
                logger.error(f"API request failed with status code {response.status_code}: {response.text}")
                return {}

            return response.json()
        except ValueError as ve:
            logger.error(f"ValueError parsing LLM response: {ve}")
            return {}
        except requests.RequestException as e:
            logger.error(f"Failed to call Ollama endpoint {LLM_ENDPOINT}: {e}")
            return {}
        except Exception as e:
            logger.error(f"Unexpected error when calling LLM API: {e}")
            return {}

      
    def query_to_notions_prompt_based(self, query : str, mode : str = "default") -> dict[str, float]:
        """
        Given a query, return the top_k notions that are most relevant to the query using a prompt-based approach.
        Args:
            query: The input query string.
            mode : The mode of the prompt, can be "default" or "cot" (chain-of-thought) or "self-reflection".

        Returns:
            A dictionary mapping notion_id to its corresponding weight, sorted by weight in descending order.
        """
        ret = {}
        prompt = f"""Tu es un enseignant expert en développement d'applications web en Java Spring et en base de donénes relationnelles. Un étudiant soumet la question suivante lors d'un cours '{query}'. Tu dois
                identifier {NB_NOTIONS_TOPK} notions au maximum qui sont en lien avec la question. Les notions possibles sont les suivantes au format (notion_id, description): {kg_query.get_all_notions()}.
                """
        if mode == "cot":
            prompt+= """Explique ton raisonnement étape par étape avant de fournir la réponse finale (chain-of-thought) mais n'intègre pas ce raisonnement dans ta réponse."""
        elif mode == "self-reflection":
            prompt+= """Une fois la liste initiale des {NB_NOTIONS_TOPK} proposée, génère une description textuelle de chaque notion, puis, réfléchis à nouveau à la question et à ta réponse, 
            et propose une liste finale des {NB_NOTIONS_TOPK} notions les plus pertinentes pour la question posée. 
            N'intègre pas dans la réponse ta réflexion. """

        prompt += """Retourne la liste des {NB_NOTIONS_TOPK} notions au format JSON suivant : {"result": [{"notion_id": "id1", "poids": 0.8}, {"notion_id": "id2", "poids": 0.6}, ...]}"""
        #Call the LLM API with the prompt and get the response
        response = self.call_llm_api(prompt)
        if not response:
            return None
        try:
            raw = response.get("message", {}).get("content", "")
           
          
            parsed = json.loads(raw)
            notions_json = parsed.get("result", [])
            if not isinstance(notions_json, list):
                logger.error(f"Unexpected 'result' format in LLM response: {type(notions_json)}")
                return None

            for notiondict in notions_json:
                notion_id = notiondict.get("notion_id")
                weight = notiondict.get("poids", 0)
                if notion_id != 'cot' and notion_id != 'self_reflection': #exclude the chain-of-thought explanation from the notions weights
                    ret[notion_id] = float(weight)
        except Exception as e:
            logger.error(f"Failed to parse LLM response: {e}")
            logger.error(f"Raw response content: {raw}")
            return None
        return ret

if __name__ == "__main__":
   
    indexer = NLP_Courses_KG_Indexer()
    
    query = "si je te donne un exemple de jeu de données tu peux me proposer une clé primaire ?"
    # if False:
    #     top_k_notions = indexer.query_to_notions_string_search(query)
    #     print(f"Top notions for query using string matching'{query}':")
    #     for notion_id, weight in top_k_notions.items():
    #         print(f"\tNotion {notion_id}: weight {weight:.4f}")

    print("\n")
    top_k_notions_prompt = indexer.query_to_notions_prompt_based(query,mode="default")
    print(f"Top notions for query using prompt-based approach '{query}':")
    print(top_k_notions_prompt)