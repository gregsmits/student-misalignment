---
title: Indépendance des données - Mécanisme des vues externes
keywords: Indépendance des données, vues externes, SQL
sidebar: data_sidebar
summary: L'objectif de cette introduction est de présenter le mécanisme des vues existant dans tous SGBDR
toc: true
permalink: lecture_independence_views.html
folder: Database
---


# Introduction

Une BD vise à regrouper un ensemble de données structurées par un schéma relationnel avec notamment comme objectifs d'éviter toute redondance et de garantir une exploitation complète par interrogation des données.

La centralisation des données structurées par un schéma rigoureux, et l'accès à l'intégralité de ce schéma, peut cependant se heurter à deux limites :

1. une application peut nécessiter de disposer uniquement d'une table synthétisant des données issues de plusieurs relation,
2. certaines données (tables) doivent être masquées à l'utilisateur pour des questions de sécurité.

Une solution pour répondre à ces limites est de proposer une abstraction du schéma relationnel à l'aide de vues externes qui exposent non plus tout le schéma logique mais une (ou plusieurs) relation(s) résultant de l'exécution d'une requête sur la BD. Le fait que l'algèbre relationnelle forme un système de calcul fermé (les entrées d'une requête sont des relations et sa sortie est une relation), permet en effet de considérer le résultat d'une requête comme une relation particulière. 

![Abstraction du schéma par vues externes](images/data/external_views.png)


# Les vues en SQL

La construction d'un schéma externe pour chaque usage à partir du schéma logique, et de son implémentation physique, repose sur la notion de vue externe.


{% include callout.html content="**Définition** - Vue<br/>Une **vue** est une relation formée par le résultat d'une requête SQL. Les vues font partie de la norme SQL. 
" markdown="span" type="primary" %}
Une fois définie, la vue peut être utilisée dans des requêtes SQL. Lors de l'accès à une vue, le SGBD exécute la requête qui définit la vue. Une vue est un accès dématérialisé à un ensemble de données puisque, contrairement à une table, il n'y a pas de tuples stockés pour la vue. Les tuples accessibles par la vue sont récupérés par une requête SQL. 

Pour des question d'efficacité d'accès aux données accessibles depuis une vue externe, il est tout de fois possible de matérialiser cette vue afin que les tuples auxquels elle donne accès soient stockés sur disque. Cela engendre des redondances de stockage de données mais permet la définition d'index tout en maintenant des mecanismes de mise-à-jour entre les tables initiales et la vue matérialisée. 


# Définition d'une vue 

Une vue est donc créée à partir d'une requête comme l'illustre le pseudo-code SQL suivant :
```
CREATE OR REPLACE VIEW viewName AS (
    SELECT ...
);
```
![Exemple de schéma logique](images/data/exlogical_schema.png)


{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessus de schéma logique, la relation *Customer* est reliée à *Group* par une association *is member*. On peut vouloir cacher cette structuration à une application pour simplement lui fournir un accès simplifié aux données des clients des groupes localisés à Brest uniquement. La vue ci-dessous permettra de fournir cet accès spécifique.

 <br/>" markdown="span" type="success" %}

```
CREATE VIEW customers_brest as
    SELECT C.id AS idCustomer, name, job, city, description
    FROM customer C INNER JOIN is_member M ON C.id = M.idC
        INNER JOIN group G ON M.idG = G.id
    WHERE headquarter = 'Brest'
;
```

L'invocation de la vue, comme par exemple dans la requête ci-dessous, entraînera de manière transparente pour l'utilisateur l'exécution de la requête sur les tables *customer*, *is_member* et *group*.

```
SELECT * 
FROM customers_brest
WHERE job = 'mng';
```

# Contrôle des accès

Une base de données peut stocker une grande quantité de tuples et tous ne doivent pas forcément pouvoir être accessibles pour un utilisateur. De même, il peut exister des situations où un utilisateur doit pouvoir accéder aux clients de Brest et pas ceux de Paris par exemple. Le recours à des schémas externes permet de mettre en place ce genre de contrôle d'accès. 

L'instruction SQL *GRANT* permet de définir quels accès (*SELECT*, *INSERT*, *UPDATE*, *DELETE*, ...) sont autorisés à un ou plusieurs utilisateurs sur une table ou une vue.


{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessous, l'accès *SELECT* est accordé à au rôle (utilisateur en BD) *user1* sur la vue *customers_brest*.
 <br/>" markdown="span" type="success" %}

```
GRANT SELECT ON custromers_brest TO user1;
```

{% include callout.html content="**Pour aller plus loin ...** Voir plus précisément la gestion des contrôle d'accès avec la commande [*GRANT*](https://docs.postgresql.fr/13/sql-grant.html) et découvrir quelques subtilités sur la [manipulation des vues en SQL](https://docs.postgresql.fr/12/sql-createview.html).relationnel des données" %}
