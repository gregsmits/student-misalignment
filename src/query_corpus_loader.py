"""
Manage the corpus of queries_summary_
"""
from csv import DictReader
from config import CORPUS_QUESTION_ALIGNMENT

class QueryLoader:
    def __init__(self, queries_file: str):
        self.queries_file = queries_file
        self.queries = self.load_queries()

    def load_queries(self):
        """
        Load the queries from the CSV file and return them as a list of dictionaries.
         Each dictionary contains the query and its associated metadata.
         """
        queries = []
        with open(self.queries_file, "r") as f:
            #load csv with header and return a list of dictionaries where the keys are the column names and the values are the cell values
            reader = DictReader(f, delimiter=";")
            for row in reader:
                # Convert the 'course' field to a list if it's a string
                if isinstance(row['course'], str):
                    row['course'] = row['course'].split(',')
                queries.append(row)
        return queries



if __name__ == "__main__":
    query_loader = QueryLoader(CORPUS_QUESTION_ALIGNMENT)
    queries = query_loader.load_queries()
    print(f"Loaded {len(queries)} queries.")
    for query in queries:
        print(query)
