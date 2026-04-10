---
title: Modélisation et normalisation de schémas relationnels
keywords: modèle relationnel, UML, normalisation
sidebar: data_sidebar
summary: La définition du schéma relationnel et de ses contraintes d'intégrité est une étape cruciale pour garantir que la base de données pourra être efficacement exploitée. Cette section introduit deux méthodes pour conduire une démarche de conception d'un schéma relationnel. Des règles normatives existent pour garantir la qualité d'un schéma.
toc: true
permalink: lecture_modeling_normalization.html
folder: Database
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>
- [Connaître le modèle relationnel](lecture_relational_model.html)<br/>
- [Comprendre la notion d'intégrité des données](lecture_db_integrity.html)" markdown="span" type="danger"%} -->

<!-- {% include callout.html content="**Approfondissements**<br/><br/>
- [Modèle relationnel et intégrité des données](bd_td_modele_relationnel.html)<br/>" markdown="span" type="warning"%} -->

# Introduction

L'étape de structuration d'une base de données relationnelles, c'est-à-dire le processus permettant d'aboutir à un schéma relationnel à partir de l'expression d'un besoin de persistance de données, est cruciale. Une structuration inadéquate des données peut suivant les cas :

- être source de redondance, c’est-à-dire de répétition inutile d’information. Cette redondance pouvant à son tour entraîner des incohérences lors de mises-à-jour, si on ne modifie pas l’information redondante partout où elle est présente.
- être contradictoire avec les hypothèses, et ne pas permettre de représenter une information correcte,
- avoir une incidence sur le nombre d’opérations nécessaires pour chercher une information ou pour la mettre à jour.

Plusieurs méthodes existent pour conduire cette étape de définition d'un schéma relationnel et nous allons en aborder deux :<br/>

1- la modélisation conceptuelle des données,<br/>
2- le découpage par application successive de règles de normalisation.


Un enjeu est d'aboutir à une solution apportant un compromis entre garantie d'intégrité des données et efficacité des accès.


## Dictionnaire de données

Un point de départ de toute méthode de construction d'un schéma relationnel est de connaître les données manipulées. Un dictionnaire de données est un recensement et une première description des données à considérer. Le dictionnaire est un document contenant pour chaque attribut son type, une description et des contraintes de domaine. Voici un exemple ci-dessous de dictionnaire :

#### Dictionnaire de données

  | nom      | type      | contrainte                        | description
  | -------- | ----------|  --------                         | ----------------
  | numéro   | entier    |  identifiant auto-incrémenté      | matricule d'un client de l'enterprise
  | nom   | chaîne de caractères    |  longueur entre 2 et 30      | nom du client
  | ville   | chaîne de caractères    |  longueur entre 2 et 40      | ville de résidence du client
  | fonction   | chaîne de caractères    |  longueur entre 3 et 40      | fonction assurée par le client
  | Gid   | chaîne de caractères    |  commence par G      | identifiant du groupe
  | designation   | chaîne de caractères    |        | désignation du groupe
  | villeG   | chaîne de caractères    |  longueur entre 2 et 40      | siège social du groupe


La description des données à travers un dictionnaire n'est pas suffisante pour comprendre le rôle et les interactions entre les attributs. Par exemple, on pourrait imaginer qu'un membre du personnel d'une entreprise ne peut occuper qu'une seule fonction, au maximum une fonction par groupe ou bien qu'il n'y ait aucune limitation. Ces précisions sur les liens entre données sont donc tout aussi importantes que le dictionnaire et doivent être établies comme point de départ de la phase de construction du schéma relationnel, quelque soit la méthode employée.

## Relation universelle

Sans compétence en base de données, une première possibilité est de regrouper toutes les données dans une unique relation, appelée **relation universelle**. Ceci revient à utiliser un simple tableur (Calc, Excel, etc.).
Nous verrons que la relation universelle constituera le point de départ de la démarche de structuration par découpage via l'application séquentielle de règles de normalisation.

#### Relation universelle *Personnel*

  | numéro    | nom    | ville    | fonction  | idG    | designation   | villeG
  | ------    | ------ |  ------  | ------    | ------ | ------        | ------
  | 1         | Dias   | Plouzané | DevOps    | G1     | SoftDev4.0    | Brest
  | 1         | Dias   | Plouzané | SysAdm    | G2     | LinGnu        | Paris
  | 2         | Monti  | Brest    | DevOps    | G1     | SoftDev4.0    | Brest
  | 3         | Stu    | Gouesnou | mng       | G1     | SoftDev4.0    | Brest
  | 4         | Pierou | Landéda  | mng       | G2     | LinGnu        | Paris
  | 4         | Pierou | Landéda  | cons      | G1     | SoftDev4.0    | Brest
  | 5         | Djid   | Bres     | DevOps    | G1     | SoftDev4.0    | Brest


## Redondance et difficulté d'interrogation

Même sans compétence en BD, il est aisé de constater que recourir à une relation universelle pour stocker les données de l'application n'est pas une solution pérenne. Le premier problème est lié à la **redondance de données** puisque la description des groupes est répétée pour chacun de ses membres. Imaginez que le siège social de l'entreprise *SoftDev4.0* change. Il faut alors répercuter cette modification dans plusieurs tuples de la relation universelle.

La seconde limite forte de cette stratégie naïve est la difficulté à répondre à certains besoins d'informations. Certaines recherches sont en effet difficiles à mener. Imaginez que vous souhaitiez avec un tableur écrire une formule pour identifier les personnels qui habitent dans la même ville que le manager (fonction *mng*) de leur groupe. Eh bien, bon courage.


{% include callout.html content="<b>Pour continuer ...</b><br/>
Il vous tarde sans doute de découvrir comment les deux méthodes envisagées ([Modélisation conceptuelle](lecture_conceptual_modeling.html) et [Normalisation](lecture_normalization.html)), permettent d'aboutir à un schéma relationnel à partir de ces descriptions des données. La modélisation conceptuelle est une méthode pouvant être appliquée même pour des données et situations complexes alors que le découpage par normalisation est davantage pragmatique et ciblé. Cette dernière est donc plutôt dédiée aux situations de complexité modeste." markdown="span" type="warning"%}
