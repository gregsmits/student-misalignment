---
title: Activité - Modélisation conceptuelle des données et dérivation (version avancée)
keywords: modélisation conceptuelle, UML, dérivation
sidebar: data_sidebar
summary: Cette activité a pour objectif de vous exercer à la modélisation conceptuelle des données en utilisant le formalisme UML. Vous vous exercerez également à produire un schéma logique en utilisant les règles de dérivation.
toc: true
permalink: activity_conceptual_modeling_advanced.html
folder: Database
---

{% include callout.html content="**Pré-requis**<br/><br/>
- [Connaître le modèle relationnel](lecture_relational_model.html)<br/>
- [Comprendre la notion d'intégrité des données](lecture_db_integrity.html)<br/>
- [Introduction à la construction d'un schéma relationnel](lecture_modeling_normalization.html)<br/>
- [Modélisation conceptuelle des données](lecture_conceptual_modeling.html)
- [Activité sur des cas plus simples de modélisation conceptuelle](activity_conceptual_modeling.html)" markdown="span" type="danger"%}

## Présentation du problème

L'objectif de cet exercice est de poursuivre la modélisation conceptuelle que vous avez débutée dans l'[activité - Modélisation conceptuelle](activity_conceptual_modeling.html). 
<!-- otre encadrant vous donnera le numéro des contraintes pour lesquelles vous devrez adapter votre modèle conceptuel et modifier en conséquence sa dérivation en schéma logique. Sans instruction de sa part exécutez dans l'ordre en faisant valider chacune des sections avant de passer à la suivante. -->

### Alternatives sur les enseignants

- A1 - Il y a deux types d'enseignants : les vacataires extérieurs et les permanents.
- A2 - Les vacataires extérieurs ont un employeur principal qui n'est pas l'école et une date de validité de l'autorisation de cumul. Cette information est purement réglementaire et l'on ne désire pas stocker des informations sur les entreprises extérieures.
- A3 - Seuls les permanents ont une appellation (CER, MC, Prof, IE, DE).
- A4 - Les permanents sont rattachés à un département et à un seul. Les départements ont un nom et ils ont un chef qui est un permanent du département.

### Alternatives sur les modules

- B1 - Les modules sont coordonnés par un ou deux permanents (2 au maximum). Les vacataires extérieurs ne peuvent pas coordonner de modules.
- B2 - Les séances peuvent être encadrées par plusieurs enseignants mais il est possible qu'une séance se déroule en autonomie sans la présence d'un enseignant.
- B3 - Un module est structuré en différentes activités qui sont ordonnées. Les activités ont un titre et un type. Ces activités sont jouées lors des séances. Une séance ne comprend qu'une seule activité mais une activité peut durer plusieurs séances.

### Alternatives sur les Stagiaires

- C1 - Les stagiaires s'inscrivent désormais à une formation qui est constituée de plusieurs modules.

### Gestion de l'historique

- D1 - On désire s'assurer qu'on puisse gérer l'historique de toutes les informations présentes dans la base de données. Ajoutez ou changez en conséquence tout ce qui est nécessaire.




{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_conceptual_modeling_advanced_correction.html)." markdown="span" type="danger"%} 

<!-- 
## Évaluation d'un schéma conceptuel et de sa dérivation

Pour évaluer votre travail nous vous proposons d'utiliser la [grille](ressources/pdf_bd/grille_modelisation.pdf) suivante :

<iframe src="ressources/pdf_bd/grille_modelisation.pdf"  width="800" height="600" align="middle"></iframe> -->
