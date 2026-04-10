---
title: Niveaux d'isolation dans un SGBDR
keywords: Transaction, isolation
sidebar: data_sidebar
summary: Ce cours vous présente une notion importante des SGBDR, la gestion des accès concurrents de mise-à-jour des données à l'aide des mécanismes transactionnels et surtout le principe d'isolation.
toc: true
permalink: lecture_isolation.html
folder: Database
---

<!--
{% include callout.html content="**Pré-requis**<br/><br/>
- [Connaître le mécanisme transactionnel et les propriétés ACID](lecture_transaction.html)" markdown="span" type="danger"%} -->

# Introduction

Une transaction est une unité atomique d'exécution composée d'une séquence d'opérations (de lecture et/ou d'écriture). Un SGBDR peut à un instant donné exécuter une seule opération et avoir pourtant à gérer de multiples transactions simultanément. Une solution naïve serait d'exécuter les transactions les unes après les autres (en séquence), mais une transaction longue pénaliserait l'accès au SGBDR pour toutes les autres. Un ordonnanceur a donc pour rôle d'entrelacer les opérations issues de différentes transactions.


![Transaction non sérialisable](images/data/transactionError.png)

{% include callout.html content="**Exemple**<br/>Cependant, comme l'illustre la figure ci-dessus, l'entrelacement des opérations des transactions concurrentes ne se fait pas sans risque. Dans cet exemple, deux transactions concurrentes sont composées chacune, d'une opération de lecture d'une valeur $$X$$ dans une variable locale à la transaction ($$v_1$$ et $$v_2$$ respectivement). La transaction $$T_1$$ retire 50 à la valeur stockée dans $$v_1$$ avant d'écrire cette valeur dans la base de données. $$T_2$$ fait de même en ajoutant 150 à $$X$$. L'entrelacement des opérations conduit cependant à une valeur finale de 800 pour $$X$$ alors que 750 était attendu.
<br/>" markdown="span" type="success" %}

# Situations problématiques

L'exécution concurrente de transactions, et surtout l'entrelacement de leurs opérations, peut conduire à des situations problématiques qui pourront être évitées par la mise en place d'un niveau d'isolation adapté, mais attention au détriment de la performance d'exécution de ces transactions.


## Lecture fantôme

Lorsqu'une même requête de lecture est exécutée plusieurs fois dans une même transaction et que les résultats diffèrent (c.-à-d., le nombre de lignes résultat n'est pas le même), alors on nomme cette situation une lecture fantôme. Cette différence dans les résultats résulte d'une modification de la BD (ajout et suppression de tuples) par d'autres transactions entre les requêtes.

## Lecture non reproductible

Une situation de lecture non reproductible survient lorsqu'au cours d'une transaction $$T_1$$, un tuple est lu dans la BD. Puis une transaction concurrente $$T_2$$ modifie ce tuple. Après cette modification, $$T_1$$ réitère sa lecture du même tuple et observe une valeur différente. Deux lectures d'un même tuple au sein d'une même transaction qui retournent des valeurs différentes constituent un cas de lecture non reproductible.

## Mise à jour perdue

Cette situation correspond à l'illustration précédente (modification concurrente de la valeur $$X$$) où des transactions lisent une même donnée pour ensuite la modifier à tour de rôle. Seule la dernière modification est prise en compte, les autres sont ignorées.

## Lecture sale

Cette situation arrive lorsqu'une transaction lit une valeur dans la BD qui a été mise-à-jour dans une transaction concurrente pas encore validée. En cas d'annulation de cette dernière transaction, alors la lecture de la valeur par la première transaction est dite sale puisque la valeur lue n'existe plus.

# Verrous

Pour éviter les situations problématiques l'isolation des transactions repose sur un mécanisme de verrous posés par les transactions sur les ressources (tables, pages ou tuple) qu'elles manipulent.

Un verrou peut être demandé par une transaction sur une ressource pour interdire à d'autres transactions d'y accéder. Un verrou peut être partagé ou exclusif. Partagé indique que d'autres verrous du même type peuvent être posés sur la même ressource, par exemple pour permettre plusieurs lectures concurrentes. Exclusif indique que la pose d'un autre verrou sur la même ressource est impossible, la transaction demandeuse est alors mise en attente de libération du verrou.

Un mécanisme de délai (*timeout*) permet d'éviter des cas d'interblocage lorsque la pose d'un verrou est bloqué par un verrou existant en mode exclusif.

# Niveaux d'isolation

Pour éviter les situations problématiques introduites précédemment, le comportement d'un SGBD est défini par un niveau d'isolation. Quatre niveaux d'isolation sont définis dans une norme SQL92 ANSI. Le choix d'un niveau d'isolation doit être motivé par les exigences du contexte applicatif afin de définir un compromis entre performance (degré de concurrence) et protection vis-à-vis des situations problématiques. Un niveau d'isolation peut être indiqué par transaction.

## Sérializable

Ce niveau d'isolation est le plus strict car il assure que les transactions seront gérées comme si elles étaient exécutées séquentiellement.

L'instruction SQL permettant de mettre en place le niveau d'isolation *Serializable* est :
```set transaction isolation level serializable;```

## Repeatable reads

Une action d'une transaction exécutée dans ce niveau d'isolation ne pourra débuter que lorsque les tuples concernés par cette action n'auront plus aucun verrou d'écriture. Ce mode assure que les lectures au sein de la transaction se feront sur une version de la BD ne pouvant plus évoluer. Par exemple, si on sélectionne des tuples d'une table, alors les tuples concernés de la table ne pourront pas être modifiés par d'autres transactions.

## Read committed

Il s'agit du mode par défaut dans PostgreSQL. 
La transaction exécutée en mode d'isolation *read committed* ne peut débuter que lorsque les verrous de modification des tuples concernés sont libérés. Puis un verrou est posé sur chaque tuple lors de la lecture mais libéré juste après la lecture du tuple, contrairement au mode plus restrictif *repeatable reads* où les verrous sur les tuples en lecture ne sont libérés qu'en fin de transaction. Pas de lecture sale dans ce mode d'isolation mais plusieurs lectures identiques peuvent retourner des résultats différents au sein d'une même transaction.


## Read uncommitted

Aucun mécanisme d'isolation n'est appliqué puisqu'une transaction peut lire des données écrites par une autre transaction même sans que celles-ci soient validées par un *commit*.



| Niveau d'isolation	| Lecture fantôme	| Lecture non reproductible	| Lecture sale	| Mise à jour perdue
| ------                | ------            | ------                    | ------        | ------
| SERIALIZABLE	        |                   |	                        |	            |
| REPEATABLE READ	    | possible          |	                        |	            |
| READ COMMITTED	    | possible          |	possible                |	            |
| READ UNCOMMITTED	    | possible          |	possible                |	possible	|
| Sans isolation        | possible          |	possible                |	possible	| possible

<!--
{% include callout.html content="**Pour continuer ...** Consulter une description plus détaillée des transactions et des niveaux d'isolation [ici par exemple](http://sys.bdpedia.fr/transactions.html)." %} -->
