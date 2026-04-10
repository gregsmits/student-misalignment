---
title: Repository versus DAO
keywords: Repository, @query, DAO, CRUD, Spring
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_jpa_repository_advanced.html
summary: Cette section explique comment créer des requêtes avancées avec un Repository. Elle montre les rouages de son fonctionnement ainsi que ses limites. Elle réalise enfin une comparaison entre le concept de Repository et de DAO.
---
<!-- Objectifs pédagogiques

- montrer comment créer des reuqêtes complexes avec l'annotation @query
- montrer les limites des repositories
- comparer le concept de repository et de DAO
- expliquer le principe de fonctionnement des repositories
-->
## Déclarer des requêtes complexes

Pour des besoins plus spécifiques ou des requêtes plus élaborées difficiles à exprimer sous forme de méthode spécifique, il est possible de les définir au format JPQL ou au format SQL. Pour ce faire, il faut que l’interface hérite de l’interface JpaRepository et que les méthodes soient explicitement annotées avec :

- `@Query` pour une requête au format JPQL ;
- `@NativeQuery` (ou `@Query(nativeQuery = true)`) pour une requête SQL native.

Le code suivant montre un exemple d'interface avec une méthode annotée @Query pour JPQL.

```java
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import fr.atlantique.imt.inf211.comrec.entities.Emp;

import java.util.Date;
import java.util.List;

@Repository
public interface EmpRepository extends CrudRepository<Emp, Integer> {
    @Query(value = "SELECT e FROM Emp e WHERE e.hiredate>= :start AND e.hiredate<= :end")
    List<Emp> findEmpHiredBetweenDate(@Param("start") Date start, @Param("end") Date end);
}
```

## Pour aller plus loin : fonctionnement interne

La question qui se pose est : comment fonctionne un Repository à partir uniquement d’une spécification d’interface ?

Ce n’est pas magique ! Si le développeur n’écrit aucune implémentation de Repository c’est que le framework Spring se charge de faire le nécessaire durant le runtime. Donc lors du démarrage de l’application, **Spring Boot** active **Spring Data JPA** qui scan les packages du projet à la recherche des interfaces filles de l’interface `Repository`.

Pour chaque interface détectée ne portant pas l’annotation `@NoRepositoryBean`, Spring crée un **proxy dynamique JDK** et l’enregistre comme un bean Spring. Ce proxy implémente les méthodes définies dans l’interface et interceptes tous les appels de méthodes et les délègue ensuite à la classe [org.springframework.data.jpa.repository.support.SimpleJpaRepository](https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/support/SimpleJpaRepository.html){:target="_blank"}, laquelle utilise l’`EntityManager` pour gérer le contexte de persistance et traduire les requêtes JPQL en requêtes SQL.

Pour les méthodes spécifiques appellée ici méthodes dérivées, Spring Data parse le nom de la méthode afin de construire la requête JPQL correspondante, puis l’exécute via l’`EntityManager`.


Au final la chaine de traitement sous-jacente dans Spring en partant du contrôleur à la base de données passe par le pipeline suivant :


```
Controller → Service → XXXRepository → SimpleJpaRepository → EntityManager → ORM (Hibernate ou autre) → SQL → Base de données
```
*XXXRepository est l’interface définie pour l’entité XXX qui sera implémentée par le proxy*.
---

## Comparaison entre le pattern DAO et le concept Repository

Le concept de Repository constitue une alternative moderne et productive au pattern DAO traditionnel. En effet, il est facile à mettre en œuvre et accroit la productivité. Puisqu’il n’y a plus besoin d’écrire des requêtes SQL ou JPQL pour les opérations standards, alors il y a gain de temps. Le code est clair, concis et facile à maintenir et donc plus lisible et plus robuste puisque les méthodes sont déjà testées par la communauté Spring.

Les DAO sont plus fastidieux à mettre en place pour des services CRUD. En effet, ils nécessitent d’écrire beaucoup de code répétitif qui sera moins standardisé et plus long à tester. En contrepartie, les DAO permettent un contrôle total du traitement de persistance, ce qui permet d’avoir un contrôle fin de la logique métier. En effet, avec les DAO, il est possible d’écrire des requêtes SQL et/ou JPQL personnalisées mieux adaptées au traitement des requêtes complexes. Dans ce cas, un développeur expérimenté peut obtenir un code plus circonscrit, lisible et performant.

Le tableau suivant synthétise un comparatif des critères entre une solution basée sur le concept de Repository et le pattern DAO.

|**Critère**|**Repository**|**Pattern DAO**|
| ------ | ------ | -------- |
|**Implémentation**|Générée automatiquement|Manuelle|
|**Code CRUD**|❌ Aucun|✔️ Obligatoire|
|**Proxy Spring**|✔️ Oui|❌ Non|
|**Méthodes dérivées**|✔️ Oui|❌ Non|
|**Requêtes complexes**|⚠️ Limité|✔️ Excellent|
|**Lisibilité**|✔️ Très bonne|⚠️ Dépend du développeur|
|**Performance**|✔️ Optimisée|✔️ Optimisée|
|**Courbe d’apprentissage**|✔️ Rapide|❌ Plus longue|

## Quand utiliser DAO ou Repository ?

Face à ces deux alternatives de solution, nous pouvons nous demander laquelle il faut utiliser durant notre développement. Le consensus et le bon sens, suggèrent d’utiliser la solution Repository quand nous devons privilégier la productivité et que nos besoins se limitent à développer un service offrant un CRUD standard ou des requêtes simples. Bien sûr, nous sommes dans un cadre de projet Spring Boot.

L’utilisation de la solution DAO plus classique est à privilégier dans le cas où les besoins métier nécessitent d’écrire des requêtes SQL plus complexes ou imposent des contraintes de performance critiques ou bien nécessitent d’accéder simultanément à plusieurs sources de données.

Typiquement, les requêtes SQL avancées comportant des expressions de table commune appelées CTE (Common Table Expressions) ne sont pas supportées par Spring Data. Il s’agit des requêtes complexes découpées en sous requêtes avec la clause WITH pour isoler une étape du traitement et la réutiliser ensuite dans la requête. C’est le cas par exemple des requêtes récursives composées d’un membre d’ancrage, un membre récursif, un contrôle de terminaison et une invocation. Ce type de requête est utilisée pour construire par exemple une arborescence ou un organigramme d’une entreprise (relation manager employés). La structure des requêtes récursives est la suivante : 

![Common Table Expressions recursive](images/archi/cte_recursive.png)

_[Figure issue de learnsql](https://learnsql.fr/blog/sql-ctes-une-vue-d-ensemble-complete-des-expressions-de-table-communes/){:target="_blank"} consultée le 12/01/2025_

Et à titre d’exemple la requête suivante permet de calculer le factoriel :

```sql
WITH RECURSIVE factorial(n, factorial) AS (
SELECT 1, 1
UNION ALL
SELECT n + 1, (n +1) * factorial FROM factorial WHERE n < 5
)
SELECT * FROM factorial;
```
Autre exemple, les requêtes comportant des [fonctions analytiques](https://fr.wikipedia.org/wiki/Fonction_de_fen%C3%AAtrage_(SQL)){:target="_blank"} pour calculer des métriques (totaux, cumuls, moyenne) sur un partitionnement ou ordre de lignes.

Par exemple, si nous souhaitons afficher le salaire des employés d’une entreprise avec pour chaque ligne le salaire moyen du département auquel appartient l’employé nous devons utiliser une requête utilisant la clause OVER avec PARTITION BY comme la suivante :

```sql
SELECT employee_id, departement_id, salary, avg(salary) OVER (PARTITION BY departement_id) FROM employees;
```
Cette requête n’est pas supportée par un Repository mais peut être traitée avec un DAO. En effet, Spring Data JPA ne dispose pas d’un parseur SQL fiable pour traiter toutes les syntaxes SQL possibles car traiter ces requêtes n’est pas son objectif principal.

Il est possible d’adopter une approche hybride mixant les deux solutions, un Repository pour les fonctionnalités CRUD de base et des besoins standards et un DAO pour des fonctionnalités avancées et complexes et des besoins liés à une logique très spécifique.