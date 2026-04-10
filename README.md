# Student Query Misalignment

This repository contains an experimental pipeline to study whether a student question is aligned with the knowledge and prerequisites of a set of database and Java Spring courses. The code combines three sources of information:

- a corpus of course materials stored as Markdown files,
- a knowledge graph stored in Neo4j that links courses, sections, notions, and prerequisite relations,
- embedding- and LLM-based methods used to map a student query to relevant courses or knowledge components.

The main entry point for the experiments is `src/experiments.py`.

## Repository content

### Main folders

- `data/courses/`: course materials used to build or query the course index.
- `data/kg/`: knowledge-graph assets. In particular, `build_kg.cypher` creates and populates the Neo4j graph.
- `data/queries/`: CSV files containing the expert-labelled evaluation queries.
- `index/`: FAISS index currently used by the default configuration.
- `index_qwen/`: alternate FAISS index artifacts.
- `src/`: Python source code for indexing, graph access, and experiment execution.
- `venv_misalignment/`: local Python virtual environment currently present in the repository.

### Main Python files

- `src/experiments.py`: interactive script that runs the evaluation experiments.
- `src/courses_indexer.py`: loads or builds the FAISS course index and maps queries to courses or notions.
- `src/nlp_courses_kg_indexer.py`: extracts notions from queries using either string matching or prompt-based Mistral calls.
- `src/kg_query.py`: reads courses, notions, sections, and prerequisite relations from Neo4j.
- `src/query_corpus_loader.py`: loads the evaluation query CSV files.
- `src/config.py`: central configuration for paths, model names, API key, and Neo4j connection settings.

## What the experiments evaluate

The repository currently exposes three experiment families through `src/experiments.py`.

### 1. KC extraction from student queries

This experiment evaluates how well a method extracts notions or knowledge components from a natural-language student query. The script compares extracted notions against the notions associated with the expert-labelled target course.

The evaluation reports:

- `Hit@k`
- `NDCG@k`
- mean execution time

By default, the script is currently configured to run the `NLP-based prompt` method with `k = 7`, but the source code contains placeholders for additional methods:

- `KG-based`
- `NLP-based string similarity`
- `NLP-based prompt`
- `NLP-based prompt with CoT`
- `NLP-based prompt with self-reflection`

### 2. Query-course matching

This experiment evaluates whether the course retrieval pipeline ranks the expected course(s) near the top for each query. It uses the FAISS index over the course corpus and prints, for each query:

- the retrieved courses,
- the expert ground truth,
- the number of correct matches,
- the per-query NDCG.

At the end, it prints a global NDCG over the full query set.

### 3. Query misalignment with ongoing courses

This experiment evaluates whether a query is aligned or misaligned with a predefined list of ongoing courses. It compares query notions with course notions and prerequisite structure extracted from the knowledge graph.

The evaluation reports:

- recall,
- precision,
- F1-score.

## Requirements

You need all of the following before running the experiments successfully:

- Python 3 with the required packages installed in a virtual environment.
- A running Neo4j instance.
- The knowledge graph inserted into Neo4j from `data/kg/build_kg.cypher`.
- A valid Mistral API key.

### Important note about the Mistral key

The repository currently contains a temporarily valid Mistral key in `src/config.py` and `.env`. Do not rely on it.

You should replace it with your own valid Mistral API key before running the experiments because:

- the temporary key may expire at any time,
- it may be rate-limited,
- it should not be treated as a stable credential for reproducible experiments.

## Environment setup

### 1. Activate the Python environment

If you want to reuse the local environment already present in the repository:

```bash
source venv_misalignment/bin/activate
```

If you prefer to create a clean environment instead:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

This repository does not currently expose a dedicated `requirements.txt` or `pyproject.toml`, so dependencies must come from the existing environment or be installed manually.

### 2. Configure Neo4j credentials

The Docker Compose file expects the Neo4j credentials from `.env`:

```env
NEO4J_USER=neo4j
NEO4J_PASSWORD=neo4jpwd
NEO4J_URL=bolt://127.0.0.1:7687
```

The Python code also uses the same values from `src/config.py`. Keep `.env` and `src/config.py` consistent.

### 3. Configure the Mistral API key

Update the Mistral API key in the repository before running prompt-based experiments.

The code currently reads the key from `src/config.py`:

```python
MISTRAL_API_KEY = "..."
```

Replace that value with your own key. If you also want Docker and local configuration to stay aligned, update `.env` as well.

Prompt-based experiments depend on this key. Without a valid Mistral key, the following methods will fail or return empty results:

- `NLP-based prompt`
- `NLP-based prompt with CoT`
- `NLP-based prompt with self-reflection`

## Start Neo4j and insert the graph data

Running `src/experiments.py` requires Neo4j to be available and populated. This is mandatory because the code queries the knowledge graph for:

- all notions,
- course-section relations,
- section-notion relations,
- prerequisite distances between courses.

### Recommended command

From the repository root:

```bash
docker compose up -d neo4j neo4j-init
```

What this does:

- starts the `neo4j` container,
- waits for the database to become healthy,
- runs the `neo4j-init` one-shot container,
- executes `data/kg/build_kg.cypher` inside Neo4j,
- inserts the graph data needed by the experiments.

### Optional: start everything defined in Docker Compose

If you also want the local Ollama service available:

```bash
docker compose up -d
```

This is not required for the default configuration because the current code uses Mistral for embeddings and prompt-based calls, not Ollama.

### Check that data insertion completed

You can inspect the init container logs:

```bash
docker compose logs neo4j-init
```

If the graph was inserted correctly, the container should complete without an authentication or Cypher execution error.

### If you need to reload the graph from scratch

Because Neo4j data is stored in the `neo4j-data` Docker volume, restarting the containers does not automatically reset the graph. If you want a clean reimport:

```bash
docker compose down -v
docker compose up -d neo4j neo4j-init
```

Use this only if you intentionally want to remove the existing Neo4j data volume.

## Running the experiments

Run the main experiment script from the repository root:

```bash
python src/experiments.py
```

The script will:

1. initialize the `CoursesIndexer`,
2. load or rebuild the FAISS index,
3. connect to Neo4j and compute notion weights by course,
4. initialize the NLP-based notion extractor,
5. show an interactive menu asking which experiment to run.

If the FAISS index is missing, the script will rebuild it from `data/courses/` automatically.

### Interactive menu

When launched, the script displays:

```text
1. Evaluate the KCs extraction from the queries
2. Evaluate query-course matching
3. Evaluate query misalignment with ongoing courses
```

Enter `1`, `2`, or `3` depending on the experiment you want to run.

## Detailed execution paths

### Experiment 1: Evaluate KC extraction from queries

Run:

```bash
python src/experiments.py
```

Then choose:

```text
1
```

This experiment:

- loads the expert query corpus from `data/queries/questions_resources_expert.csv`,
- extracts notions from each query,
- compares them with the notions associated with the expected course,
- computes aggregate `Hit@k`, `NDCG@k`, and execution time.

In the current source code, only `NLP-based prompt` is enabled by default. If you want to benchmark the other extraction methods, edit the `methods` list in `src/experiments.py`.

### Experiment 2: Evaluate query-course matching

Run:

```bash
python src/experiments.py
```

Then choose:

```text
2
```

This experiment:

- loads the expert query corpus,
- retrieves the top matching courses using the FAISS index,
- prints the ranked results for each query,
- compares them with the expert-labelled ground truth,
- computes a global NDCG over the dataset.

This is the main course-retrieval evaluation.

### Experiment 3: Evaluate query misalignment with ongoing courses

Run:

```bash
python src/experiments.py
```

Then choose:

```text
3
```

This experiment:

- uses a hard-coded list of ongoing courses in `src/experiments.py`,
- extracts query notions,
- compares them against course notions and prerequisite distances from Neo4j,
- evaluates whether the query should be considered aligned or misaligned,
- prints recall, precision, and F1-score.

The current ongoing course list is:

- `activity_normalization`
- `activity_decomposition`
- `practice_jpa_advanced`
- `practice_jpa`
- `practice_spring_tests`
- `practice_spring_2tiers`

If you want to evaluate another teaching context, edit the `ongoing_courses` list in `src/experiments.py`.

## Data files used by the experiments

### Course corpus

The Markdown files in `data/courses/` are the textual course resources used for indexing and retrieval.

### Query corpus

The default experiment script uses:

- `data/queries/questions_resources_expert.csv`

This file is expected to contain, at minimum, a query text and an expert-labelled target course column.

### Knowledge graph

The knowledge graph is built from:

- `data/kg/build_kg.cypher`

This Cypher script must be executed in Neo4j before any experiment that depends on `kg_query.py` can run.

## Typical workflow

For a clean run, the practical sequence is:

```bash
source venv_misalignment/bin/activate
docker compose up -d neo4j neo4j-init
python src/experiments.py
```

Then select `1`, `2`, or `3` in the interactive menu.

## Troubleshooting

### Neo4j connection errors

If the script fails when querying Neo4j:

- verify that the `neo4j` container is running,
- verify that `neo4j-init` completed successfully,
- verify that `src/config.py` and `.env` use the same Neo4j credentials,
- verify that Neo4j is reachable at `bolt://127.0.0.1:7687`.

### Empty or failing prompt-based results

If experiment 1 returns empty results for prompt-based extraction:

- check that the Mistral API key is valid,
- replace the temporary key with your own key,
- verify network access to `https://api.mistral.ai/v1/chat/completions`.

### FAISS index rebuilds automatically

If the index cannot be loaded, `CoursesIndexer` recreates it from the Markdown corpus. This can take some time on the first run.

## Notes

- The default experiment path depends on Mistral, not just on local resources.
- Neo4j is not optional for the current experiment script because notion weighting and prerequisite reasoning come from the graph.
- The Ollama container is available in `docker-compose.yaml`, but it is optional for the default configuration currently used by `src/experiments.py`.

When you're ready to make this README your own, just edit this file and use the handy template below (or feel free to structure it however you want - this is just a starting point!). Thanks to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in the template are suggestions for most open source projects. Also keep in mind that while a README can be too long and detailed, too long is better than too short. If you think your README is too long, consider utilizing another form of documentation rather than cutting out information.

## Name
Choose a self-explaining name for your project.

## Description
Let people know what your project can do specifically. Provide context and add a link to any reference visitors might be unfamiliar with. A list of Features or a Background subsection can also be added here. If there are alternatives to your project, this is a good place to list differentiating factors.

## Badges
On some READMEs, you may see small images that convey metadata, such as whether or not all the tests are passing for the project. You can use Shields to add some to your README. Many services also have instructions for adding a badge.

## Visuals
Depending on what you are making, it can be a good idea to include screenshots or even a video (you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out Asciinema for a more sophisticated method.

## Installation
Within a particular ecosystem, there may be a common way of installing things, such as using Yarn, NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people to using your project as quickly as possible. If it only runs in a specific context like a particular programming language version or operating system or has dependencies that have to be installed manually, also add a Requirements subsection.

## Usage
Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

## Support
Tell people where they can go to for help. It can be any combination of an issue tracker, a chat room, an email address, etc.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how to get started. Perhaps there is a script that they should run or some environment variables that they need to set. Make these steps explicit. These instructions could also be useful to your future self.

You can also document commands to lint the code or run tests. These steps help to ensure high code quality and reduce the likelihood that the changes inadvertently break something. Having instructions for running tests is especially helpful if it requires external setup, such as starting a Selenium server for testing in a browser.

## Authors and acknowledgment
Show your appreciation to those who have contributed to the project.

## License
For open source projects, say how it is licensed.

## Project status
If you have run out of energy or time for your project, put a note at the top of the README saying that development has slowed down or stopped completely. Someone may choose to fork your project or volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also make an explicit request for maintainers.
