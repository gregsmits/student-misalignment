"""
run different experiments to evaluate the performance of the courses indexer and the query loader
"""

from courses_indexer import CoursesIndexer
from query_corpus_loader import QueryLoader
from config import QUERIES_FILE
from nlp_courses_kg_indexer import NLP_Courses_KG_Indexer
from tqdm import tqdm
import time
def calculate_hit_rate(gt : list[str], results : dict[str, float], k: int) -> float:
    """
    Calculate the hit rate for a given query and its results.
    Args:
        gt (list[str]): The ground truth courses for the query.
        results (dict[str, float]): The top k matching courses for the query with their similarity scores.
        k (int): The number of top matching courses to consider for the hit rate calculation.
    Returns:
        float: The hit rate for the query.
    """
    hits = sum(1 for course in list(results.keys())[:k] if course in gt)
    return hits / len(gt) if gt else 0.0

def calculate_ndcg_at(gt : list[str], results : dict[str, float], k: int) -> float:
    """
    Calculate the NDCG@k for a given query and its results.
    Args:
        gt (list[str]): The ground truth courses for the query.
        results (dict[str, float]): The top k matching courses for the query with their similarity scores.
        k (int): The number of top matching courses to consider for the NDCG calculation.
    Returns:
        float: The NDCG@k score for the query.
    """
    dcg = 0.0
    idcg = 0.0
    ranked_results = list(results.items())[:k]
    for i in range(min(k, len(ranked_results))):
        if ranked_results[i][0] in gt:
            dcg += 1 / (i + 1)
    for i in range(min(k, len(gt))):
        idcg += 1 / (i + 1)
    return dcg / idcg if idcg > 0 else 0.0

def get_most_matching_course(query: str, indexer: CoursesIndexer) -> str:
    """
    Get the most matching course for a given query.
    Args:
        query (str): The query to search for.
        indexer (CoursesIndexer): The courses indexer instance to use for searching.
    Returns:
        str: The ID of the most matching course for the query.
    """
    results = indexer.get_topk_matching_course(query)
    if results:
        return max(results, key=results.get)  # Return the course with the highest similarity score
    return None

def evaluate_query_course_matching(indexer: CoursesIndexer, nlp_indexer: NLP_Courses_KG_Indexer, query_loader: QueryLoader):
    """
    Evaluate the performance of the courses indexer and the query loader by running a set of queries and checking the top k matching courses for each query.
    """
    queries = query_loader.load_queries()
    global_ndcg = 0.0
    for query in queries:
        print(f"Evaluating query: {query['query']}")
        results = indexer.get_topk_matching_course(query['query'])
        print(f"Top {len(results)} matching courses for query: '{query['query']}'")
        for idx, course in enumerate(results):
            print(f"{idx+1}. {course}")
        gt = query['course']
        print(f"Ground truth courses: {gt}")
        
        print(f"Correct matches: {len(set(results) & set(gt))}")
        ndcg = calculate_ndcg_at(gt, results, k=len(results))
        print(f"NDCG@{len(gt)}: {ndcg}")
        print("\n")
        global_ndcg += ndcg

    print(f"Global NDCG for {len(queries)} queries: {global_ndcg / len(queries)}")


def evaluate_query_course_kcs_matching(indexer: CoursesIndexer, nlp_indexer: NLP_Courses_KG_Indexer, query_loader: QueryLoader, method: str = "KG-based", k: int=4, DEBUG: bool = False)->tuple[float, float]:
    """Evaluate the performance of the courses indexer and the query loader by running a set of queries and checking the top k matching courses for each query.

    Args:
        indexer (CoursesIndexer): _description_
        query_loader (QueryLoader): _description_
        k (int, optional): _description_. Defaults to 7.

    Returns:
        tuple[float, float]: hit@k and ndcg@k for the query-course-KCs matching evaluation
    """
    queries = query_loader.load_queries()
    hit_rates = []
    ndcg_score = []
    ret = {}
    nbq = 1
    meanexecutiontime = 0.0
    courses_to_notions = {}
    for query in tqdm(query_loader.load_queries()):
        #à mémoiser
        notions_associated_courses = indexer.courses_to_notions(query['course'], top_k=5)
        if DEBUG:
            print(f"Notions associated with the ground truth course '{query['course']}':")
            for notion_id, weight in notions_associated_courses.items():
                print(f"\tNotion {notion_id}: weight {weight:.4f}")
        #current time in milliseconds before the execution of the query
        start_time = time.time()
        notions_extract_from_query = {}
        #Version KG-based
        if method == "KG-based":
            notions_extract_from_query = indexer.query_to_notions(query['query'], indexer.notions_weights, top_k=15)
        
        #Version NLP-based
        elif method == "NLP-based string similarity":
            notions_extract_from_query = nlp_indexer.query_to_notions_string_search(query['query'])

        #Version NLP-based prompt
        elif method == "NLP-based prompt":
            notions_extract_from_query = nlp_indexer.query_to_notions_prompt_based(query['query'], "default")

        #Version NLP-based prompt with COT  
        elif method == "NLP-based prompt with CoT":
            notions_extract_from_query = nlp_indexer.query_to_notions_prompt_based(query['query'], "cot")

        #Version NLP-based prompt with self-reflection
        elif method == "NLP-based prompt with self-reflection":
            notions_extract_from_query = nlp_indexer.query_to_notions_prompt_based(query['query'], "self-reflection")

        if notions_extract_from_query is not None:
            htr = calculate_hit_rate(notions_associated_courses, notions_extract_from_query,k)
            hit_rates.append(htr)
            ndcgs = calculate_ndcg_at(notions_associated_courses, notions_extract_from_query, k)
            ndcg_score.append(ndcgs)
            nbq += 1
        #stop time
        end_time = time.time()
        meanexecutiontime += (end_time - start_time)
    mean_hit_rate = sum(hit_rates) / len(hit_rates) if hit_rates else 0.0
    mean_ndcg = sum(ndcg_score) / len(ndcg_score) if ndcg_score else 0.0
    std_dev_hit_rate = (sum((x - mean_hit_rate) ** 2 for x in hit_rates) / len(hit_rates)) ** 0.5 if hit_rates else 0.0
    std_dev_ndcg = (sum((x - mean_ndcg) ** 2 for x in ndcg_score) / len(ndcg_score)) ** 0.5 if ndcg_score else 0.0
    ret[method] = (mean_hit_rate, std_dev_hit_rate, mean_ndcg, std_dev_ndcg, meanexecutiontime / nbq if nbq > 0 else 0.0)
    if DEBUG:
        print(f"GlobalHit@{k} ({method}): {mean_hit_rate:.4f} ± {std_dev_hit_rate:.4f}")
        print(f"Global NDCG@{k} ({method}): {mean_ndcg:.4f} ± {std_dev_ndcg:.4f}")
    return ret
        
def evaluate_query_course_alignment(indexer: CoursesIndexer, nlp_indexer: NLP_Courses_KG_Indexer, query_loader: QueryLoader, ongoingcourses: list[str]) -> tuple[float, float, float]:
    """
    Evaluate the alignment between the notions extracted from the query and the notions associated with the ongoing courses, by quantifying the alignment score between the two sets of notions.
    Parameters:
        indexer (CoursesIndexer): The courses indexer instance to use for retrieving the notions associated with the courses and for quantifying the alignment score.
        nlp_indexer (NLP_Courses_KG_Indexer): The NLP-based indexer instance to use for extracting the notions from the query.
        query_loader (QueryLoader): The query loader instance to use for loading the queries and their associated courses.
        ongoingcourses (list[str]): The list of ongoing courses to consider for the evaluation.
    Returns:    
        tuple[float, float, float]: The recall, precision and F1-score for the alignment between the notions extracted from the query and the notions associated with the ongoing courses.
    """
    queries = query_loader.load_queries()
    falsepositive = 0
    falsenegative = 0
    truepositive = 0
    truenegative = 0
    courses_notions = {}
    for c in ongoing_courses:
        courses_notions[c] = indexer.courses_to_notions([c])
    for query in tqdm(queries):
        #get kcq
        querystr= query['query']
        kcq = indexer.query_to_notions(querystr, indexer.notions_weights)
        
        align = None
        mostalignedcourse = None
        misalign = indexer.quantify_alignment(kcq, ongoing_courses)

        if misalign is not None and misalign == 0.0:
            if query['misalignment'] == "non":
                truepositive += 1
            else:
                falsepositive += 1
        elif misalign is not None and misalign != 0.0:
            if query['misalignment'] == "non":
                falsenegative += 1
            else:
                truenegative += 1
        
    recall = truepositive / (truepositive + falsenegative) if (truepositive + falsenegative) > 0 else 0.0
    precision = truepositive / (truepositive + falsepositive) if (truepositive + falsepositive) > 0 else 0.0
    f1_score = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0.0
    return (recall, precision, f1_score)

if __name__ == "__main__":

    #KCs addressed during the exam
    #evaluation_finale_exos:
    #activity_normalization,activity_decomposition,lecture_transaction,practice_jpa,practice_spring_tests,practice_spring_2tiers
    #KC: forme normale,première forme normale,deuxième forme normale,couverture minimale,troisième forme normale,ACID,JPA,hibernate,@Entity,@Id,mapping attribut-clé primaire,mapping classe-table,@Controller,@Repository,@Service,@Mock,@InjectMocks,mapping url-code
    exos_kc = ["Data.36", "Data.37", "Data.38", "Data.39", "Data.41","Conc.5","Conc.6","Conc.7","Conc.8","Conc.9","Jpa.3","Jpa.5","Jpa.8","Jpa.13","Jpa.12","Jpa.7","Jpa.42","Jpa.44","Test.18","Test.19"]

    #evaluation_finale_tp:
    #practice_jpa,lecture_jpa_repository,practice_spring_2tiers
    #KC:mapping url-code,mapping classe-table,@Entity,@Table,mapping attribut-colonne,@Column,mapping attribut-clé primaire,@Id,@GeneratedValue,mapping association entre classes,@ManyToOne,spring repository,mapping url-code,service spring,@Service,@Transactional
    prog_kcs = ["Jpa.3","Archi.44","Jpa.8","Jpa.9","Jpa.7","Jpa.10","Jpa.11","Jpa.12","Jpa.13","Jpa.14","Jpa.15","Archi.65","Archi.44","Archi.37","Archi.51"]

    #needed to compute the notion weights for the courses
    indexer = CoursesIndexer()
    query_loader = QueryLoader(QUERIES_FILE)
    indexer.compute_notions_weigth_by_course()
    nlp_indexer = NLP_Courses_KG_Indexer()
    #ask which experiment to run
    print("Which experimentation do you want to run?")
    print("1. Evaluate the KCs extraction from the queries")
    print("2. Evaluate query-course matching")
    print("3. Evaluate query misalignment with ongoing courses")
    choice = input("Enter the number of the experiment you want to run: ")
    if choice == "1":
        methods = ["NLP-based prompt"]#["KG-based", "NLP-based string similarity", "NLP-based prompt", "NLP-based prompt with CoT", "NLP-based prompt with self-reflection"]
        Ks =  [7]        
        ret = {method : (0.0,0.0,0.0,0.0) for method in methods}
        for method in methods:
            for k in Ks:
                print(f"Evaluating method: {method} with K={k}")
                res = evaluate_query_course_kcs_matching(indexer=indexer, nlp_indexer=nlp_indexer, query_loader=query_loader, method=method, k=k)
                ret[method+"@"+str(k)] = res[method]
                print(f"Results for method {method} with K={k}: Hit@{k} = {res[method][0]:.4f} ± {res[method][1]:.4f}, NDCG@{k} = {res[method][2]:.4f} ± {res[method][3]:.4f}, Execution Time = {res[method][4]:.4f} milliseconds\n") 
    elif choice == "2":
        evaluate_query_course_matching(indexer=indexer, nlp_indexer=nlp_indexer, query_loader=query_loader)

    elif choice == "3":
        #ongoing courses correspond to courses related to the exam subject
        ongoing_courses = ["activity_normalization", "activity_decomposition", "practice_jpa_advanced", "practice_jpa", "practice_spring_tests", "practice_spring_2tiers"]
        ret = evaluate_query_course_alignment(indexer=indexer, nlp_indexer=nlp_indexer, query_loader=query_loader, ongoingcourses=ongoing_courses)
        print(f"Results for query-course misalignment evaluation: Recall = {ret[0]:.4f}, Precision = {ret[1]:.4f}, F1-score = {ret[2]:.4f}")
    else:
        print("Invalid choice. Please enter 1, 2, or 3.")

