


// ============================================================
// STEP 1: Create Course Nodes
// ============================================================
CREATE
/* Environment Node */
(technical_environment_home:Course {
  id: "technical_environment_home",
  name: "Aperçu de l'environnement", 
  type: "Lecture", 
  duration: 10, 
  importance: "Indispensable"
}),
(development_environment:Course {
  id: "development_environment",
  name: "Environnement de développement pour l'UV INF 210", 
  type: "Practical Activty", 
  duration: 15, 
  importance: "Indispensable"
}),


/* Docker Nodes */
(documentation_docker:Course {
  id: "documentation_docker",
  name: "Architecture N-tiers avec Docker", 
  type: "Lecture", 
  duration: 5, 
  importance: "Indispensable"
}),
(practice_docker:Course {
  id: "practice_docker",
  name: "Images et conteneurs", 
  type: "Practical Activity", 
  duration: 30, 
  importance: "Indispensable"
}),
(practice_docker_advanced:Course {
  id: "practice_docker_advanced",
  name: "Personnalisation d'images et d'architectures", 
  type: "Practical Activity", 
  duration: 45, 
  importance: "Indispensable"
}),

/* Database Management System Nodes */
(documentation_rdbms:Course {
  id: "documentation_rdbms",
  name: "Systèmes de gestion de BD", 
  type: "Lecture", 
  duration: 5, 
  importance: "Indispensable"
}),
(practice_postgresql:Course {
  id: "practice_postgresql",
  name: "PostgreSQL et Docker", 
  type: "Practical Activity", 
  duration: 15, 
  importance: "Indispensable"
}),

/* Java Spring Nodes */
(documentation_programming:Course {
  id: "documentation_programming",
  name: "Le framework Java Spring", 
  type: "Lecture", 
  duration: 5, 
  importance: "Indispensable"
}),
(practice_spring:Course {
  id: "practice_spring",
  name: "Projets avec Java Spring", 
  type: "Practical Activity", 
  duration: 30, 
  importance: "Indispensable"
}),
(spring_bean:Course {
  id: "spring_bean",
  name: "Spring bean", 
  type: "Lecture", 
  duration: 10, 
  importance: "Complement"
}),
(inversion_of_control:Course {
  id: "inversion_of_control",
  name: "Inversion de contrôle", 
  type: "Lecture", 
  duration: 10, 
  importance: "Complement"
}),

/* Architecture Patterns Nodes */
(web_architecture_home:Course {
  id: "web_architecture_home",
  name: "Introduction aux architectures d'applications web", 
  type: "Lecture", 
  duration: 5, 
  importance: "Indispensable"
}),
(lecture_technical_architecture:Course {
  id: "lecture_technical_architecture",
  name: "Architecture technique d'applications web", 
  type: "Lecture", 
  duration: 10, 
  importance: "Indispensable"
}),
(lecture_software_architecture:Course {
  id: "lecture_software_architecture",
  name: "Architecture logicielle d'applications web", 
  type: "Lecture", 
  duration: 10, 
  importance: "Indispensable"
}),
(lecture_dto:Course {
  id: "lecture_dto",
  name: "Introduction aux Data Transfer Object", 
  type: "Lecture", 
  duration: 5, 
  importance: "Indispensable"
}),

/* Spring-based Web Apps Nodes */
(lecture_mvc_spring:Course {
  id: "lecture_mvc_spring",
  name: "Architecture des applications Spring web", 
  type: "Lecture", 
  duration: 15, 
  importance: "Indispensable"
}),
(lecture_jpa:Course {
  id: "lecture_jpa",
  name: "ORM (JPA)", 
  type: "Lecture", 
  duration: 10, 
  importance: "Indispensable"
}),
(practice_spring_2tiers:Course {
  id: "practice_spring_2tiers",
  name: "Spring Web", 
  type: "Practical Activity", 
  duration: 120, 
  importance: "Indispensable"
}),
(practice_jpa:Course {
  id: "practice_jpa",
  name: "Spring JPA", 
  type: "Practical Activity", 
  duration: 120, 
  importance: "Indispensable"
}),
(practice_jpa_advanced:Course {
  id: "practice_jpa_advanced",
  name: "Spring JPA (avancée)", 
  type: "Practical Activity", 
  duration: 60, 
  importance: "Indispensable"
}),
(practice_spring_2tiers_ext:Course {
  id: "practice_spring_2tiers_ext",
  name: "Deploiement d'une application Spring", 
  type: "Practical Activity", 
  duration: 75, 
  importance: "Complement"
}),

/* Langages de structuration de données */
(practice_json:Course {
  id: "practice_json",
  name: "Sérialisation JSON", 
  type: "Practical Activity", 
  duration: 20, 
  importance: "Indispensable"
}),
(lecture_tests:Course {
  id: "lecture_tests",
  name: "Tester une application multi-couche",
  type: "Lecture",
  duration: 15,
  importance: "Indispensable"
}),

(lecture_springboot_tests:Course {
  id: "lecture_springboot_tests",
  name: "Tests avec Spring/Spring Boot",
  type: "Lecture",
  duration: 10,
  importance: "Indispensable"
}),

(practice_spring_tests:Course {
  id: "practice_spring_tests",
  name: "Activité pratique sur le test de Spring JPA",
  type: "Practical Activity",
  duration: 60,
  importance: "Indispensable"
}),

(practice_spring_microservices:Course {
  id: "practice_spring_microservices",
  name: "Développement d'une application web par micro-services",
  type: "Practical Activity",
  duration: 60,
  importance: "Complement"
}),

(lecture_software_architecture_microservices:Course {
  id: "lecture_software_architecture_microservices",
  name: "Architectures microservice",
  type: "Lecture",
  duration: 15,
  importance: "Complement"
}),

(practice_spring_microservices_2:Course {
  id: "practice_spring_microservices_2",
  name: "Développement d'une application web par micro-services",
  type: "Practical Activity",
  duration: 60,
  importance: "Complement"
}),

(practice_spring_microservices_3:Course {
  id: "practice_spring_microservices_3",
  name: "Développement d'une application web par micro-services",
  type: "Practical Activity",
  duration: 60,
  importance: "Complement"
}),

(lecture_jpa_repository:Course {
  id: "lecture_jpa_repository",
  name: "Spring Data JPA - Repository",
  type: "Lecture",
  duration: 10,
  importance: "Indispensable"
}),

(lecture_jpa_repository_advanced:Course {
  id: "lecture_jpa_repository_advanced",
  name: "Repository versus DAO",
  type: "Lecture",
  duration: 10,
  importance: "Complement"
}),
(data_home:Course {
  id: "data_home",
  name: "Persistance de données",
  type: "Lecture",
  duration: 5,
  importance: "Indispensable"
}),

(lecture_relational_model:Course {
  id: "lecture_relational_model",
  name: "Introduction au modèle relationnel",
  type: "Lecture",
  duration: 5,
  importance: "Indispensable"
}),

(lecture_db_integrity:Course {
  id: "lecture_db_integrity",
  name: "Intégrité des données",
  type: "Lecture",
  duration: 20,
  importance: "Indispensable"
}),

(activity_relational_model:Course {
  id: "activity_relational_model",
  name: "Activité sur le modèle relationnel et l'intégrité de données",
  type: "Practical Activity",
  duration: 45,
  importance: "Indispensable"
}),

(lecture_modeling_normalization:Course {
  id: "lecture_modeling_normalization",
  name: "Modélisation et normalisation de schémas relationnels",
  type: "Lecture",
  duration: 5,
  importance: "Indispensable"
}),

(lecture_conceptual_modeling:Course {
  id: "lecture_conceptual_modeling",
  name: "Modélisation conceptuelle de schémas relationnels",
  type: "Lecture",
  duration: 30,
  importance: "Indispensable"
}),

(activity_conceptual_modeling:Course {
  id: "activity_conceptual_modeling",
  name: "Activité - Modélisation conceptuelle des données et dérivation",
  type: "Practical Activity",
  duration: 30,
  importance: "Indispensable"
}),

(activity_conceptual_modeling_advanced:Course {
  id: "activity_conceptual_modeling_advanced",
  name: "Activité - Modélisation conceptuelle des données et dérivation (version avancée)",
  type: "Practical Activity",
  duration: 45,
  importance: "Complement"
}),

(lecture_normalization:Course {
  id: "lecture_normalization",
  name: "Normalisation et découpage d'une relation universelle",
  type: "Lecture",
  duration: 30,
  importance: "Indispensable"
}),

(activity_normalization:Course {
  id: "activity_normalization",
  name: "Activité - Dépendances fonctionnelles et formes normales",
  type: "Practical Activity",
  duration: 45,
  importance: "Indispensable"
}),

(activity_decomposition:Course {
  id: "activity_decomposition",
  name: "Activity - Décomposition d'une relation",
  type: "Practical Activity",
  duration: 30,
  importance: "Indispensable"
}),

(lecture_independence_views:Course {
  id: "lecture_independence_views",
  name: "Les vues en SQL",
  type: "Lecture",
  duration: 15,
  importance: "Complement"
}),

(practice_independence_views:Course {
  id: "practice_independence_views",
  name: "Activité pratique - Indépendance des données - Mécanisme des vues externes",
  type: "Practical Activity",
  duration: 60,
  importance: "Complement"
}),

(lecture_relational_algebra:Course {
  id: "lecture_relational_algebra",
  name: "L'algèbre relationnel",
  type: "Lecture",
  duration: 30,
  importance: "Complement"
}),

(activity_sql:Course {
  id: "activity_sql",
  name: "Introduction au langage SQL",
  type: "Practical Activity",
  duration: 30,
  importance: "Indispensable"
}),

(practice_sql:Course {
  id: "practice_sql",
  name: "Pratiquer avec le langage SQL",
  type: "Practical Activity",
  duration: 30,
  importance: "Indispensable"
}),

(practice_advanced_sql:Course {
  id: "practice_advanced_sql",
  name: "Pratiquer avec le langage SQL en version avancée",
  type: "Practical Activity",
  duration: 45,
  importance: "Complement"
}),

(lecture_transaction:Course {
  id: "lecture_transaction",
  name: "Transaction",
  type: "Lecture",
  duration: 20,
  importance: "Indispensable"
}),

(practice_transaction:Course {
  id: "practice_transaction",
  name: "Activité pratique - Transactions",
  type: "Practical Activity",
  duration: 45,
  importance: "Indispensable"
}),

(lecture_isolation:Course {
  id: "lecture_isolation",
  name: "Niveaux d'isolation dans un SGBDR",
  type: "Lecture",
  duration: 20,
  importance: "Complement"
}),

(practice_isolation:Course {
  id: "practice_isolation",
  name: "Activité pratique - Niveaux d'isolation",
  type: "Practical Activity",
  duration: 45,
  importance: "Complement"
}),

(lecture_indexation:Course {
  id: "lecture_indexation",
  name: "Plan d'exécution de requêtes et indexation",
  type: "Lecture",
  duration: 10,
  importance: "Complement"
}),

(practice_indexation:Course {
  id: "practice_indexation",
  name: "Activité pratique - Indexation",
  type: "Practical Activity",
  duration: 20,
  importance: "Complement"
}),
(lecture_json:Course {
  id: "lecture_json",
  name: "Le format JSON", 
  type: "Lecture", 
  duration: 10, 
  importance: "Indispensable"
});
// ============================================================
// STEP 2: Create Prerequisite Relationships
// ============================================================
MATCH 
  (technical_environment_home:Course {name: "Aperçu de l'environnement"}),
  (documentation_docker:Course {name: "Architecture N-tiers avec Docker"}),
  (documentation_programming:Course {name: "Le framework Java Spring"}),
  (practice_postgresql:Course {name: "PostgreSQL et Docker"}),
  (documentation_rdbms:Course {name: "Systèmes de gestion de BD"}),
  (practice_docker:Course {name: "Images et conteneurs"}),
  (practice_docker_advanced:Course {name: "Personnalisation d'images et d'architectures"}),
  (inversion_of_control:Course {name: "Inversion de contrôle"}),
  (practice_spring:Course {name: "Projets avec Java Spring"}),
  (spring_bean:Course {name: "Spring bean"}),
  (web_architecture_home:Course {name: "Introduction aux architectures d applications web"}),
  (lecture_technical_architecture:Course {name: "Architecture technique d applications web"}),
  (lecture_software_architecture:Course {name: "Architecture logicielle d applications web"}),
  (practice_spring_2tiers_ext:Course {name: "Deploiement d une application Spring"}),
  (practice_spring_2tiers:Course {name: "Spring Web"}),
  (lecture_mvc_spring:Course {name: "Architecture des applications Spring web"}),
  (lecture_jpa:Course {name: "ORM (JPA)"}),
  (practice_jpa:Course {name: "Spring JPA"}),
  (practice_jpa_advanced:Course {name: "Spring JPA (avancée)"}),
  (lecture_dto:Course {name: "Introduction aux Data Transfer Object"}),
  (lecture_json:Course {name: "Le format JSON"}),
  (practice_json: Course {name: "Sérialisation JSON"}),
  (development_environment:Course {name: "Environnement de développement pour l'UV INF 210"}),

  // New courses
  (lecture_tests:Course {name: "Tester une application multi-couche"}),
  (lecture_springboot_tests:Course {name: "Tests avec Spring/Spring Boot"}),
  (practice_spring_tests:Course {name: "Activité pratique sur le test de Spring JPA"}),
  (practice_spring_microservices:Course {name: "Développement d'une application web par micro-services"}),
  (lecture_software_architecture_microservices:Course {name: "Architectures microservice"}),
  (practice_spring_microservices_2:Course {name: "Développement d'une application web par micro-services"}),
  (practice_spring_microservices_3:Course {name: "Développement d'une application web par micro-services"}),
  (lecture_jpa_repository:Course {name: "Spring Data JPA - Repository"}),
  (lecture_jpa_repository_advanced:Course {name: "Repository versus DAO"}),
  (data_home:Course {name: "Persistance de données"}),
  (lecture_relational_model:Course {name: "Introduction au modèle relationnel"}),
  (lecture_db_integrity:Course {name: "Intégrité des données"}),
  (activity_relational_model:Course {name: "Activité sur le modèle relationnel et l'intégrité de données"}),
  (lecture_modeling_normalization:Course {name: "Modélisation et normalisation de schémas relationnels"}),
  (lecture_conceptual_modeling:Course {name: "Modélisation conceptuelle de schémas relationnels"}),
  (activity_conceptual_modeling:Course {name: "Activité - Modélisation conceptuelle des données et dérivation"}),
  (activity_conceptual_modeling_advanced:Course {name: "Activité - Modélisation conceptuelle des données et dérivation (version avancée)"}),
  (lecture_normalization:Course {name: "Normalisation et découpage d'une relation universelle"}),
  (activity_normalization:Course {name: "Activité - Dépendances fonctionnelles et formes normales"}),
  (activity_decomposition:Course {name: "Activity - Décomposition d'une relation"}),
  (lecture_independence_views:Course {name: "Les vues en SQL"}),
  (practice_independence_views:Course {name: "Activité pratique - Indépendance des données - Mécanisme des vues externes"}),
  (lecture_relational_algebra:Course {name: "L'algèbre relationnel"}),
  (activity_sql:Course {name: "Introduction au langage SQL"}),
  (practice_sql:Course {name: "Pratiquer avec le langage SQL"}),
  (practice_advanced_sql:Course {name: "Pratiquer avec le langage SQL en version avancée"}),
  (lecture_transaction:Course {name: "Transaction"}),
  (practice_transaction:Course {name: "Activité pratique - Transactions"}),
  (lecture_isolation:Course {name: "Niveaux d'isolation dans un SGBDR"}),
  (practice_isolation:Course {name: "Activité pratique - Niveaux d'isolation"}),
  (lecture_indexation:Course {name: "Plan d'exécution de requêtes et indexation"}),
  (practice_indexation:Course {name: "Activité pratique - Indexation"})

UNWIND [
  {from: "technical_environment_home", to: "documentation_docker"},
  {from: "technical_environment_home", to: "documentation_programming"},
  {from: "technical_environment_home", to: "practice_postgresql"},
  {from: "technical_environment_home", to: "documentation_rdbms"},
  {from: "documentation_docker", to: "practice_docker"},
  {from: "practice_docker", to: "practice_docker_advanced"},
  {from: "practice_docker", to: "practice_postgresql"},
  {from: "practice_docker", to: "development_environment"},
  {from: "practice_postgresql", to: "development_environment"},
  {from: "practice_spring", to: "development_environment"},
  {from: "documentation_programming", to: "inversion_of_control"},
  {from: "practice_spring", to: "spring_bean"},
  {from: "web_architecture_home", to: "lecture_technical_architecture"},
  {from: "web_architecture_home", to: "lecture_software_architecture"},
  {from: "lecture_technical_architecture", to: "practice_spring_2tiers_ext"},
  {from: "practice_spring_2tiers", to: "practice_spring_2tiers_ext"},
  {from: "lecture_technical_architecture", to: "lecture_software_architecture_microservices"},
  {from: "lecture_software_architecture", to: "lecture_software_architecture_microservices"},
  {from: "lecture_software_architecture_microservices", to: "practice_spring_microservices"},
  {from: "lecture_mvc_spring", to: "practice_spring_microservices"},
  {from: "practice_spring_microservices", to: "practice_spring_microservices_2"},
  {from: "practice_spring_microservices", to: "practice_spring_microservices_3"},
  {from: "practice_jpa", to: "practice_spring_2tiers"},
  {from: "lecture_software_architecture", to: "lecture_jpa"},
  {from: "lecture_software_architecture", to: "lecture_mvc_spring"},
  {from: "lecture_mvc_spring", to: "practice_jpa"},
  {from: "lecture_jpa", to: "practice_jpa"},
  {from: "lecture_jpa", to: "lecture_jpa_repository"},
  {from: "lecture_jpa_repository", to: "lecture_jpa_repository_advanced"},
  {from: "practice_jpa", to: "practice_jpa_advanced"},
  {from: "lecture_mvc_spring", to: "lecture_tests"},
  {from: "lecture_tests", to: "lecture_springboot_tests"},
  {from: "lecture_springboot_tests", to: "practice_spring_tests"},
  {from: "lecture_software_architecture", to: "lecture_dto"},
  {from: "data_home", to: "lecture_relational_model"},
  {from: "data_home", to: "lecture_modeling_normalization"},
  {from: "data_home", to: "lecture_independence_views"},
  {from: "data_home", to: "activity_sql"},
  {from: "data_home", to: "lecture_indexation"},
  {from: "data_home", to: "lecture_transaction"},
  {from: "lecture_relational_model", to: "lecture_relational_algebra"},
  {from: "lecture_relational_model", to: "lecture_db_integrity"},
  {from: "lecture_db_integrity", to: "activity_relational_model"},
  {from: "lecture_modeling_normalization", to: "lecture_conceptual_modeling"},
  {from: "lecture_conceptual_modeling", to: "activity_conceptual_modeling"},
  {from: "activity_conceptual_modeling", to: "activity_conceptual_modeling_advanced"},
  {from: "lecture_modeling_normalization", to: "lecture_normalization"},
  {from: "lecture_normalization", to: "activity_normalization"},
  {from: "activity_normalization", to: "activity_decomposition"},
  {from: "lecture_independence_views", to: "practice_independence_views"},
  {from: "activity_sql", to: "practice_sql"},
  {from: "practice_sql", to: "practice_advanced_sql"},
  {from: "activity_sql", to: "practice_indexation"},
  {from: "activity_sql", to: "practice_transaction"},
  {from: "lecture_transaction", to: "practice_transaction"},
  {from: "practice_transaction", to: "practice_indexation"},
  {from: "lecture_indexation", to: "practice_indexation"},
  {from: "lecture_transaction", to: "lecture_isolation"},
  {from: "practice_transaction", to: "practice_isolation"},
  {from: "lecture_isolation", to: "practice_isolation"},
  {from: "lecture_dto", to: "lecture_json"},
  {from: "lecture_json", to: "practice_json"}
] AS rel
MATCH (from:Course {id: rel.from})
MATCH (to:Course {id: rel.to})
MERGE (from)-[:PREREQUISITE]->(to);

// ============================================================
// STEP 3: Create Section Nodes
// ============================================================
CREATE
(:Section {label: "Java Spring et le développement web", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/technical_environment_home.html#java-spring-et-le-développement-web"}),
(:Section {label: "Postgresql", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/technical_environment_home.html#postgresql"}),
(:Section {label: "Virtualisation vs. Conteneurisation", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_docker.html#virtualisation-vs-conteneurisation"}),
(:Section {label: "Images", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_docker.html#images"}),
(:Section {label: "Conteneurs", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_docker.html#conteneurs"}),
(:Section {label: "Dockerfile et Docker-compose", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_docker.html#dockerfile-et-docker-compose"}),
(:Section {label: "Docker c'est quoi", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker.html#docker-cest-quoi"}),
(:Section {label: "Image et conteneur", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker.html#image-et-conteneur"}),
(:Section {label: "Déployer un ensemble de services pré-configurés", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker.html#déployer-un-ensemble-de-services-pré-configurés"}),
(:Section {label: "Démarrer et arrêter les services", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker.html#démarrer-et-arrêter-les-services"}),
(:Section {label: "Dockerfile", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker_advanced.html"}),
(:Section {label: "Docker compose", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker_advanced.html"}),
(:Section {label: "Volumes", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker_advanced.html"}),
(:Section {label: "Réseaux virtuel", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_docker_advanced.html"}),
(:Section {label: "Qu'est-ce qu'un système de gestion de bases de données (SGBD) ?", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_rdbms.html#quest-ce-quun-système-de-gestion-de-bases-de-données-sgbd-"}),
(:Section {label: "Objectif d'un SGBD", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_rdbms.html#objectifs-dun-sgbd"}),
(:Section {label: "Fonctionnalités d'un SGBD", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_rdbms.html#fonctionnalités-dun-sgbd"}),
(:Section {label: "Les SGBD sont-ils incontournables ?", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_rdbms.html#les-sgbd-sont-ils-incontournables-"}),
(:Section {label: "Une démarche orientée système", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_rdbms.html#une-démarche-orientée-système"}),
(:Section {label: "Connexion au SGBDR", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_postgresql.html#connexion-au-sgbdr"}),
(:Section {label: "Schéma de la base de données", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_postgresql.html#schéma-de-la-base-de-données"}),
(:Section {label: "Le framework Spring", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/documentation_programming.html#le-framework-spring"}),
(:Section {label: "Application web avec Spring boot", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring.html#application-web-avec-spring-boot"}),
(:Section {label: "Gestion de l'application avec Maven", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring.html#gestion-de-lapplication-avec-maven"}),
(:Section {label: "Spring bean", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/spring_bean.html"}),
(:Section {label: "L'inversion de contrôle (IoC)", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/inversion_of_control.html#linversion-de-contrôle-ioc"}),
(:Section {label: "Contexte d'application", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/inversion_of_control.html#contexte-dapplication"}),
(:Section {label: "L'injection de dépendances", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/inversion_of_control.html#linjection-de-dépendances"}),
(:Section {label: "Injection de valeur", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/inversion_of_control.html#injection-de-valeur"}),
(:Section {label: "Sérialisation", order: 1, url:"https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_dto.html"}),
(:Section {label: "Le patron DTO", order: 2, url:"https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_dto.html"}),
(:Section {label: "Structuration d'une application web", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/web_architecture_home.html#structuration-dune-application-web"}),
(:Section {label: "Échange de données", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/web_architecture_home.html#%C3%A9change-de-donn%C3%A9es"}),
(:Section {label: "Quelques notions d'architecture technique", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_technical_architecture.html#quelques-notions-darchitecture-technique"}),
(:Section {label: "Architecture N-tiers", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_technical_architecture.html#architecture-n-tiers"}),
(:Section {label: "Les applications dans le cloud et les micro-services", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_technical_architecture.html#les-applications-dans-le-cloud-et-les-micro-services"}),
(:Section {label: "Les architectures multi-couches", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture.html#les-architectures-multi-couches"}),
(:Section {label: "Les patrons de conception", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture.html#les-patrons-de-conception"}),
(:Section {label: "Le patron MVC", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture.html#le-patron-de-conception-mvc"}),
(:Section {label: "Le principe REST et les architectures par micro-service", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture.html#le-principe-rest-et-les-architectures-par-micro-services"}),
(:Section {label: "Découpage fonctionnel d'une application Spring", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_mvc_spring.html#d%C3%A9coupage-fonctionnel-dune-application-spring"}),
(:Section {label: "MVC dans Spring", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_mvc_spring.html#mvc-dans-spring"}),
(:Section {label: "Développer du MVC avec Spring", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_mvc_spring.html#developper-du-mvc-avec-spring"}),
(:Section {label: "Rappel sur l'architecture technique", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers.html#rappel-sur-larchitecture-technique"}),
(:Section {label: "Présentation de l'application", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers.html#pr%C3%A9sentation-de-lapplication"}),
(:Section {label: "Structuration de l'application", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers.html#structuration-de-lapplication"}),
(:Section {label: "La couche présentation", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers.html#la-couche-pr%C3%A9sentation"}),
(:Section {label: "Vers des architectures REST pour les micro-services", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers_ext.html#vers-des-architectures-rest-pour-les-micro-services"}),
(:Section {label: "Vers une architecture 3-tiers", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_2tiers_ext.html#vers-une-architecture-3-tiers"}),
(:Section {label: "Principe d'un ORM", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa.html#principe-dun-orm"}),
(:Section {label: "Java Persistence API (JPA)", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa.html#java-persistence-api-jpa"}),
(:Section {label: "Connexion à la base de données", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa.html#connexion-%C3%A0-la-base-de-donn%C3%A9es"}),
(:Section {label: "Association objet – base de données relationnelle", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa.html#association-objet---base-de-donn%C3%A9es-relationnelle"}),
(:Section {label: "L'Entity Manager", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa.html#lentity-manager"}),
(:Section {label: "Le projet comrec", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#le-projet-comrec"}),
(:Section {label: "Exercice 1 (découverte de JPA via un cas simple)", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#exercice-1-d%C3%A9couverte-de-jpa-via-un-cas-simple"}),
(:Section {label: "Le mapping entre les classes et les tables", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#le-mapping-entre-les-classes-et-les-tables"}),
(:Section {label: "Collections persistantes", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#collections-persistantes"}),
(:Section {label: "Gestion des identifiants / clé primaire", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#gestion-des-identi%EF%AC%81ants--cl%C3%A9-primaire"}),
(:Section {label: "Gestion des associations", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa.html#gestion-des-associations"}),
(:Section {label: "Les classes de l'application", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa_advanced.html#les-classes-de-lapplication"}),
(:Section {label: "Recherche et gestion du cache", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa_advanced.html#recherche-et-gestion-du-cache"}),
(:Section {label: "Retour sur le contexte transactionnel", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_jpa_advanced.html#retour-sur-le-contexte-transactionnel"}),
(:Section {label: "Activité JSON et JAVA", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_json.html"}),
(:Section {label: "JSON", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_json.html"}),
(:Section {label: "Mise en place de l'environnement de développement", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/development_environment.html#mise-en-place-de-lenvironnement-de-d%C3%A9veloppement"}),
(:Section {label: "Service dockerisé", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/development_environment.html#services-dockeris%C3%A9"}),
(:Section {label: "Démarrage des services BD et Web", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/development_environment.html#d%C3%A9marrage-des-services-bd-et-web"}),
(:Section {label: "Applications Java Spring", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/development_environment.html#applications-java-spring"}),
// Green group 1 - Tests lecture
(:Section {label: "Rappels rapides sur les tests", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_tests.html#rappels-rapides-sur-les-tests"}),
(:Section {label: "Tester une application multi-couche", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_tests.html#tester-une-application-multi-couche"}),

// Green group 2 - Spring Boot tests lecture
(:Section {label: "Tester les repositories de la couche données", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#tester-les-repositories-de-la-couche-de-donn%C3%A9es"}),
(:Section {label: "Configuration", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#configuration"}),
(:Section {label: "Bonnes pratiques", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#bonnes-pratiques"}),
(:Section {label: "Tester les classes de la couche services", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#tester-les-classes-de-la-couche-services"}),
(:Section {label: "Les tests unitaires", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#les-tests-unitaires"}),
(:Section {label: "Les tests d'integration", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#les-tests-dint%C3%A9gration"}),
(:Section {label: "Bonnes pratiques", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_springboot_tests.html#bonnes-pratiques-1"}),

// Green group 3 - Spring tests practice
(:Section {label: "Tests unitaires avec Junit", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_tests.html#exercice-1-tests-unitaires-avec-junit"}),
(:Section {label: "Tester les repository JPA", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_tests.html#exercice-2-tester-les-repository-jpa"}),
(:Section {label: "Tester la couche services", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_tests.html#exercice-3-tester-la-couche-services"}),

// Orange group 1 - Microservices practice 1
(:Section {label: "Présentation de l'application", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices.html#pr%C3%A9sentation-de-lapplication"}),
(:Section {label: "Réservation de billets avec une BD partagée", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices.html#r%C3%A9servation-de-billets-avec-une-bd-partag%C3%A9e"}),

// Orange group 2 - Microservices lecture
(:Section {label: "Les architectures par micro-services", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#les-architectures-par-micro-services"}),
(:Section {label: "Conception d'architectures micro-service", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#conception-darchitectures-micro-service"}),
(:Section {label: "Gestion des données dans une architecture micro-service", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#gestion-des-donn%C3%A9es-dans-une-architecture-micro-service"}),
(:Section {label: "Gestion des transactions inter-services", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#gestion-des-transactions-inter-services"}),
(:Section {label: "Gestion des services", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#gestion-des-services"}),
(:Section {label: "Les principes de communication REST", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#les-principes-de-communication-rest"}),
(:Section {label: "Les principes de communication asynchrone entre (micro-)services", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_software_architecture_microservices.html#les-principes-de-communication-asynchrone-entre-micro-services"}),

// Orange group 3 - Microservices practice 2
(:Section {label: "Développement d'une application web par micro-services", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_2.html#pr%C3%A9sentation-de-lapplication"}),
(:Section {label: "Préparation de l'application", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_2.html#pr%C3%A9paration-de-lapplication"}),
(:Section {label: "Exécution indépendante des micro-services", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_2.html#ex%C3%A9cution-ind%C3%A9pendante-des-micro-services"}),
(:Section {label: "Gestion des transactions entre micro-services", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_2.html#gestion-des-transactions-entre-micro-services"}),

// Orange group 4 - Microservices practice 3
(:Section {label: "Développement d'une application web par micro-services", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#pr%C3%A9sentation-de-lapplication"}),
(:Section {label: "Mise en place de l'application", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#mise-en-place-de-lapplication"}),
(:Section {label: "Préparation de l'application", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#pr%C3%A9paration-de-lapplication"}),
(:Section {label: "Exécution indépendante des micro-services", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#ex%C3%A9cution-ind%C3%A9pendante-des-micro-services"}),
(:Section {label: "Rendre asynchrone les étapes d'une transaction entre micro-services", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#pr%C3%A9paration-de-lapplication-1"}),
(:Section {label: "Communiquer via un serveur kafka", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#communiquer-via-un-serveur-kafka"}),
(:Section {label: "Activer kafka dans l'application", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#activer-kafka-dans-lapplication"}),
(:Section {label: "POJO de communication des données", order: 8, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#pojo-de-communication-des-donn%C3%A9es"}),
(:Section {label: "Configuration d'un producteur de messages kafka", order: 9, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#configuration-dun-producteur-de-messages-kafka"}),
(:Section {label: "Configuration d'un consommateur de messages kafka", order: 10, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_spring_microservices_3.html#configuration-dun-consommateur-de-messages-kafka"}),

// Vert group 1 - JPA Repository lecture
(:Section {label: "Spring Data JPA - Repository", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#questce-quun-repository-"}),
(:Section {label: "À quoi sert un Repository ?", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#%C3%A0-quoi-sert-un-repository-"}),
(:Section {label: "Comment créer et utiliser un Repository ?", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#comment-cr%C3%A9er-et-utiliser-un-repository-"}),
(:Section {label: "Comment enrichir un Repository avec des méthodes spécifiques ?", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#comment-enrichir-un-repository-avec-des-m%C3%A9thodes-sp%C3%A9cifiques-"}),
(:Section {label: "Convention de nommage des méthodes", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#convention-de-nommage-des-m%C3%A9thodes"}),
(:Section {label: "Bonnes pratiques", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository.html#bonnes-pratiques"}),

// Orange group 5 - JPA Repository advanced
(:Section {label: "Repository versus DAO", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository_advanced.html#d%C3%A9clarer-des-requ%C3%AAtes-complexes"}),
(:Section {label: "Pour aller plus loin : fonctionnement interne", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository_advanced.html#pour-aller-plus-loin--fonctionnement-interne"}),
(:Section {label: "Comparaison entre le pattern DAO et le concept Repository", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository_advanced.html#comparaison-entre-le-pattern-dao-et-le-concept-repository"}),
(:Section {label: "Quand utiliser DAO ou Repository ?", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_jpa_repository_advanced.html#quand-utiliser-dao-ou-repository-"});
UNWIND [
  {label: "Persistance de données", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/data_home.html"},
  {label: "Introduction", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_model.html"},
  {label: "Définitions", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_model.html#d%C3%A9finitions"},
  {label: "Integrité de relation", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_db_integrity.html#int%C3%A9grit%C3%A9-de-relation"},
  {label: "Integrité de domaine", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_db_integrity.html#int%C3%A9grit%C3%A9-de-domaine"},
  {label: "Integrité référentielle", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_db_integrity.html#int%C3%A9grit%C3%A9-r%C3%A9f%C3%A9rentielle"},
  {label: "Integrité utilisateur", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_db_integrity.html#int%C3%A9grit%C3%A9-utilisateur"},
  {label: "La notion de clé primaire et de clé candidate", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_relational_model.html#la-notion-de-clef-primaire-et-candidate"},
  {label: "La notion de clef étrangère", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_relational_model.html#la-notion-de-clef-%C3%A9trang%C3%A8re"},
  {label: "Dictionnaire de données", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_modeling_normalization.html#dictionnaire-de-donn%C3%A9es"},
  {label: "Relation universelle", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_modeling_normalization.html#relation-universelle"},
  {label: "Redondance et difficulté d'interrogation", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_modeling_normalization.html#redondance-et-difficult%C3%A9-dinterrogation"},
  {label: "Introduction", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html"},
  {label: "Le langage UML (enfin une partie)", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#le-langage-uml-enfin-une-partie"},
  {label: "Règle 1 - Dérivation d'une classe", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#r%C3%A8gle-1--d%C3%A9rivation-de-classe"},
  {label: "Règle 2 - Dérivation d'une association de type 1:1", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#r%C3%A8gle-2--d%C3%A9rivation-dune-association-de-type-11"},
  {label: "Règle 3 - Dérivation d'une association de type 1:N", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#r%C3%A8gle-3--d%C3%A9rivation-dune-association-de-type-1n"},
  {label: "Règle 4 - Dérivation d'une association de type n:m", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#r%C3%A8gle-4--d%C3%A9rivation-dune-association-de-type-nm"},
  {label: "Règle 5 - Dérivation de l'héritage de classes", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_conceptual_modeling.html#r%C3%A8gle-5--d%C3%A9rivation-de-lh%C3%A9ritage-de-classes"},
  {label: "La place de la modélisation conceptuelle de données", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_conceptual_modeling.html#la-place-de-la-mod%C3%A9lisation-conceptuelle-de-donn%C3%A9es"},
  {label: "Présentation du problème", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_conceptual_modeling_advanced.html#pr%C3%A9sentation-du-probl%C3%A8me"},
  {label: "Introduction", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html"},
  {label: "Définition", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#d%C3%A9finition"},
  {label: "Quelques propriétés des dépendances fonctionnelles", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#quelques-propri%C3%A9t%C3%A9s-des-d%C3%A9pendances-fonctionnelles"},
  {label: "Types de dépendances fonctionnelles", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#types-de-d%C3%A9pendances-fonctionnelles"},
  {label: "Graphe des dépendances élémentaires directes", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#graphe-des-d%C3%A9pendances-fonctionnelles-%C3%A9l%C3%A9mentaires-et-directes"},
  {label: "Clé de la relation universelle", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#clef-de-la-relation-universelle"},
  {label: "Première forme normale", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#premi%C3%A8re-forme-normale"},
  {label: "Deuxième forme normale", order: 8, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#deuxi%C3%A8me-forme-normale"},
  {label: "Troisième forme normale", order: 9, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_normalization.html#troisi%C3%A8me-forme-normale"},
  {label: "Dépendances fonctionnelles", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_normalization.html#d%C3%A9pendances-fonctionnelles"},
  {label: "Formes normales", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_normalization.html#formes-normales"},
  {label: "Couverture minimale", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_decomposition.html#couverture-minimale"},
  {label: "Règles d'inférence d'Armstrong sur les dépendances fonctionnelles", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_decomposition.html#r%C3%A8gles-dinf%C3%A9rence-darmstrong-sur-les-d%C3%A9pendances-fonctionnelles"},
  {label: "Algorithme de décomposition d'une relation", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_decomposition.html#algorithme-de-d%C3%A9composition-dune-relation"},
  {label: "Applications", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_decomposition.html#applications"},
  {label: "Les vues en SQL", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_independence_views.html"},
  {label: "Activité pratique - Indépendance des données - Mécanisme des vues externes", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_independence_views.html"},
  {label: "Introduction", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.htm"},
  {label: "Projection", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#projection"},
  {label: "Sélection", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#s%C3%A9lection"},
  {label: "Composition de tuples", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#composition-de-tuples"},
  {label: "Produit cartésien", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#produit-cart%C3%A9sien"},
  {label: "Jointure", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#jointure"},
  {label: "Union", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#union"},
  {label: "Intersection", order: 8, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#intersection"},
  {label: "Différence", order: 9, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#diff%C3%A9rence"},
  {label: "Fonction d'aggrégation", order: 10, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#fonction-dagr%C3%A9gation"},
  {label: "Groupement de tuples", order: 11, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#groupement-de-tuples"},
  {label: "Filtrage de groupes", order: 12, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#filtrage-de-groupes"},
  {label: "Expression algébrique imbriquée", order: 13, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_relational_algebra.html#expression-alg%C3%A9brique-imbriqu%C3%A9e"},
  {label: "Structure générale d'une requête", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_sql.html#structure-g%C3%A9n%C3%A9rale-dune-requ%C3%AAte"},
  {label: "Interrogation d'une table", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_sql.html#interrogation-dune-table"},
  {label: "Jointures entre plusieurs tables", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_sql.html#jointures-entre-plusieurs-tables"},
  {label: "Calculs et regroupements", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/activity_sql.html#calculs-et-regroupement"},
  {label: "Description de la base de données SOINS", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#description-de-la-base-de-donn%C3%A9es-soins"},
  {label: "Accès à la BD", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#acc%C3%A8s-%C3%A0-la-bd"},
  {label: "Pattern matching et tris", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#pattern-matching-et-tris"},
  {label: "Jointures", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#jointures"},
  {label: "Négations et listes", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#n%C3%A9gation-et-listes"},
  {label: "Comptages et aggrégation", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_sql.html#comptages-et-aggr%C3%A9gations"},
  {label: "Description de la base de données SOINS", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_advanced_sql.html#description-de-la-base-de-donn%C3%A9es-soins"},
  {label: "Accès à la BD", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_advanced_sql.html#acc%C3%A8s-%C3%A0-la-bd"},
  {label: "Quelques requêtes simples", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_advanced_sql.html#quelques-requ%C3%AAtes-simples"},
  {label: "Des requêtes plus compliquées", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_advanced_sql.html#quelques-requ%C3%AAtes-plus-compliqu%C3%A9es"},
  {label: "Quelques indications sur les différents types de jointure", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_advanced_sql.html#quelques-indications-sur-les-diff%C3%A9rents-types-de-jointure"},
  {label: "Transaction", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_transaction.html#transaction"},
  {label: "Propriétés ACID", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_transaction.html#propri%C3%A9t%C3%A9s-acid"},
  {label: "Concurrence", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_transaction.html#concurrence"},
  {label: "Contexte", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#contexte"},
  {label: "Mise en place du TP", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#mise-en-place-du-tp"},
  {label: "Présentation des vues", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#pr%C3%A9sentation-des-vues"},
  {label: "Présentation des fonctions stockées", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#pr%C3%A9sentation-des-fonctions-stock%C3%A9es"},
  {label: "Valider et annuler une transaction", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#valider-et-annuler-une-transaction"},
  {label: "Retour sur l'intégrité de données", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_transaction.html#un-retour-sur-lint%C3%A9grit%C3%A9-des-donn%C3%A9es"},
  {label: "Lecture fantôme", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#lecture-fant%C3%B4me"},
  {label: "Lecture non reproductible", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#lecture-non-reproductible"},
  {label: "Mise à jour perdue", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#mise-%C3%A0-jour-perdue"},
  {label: "Lecture sale", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#lecture-sale"},
  {label: "Sérializable", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#s%C3%A9rializable"},
  {label: "Repeatable reads", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#repeatable-reads"},
  {label: "Read commited", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#read-committed"},
  {label: "Read uncommited", order: 8, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_isolation.html#read-uncommitted"},
  {label: "Accès à la BD", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#acc%C3%A8s-%C3%A0-la-bd"},
  {label: "Création d'un environnement concurrent", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#cr%C3%A9ation-dun-environnement-concurrent"},
  {label: "Découverte des niveaux d'isolation", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#d%C3%A9couverte-des-niveaux-disolation"},
  {label: "Modification des niveaux d'isolation", order: 4, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#modification-des-niveaux-disolation"},
  {label: "Lectures reproductibles", order: 5, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#lectures-reproductibles"},
  {label: "Fantômes", order: 6, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#fant%C3%B4mes"},
  {label: "Bilan du niveau Sérializable", order: 7, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#bilan-du-comportement-du-niveau-serializable"},
  {label: "Erreurs de séarialisation et interblocages", order: 8, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#erreurs-de-s%C3%A9rialisation-et-interblocages"},
  {label: "Phénomènes survenant lors des transactions", order: 9, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#ph%C3%A9nom%C3%A8nes-survenant-lors-des-transactions"},
  {label: "Niveaux d'isolation ANSI", order: 10, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_isolation.html#niveaux-disolation-ansi"},
  {label: "Plan d'exécution des requêtes", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_indexation.html#plan-dex%C3%A9cution-de-requ%C3%AAtes"},
  {label: "EXPLAIN", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_indexation.html#explain"},
  {label: "Types d'index", order: 3, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/lecture_indexation.html#types-dindex"},
  {label: "Création d'un index", order: 1, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_indexation.html#cr%C3%A9ation-dun-index"},
  {label: "Colonne tx_vector", order: 2, url: "https://hub.imt-atlantique.fr/uv-fip-inf210/practice_indexation.html#colonne-ts_vector"}
] AS section
CREATE (:Section {label: section.label, order: section.order, url: section.url});

// ============================================================
// STEP 4: Create Notion Nodes
// ============================================================
UNWIND [
  {id: 'Archi.1', label: 'Séparation de responsabilités'},
  {id: 'Archi.2', label: 'DTO'},
  {id: 'Archi.3', label: 'Architecture technique'},
  {id: 'Archi.4', label: 'Architecture logicielle'},
  {id: 'Archi.5', label: 'Service'},
  {id: 'Archi.6', label: 'Architecture client/serveur'},
  {id: 'Archi.8', label: 'Tier'},
  {id: 'Archi.9', label: 'Conteneur Docker'},
  {id: 'Archi.10', label: 'Architecture 1-tier'},
  {id: 'Archi.11', label: 'Architecture 2-tiers'},
  {id: 'Archi.12', label: 'Architecture 3-tiers'},
  {id: 'Archi.13', label: 'Serveur web'},
  {id: 'Archi.14', label: "Serveur d'application"},
  {id: 'Archi.15', label: 'Architecture N-tiers'},
  {id: 'Archi.16', label: 'Architecture cloud'},
  {id: 'Archi.17', label: 'Architecture multi-couches'},
  {id: 'Archi.18', label: 'Couche présentation'},
  {id: 'Archi.19', label: 'Couche métier'},
  {id: 'Archi.20', label: 'Couche données'},
  {id: 'Archi.21', label: 'Patron de conception'},
  {id: 'Archi.22', label: 'Singleton'},
  {id: 'Archi.23', label: 'Fabrique'},
  {id: 'Archi.24', label: 'Data Access Object'},
  {id: 'Archi.25', label: 'Patron MVC'},
  {id: 'Archi.26', label: 'Modèle'},
  {id: 'Archi.27', label: 'Vue'},
  {id: 'Archi.28', label: 'Contrôleur'},
  {id: 'Archi.29', label: 'Architecture par micro-services'},
  {id: 'Archi.30', label: 'REST'},
  {id: 'Archi.31', label: 'Sérialisation'},
  {id: 'Archi.32', label: 'Désérialisation'},
  {id: 'Archi.33', label: 'Spring'},
  {id: 'Archi.34', label: 'Serveur Tomcat'},
  {id: 'Archi.35', label: 'Entité'},
  {id: 'Archi.36', label: 'Répertoire Spring'},
  {id: 'Archi.37', label: 'Service Spring'},
  {id: 'Archi.38', label: 'Contrôleur Spring'},
  {id: 'Archi.39', label: 'Vue Spring'},
  {id: 'Archi.40', label: 'Modèle Spring'},
  {id: 'Archi.41', label: 'Template Thymeleaf'},
  {id: 'Archi.42', label: '@Controller'},
  {id: 'Archi.43', label: '@RestController'},
  {id: 'Archi.44', label: 'Mapping URL-code'},
  {id: 'Archi.45', label: 'Environnement dockerisé'},
  {id: 'Archi.46', label: 'Schéma conceptuel de données'},
  {id: 'Archi.47', label: 'pgAdmin'},
  {id: 'Archi.48', label: 'Base de données'},
  {id: 'Archi.49', label: 'Méthodes CRUD'},
  {id: 'Archi.50', label: 'Tomcat'},
  {id: 'Archi.51', label: '@Transactional'},
  {id: 'Archi.52', label: 'JSON'},
  {id: 'Archi.53', label: 'Jakarta EE'},
  {id: 'Archi.54', label: 'Wildfly'},
  {id: 'Spring.1', label: 'Java Spring'},
  {id: 'Spring.2', label: 'Framework de programmation'},
  {id: 'Spring.3', label: 'Spring boot'},
  {id: 'Spring.4', label: 'Maven'},
  {id: 'Spring.5', label: 'Service Java'},
  {id: 'Spring.6', label: 'Controlleur Java'},
  {id: 'Spring.7', label: 'Main page'},
  {id: 'Spring.8', label: 'Java bean'},
  {id: 'Spring.9', label: 'Inversion de contrôle'},
  {id: 'Spring.10', label: 'Java component'},
  {id: 'Spring.11', label: 'Annotation java'},
  {id: 'Spring.12', label: 'Configuration'},
  {id: 'DB.1', label: 'SGBD'},
  {id: 'DB.2', label: 'PostgreSQL'},
  {id: 'DB.3', label: 'Stockage'},
  {id: 'DB.4', label: 'Sauvegarde'},
  {id: 'DB.5', label: 'Persistance'},
  {id: 'DB.6', label: 'Interrogation'},
  {id: 'DB.7', label: 'Données'},
  {id: 'DB.8', label: 'SQL'},
  {id: 'DB.9', label: 'Schéma de base de données'},
  {id: 'DB.10', label: 'schéma relationnel'},
  {id: 'Docker.1', label: 'virtualisation'},
  {id: 'Docker.2', label: 'conteneurisation'},
  {id: 'Docker.3', label: 'machine virtuelle'},
  {id: 'Docker.4', label: 'conteneur'},
  {id: 'Docker.5', label: 'Docker'},
  {id: 'Docker.6', label: 'Image Docker'},
  {id: 'Docker.7', label: 'Dockerfile'},
  {id: 'Docker.8', label: 'Docker-compose'},
  {id: 'Docker.9', label: 'Volumes'},
  {id: 'Docker.10', label: 'Réseaux virtuels'},
  {id: 'Dev.1', label: 'Environnement de travail'},
  {id: 'Dev.2', label: 'Environnement de développement'},
  {id: 'JPA.1', label: 'ORM'},
  {id: 'JPA.2', label: 'JDBC'},
  {id: 'JPA.3', label: 'JPA'},
  {id: 'JPA.4', label: 'Fournisseur JPA'},
  {id: 'JPA.5', label: 'Hibernate'},
  {id: 'JPA.6', label: 'application.properties'},
  {id: 'JPA.7', label: 'Mapping classe-table'},
  {id: 'JPA.8', label: '@Entity'},
  {id: 'JPA.9', label: '@Table'},
  {id: 'JPA.10', label: 'Mapping attribut-colonne'},
  {id: 'JPA.11', label: '@Column'},
  {id: 'JPA.12', label: 'Mapping attribut-clé primaire'},
  {id: 'JPA.13', label: '@Id'},
  {id: 'JPA.14', label: '@GeneratedValue'},
  {id: 'JPA.15', label: 'Mapping association entre classes'},
  {id: 'JPA.16', label: '@ManyToOne'},
  {id: 'JPA.17', label: '@OneToMany'},
  {id: 'JPA.18', label: 'mappedBy'},
  {id: 'JPA.19', label: 'EntityManager'},
  {id: 'JPA.20', label: 'Transaction'},
  {id: 'JPA.21', label: 'Commit'},
  {id: 'JPA.22', label: 'Rollback'},
  {id: 'JPA.23', label: 'Entité gérée'},
  {id: 'JPA.24', label: 'Entité détachée'},
  {id: 'JPA.25', label: 'Méthode find'},
  {id: 'JPA.26', label: 'Fetch'},
  {id: 'JPA.27', label: 'Eager'},
  {id: 'JPA.28', label: 'Lazy'},
  {id: 'JPA.29', label: 'Méthode persist'},
  {id: 'JPA.30', label: 'Méthode merge'},
  {id: 'JPA.31', label: 'Collection persistante'},
  {id: 'JPA.32', label: 'ddl.auto'},
  {id: 'JPA.33', label: 'cascade'},
  {id: 'JSON.1', label: 'JSON'},
  {id: 'JSON.2', label: 'Jackson'},
  {id: 'Archi.56', label: 'Eureka'},
  {id: 'Archi.58', label: 'SAGA (orchestration, chorégraphie)'},
  {id: 'Archi.59', label: 'Serveur de messages'},
  {id: 'Archi.60', label: 'Registre de micro-services'},
  {id: 'Archi.61', label: 'Transaction entre services'},
  {id: 'Archi.62', label: 'POJO'},
  {id: 'Archi.63', label: 'Producteur de message'},
  {id: 'Archi.64', label: 'Consommateur de message'},
  {id: 'Archi.65', label: 'Spring Repository'},
  {id: 'Archi.66', label: 'Spring JpaRepository'},
  {id: 'Archi.67', label: 'Spring CrudRepository'},
  {id: 'TEST.1', label: 'Types de test'},
  {id: 'TEST.2', label: 'Test unitaire'},
  {id: 'TEST.3', label: "Test d'intégration"},
  {id: 'TEST.4', label: 'Test fonctionnel'},
  {id: 'TEST.5', label: 'Test de bout en bout'},
  {id: 'TEST.6', label: 'Environnement mocké'},
  {id: 'TEST.7', label: 'Test slicing'},
  {id: 'TEST.8', label: 'Bonnes pratiques tests'},
  {id: 'TEST.9', label: 'Layered slicing'},
  {id: 'TEST.10', label: '@DataJpaTest'},
  {id: 'TEST.11', label: 'Test repository JPA'},
  {id: 'TEST.12', label: 'Base de données pour les tests'},
  {id: 'TEST.13', label: 'H2'},
  {id: 'TEST.14', label: 'Configuration du test slicing'},
  {id: 'TEST.15', label: '@SpringBootTest'},
  {id: 'TEST.16', label: 'Test des services Spring'},
  {id: 'TEST.17', label: 'Mockito'},
  {id: 'TEST.18', label: '@Mock'},
  {id: 'TEST.19', label: '@InjectMocks'},
  {id: 'Data.1', label: 'SGBDR'},
  {id: 'Data.2', label: 'SGBD'},
  {id: 'Data.3', label: 'Persistance'},
  {id: 'Data.4', label: 'Modèle relationnel'},
  {id: 'Data.5', label: 'Donnée'},
  {id: 'Data.6', label: "Schéma d'une relation"},
  {id: 'Data.7', label: "Arité d'une relation"},
  {id: 'Data.8', label: 'Relation'},
  {id: 'Data.9', label: 'Attribut'},
  {id: 'Data.10', label: 'Tuple'},
  {id: 'Data.11', label: "Cardinalité d'une relation"},
  {id: 'Data.12', label: "Schéma d'une base de données"},
  {id: 'Data.13', label: "Integrité d'une relation"},
  {id: 'Data.14', label: 'Clé primaire'},
  {id: 'Data.15', label: 'Clé référentielle'},
  {id: 'Data.16', label: 'Clé candidate'},
  {id: 'Data.17', label: 'Integrité de domaine'},
  {id: 'Data.18', label: 'Integrité'},
  {id: 'Data.19', label: 'Integrité référentielle'},
  {id: 'Data.20', label: 'Integrité utilisateur'},
  {id: 'Data.21', label: 'Donnée redondante'},
  {id: 'Data.22', label: "Structuration d'une base de données relationnelles"},
  {id: 'Data.23', label: 'Modélisation conceptuelle'},
  {id: 'Data.24', label: 'Dictionnaire de données'},
  {id: 'Data.25', label: 'Relation universelle'},
  {id: 'Data.26', label: 'Schéma logique de données'},
  {id: 'Data.27', label: 'Dérivation'},
  {id: 'Data.28', label: 'Règles de dérivation'},
  {id: 'Data.29', label: 'Dépendance fonctionnelle'},
  {id: 'Data.30', label: 'Dépendance fonctionnelle élementaire'},
  {id: 'Data.31', label: 'Dépendance fonctionnelle directe'},
  {id: 'Data.32', label: 'Graphe des dépendances fonctionnelles'},
  {id: 'Data.33', label: 'Clé de la relation universelle'},
  {id: 'Data.34', label: "Propriété d'une dépendance fonctionnelle"},
  {id: 'Data.35', label: "Règle d'inférence d'Armstrong"},
  {id: 'Data.36', label: 'Forme normale'},
  {id: 'Data.37', label: 'Première forme normale'},
  {id: 'Data.38', label: 'Deuxième forme normale'},
  {id: 'Data.39', label: 'Troisième forme normale'},
  {id: 'Data.40', label: 'Normalisation'},
  {id: 'Data.41', label: 'Couverture minimale'},
  {id: 'Data.42', label: 'Décomposition d\'une relation'},
  {id: 'Data.43', label: 'Vue'},
  {id: 'Data.44', label: 'Indépendance des données'},
  {id: 'Data.45', label: 'Create view'},
  {id: 'Data.46', label: 'Contrôle d\'accès'},
  {id: 'Data.47', label: 'Grant'},
  {id: 'Data.48', label: 'Niveau logique'},
  {id: 'Data.49', label: 'Niveau physique'},
  {id: 'Data.50', label: 'Niveau externe'},
  {id: 'Data.51', label: 'Algèbre relationnelle'},
  {id: 'Data.52', label: 'Opérateur ensembliste'},
  {id: 'Data.53', label: 'Opérateur relationnel'},
  {id: 'Data.54', label: 'Projection'},
  {id: 'Data.55', label: 'Sélection'},
  {id: 'Data.56', label: 'Composition'},
  {id: 'Data.57', label: 'Produit cartesien'},
  {id: 'Data.58', label: 'Expression algébrique relationnelle'},
  {id: 'Data.59', label: 'Jointure'},
  {id: 'Data.60', label: 'Union'},
  {id: 'Data.61', label: 'Intersection'},
  {id: 'Data.62', label: 'Différence'},
  {id: 'Data.63', label: 'Fonction d\'aggrégation'},
  {id: 'Data.64', label: 'Groupement de tuples'},
  {id: 'Data.65', label: 'Filtrage de groupes'},
  {id: 'Data.66', label: 'Expression algébrique imbriquée'},
  {id: 'Data.67', label: 'Donnée persistante'},
  {id: 'Data.68', label: 'Règle de gestion'},
  {id: 'Data.69', label: 'Fonction stockée'},
  {id: 'SQL.1', label: 'Langage SQL'},
  {id: 'SQL.2', label: 'Requête d\'interrogation'},
  {id: 'SQL.3', label: 'SELECT'},
  {id: 'SQL.4', label: 'Clause WHERE'},
  {id: 'SQL.5', label: 'Jointure'},
  {id: 'SQL.6', label: 'JOIN'},
  {id: 'SQL.7', label: 'Regroupement'},
  {id: 'SQL.8', label: 'Aggrégation'},
  {id: 'SQL.9', label: 'GROUP BY'},
  {id: 'SQL.10', label: 'COUNT'},
  {id: 'SQL.11', label: 'HAVING'},
  {id: 'SQL.12', label: 'Requête SQL imbriquée'},
  {id: 'SQL.13', label: 'clause NOT IN'},
  {id: 'SQL.14', label: 'INSERT'},
  {id: 'SQL.15', label: 'Requête de modification'},
  {id: 'SQL.16', label: 'UPDATE'},
  {id: 'SQL.17', label: 'DELETE'},
  {id: 'SQL.18', label: 'ALTER TABLE'},
  {id: 'Conc.1', label: 'Transaction'},
  {id: 'Conc.2', label: 'Commit'},
  {id: 'Conc.3', label: 'Rollback'},
  {id: 'Conc.4', label: 'Auto-commit'},
  {id: 'Conc.5', label: 'ACID'},
  {id: 'Conc.6', label: 'Atomicité'},
  {id: 'Conc.7', label: 'Cohérence'},
  {id: 'Conc.8', label: 'Isolation'},
  {id: 'Conc.9', label: 'Durabilité'},
  {id: 'Conc.10', label: 'Accès concurrents'},
  {id: 'Conc.11', label: 'Niveau d\'isolation'},
  {id: 'Conc.12', label: 'Lecture fantôme'},
  {id: 'Conc.13', label: 'Lecture non reproductible'},
  {id: 'Conc.14', label: 'Mise à jour perdue'},
  {id: 'Conc.15', label: 'Lecture sale'},
  {id: 'Conc.16', label: 'Verrou'},
  {id: 'Conc.17', label: 'Verrou partagé'},
  {id: 'Conc.18', label: 'Verrou exclusif'},
  {id: 'Conc.19', label: 'Sérializable'},
  {id: 'Conc.20', label: 'Repeatable reads'},
  {id: 'Conc.21', label: 'Read commited'},
  {id: 'Conc.22', label: 'Read uncommited'},
  {id: 'Conc.23', label: 'Plan d\'exécution'},
  {id: 'Conc.24', label: 'EXPLAIN'},
  {id: 'Conc.25', label: 'Temps d\'exécution d\'une requête'},
  {id: 'Conc.26', label: 'Indexation'},
  {id: 'Conc.27', label: 'Index'},
  {id: 'Conc.28', label: 'CREATE INDEX'},
  {id: 'Conc.29', label: 'Type d\'index'},
  {id: 'UML.1', label: 'UML'},
  {id: 'UML.2', label: 'Classe'},
  {id: 'UML.3', label: 'Propriété'},
  {id: 'UML.4', label: 'Association'},
  {id: 'UML.5', label: 'Label d\'une association'},
  {id: 'UML.6', label: 'Association ternaire'},
  {id: 'UML.7', label: 'Assocation réflexive'},
  {id: 'UML.8', label: 'Cardinalité d\'une association'},
  {id: 'UML.9', label: 'Cardinalité 1:N'},
  {id: 'UML.10', label: 'Cardinalité N:M'},
  {id: 'UML.11', label: 'Cardinalité 1:1'},
  {id: 'UML.12', label: 'Héritage'},
  {id: 'UML.13', label: 'Héritage exclusif'},
  {id: 'Archi.65', label: 'Spring Repository'},
  {id: 'Archi.66', label: 'Spring JpaRepository'},
  {id: 'Archi.67', label: 'Spring CrudRepository'},
  {id: 'UML.14', label: 'Héritage non exclusif'}
] AS notion
CREATE (:Notion {id: notion.id, label: notion.label});

// ============================================================
// STEP 5: Create Course-Section Relationships
// ============================================================
UNWIND [
  {course_name: "Aperçu de l'environnement", sections: [
    {label: "Java Spring et le développement web", order: 1}, 
    {label: "Postgresql", order: 2}]},
  {course_name: "Architecture N-tiers avec Docker", sections: [
    {label: "Virtualisation vs. Conteneurisation", order: 1}, 
    {label: "Images", order: 2}, 
    {label: "Conteneurs", order: 3}, 
    {label: "Dockerfile et Docker-compose", order: 4}]},
  {course_name: "Images et conteneurs", sections: [
    {label: "Docker c'est quoi", order: 1}, 
    {label: "Image et conteneur", order: 2}, 
    {label: "Déployer un ensemble de services pré-configurés", order: 3}, 
    {label: "Démarrer et arrêter les services", order: 4}]},
  {course_name: "Personnalisation d'images et d'architectures", sections: [
    {label: "Dockerfile", order: 1}, 
    {label: "Docker compose", order: 2}, 
    {label: "Volumes", order: 3}, 
    {label: "Réseaux virtuel", order: 4}]},
  {course_name: "Systèmes de gestion de BD", sections: [
    {label: "Qu'est-ce qu'un système de gestion de bases de données (SGBD) ?", order: 1}, 
    {label: "Objectif d'un SGBD", order: 2}, 
    {label: "Fonctionnalités d'un SGBD", order: 3}, 
    {label: "Les SGBD sont-ils incontournables ?", order: 4}, 
    {label: "Une démarche orientée système", order: 5}]},
  {course_name: "PostgreSQL et Docker", sections: [
    {label: "Connexion au SGBDR", order: 1}, 
    {label: "Schéma de la base de données", order: 2}]},
  {course_name: "Le framework Java Spring", sections: [
    {label: "Le framework Spring", order: 1}]},
  {course_name: "Projets avec Java Spring", sections: [
    {label: "Application web avec Spring boot", order: 1}, 
    {label: "Gestion de l'application avec Maven", order: 2}]},
  {course_name: "Spring bean", sections: [
    {label: "Spring bean", order: 1}]},
  {course_name: "Inversion de contrôle", sections: [
    {label: "L'inversion de contrôle (IoC)", order: 1}, 
    {label: "Contexte d'application", order: 2}, 
    {label: "L'injection de dépendances", order: 3}, 
    {label: "Injection de valeur", order: 4}]},
  {course_name: "Introduction aux architectures d applications web", sections: [
    {label: "Structuration d'une application web", order: 1}, 
    {label: "Échange de données", order: 2}]},
  {course_name: "Architecture technique d applications web", sections: [
    {label: "Quelques notions d'architecture technique", order: 1}, 
    {label: "Architecture N-tiers", order: 2}, 
    {label: "Les applications dans le cloud et les micro-services", order: 3}]},
  {course_name: "Architecture logicielle d applications web", sections: [
    {label: "Les architectures multi-couches", order: 1}, 
    {label: "Les patrons de conception", order: 2}, 
    {label: "Le patron MVC", order: 3}, 
    {label: "Le principe REST et les architectures par micro-service", order: 4}]},
  {course_name: "Architecture des applications Spring web", sections: [
    {label: "Découpage fonctionnel d'une application Spring", order: 1}, 
    {label: "MVC dans Spring", order: 2}, 
    {label: "Développer du MVC avec Spring", order: 3}]},
  {course_name: "Spring Web", sections: [
    {label: "Rappel sur l'architecture technique", order: 1}, 
    {label: "Présentation de l'application", order: 2}, 
    {label: "Structuration de l'application", order: 3}, 
    {label: "La couche présentation", order: 4}]},
  {course_name: "Deploiement d une application Spring", sections: [
    {label: "Vers des architectures REST pour les micro-services", order: 1}, 
    {label: "Vers une architecture 3-tiers", order: 2}]},
  {course_name: "ORM (JPA)", sections: [
    {label: "Principe d'un ORM", order: 1}, 
    {label: "Java Persistence API (JPA)", order: 2}, 
    {label: "Connexion à la base de données", order: 3}, 
    {label: "Association objet – base de données relationnelle", order: 4}, 
    {label: "L'Entity Manager", order: 5}]},
  {course_name: "Spring JPA", sections: [
    {label: "Le projet comrec", order: 1}, 
    {label: "Exercice 1 (découverte de JPA via un cas simple)", order: 2}, 
    {label: "Le mapping entre les classes et les tables", order: 3}, 
    {label: "Collections persistantes", order: 4}, 
    {label: "Gestion des identifiants / clé primaire", order: 5}, 
    {label: "Gestion des associations", order: 6}]},
  {course_name: "Introduction aux Data Transfer Object", sections: [
    {label: "Sérialisation", order: 1}, 
    {label: "Le patron DTO", order: 2}]},
  {course_name: "Le format JSON", sections: [
    {label: "JSON", order: 1}]},
  {course_name: "Sérialisation JSON", sections: [
    {label: "Activité JSON et JAVA", order: 1}]},
  {course_name: "Spring JPA (avancée)", sections: [
    {label: "Les classes de l'application", order: 1}, 
    {label: "Recherche et gestion du cache", order: 2}, 
    {label: "Retour sur le contexte transactionnel", order: 3}]},
  {course_name: "Tester une application multi-couche", sections: [
    {label: "Rappels rapides sur les tests", order: 1}, 
    {label: "Tester une application multi-couche", order: 2}]},
  {course_name: "Tests avec Spring/Spring Boot", sections: [
    {label: "Tester les repositories de la couche données", order: 1}, 
    {label: "Configuration", order: 2}, 
    {label: "Bonnes pratiques", order: 3}, 
    {label: "Tester les classes de la couche services", order: 4}, 
    {label: "Les tests unitaires", order: 5}, 
    {label: "Les tests d'integration", order: 6}, 
    {label: "Bonnes pratiques", order: 7}]},
  {course_name: "Activité pratique sur le test de Spring JPA", sections: [
    {label: "Tests unitaires avec Junit", order: 1}, 
    {label: "Tester les repository JPA", order: 2}, 
    {label: "Tester la couche services", order: 3}]},
  {course_name: "Développement d'une application web par micro-services", sections: [
    {label: "Présentation de l'application", order: 1}, 
    {label: "Réservation de billets avec une BD partagée", order: 2}]},
  {course_name: "Architectures microservice", sections: [
    {label: "Les architectures par micro-services", order: 1}, 
    {label: "Conception d'architectures micro-service", order: 2}, 
    {label: "Gestion des données dans une architecture micro-service", order: 3}, 
    {label: "Gestion des transactions inter-services", order: 4}, 
    {label: "Gestion des services", order: 5}, 
    {label: "Les principes de communication REST", order: 6}, 
    {label: "Les principes de communication asynchrone entre (micro-)services", order: 7}]},
  {course_name: "Développement d'une application web par micro-services", sections: [
    {label: "Développement d'une application web par micro-services", order: 1}, 
    {label: "Préparation de l'application", order: 2}, 
    {label: "Exécution indépendante des micro-services", order: 3}, 
    {label: "Gestion des transactions entre micro-services", order: 4}]},
  {course_name: "Développement d'une application web par micro-services", sections: [
    {label: "Développement d'une application web par micro-services", order: 1}, 
    {label: "Mise en place de l'application", order: 2}, 
    {label: "Préparation de l'application", order: 3}, 
    {label: "Exécution indépendante des micro-services", order: 4}, 
    {label: "Rendre asynchrone les étapes d'une transaction entre micro-services", order: 5}, 
    {label: "Communiquer via un serveur kafka", order: 6}, 
    {label: "Activer kafka dans l'application", order: 7}, 
    {label: "POJO de communication des données", order: 8}, 
    {label: "Configuration d'un producteur de messages kafka", order: 9}, 
    {label: "Configuration d'un consommateur de messages kafka", order: 10}]},
  {course_name: "Spring Data JPA - Repository", sections: [
    {label: "Spring Data JPA - Repository", order: 1}, 
    {label: "À quoi sert un Repository ?", order: 2}, 
    {label: "Comment créer et utiliser un Repository ?", order: 3}, 
    {label: "Comment enrichir un Repository avec des méthodes spécifiques ?", order: 4}, 
    {label: "Convention de nommage des méthodes", order: 5}, 
    {label: "Bonnes pratiques", order: 6}]},
  {course_name: "Environnement de développement pour l'UV INF 210", sections: [
    {label: "Mise en place de l'environnement de développement", order: 1}, 
    {label: "Service dockerisé", order: 2}, 
    {label: "Démarrage des services BD et Web", order: 3}, 
    {label: "Applications Java Spring", order: 4}]},
  {course_name: "Repository versus DAO", sections: [
    {label: "Repository versus DAO", order: 1}, 
    {label: "Pour aller plus loin : fonctionnement interne", order: 2}, 
    {label: "Comparaison entre le pattern DAO et le concept Repository", order: 3}, 
    {label: "Quand utiliser DAO ou Repository ?", order: 4}]},
  {course_name: "Persistance de données", sections: [
    {label: "Persistance de données", order: 1}]},
  {course_name: "Introduction au modèle relationnel", sections: [
    {label: "Introduction", order: 1}, 
    {label: "Définitions", order: 2}]},
  {course_name: "Intégrité des données", sections: [
    {label: "Integrité de relation", order: 1}, 
    {label: "Integrité de domaine", order: 2}, 
    {label: "Integrité référentielle", order: 3}, 
    {label: "Integrité utilisateur", order: 4}]},
  {course_name: "Activité sur le modèle relationnel et l'intégrité de données", sections: [
    {label: "La notion de clé primaire et de clé candidate", order: 1}, 
    {label: "La notion de clef étrangère", order: 2}]},
  {course_name: "Modélisation et normalisation de schémas relationnels", sections: [
    {label: "Dictionnaire de données", order: 1}, 
    {label: "Relation universelle", order: 2}, 
    {label: "Redondance et difficulté d'interrogation", order: 3}]},
  {course_name: "Modélisation conceptuelle de schémas relationnels", sections: [
    {label: "Introduction", order: 1}, 
    {label: "Le langage UML (enfin une partie)", order: 2}, 
    {label: "Règle 1 - Dérivation d'une classe", order: 3}, 
    {label: "Règle 2 - Dérivation d'une association de type 1:1", order: 4}, 
    {label: "Règle 3 - Dérivation d'une association de type 1:N", order: 5}, 
    {label: "Règle 4 - Dérivation d'une association de type n:m", order: 6}, 
    {label: "Règle 5 - Dérivation de l'héritage de classes", order: 7}]},
  {course_name: "Activité - Modélisation conceptuelle des données et dérivation", sections: [
    {label: "La place de la modélisation conceptuelle de données", order: 1}]},
  {course_name: "Activité - Modélisation conceptuelle des données et dérivation (version avancée)", sections: [
    {label: "Présentation du problème", order: 1}]},
  {course_name: "Normalisation et découpage d'une relation universelle", sections: [
    {label: "Introduction", order: 1}, 
    {label: "Définition", order: 2}, 
    {label: "Quelques propriétés des dépendances fonctionnelles", order: 3}, 
    {label: "Types de dépendances fonctionnelles", order: 4}, 
    {label: "Graphe des dépendances élémentaires directes", order: 5}, 
    {label: "Clé de la relation universelle", order: 6}, 
    {label: "Première forme normale", order: 7}, 
    {label: "Deuxième forme normale", order: 8}, 
    {label: "Troisième forme normale", order: 9}]},
  {course_name: "Activité - Dépendances fonctionnelles et formes normales", sections: [
    {label: "Dépendances fonctionnelles", order: 1}, 
    {label: "Formes normales", order: 2}]},
  {course_name: "Activity - Décomposition d'une relation", sections: [
    {label: "Couverture minimale", order: 1}, 
    {label: "Règles d'inférence d'Armstrong sur les dépendances fonctionnelles", order: 2}, 
    {label: "Algorithme de décomposition d'une relation", order: 3}, 
    {label: "Applications", order: 4}]},
  {course_name: "Les vues en SQL", sections: [
    {label: "Les vues en SQL", order: 1}]},
  {course_name: "Activité pratique - Indépendance des données - Mécanisme des vues externes", sections: [
    {label: "Activité pratique - Indépendance des données - Mécanisme des vues externes", order: 1}]},
  {course_name: "L'algèbre relationnel", sections: [
    {label: "Introduction", order: 1}, 
    {label: "Projection", order: 2}, 
    {label: "Sélection", order: 3}, 
    {label: "Composition de tuples", order: 4}, 
    {label: "Produit cartésien", order: 5}, 
    {label: "Jointure", order: 6}, 
    {label: "Union", order: 7}, 
    {label: "Intersection", order: 8}, 
    {label: "Différence", order: 9}, 
    {label: "Fonction d'aggrégation", order: 10}, 
    {label: "Groupement de tuples", order: 11}, 
    {label: "Filtrage de groupes", order: 12}, 
    {label: "Expression algébrique imbriquée", order: 13}]},
  {course_name: "Introduction au langage SQL", sections: [
    {label: "Structure générale d'une requête", order: 1}, 
    {label: "Interrogation d'une table", order: 2}, 
    {label: "Jointures entre plusieurs tables", order: 3}, 
    {label: "Calculs et regroupements", order: 4}]},
  {course_name: "Pratiquer avec le langage SQL", sections: [
    {label: "Description de la base de données SOINS", order: 1}, 
    {label: "Accès à la BD", order: 2}, 
    {label: "Pattern matching et tris", order: 3}, 
    {label: "Jointures", order: 4}, 
    {label: "Négations et listes", order: 5}, 
    {label: "Comptages et aggrégation", order: 6}]},
  {course_name: "Pratiquer avec le langage SQL en version avancée", sections: [
    {label: "Description de la base de données SOINS", order: 1}, 
    {label: "Accès à la BD", order: 2}, 
    {label: "Quelques requêtes simples", order: 3}, 
    {label: "Des requêtes plus compliquées", order: 4}, 
    {label: "Quelques indications sur les différents types de jointure", order: 5}]},
  {course_name: "Transaction", sections: [
    {label: "Transaction", order: 1}, 
    {label: "Propriétés ACID", order: 2}, 
    {label: "Concurrence", order: 3}]},
  {course_name: "Activité pratique - Transactions", sections: [
    {label: "Contexte", order: 1}, 
    {label: "Mise en place du TP", order: 2}, 
    {label: "Présentation des vues", order: 3}, 
    {label: "Présentation des fonctions stockées", order: 4}, 
    {label: "Valider et annuler une transaction", order: 5}, 
    {label: "Retour sur l'intégrité de données", order: 6}]},
  {course_name: "Niveaux d'isolation dans un SGBDR", sections: [
    {label: "Lecture fantôme", order: 1}, 
    {label: "Lecture non reproductible", order: 2}, 
    {label: "Mise à jour perdue", order: 3}, 
    {label: "Lecture sale", order: 4}, 
    {label: "Sérializable", order: 5}, 
    {label: "Repeatable reads", order: 6}, 
    {label: "Read commited", order: 7}, 
    {label: "Read uncommited", order: 8}]},
  {course_name: "Activité pratique - Niveaux d'isolation", sections: [
    {label: "Accès à la BD", order: 1}, 
    {label: "Création d'un environnement concurrent", order: 2}, 
    {label: "Découverte des niveaux d'isolation", order: 3}, 
    {label: "Modification des niveaux d'isolation", order: 4}, 
    {label: "Lectures reproductibles", order: 5}, 
    {label: "Fantômes", order: 6}, 
    {label: "Bilan du niveau Sérializable", order: 7}, 
    {label: "Erreurs de séarialisation et interblocages", order: 8}, 
    {label: "Phénomènes survenant lors des transactions", order: 9}, 
    {label: "Niveaux d'isolation ANSI", order: 10}]},
  {course_name: "Plan d'exécution de requêtes et indexation", sections: [
    {label: "Plan d'exécution des requêtes", order: 1}, 
    {label: "EXPLAIN", order: 2}, 
    {label: "Types d'index", order: 3}]},
  {course_name: "Activité pratique - Indexation", sections: [
    {label: "Création d'un index", order: 1}, 
    {label: "Colonne tx_vector", order: 2}]}
] AS entry
UNWIND entry.sections AS sectionInfo
MATCH (c:Course {name: entry.course_name})
MATCH (s:Section {label: sectionInfo.label})
CREATE (c)-[:has_section {orderInCourse: sectionInfo.order}]->(s);
// ============================================================
// STEP 6: Create Section-Notion Relationships
// ============================================================
UNWIND [
  {section: "Java Spring et le développement web", ids: ['Spring.1', 'Spring.2', 'Spring.3']},
  {section: "Postgresql", ids: ['Archi.5', 'DB.1', 'DB.2']},
  {section: "Virtualisation vs. Conteneurisation", ids: ['Docker.1', 'Docker.2', 'Docker.3', 'Docker.5', 'Archi.5']},
  {section: "Images", ids: ['Docker.5', 'Docker.6', 'Spring.12']},
  {section: "Conteneurs", ids: ['Docker.4', 'Docker.5']},
  {section: "Dockerfile et Docker-compose", ids: ['Docker.4', 'Docker.5', 'Docker.6', 'Docker.7', 'Docker.8', 'Archi.5', 'Spring.12']},
  {section: "Docker c'est quoi", ids: ['Archi.5', 'Docker.5']},
  {section: "Image et conteneur", ids: ['Docker.5', 'Docker.6', 'Docker.4']},
  {section: "Déployer un ensemble de services pré-configurés", ids: ['Docker.4', 'Docker.5', 'Docker.6', 'Dev.1', 'Dev.2', 'Archi.47', 'Archi.54', 'Spring.12']},
  {section: "Démarrer et arrêter les services", ids: ['Docker.4', 'Docker.5', 'Docker.6', 'Dev.1', 'Dev.2', 'Archi.5', 'Docker.8', 'Spring.12']},
  {section: "Dockerfile", ids: ['Archi.5', 'Docker.5', 'Docker.4', 'DB.2', 'Docker.6', 'Docker.7', 'Spring.12']},
  {section: "Docker compose", ids: ['Archi.5', 'Docker.5', 'Docker.4', 'DB.2', 'Docker.6', 'Docker.7', 'Docker.8', 'Spring.12']},
  {section: "Volumes", ids: ['Archi.5', 'Docker.5', 'Docker.4', 'DB.2', 'Docker.6', 'Docker.7', 'Docker.9', 'Spring.12']},
  {section: "Réseaux virtuel", ids: ['Archi.5', 'Docker.5', 'Docker.4', 'DB.2', 'Docker.6', 'Docker.7', 'Docker.10', 'Spring.12']},
  {section: "Qu'est-ce qu'un système de gestion de bases de données (SGBD) ?", ids: ['Archi.5', 'DB.1', 'DB.3', 'DB.4', 'DB.5', 'DB.6', 'DB.7']},
  {section: "Objectif d'un SGBD", ids: ['Dev.2', 'DB.3', 'DB.4', 'DB.5', 'DB.6', 'DB.7', 'DB.8']},
  {section: "Fonctionnalités d'un SGBD", ids: ['Dev.2', 'DB.3', 'DB.4', 'DB.5', 'DB.6', 'DB.7', 'DB.8', 'Archi.5', 'DB.1']},
  {section: "Les SGBD sont-ils incontournables ?", ids: ['Dev.2', 'Archi.5', 'DB.1']},
  {section: "Une démarche orientée système", ids: ['Archi.5', 'DB.1']},
  {section: "Connexion au SGBDR", ids: ['Archi.5', 'DB.1', 'DB.2', 'Docker.2', 'Docker.4', 'Docker.5', 'Dev.2', 'Archi.47']},
  {section: "Schéma de la base de données", ids: ['DB.1', 'DB.2', 'Archi.47', 'DB.9', 'DB.10']},
  {section: "Le framework Spring", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Archi.14', 'Spring.11']},
  {section: "Application web avec Spring boot", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Dev.2', 'Spring.11']},
  {section: "Gestion de l'application avec Maven", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Dev.2', 'Spring.4', 'Archi.27', 'Spring.5', 'Spring.6', 'Spring.7']},
  {section: "Spring bean", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Spring.7', 'Spring.8', 'Spring.9', 'Spring.10', 'Archi.21', 'Spring.11']},
  {section: "L'inversion de contrôle (IoC)", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Spring.7', 'Spring.8', 'Spring.9', 'Spring.10', 'Archi.21', 'Spring.11']},
  {section: "Contexte d'application", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Dev.2', 'Spring.9', 'Spring.11']},
  {section: "L'injection de dépendances", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Spring.7', 'Spring.8', 'Spring.9', 'Spring.10', 'Archi.21', 'Spring.11']},
  {section: "Injection de valeur", ids: ['Spring.1', 'Spring.2', 'Spring.3', 'Archi.5', 'Spring.7', 'Spring.8', 'Spring.9', 'Spring.10', 'Archi.21', 'Spring.11', 'Spring.12']},
  {section: "Structuration d'une application web", ids: ['Archi.1','Archi.3','Archi.4']},
  {section: "Échange de données", ids: ['Archi.2']},
  {section: "Quelques notions d'architecture technique", ids: ['Archi.3','Archi.5','Archi.6']},
  {section: "Architecture N-tiers", ids: ['Archi.8','Archi.9','Archi.10','Archi.11','Archi.12','Archi.13','Archi.14']},
  {section: "Les applications dans le cloud et les micro-services", ids: ['Archi.15','Archi.16']},
  {section: "Les architectures multi-couches", ids: ['Archi.17','Archi.18','Archi.19','Archi.20']},
  {section: "Les patrons de conception", ids: ['Archi.21','Archi.22','Archi.23','Archi.24','Archi.49']},
  {section: "Le patron MVC", ids: ['Archi.25','Archi.26','Archi.27','Archi.28']},
  {section: "Le principe REST et les architectures par micro-service", ids: ['Archi.29','Archi.30','Archi.16','Archi.15']},
  {section: "Découpage fonctionnel d'une application Spring", ids: ['Archi.14','Archi.33','Archi.34','Archi.11','Archi.17','Archi.24','Archi.35','Archi.36','Archi.37','Archi.38','Archi.39']},
  {section: "MVC dans Spring", ids: ['Archi.25','Archi.38','Archi.39','Archi.40']},
  {section: "Développer du MVC avec Spring", ids: ['Archi.38','Archi.42','Archi.43','Archi.44','Archi.40','Archi.39','Archi.41']},
  {section: "Rappel sur l'architecture technique", ids: ['Archi.11','Archi.45']},
  {section: "Présentation de l'application", ids: ['Archi.46','Archi.47','Archi.48']},
  {section: "Structuration de l'application", ids: ['Archi.49','Archi.35','Archi.19','Archi.38','Archi.40','Archi.39']},
  {section: "La couche présentation", ids: ['Archi.38','Archi.39','Archi.40','Archi.19','Archi.18','Archi.42','Archi.41','Archi.13','Archi.50','Archi.37','Archi.44','Archi.51']},
  {section: "Vers des architectures REST pour les micro-services", ids: ['Archi.30','Archi.2','Archi.38','Archi.43','Archi.52','Archi.49']},
  {section: "Vers une architecture 3-tiers", ids: ['Archi.14','Archi.53','Archi.54','Archi.30','Archi.12','Archi.18','Archi.19','Archi.17','Archi.25','Archi.26','Archi.35','Archi.52','Archi.2']},
  {section: "Principe d'un ORM", ids: ['JPA.1']},
  {section: "Java Persistence API (JPA)", ids: ['JPA.2','JPA.3','JPA.4','JPA.5']},
  {section: "Connexion à la base de données", ids: ['JPA.6']},
  {section: "Association objet – base de données relationnelle", ids: ['JPA.7','Archi.35','JPA.8','JPA.9','JPA.10','JPA.11','JPA.12','JPA.13','JPA.14','JPA.15','JPA.16','JPA.17','JPA.18']},
  {section: "L'Entity Manager", ids: ['JPA.19','JPA.20','JPA.21','JPA.22','JPA.23','JPA.24','JPA.25','JPA.26','JPA.27','JPA.28','JPA.29','JPA.30']},
  {section: "Le projet comrec", ids: ['JPA.3','Archi.46','JPA.31','Archi.49','Archi.36','Archi.24']},
  {section: "Exercice 1 (découverte de JPA via un cas simple)", ids: ['Archi.33','JPA.3','JPA.5','JPA.6','JPA.32']},
  {section: "Le mapping entre les classes et les tables", ids: ['JPA.7','JPA.11']},
  {section: "Collections persistantes", ids: ['JPA.19','JPA.31','Archi.49','Archi.24','Archi.51','JPA.20','Archi.36']},
  {section: "Gestion des identifiants / clé primaire", ids: ['JPA.13','JPA.12','JPA.14']},
  {section: "Gestion des associations", ids: ['JPA.15','JPA.33']},
  {section: "Les classes de l'application", ids: ['Archi.46']},
  {section: "Recherche et gestion du cache", ids: ['Archi.24','JPA.19']},
  {section: "Sérialisation", ids: ['Archi.31','Archi.32']},
  {section: "Le patron DTO", ids: ['Archi.2']},
  {section: "JSON", ids: ['JSON.1']},
  {section: "Activité JSON et JAVA", ids: ['JSON.1','JSON.2','Archi.31','Archi.32']},
  { section: "Mise en place de l'environnement de développement", ids: ['Docker.5','Docker.6','Dev.2'] },
  { section: "Service dockerisé", ids: ['DB.1','DB.2','Archi.47','Archi.54','Archi.14','Docker.4','Docker.8'] },
  { section: "Démarrage des services BD et Web", ids: ['Archi.5','DB.1','DB.2','Docker.8','Archi.47','Archi.54','Archi.14'] },
  { section: "Applications Java Spring", ids: ['Spring.1','Spring.3','Spring.4','Spring.4','Spring.4'] },
  {section: "Rappels rapides sur les tests", ids: ['TEST.1', 'TEST.2', 'TEST.3', 'TEST.4', 'TEST.5']},
  {section: "Tester une application multi-couche", ids: ['TEST.6', 'TEST.7', 'TEST.8']},
  {section: "Tester les repositories de la couche données", ids: ['TEST.13', 'TEST.10', 'TEST.11', 'TEST.12']},
  {section: "Configuration", ids: ['TEST.10']},
  {section: "Bonnes pratiques", ids: ['TEST.8', 'TEST.11', 'TEST.14']},
  {section: "Tester les classes de la couche services", ids: ['TEST.2', 'TEST.3', 'TEST.6', 'TEST.16']},
  {section: "Les tests unitaires", ids: ['TEST.2', 'TEST.6', 'TEST.16', 'TEST.17', 'TEST.18', 'TEST.19']},
  {section: "Les tests d'integration", ids: ['TEST.3', 'TEST.15', 'TEST.16']},
  {section: "Tests unitaires avec Junit", ids: ['TEST.2']},
  {section: "Tester les repository JPA", ids: ['TEST.6', 'TEST.7', 'TEST.8', 'TEST.9', 'TEST.10', 'TEST.11', 'TEST.12', 'TEST.13', 'TEST.14']},
  {section: "Tester la couche services", ids: ['TEST.2', 'TEST.3', 'TEST.6', 'TEST.7', 'TEST.8', 'TEST.9', 'TEST.14', 'TEST.15', 'TEST.16', 'TEST.17', 'TEST.18', 'TEST.19']},
  {section: "Présentation de l'application", ids: ['Archi.29', 'Archi.56', 'Archi.60']},
  {section: "Réservation de billets avec une BD partagée", ids: ['Archi.29', 'Archi.51']},
  {section: "Les architectures par micro-services", ids: ['Archi.29']},
  {section: "Conception d'architectures micro-service", ids: ['Archi.29', 'Archi.4', 'Archi.1']},
  {section: "Gestion des données dans une architecture micro-service", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.48']},
  {section: "Gestion des transactions inter-services", ids: ['Archi.29', 'Archi.4', 'Archi.58']},
  {section: "Gestion des services", ids: ['Archi.29', 'Archi.4', 'Archi.61']},
  {section: "Les principes de communication REST", ids: ['Archi.29', 'Archi.4', 'Archi.56', 'Archi.60']},
  {section: "Les principes de communication asynchrone entre (micro-)services", ids: ['Archi.29', 'Archi.4', 'Archi.30']},
  {section: "Développement d'une application web par micro-services", ids: ['Archi.29', 'Archi.4', 'Archi.1']},
  {section: "Préparation de l'application", ids: ['Archi.29', 'Archi.4', 'Archi.1']},
  {section: "Exécution indépendante des micro-services", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.56', 'Archi.60']},
  {section: "Gestion des transactions entre micro-services", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.58', 'Archi.61', 'Archi.60']},
  {section: "Mise en place de l'application", ids: ['Archi.29', 'Archi.4', 'Archi.1']},
  {section: "Rendre asynchrone les étapes d'une transaction entre micro-services", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.57', 'Archi.61', 'Archi.58', 'Archi.59']},
  {section: "Communiquer via un serveur kafka", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.57', 'Archi.61', 'Archi.58', 'Archi.59']},
  {section: "Activer kafka dans l'application", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.57', 'Archi.61', 'Archi.58', 'Archi.59']},
  {section: "POJO de communication des données", ids: ['Archi.2', 'Archi.62']},
  {section: "Configuration d'un producteur de messages kafka", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.57', 'Archi.61', 'Archi.58', 'Archi.59', 'Archi.63']},
  {section: "Configuration d'un consommateur de messages kafka", ids: ['Archi.29', 'Archi.4', 'Archi.1', 'Archi.57', 'Archi.61', 'Archi.58', 'Archi.59', 'Archi.64']},
  {section: "Spring Data JPA - Repository", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65']},
  {section: "À quoi sert un Repository ?", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65']},
  {section: "Comment créer et utiliser un Repository ?", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.67']},
  {section: "Comment enrichir un Repository avec des méthodes spécifiques ?", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.67']},
  {section: "Convention de nommage des méthodes", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.66']},
  {section: "Repository versus DAO", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.24']},
  {section: "Pour aller plus loin : fonctionnement interne", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65']},
  {section: "Comparaison entre le pattern DAO et le concept Repository", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.24']},
  {section: "Quand utiliser DAO ou Repository ?", ids: ['Archi.4', 'Archi.17', 'Archi.20', 'Archi.65', 'Archi.24']},
  {section: "Retour sur le contexte transactionnel", ids: ['JPA.23','JPA.24','JPA.30','JPA.27','JPA.26','JPA.28']},
  {section: "Persistance de données", ids: ['Data.1', 'Data.2', 'Data.3']},
  {section: "Introduction", ids: ['Data.4', 'Data.5', 'Data.66']},
  {section: "Définitions", ids: ['Data.4', 'Data.6', 'Data.7', 'Data.8', 'Data.9', 'Data.10', 'Data.11', 'Data.12']},
  {section: "Integrité de relation", ids: ['Data.18', 'Data.13', 'Data.14', 'Data.16']},
  {section: "Integrité de domaine", ids: ['Data.17']},
  {section: "Integrité référentielle", ids: ['Data.19', 'Data.15']},
  {section: "Integrité utilisateur", ids: ['Data.20']},
  {section: "La notion de clé primaire et de clé candidate", ids: ['Data.67', 'Data.14', 'Data.16', 'Data.21']},
  {section: "La notion de clef étrangère", ids: ['Data.15', 'Data.41']},
  {section: "Dictionnaire de données", ids: ['Data.22', 'Data.23', 'Data.24', 'Data.40']},
  {section: "Relation universelle", ids: ['Data.22', 'Data.25', 'Data.40']},
  {section: "Redondance et difficulté d'interrogation", ids: ['Data.21', 'Data.22']},
  {section: "Introduction", ids: ['Data.23', 'Data.24', 'Archi.46']},
  {section: "Le langage UML (enfin une partie)", ids: ['UML1', 'UML.2', 'UML.3', 'UML.4', 'UML.5', 'UML.6', 'UML.7', 'UML.8', 'UML.9', 'UML.10', 'UML.11', 'UML.12', 'UML.13', 'UML.14']},
  {section: "Règle 1 - Dérivation d'une classe", ids: ['Data.26', 'Data.27', 'Data.28']},
  {section: "Règle 2 - Dérivation d'une association de type 1:1", ids: ['Data.26', 'Data.27', 'Data.28']},
  {section: "Règle 3 - Dérivation d'une association de type 1:N", ids: ['Data.26', 'Data.27', 'Data.28']},
  {section: "Règle 4 - Dérivation d'une association de type n:m", ids: ['Data.26', 'Data.27', 'Data.28']},
  {section: "Règle 5 - Dérivation de l'héritage de classes", ids: ['Data.26', 'Data.27', 'Data.28']},
  {section: "La place de la modélisation conceptuelle de données", ids: ['Data.23', 'Archi.46', 'Data.26', 'Data.27', 'Data.28']},
  {section: "Présentation du problème", ids: ['Data.23', 'Archi.46', 'Data.26', 'Data.27', 'Data.28']},
  {section: "Introduction", ids: ['Data.25', 'Data.40']},
  {section: "Définition", ids: ['Data.29']},
  {section: "Quelques propriétés des dépendances fonctionnelles", ids: ['Data.34', 'Data.35']},
  {section: "Types de dépendances fonctionnelles", ids: ['Data.30', 'Data.31']},
  {section: "Graphe des dépendances élémentaires directes", ids: ['Data.32']},
  {section: "Clé de la relation universelle", ids: ['Data.33']},
  {section: "Première forme normale", ids: ['Data.36', 'Data.37']},
  {section: "Deuxième forme normale", ids: ['Data.38']},
  {section: "Troisième forme normale", ids: ['Data.39']},
  {section: "Dépendances fonctionnelles", ids: ['Data.25', 'Data.29', 'Data.30']},
  {section: "Formes normales", ids: ['Data.36', 'Data.37', 'Data.38', 'Data.39']},
  {section: "Couverture minimale", ids: ['Data.41']},
  {section: "Règles d'inférence d'Armstrong sur les dépendances fonctionnelles", ids: ['Data.35', 'Data.34']},
  {section: "Algorithme de décomposition d'une relation", ids: ['Data.41', 'Data.36', 'Data.37', 'Data.38', 'Data.39']},
  {section: "Applications", ids: ['Data.41', 'Data.36', 'Data.37', 'Data.38', 'Data.39']},
  {section: "Les vues en SQL", ids: ['Data.42', 'Data.43', 'Data.44', 'Data.45', 'Data.46']},
  {section: "Activité pratique - Indépendance des données - Mécanisme des vues externes", ids: ['Data.42', 'Data.43', 'Data.44', 'Data.47', 'Data.48', 'Data.49']},
  {section: "Introduction", ids: ['Data.50', 'Data.51', 'Data.52', 'Data.57']},
  {section: "Projection", ids: ['Data.53']},
  {section: "Sélection", ids: ['Data.54']},
  {section: "Composition de tuples", ids: ['Data.55']},
  {section: "Produit cartésien", ids: ['Data.56']},
  {section: "Jointure", ids: ['Data.58']},
  {section: "Union", ids: ['Data.59']},
  {section: "Intersection", ids: ['Data.60']},
  {section: "Différence", ids: ['Data.61']},
  {section: "Fonction d'aggrégation", ids: ['Data.62']},
  {section: "Groupement de tuples", ids: ['Data.63']},
  {section: "Filtrage de groupes", ids: ['Data.64']},
  {section: "Expression algébrique imbriquée", ids: ['Data.65']},
  {section: "Structure générale d'une requête", ids: ['SQL.1']},
  {section: "Interrogation d'une table", ids: ['SQL.2', 'SQL.3', 'SQL.4', 'SQL.5']},
  {section: "Jointures entre plusieurs tables", ids: ['SQL.5', 'SQL.6']},
  {section: "Calculs et regroupements", ids: ['SQL.7', 'SQL.8', 'SQL.9', 'SQL.10', 'SQL.11']},
  {section: "Description de la base de données SOINS", ids: ['Data.14', 'Data.15', 'Data.26']},
  {section: "Accès à la BD", ids: ['6', '10', '11', '17']},
  {section: "Pattern matching et tris", ids: ['SQL.3', 'SQL.4']},
  {section: "Jointures", ids: ['SQL.5', 'SQL.6']},
  {section: "Négations et listes", ids: ['SQL.12', 'SQL.13']},
  {section: "Comptages et aggrégation", ids: ['SQL.7', 'SQL.8', 'SQL.9', 'SQL.10', 'SQL.11']},
  {section: "Quelques requêtes simples", ids: ['SQL.1', 'SQL.2', 'SQL.3', 'SQL.4', 'SQL.5', 'SQL.6', 'SQL.7', 'SQL.8', 'SQL.9', 'SQL.10', 'SQL.11', 'SQL.12', 'SQL.13']},
  {section: "Des requêtes plus compliquées", ids: ['SQL.1', 'SQL.2', 'SQL.3', 'SQL.4', 'SQL.5', 'SQL.6', 'SQL.7', 'SQL.8', 'SQL.9', 'SQL.10', 'SQL.11', 'SQL.12', 'SQL.13']},
  {section: "Quelques indications sur les différents types de jointure", ids: ['SQL.5', 'SQL.6']},
  {section: "Transaction", ids: ['Conc.1', 'Conc.2', 'Conc.3', 'Conc.4', 'Conc.10']},
  {section: "Propriétés ACID", ids: ['Conc.5', 'Conc.6', 'Conc.7', 'Conc.9', 'Conc.8', 'Conc.10']},
  {section: "Concurrence", ids: ['Conc.10']},
  {section: "Contexte", ids: ['Data.1', 'Data.18']},
  {section: "Mise en place du TP", ids: ['6', '10', '11', '17']},
  {section: "Présentation des vues", ids: ['Data.42']},
  {section: "Présentation des fonctions stockées", ids: ['Data.68']},
  {section: "Valider et annuler une transaction", ids: ['Data.68', 'Conc.1', 'Conc.2', 'Conc.3']},
  {section: "Retour sur l'intégrité de données", ids: ['Data.18', 'SQL.14', 'SQL.15', 'SQL.16', 'SQL.17', 'Data.14', 'Data.15']},
  {section: "Lecture fantôme", ids: ['Conc.10', 'Conc.12']},
  {section: "Lecture non reproductible", ids: ['Conc.10', 'Conc.13']},
  {section: "Mise à jour perdue", ids: ['Conc.10', 'Conc.14']},
  {section: "Lecture sale", ids: ['Conc.10', 'Conc.15']},
  {section: "Sérializable", ids: ['Conc.16', 'Conc.17', 'Conc.18', 'Conc.11', 'Conc.19', 'SQL.1']},
  {section: "Repeatable reads", ids: ['Conc.11', 'Conc.12', 'Conc.16', 'Conc.17', 'Conc.18', 'Conc.20']},
  {section: "Read commited", ids: ['Conc.11', 'Conc.12', 'Conc.13', 'Conc.17', 'Conc.18', 'Conc.21']},
  {section: "Read uncommited", ids: ['Conc.11', 'Conc.12', 'Conc.13', 'Conc.15', 'Conc.17', 'Conc.18', 'Conc.22']},
  {section: "Création d'un environnement concurrent", ids: ['Conc.4', '17']},
  {section: "Découverte des niveaux d'isolation", ids: ['Conc.11', 'Conc.19', 'Conc.20', 'Conc.21', 'Conc.22']},
  {section: "Modification des niveaux d'isolation", ids: ['SQL.1', 'Conc.11']},
  {section: "Lectures reproductibles", ids: ['SQL.1', 'Conc.2', 'Conc.11', 'Conc.19', 'Conc.21', 'Con.13']},
  {section: "Fantômes", ids: ['SQL.1', 'Conc.2', 'Conc.11', 'Conc.19', 'Conc.21', 'Con.12']},
  {section: "Bilan du niveau Sérializable", ids: ['Conc.2', 'Conc.19']},
  {section: "Erreurs de séarialisation et interblocages", ids: ['SQL.1', 'Conc.2', 'Conc.11', 'Conc.19', 'Conc.21']},
  {section: "Phénomènes survenant lors des transactions", ids: ['Conc.12', 'Conc.13', 'Conc.15']},
  {section: "Niveaux d'isolation ANSI", ids: ['Conc.11', 'Conc.12', 'Conc.13', 'Conc.14', 'Conc.15', 'Conc.19', 'Conc.20', 'Conc.21', 'Conc.22']},
  {section: "Plan d'exécution des requêtes", ids: ['SQL.1', 'SQL.3', 'SQL.5']},
  {section: "EXPLAIN", ids: ['Conc.23', 'Conc.24']},
  {section: "Types d'index", ids: ['Conc.25', 'Conc.26', 'Conc.27', 'Conc.28', 'Conc.29']},
  {section: "Création d'un index", ids: ['conc.23', 'Conc.27']},
  {section: "Colonne tx_vector", ids: ['SQL.1', 'SQL.16', 'SQL.18', 'Conc.25', 'Conc.26']}
] AS entry
UNWIND entry.ids AS notionId
MATCH (s:Section {label: entry.section})
MATCH (n:Notion {id: notionId})
MERGE (s)-[:has_notion]->(n);

// ============================================================
// NEW COURSES: Test BD (Partie 1) and Test TP (Partie 2)
// ============================================================

// STEP A: Create the two new Course nodes
CREATE
(test_bd:Course {
  id: "test_intermediaire_part1",
  name: "Test BD",
  type: "Practical Activity",
  duration: 30,
  importance: "Indispensable"
}),
(test_tp:Course {
  id: "test_intermediaire_part2",
  name: "Test TP",
  type: "Practical Activity",
  duration: 120,
  importance: "Indispensable"
});

// STEP B: Create prerequisite relationships
MATCH (modConc:Course {id: "lecture_conceptual_modeling"}),
      (depFonc:Course {id: "activity_normalization"}),
      (modRel:Course {id: "activity_relational_model"}),
      (jpaRepo:Course {id: "lecture_jpa_repository"}),
      (springWeb:Course {id: "practice_spring_2tiers"}),
      (jpaAdv:Course {id: "practice_jpa_advanced"}),
      (testBd:Course {id: "test_intermediaire_part1"}),
      (testTp:Course {id: "test_intermediaire_part2"})

// Test BD prerequisites
MERGE (modConc)-[:PREREQUISITE]->(testBd)
MERGE (depFonc)-[:PREREQUISITE]->(testBd)
MERGE (modRel)-[:PREREQUISITE]->(testBd)

// Test TP prerequisites
MERGE (jpaRepo)-[:PREREQUISITE]->(testTp)
MERGE (springWeb)-[:PREREQUISITE]->(testTp)
MERGE (jpaAdv)-[:PREREQUISITE]->(testTp);

// STEP C: Create the Section nodes
CREATE
(:Section {label: "Partie 1", order: 1, url: ""}),
(:Section {label: "Partie 2", order: 1, url: ""});

// STEP D: Link Courses to Sections
MATCH (testBd:Course {id: "test_bd"}),
      (testTp:Course {id: "test_tp"}),
      (s1:Section {label: "Partie 1"}),
      (s2:Section {label: "Partie 2"})
MERGE (testBd)-[:has_section {orderInCourse: 1}]->(s1)
MERGE (testTp)-[:has_section {orderInCourse: 1}]->(s2);

// STEP E: Link Sections to Notions
UNWIND [
  {section: "Partie 1", ids: ['Data.26', 'Data.29', 'Data.28', 'Data.23']},
  {section: "Partie 2", ids: ['JPA.1', 'JPA.7', 'JPA.8', 'Spring.11', 'Archi.66', 'Archi.5', 'Archi.51']}
] AS entry
UNWIND entry.ids AS notionId
MATCH (s:Section {label: entry.section})
MATCH (n:Notion {id: notionId})
MERGE (s)-[:has_notion]->(n);
