---
title: Plan d'exécution de requêtes et indexation
keywords: indexation, plan d'exécution
sidebar: data_sidebar
summary: Le temps d'exécution d'une requête, calcul de la relation résultat, dépend de la taille des données interrogées mais aussi de contraintes sur ces données. Ce cours explique comment comprendre la façon dont une requête est exécutée et introduit la notion d'index pour accéler l'exécution de requêtes SELECT. 
toc: true
permalink: lecture_indexation.html
folder: Database
---


# Introduction

Un SGBD(R) a pour rôle d'assurer la persistance de données, potentiellement volumineuses, mais doit également fournir des fonctionnalités permettant de les interroger efficacement ces données. 

En fonction de la requête soumise et des données interrogées, la relation résultat est calculée par le SGBD avec des vitesses différentes. Dans ce cours, vous allez découvrir comment comprendre la méthode utilisée par le SGBDR pour calculer ce résultat et des techniques pour accélérer son calcul, évidemment au détriement d'un autre critère, rien est magique.

## Plan d'exécution de requêtes

Lorsqu'une requête de type *SELECT* est soumise à un SGBDR, son rôle est d'identifier la méthode la plus efficace pour calculer son résultat. Prenons l'exemple de la (pseudo)requête ci-dessous :

```
SELECT *
FROM R1 INNER JOIN R2 ON R1.A = R2.A
WHERE R1.C < x and R2.B > y
;
```

Pour constuire la table résultat de cette requête, le SGBDR doit effectuer trois opérations majeures sur les données :
- joindre les tuples de *R1* et *R2* selon leur égalité sur *A*,
- sélectionner les tuples de *R1* dont la valeur sur *C* est inférieure à *x*,
- sélectionner les tuples de *R2* dont la valeur sur *B* est supérieur à *x*.

Intuitivement, on imagine bien qu'en fonction du nombre de tuples de *R1* et de *R2* satisfaisant le critère de le sélection, il est plus intéressant de procéder à une sélection avant de faire la jointure. Mais si inversement tous les tuples de *R1* et de *R2* sont satisfaisants vis-à-vis des critères de sélection alors il faut mieux faire la jointure d'abord. C'est ce genre de calculs que le SGBD effectue pour déterminer la meilleure façon de répondre à une requête parmi les exécutions possibles (voir la [gestion des statistiques sur la distribution des données dans un SGBD](https://www.postgresql.org/docs/current/row-estimation-examples.html))

## EXPLAIN


{% include callout.html content="**Définition** - Plan d'exécution<br/>Le **plan d'exécution** d'une requête décrit les étapes de résolution d'une requête choisi par le moteur d'exécution d'un SGBD. Ce plan indique quelles tables ou parties de tables seront parcourues et dans quel ordre pour récupérer l'ensemble des tuples nécessaires à la construction du résultat de la requête.
" markdown="span" type="primary" %}

L'instruction *EXPLAIN* peut précéder une requête de type *SELECT* pour indiquer au SGBDR (PostgreSQL dans notre cas) qu'au lieu de calculer la relation résultat, le plan d'exécution de la requête doit être affiché. En complément du plan d'exécution, une estimation du temps nécessaire pour identifier le premier tuple satisfaisant et l'intégralité des réponses, ainsi que le nombre de ces réponses est indiqué.

L'option *ANALYZE* peut être ajoutée à l'instruction *EXPLAIN* pour demander au SGBD d'afficher le plan d'exécution, les estimations des temps de traitement, d'exécuter la requête et d'afficher le temps réellement mis pour construire le résultat. Ceci permet de vérifier la fiabilité des estimations réalisées par le SGBD.


```
EXPLAIN SELECT * FROM tab;

                       QUERY PLAN
---------------------------------------------------------
 Seq Scan on tab  (cost=0.00..155.00 rows=10000 width=4)
(1 row)
```

{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessus, le plan d'exécution indique que pour fournir le résultat de la requête, le SGBD doit parcourir l'intégralité (*Seq Scan* signifie parcours séquentiel) de la table *tab*. Il est estimé (ici c'est assez fiable car il n'y a pas de sélection) que le résultat sera composé de 10000 tuples et que chaque tuple occupera 4 octets en mémoire (*width=4* qui dépend de l'opérateur de projection). Évidemment en cas de parcours séquentiel, et sans critère de sélection, le premier tuple de *tab* est la première réponse. Elle sera retournée en *0.00* unité de coût et tous les résultats seront disponibles après *155.00* unités de coûts. Une unité de coût est le temps nécessaire pour accéder à un tuple dans le système de stockage persistant (version paginée). Il ne s'agit pas de milli-secondes ou autre. 
 <br/>" markdown="span" type="success" %}


# Indexation

Le temps d'exécution d'une requête reposant sur un parcours séquentiel, comme dans l'exemple précécent, dépend donc de la cardinalité de la table interrogée. Certaines requêtes sont très fréquemment utilisées dans une application. On pourrait donc souhaiter disposer de mécanismes pour accélérer le calcul du résultat de ces requêtes. 


Imaginez par exemple une application où très souvent vous cherchez les produits dont le prix est inférieur à une valeur. Pour collecter toutes les réponses, il faut donc parcourir tous les tuples de la table *produits* et vérifier pour chacun si le prix est acceptable. On obtiendrait ainsi un plan d'exécution comme suit :

```
EXPLAIN SELECT count(*) FROM product WHERE price < 150;

                             QUERY PLAN
---------------------------------------------------------------------
 Aggregate  (cost=23.93..23.93 rows=1 width=4)
   ->  Seq Scan on product  (cost=0.00..23.92 rows=6 width=4)
         Filter: (price < 150)
(3 rows)
```

Plus il y a de produits et plus la requête sera longue, indépendemment du nombre de produits satisfaisant votre condition.

Pour accélérer l'exécution d'une telle requête, il faut fournir au SGBD un moyen d'identifier plus rapidement où se trouvent, sur le disque, les tuples intéressants en fonction d'un critère (le prix par exemple). C'est le rôle d'un index.


{% include callout.html content="**Définition** - Index<br/>Un **index** en base de données a le même rôle qu'un index dans un livre, c'est-à-dire indiquer à quelle page on peut trouver tel mot clef ou concept. Un index est donc une structure de données persistée qui permet au système d'associer rapidement une valeur (ou un ensemble de valeurs) à un emplacement de stockage.
" markdown="span" type="primary" %}

```
    CREATE INDEX idx_price ON product (price);
```
{% include callout.html content="**Exemple**<br/>L'instruction ci-dessus demande au système de construire un index nommé *idx_price* sur l'attribut *price* de la table *product*. L'exécution de la même requête que précédemment conduira à un plan d'exécution différent et un temps d'exécution réduit.
<br/>" markdown="span" type="success" %}

```
EXPLAIN ANALYZE SELECT count(*) FROM product WHERE price < 150;

                             QUERY PLAN
---------------------------------------------------------------------
 Aggregate  (cost=0.12..3.24 rows=1 width=4)
   ->  Index Scan using idx_price on product  (cost=0.00..2.94 rows=6 width=4)
         Index Cond: (price < 150)
(3 rows)
```

Les index doivent évidemment être créés intelligemment car bien qu'ils permettent d'accélérer l'exécution de requêtes de type *SELECT*, ils ont l'effet opposé sur les requêtes de type *INSERT* et *UPDATE*. Chaque ajout ou mise-à-jour des données implique en effet une mise-à-jour des index.

## Types d'index

Il existe plusieurs types d'index, chacun étant approprié à un type de données et des opérations. Voici les types d'index gérés par PostgreSQL :
- *B-Tree*, le type par défaut, construit un arbre binaire et peut être appliqué pour tous types de données munis d'une relation d'ordre.
- *Hash*, pour définir une fonction de hachage associant une valeur à une clef déterminant l'emplacement de stockage de la valeur. Ce type d'index ne gère que des critères d'égalité.
- *GiST* et *SP-GiST* pour des données complexes telles que des données géographiques,
- *GIN* pour effectuer une indexation inversée à partir de données complexes telles que des listes de valeurs
- *BRIN* qui indexe des intervalles de valeurs stockées de manière consécutive sur un disque. Cet index est généralement moins volumineux mais n'indique pas l'emplacement exacte de la valeur mais sa région de stockage.

Pour des données textuelles, et afin de fournir des mécanismes rapides de recherche par mots clefs par exemple, PostgreSQL fournit un [type de données intrinsèquement indexé nommé *ts_vector*](https://www.postgresql.org/docs/current/textsearch.html). 

