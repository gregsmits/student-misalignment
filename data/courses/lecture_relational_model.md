---
title: Introduction au modèle relationnel
keywords: modèle relationnel
sidebar: data_sidebar
summary: Ce cours vous présente les notions fondamentales du modèle relationnel de structuration des données.
toc: false
permalink: lecture_relational_model.html
folder: Database
---


# Introduction

Lorsque l'on souhaite rendre des données persistantes, c'est-à-dire les sauvegarder et les restaurer sur et depuis un média dédié indépendant de l'application, il est nécessaire de choisir un modèle à suivre pour définir comment les données sont structurées. Le stockage (sur disque par exemple) et l'accès à ces données dépendront également de ce choix de modèle, choix devant être guidé par l'usage. On choisira par exemple :
- un modèle *hiérarchique* pour stocker une taxonomie (comme la classification du vivant de Linné),
- un modèle orienté *document* pour stocker des ressources bibliographiques,
- un modèle *relationnel* lorsque les données peuvent être regoupées thématiquement et afin de disposer de garanties d'accès et d'intégrité,
- un modèle de type *NoSQL* lorsque l'on souhaite privilégier la rapidité d'accès à des données volumineuses au détriment de garanties d'intégrité,
- un modèle *graphe* lorsque les relations entre données varient et revêtent une importance particulière,
- un modèle document pour des données de type texte.

Le modèle relationnel reste prépondérant pour le développement d'applications web du fait qu'il propose des garanties très fortes sur l'[intégrité](lecture_db_integrity.html#intégrité-de-relation#intégrité-des-données) des données manipulées, parfois au détriment de l'efficacité des accès à ces données.

Le modèle relationnel est issu de travaux de recherche assez anciens sur la structuration des données en vue d'un stockage persistant sur disques et permettant une manipulation plus facile et fiable des données qu'à l'aide de fichiers. [Edgar Codd](https://fr.wikipedia.org/wiki/Edgar_Frank_Codd) est à l'origine de ce modèle de structuration et de manipulation des données pouvant être stockées sous forme de relations (tables) dans une BD dite Relationnelle (BDR).
- [E.F. Codd “A relational model of data for large shared data banks", 1970](https://dl.acm.org/doi/abs/10.1145/362384.362685).


Schématiquement, une information est une donnée que l'on sait interpréter. `13,25` est une donnée, mais si vous savez que c'est le prix d'un paquet de nouilles exprimé en euros, alors cela devient une information.


{% include callout.html content="**Définition** - Donnée<br/>Une donnée est une *valeur* quelconque associée à un type (*textuel*, *numérique*, *temporel*, etc.). " markdown="span" type="primary" %}

Un *nom* est souvent attaché à une donnée (*prix*, *désignation*, *date de naissance*, etc.) permettant ainsi de l'interpréter, on parle alors d'information. L'analyse de ces informations permet d'inférer des connaissances. C'est le rôle d'un *data scientist* de transformer des données en connaissances.

# Le modèle de données relationnelles

## Définitions

Le terme de *modèle de données relationnelles* désigne une manière de structurer les informations sous la forme de matrices que l'on appelle relations lorsque l'on raisonne sur la structure et tables lorsque l'on manipule leur implémentation par un SGBD.

Une base de données relationnelle est donc constituée d'un ensemble de données structurées sous forme de relations.

{% include callout.html content="**Définition** - Schéma d'une relation<br/>Le **schéma d'une relation** $$R$$ est caractérisé par un nom et une liste d'attributs $$A_1, ..., A_n$$ et se note $$R(A_1, ..., A_n)$$. On appelle arité d'une relation le nombre d'attributs qui la composent ($$n$$ dans la formalisation précédente)." markdown="span" type="primary" %}

L'arité minimale d'une relation est de 1 et dans ce cas l'attribut doit être une [clef primaire](lecture_db_integrity.html#int%C3%A9grit%C3%A9-de-relation).

{% include callout.html content="**Définition** - Schéma d'une base de données relationnelles<br/>Une base de données est composée de plusieurs relations possiblement reliées entre elles. Le **schéma relationnel d'une BD** est l'ensemble des schémas des relations qui font partie de la BD." markdown="span" type="primary" %}

{% include callout.html content="**Définition** - Attribut<br/>Un **attribut** est caractérisé par un nom, un type (*textuel*, *numérique*, *temporel*, etc.) et un domaine de définition des valeurs acceptables. Soit $$A$$ un attribut d'une relation $$R$$, on peut désigner son domaine de définition par $$dom(A)$$. Pour désigner sans ambiguité un attribut d'une relation, on utilise la notation $$R.A$$. Une relation ne peut pas posséder deux attributs de même nom, mais un même nom d'attribut peut apparaître dans plusieurs relations." markdown="span" type="primary" %}


{% include callout.html content="**Exemple**<br/>Considérons les données des clients d'une entreprise. On connaît leur numéro, leur nom, leur ville et leur numéro de téléphone. Nous pouvons exprimer cela par la relation Client (numéro, nom, ville, téléphone) qui peut se représenter sous forme d'une table, comme ci-dessous :<br/>" markdown="span" type="success" %}


#### Relation *Clients*

  | numéro   | nom      | ville  | téléphone
  | -------- | ----------|  -------- | ----------------
  | 2        | DURANT    |  BREST    | 02 12 34 56 78
  | 6        | MARTIN    |  PARIS    |
  | 22       | BERNARD   |  NICE     | 04 98 76 54 32
  | 54       | FONTAINE  |  RENNES   |


Les attributs d'une relation correspondent aux colonnes de la table. Les lignes d'une relation sont également appelées tuples.

{% include callout.html content="**Définition** - Tuple<br/>Formellement un **tuple** est une séquence de valeurs $$t = <v_1, v_2, ..., v_n>$$ prise dans l'ensemble $$dom(A_1) \bigotimes dom(A_2) \bigotimes ... \bigotimes dom(A_n)$$, c'est-à-dire le produit cartésien des domaines de définition des attributs. On note par $$t.A_i$$ la valeur prise par le tuple $$t$$ sur l'atribut $$A_i$$. <br/> On appelle cardinalité d'une relation le nombre de tuples qu'elle contient." markdown="span" type="primary" %}

La cardinalité d'une relation peut être 0 si elle ne contient pas encore de tuples.


{% include callout.html content="**Exemple**<br/>Le domaine de l'attribut `ville` est l'ensemble des villes où peuvent se situer ses clients. Le domaine n'est pas limité aux valeurs actuellement présentes dans la table." markdown="span" type="success" %}

{% include important.html content="Une relation est un ensemble au sens mathématique, il n'y a pas de notion d'ordre ni de doublons (répétitions). <br/>

**Pour continuer ...** L'absence de doublons dans une relation ainsi que la cohérence globale des données sont notamment garantis par des contraintes d'[intégrité](lecture_db_integrity.html)." %}
