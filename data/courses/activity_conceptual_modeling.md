---
title: Activité - Modélisation conceptuelle des données et dérivation
keywords: modélisation conceptuelle, UML, dérivation
sidebar: data_sidebar
summary: Cette activité a pour objectif de vous exercer à la modélisation conceptuelle des données en utilisant le formalisme UML. Vous vous exercerez également à produire un schéma logique en utilisant les règles de dérivation.
toc: true
permalink: activity_conceptual_modeling.html
folder: Database
---


## La place de la modélisation conceptuelle de données

Le modèle relationnel est suffisamment générique pour représenter de nombreuses situations, même complexe. Cependant, construire un schéma relationnel garantissant des propriétés de non-redondance et d'accessibilité (voir le cours sur la [normalisation](lecture_normalization.html)) n'est pas simple. Vous allez manipuler une approche permettant de partir des données pour aboutir à un schéma relationnel exploitable.

![Figure](images/bd/bd_td_modelisation_conceptuelle_schema_principe.png)

{% include important.html content="Ce schéma ne vous dit rien ? Vous avez dû oublier de lire les pré-requis !"%}

## Modélisation conceptuelle des données en UML

Utilisez la notation `UML` afin de concevoir le modèle conceptuel de données du problème exposé ci-dessous. Dans l'ordre, commencez par identifier :

-   les différentes classes,
-   les liens d'héritage,
-   les associations entre classes,
-   et les cardinalités de chacune des associations.

## PLes données du problème

L'objectif de cet exercice est de réaliser le schéma conceptuel et le schéma logique d'une base des données décrivant des sessions de formation continue.

Dans le cadre du dispositif de formation continue des stagiaires peuvent venir à l'école afin de suivre un module d'enseignement. Dans un premier temps chaque module est joué une fois par an et aucun historique n'est conservé d'une année à l'autre.

1. On désire pouvoir gérer les inscriptions des stagiaires aux différents modules.

2. On désire pouvoir gérer les interventions des enseignants dans les différentes séances d'un module.

3. Stagiaires et enseignants ont beaucoup de caractéristiques communes : un nom, un prénom, une adresse, un numéro de téléphone.

4. Un enseignant peut être également un stagiaire.

5. Les enseignants ont une appellation (CER, MC, Prof, IE, DE).

6. Les modules sont coordonnés par un unique enseignant. Ils possèdent un titre.

7. Chaque module est composé de plusieurs séances.

8. Les séances possèdent un titre et ont lieu dans une salle à une heure donnée. Elles sont encadrées par un unique enseignant.

9. Un stagiaire peut être inscrit à plusieurs modules.


## Dérivation

Dérivez votre schéma conceptuel en schéma logique en appliquant les règles présentées dans le cours.




{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_conceptual_modeling_correction.html)." markdown="span" type="danger"%} 


<!-- 
## Évaluation d'un schéma conceptuel et de sa dérivation

Pour évaluer votre travail nous vous proposons d'utiliser la [grille](ressources/pdf_bd/grille_modelisation.pdf) suivante :

<iframe src="ressources/pdf_bd/grille_modelisation.pdf"  width="800" height="600" align="middle"></iframe> -->
