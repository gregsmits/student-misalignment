---
title: Transaction
keywords: ACID atomicité, transaction
sidebar: data_sidebar
summary: Ce cours vous présente une notion importante des SGBDR, la gestion des accès concurrents de mise-à-jour des données à l'aide des mécanismes transactionnels.
toc: true
permalink: lecture_transaction.html
folder: Database
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>
- [Connaître le modèle relationnel](lecture_relational_model.html)<br/>
- [Comprendre la notion d'intégrité des données](lecture_db_integrity.html)" markdown="span" type="danger"%} -->

# Introduction

Dans cette partie de l'UV INF 210, nous allons nous intéresser à une problématique très importante liée aux accès concurrents à la BD et notamment lorsque plusieurs requêtes visent à modifier des données.

Il est important de rappeler qu'un rôle important d'un SGBDR est de garantir à tout moment que l'ensemble des contraintes d'intégrité des données sont respectées. On peut cependant imaginer qu'à un même moment, un SGBDR peut se retrouver dans une situation où de nombreuses requêtes de mise-à-jour, d'ajout, de suppression ou de lecture sont à exécuter en même temps.

# Le mécanisme transactionnel

## Transaction

{% include callout.html content="**Définition** - Transaction<br/>Une **transaction** est une unité atomique d'exécution dans un SGBDR regroupant une séquence d'opérations de mise-à-jour ou de lecture de la BD. Une transaction, c'est-à-dire l'ensemble de ses opérations est soit :<br/>

- complètement validée par une opération de _commit_,<br/>
- complètement annulée par une opération de _rollback_.<br/>

Le _commit_ valide l'ensemble des opérations réalisées dans la transaction alors que le _rollback_ remet la BD dans l'état où elle était avant le début de la transaction.
" markdown="span" type="primary" %}

Ce mécanisme de transactions a été relativement transparent lors des activités pratiques sur SQL car par défaut, les SGBDR sont paramétrés en _auto commit_. Ceci signifie qu'une transaction est démarrée au début de chaque requête et arrêtée par un _commit_ en cas de succès de la requête ou un _rollback_ en cas d'échec.

## Propriétés ACID

La gestion des accès concurrents par le SGBDR à travers les mécanismes de transactions vise à garantir que les quatre propriétés suivantes seront toujours respectées pour chaque transaction :

- **Atomicité** : une transaction est un atome d'exécution qui est, soit entièrement validé, soit entièrement annulé si une exception survient
- **Cohérence** : la BD sera dans un état cohérent à la fin de la transaction, c'est-à-dire que l'ensemble des contraintes d'intégrité seront satisfaites
- **Isolation** : l'exécution d'une transaction n'est pas altérée par la présence d'autres transactions concurrentes
- **Durabilité** : les résultats d'une transaction sont définitifs à la fin de celle-ci

## Concurrence

Un client qui se connecte à un SGBDR est vu comme un processus. Ce client peut soumettre au SGBDR plusieurs transactions les unes après les autres, chaque transaction étant composée d'opérations de lecture et/ou de modification des données. Ce fonctionnement n'est évidemment pas problématique car les transactions d'un même client sont exécutées les unes après les autres.

Par contre, plusieurs clients peuvent être connectés en même temps au SGBDR et donc demander des exécutions de transactions qui accèdent aux mêmes données en même temps.
Comment gérer l'exécution concurrente de ces transactions en offrant un compromis entre performance (faire attendre le moins possible chaque client) et cohérence des données ?
Le SGBDR repose sur un niveau d'isolation des transactions pour définir l'équilibre entre ces deux notions.

<!--
{% include callout.html content="**Pour continuer ...** Découvrir les [niveaux d'isolation](lecture_isolation.html) et consulter une description plus détaillée des transactions [ici par exemple](http://sys.bdpedia.fr/transactions.html)." %} -->
