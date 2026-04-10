---
title: "Pratiquer avec le langage SQL "
keywords: langage SQL
sidebar: data_sidebar
summary: Ce TP a pour objectif de vous permettre de découvrir le langage SQL.
toc: true
permalink: practice_sql.html
folder: Database
---


{% include important.html content="N'oubliez pas de sauvegarder très souvent votre éditeur de requêtes SQL dans PgAdmin et en dehors du container en faisant un copié-collé dans un fichier sur votre machine."%}

# Mise en place de l'activité pratique

## Description de la base de données SOINS

Les requêtes SQL à exprimer sont relatives à la base de données SOINS constituée des relations dont le schéma est décrit de manière linéaire ci-dessous (les clefs primaires des relations sont <u>soulignées</u>, et les attributs qui référencent une autre relation sont prédécés d'un dièse (\#)).

MEDECIN (<u>medecin_id</u>, nom, prenom, adresse, tel, specialite)<br/>
PATIENT (<u>patient_id</u>, nom, prenom, numsecu, \# rattachement,  \#medecin_referent) où *rattachement* référence *PATIENT(patient_id)* et *medecin_referent* référence *MEDECIN(medecin_id)*<br/>
VISITE (<u> #medecin,  #patient, date_visite</u>, prix) où *medecin* référence *MEDECIN(medecin_id)* et *patient* référence *PATIENT(patient_id)*<br/>
PRESCRIPTION (<u>prescription_id, medicament</u>,  #medecin, patient, date_visite, duree, posologie, modalites)
où le triplet d'attributs *(medecin, patient, date_visite)* référence *VISITE(medecin, patient, date_visite)*

Notez que :

  - L'attribut *rattachement* de la relation *PATIENT* est renseigné quand une personne (appelée *ayant-droit*) bénéficie de l'assurance maladie, non pas en son nom propre, mais par sa relation avec une autre personne (appelée *assuré*) qui en bénéficie. Par exemple, les enfants sont rattachés à l'un de leurs parents, ce qui leur donne droit à l'assurance maladie

  - L'attribut *medecin_referent* de la relation *PATIENT* désigne le médecin qu'un patient a choisi pour suivre son dossier médical

  - Les attributs *duree* et *posologie* seront traités de manière très simple dans cet exemple : la durée désigne un nombre de jours de traitement et la posologie le nombre de prises par jour

<!--
  {% include tip.html content="Si vous désirez travailler sur votre propre base de données, vous pouvez télécharger le <a href='resources/data/install_medical_db_postgresql.sql'>script PostgreSQL</a> pour créer les tables nécessaires à cette activité." span="markdown" %} -->

  - **Question 1** : Commencez par représenter graphiquement le schéma logique décrit précédemment.

## Accès à la BD

L'[environnement de développement dockerisé](documentation_rdbms.html) (téléchargeable [ici](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment)) fourni dispose d'un serveur PostgreSQL et d'un service PgAdmin4. Une fois les *containers* démarrés, vous devriez trouver un accès au service PgAdmin4. Plusieurs bases de données sont déjà installées et vous allez dans cette activité, utiliser la base *soins_db*.

![Accès à la base *soins_db*](images/data/soins_db.png)

## Pattern matching et tris

{% include important.html content="<br/>
Avant de commencer, prenez le temps d'observer les enregistrements des différentes tables. Par exemple, la requête suivante :<br/>
`SELECT distinct medicament FROM prescription;`<br/>
vous permettra de comprendre comment les médicaments sont orthographiés afin d'effectuer la requête adéquate." type="info" %}

*Questions*

  - **Question 2** : Affichez les prescriptions qui contiennent du "doliprane"
  - **Question 3** : Affichez toutes les prescriptions de "ventoline" ordonnées par durée de traitement décroissante
  - **Question 4** : Affichez les prescriptions de "ventoline" ayant une durée supérieure à 90 jours

## Jointures

 {% include important.html content="<br/>
Lorsque vous réalisez des requêtes avec des jointures, utilisez le plus petit nombre possible de tables nécessaires. On parle généralement de critère de minimalité.<br/>
Parfois il est nécessaire d'utiliser plusieurs fois la même table. On dit alors que cette table a des rôles différents. Utiliser la notion d'alias afin de renommer les tables." type="info" %}

 *Questions*

  - **Question 5** : Affichez les noms des patients et les identifiants des médecins qu'ils ont visités le 15 janvier 2021
  - **Question 6** : Affichez pour chaque ayant-droit, les numéros de sécurité sociale, nom et prénom de l'assuré auquel il est rattaché
  - **Question 7** : Affichez les noms des patients et de leur médecin référent
  - **Question 8** : Affichez les personnes qui ont un ayant-droit <i class="fa fa-question-circle text-danger" data-toggle="tooltip" data-original-title="{{site.data.corrections_bd_tp_SQL_1.q8}}"></i>

## Négation et listes

 {% include important.html content="<br/>
Attention à ne pas confondre les situations suivantes :<br/>
  - Un attribut peut être différent d'une valeur : `attribut NOT LIKE chaine` ou `attribut != valeur`<br/>
  - Un attribut peut ne pas avoir de valeur : `attribut IS NULL`<br/>
  - Un attribut peut ne pas être présent dans une liste (donné par un `SELECT` imbriqué par exemple) : `attribut NOT IN (…)`" type="info" %}

 *Questions*

  - **Question 9** : Affichez les médecins qui ne sont pas généralistes
  - **Question 10** : Affichez les patients qui n'ont pas de médecin référent

## Comptages et aggrégations

 {% include important.html content="<br/>
Avant de débuter, exécutez et comparez le résultat rendu par les ensembles de requêtes suivants :<br/>
  - `SELECT COUNT(*) FROM PATIENT;`<br/>
  - `SELECT COUNT(patient_id) FROM PATIENT;`<br/>
  - `SELECT COUNT(rattachement) FROM PATIENT;`<br/>
  - `SELECT count(DISTINCT rattachement) FROM PATIENT;`" type="info" %}

 *Questions*

  - **Question 11** : Affichez le nombre total de médecins
  - **Question 12** : Affichez le nombre de médecins par spécialité

{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé ce TP, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_sql_correction.html)." markdown="span" type="danger"%}
