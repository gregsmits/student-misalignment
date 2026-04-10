---
title: "Pratiquer avec le langage SQL en version avancée"
keywords: langage SQL
sidebar: data_sidebar
summary: Cette activité a pour objectif de vous permettre de vous perfectionner avec quelques requêtes SQL plus difficiles.
toc: true
permalink: practice_advanced_sql.html
folder: Database
---

# Rappel sur le contexte de l'activité

## Description de la base de données SOINS

Les requêtes SQL à exprimer sont relatives à la base de données SOINS constituée des relations dont le schéma est décrit de manière linéaire ci-dessous (les clefs primaires des relations sont <u>soulignées</u>, et les attributs qui référencent une autre relation sont prédécés d'un dièse (\#)).

MEDECIN (<u>medecin_id</u>, nom, prenom, adresse, tel, specialite)<br/>
PATIENT (<u>patient_id</u>, nom, prenom, numsecu, \# rattachement,  \#medecin_referent) où *rattachement* référence *PATIENT(patient_id)* et *medecin_referent* référence *MEDECIN(medecin_id)*<br/>
VISITE (<u> #medecin,  #patient, date_visite</u>, prix) où *medecin* référence *MEDECIN(medecin_id)* et *patient* référence *PATIENT(patient_id)*<br/>
PRESCRIPTION (<u>prescription_id, medicament</u>,  #medecin, patient, date_visite, duree, posologie, modalites)
où le triplet d'attributs *(medecin, patient, date_visite)* référence *VISITE(medecin, patient, date_visite)*

Notez que :

  - L'attribut *rattachement* de la relation *PATIENT* est renseigné quand une personne (appelée *ayant-droit*) bénéficie de l'assurance maladie, non pas en son nom propre, mais par sa relation avec une autre personne (appelée *assuré*) qui en bénéficie. Par exemple, les enfants sont rattachés à l'un de leurs parents, ce qui leur donne droit à l'assurance maladie.

  - L'attribut *medecin_referent* de la relation *PATIENT* désigne le médecin qu'un patient a choisi pour suivre son dossier médical.

  - Les attributs *duree* et *posologie* seront traités de manière très simple dans cet exemple : la durée désigne un nombre de jours de traitement et la posologie le nombre de prises par jour.
<!-- 
  {% include tip.html content="Si vous désirez travailler sur votre propre base de données, vous pouvez télécharger le <a href='resources/data/install_medical_db_postgresql.sql'>script PostgreSQL</a> pour créer les tables nécessaires à cette activité." span="markdown" %} -->


## Accès à la BD

L'[environnement de devéloppement dockerisé](documentation_rdbms.html) (téléchargeable [ici](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment)) fourni dispose d'un serveur PostgreSQL et d'un service PgAdmin4. Une fois les containers démarrés, vous devriez trouver un accès au service PgAdmin4. Plusieurs bases de données sont déjà installées et vous allezn dans cette activité, utiliser la base *soins_db*.

![Accès à la base *soins_db*](images/data/soins_db.png)


## Quelques requêtes simples

 {% include important.html content="<br/>

-   Ne commencez pas cette activité si vous n'avez pas intégralement fini et compris l'activité introductive sur les bases de SQL.<br/>
-   Utilisez le schéma logique **graphique** que vous avez réalisé lors de l'activité introductrice.<br/>
-   Réutilisez le code écrit lors de l'activité introductive pour répondre à certaines des requêtes suivantes.<br/>
-   Certaines requêtes nécessitent des jointures externes utilisant la syntaxe : `RIGHT JOIN`, `LEFT JOIN` et/ou `FULL OUTER JOIN`. Recherchez de l'information sur ces mots-clés.

" type="info" %}

 *Questions*

  - **Question 1** : Affichez les personnes qui ont plus de trois ayants-droit.
  - **Question 2** : Affichez les personnes qui ont exactement un ayant-droit.
  - **Question 3** : Affichez les prescriptions de "ventoline" ayant une durée supérieure à 90 jours ou une posologie supérieure à 6 prises/jour.
  - **Question 4** : Affichez les noms des patients et de leur médecin référent (en affichant également les patients sans médecin référent). 
  - **Question 5** : Affichez les noms des patients qui ont visité leur médecin référent le 02 janvier 2021.
  - **Question 6** : Affichez les patients qui n'ont jamais vu de médecin.
  - **Question 7** : Affichez les prescriptions qui ne contiennent pas de "doliprane".
  - **Question 8** : Affichez les visites où a été prescrit "doliprane" **ou** "aspegic" (ou logique).
  - **Question 9** : Affichez les visites où ont été prescrits "doliprane" **et** "aspégic".
  - **Question 10** : Affichez les patients qui n'ont jamais vu leur médecin référent.

## Quelques requêtes plus compliquées

 {% include important.html content="<br/>
On passe à un niveau de difficulté supérieur, ne faites pas les requêtes suivantes avant d'avoir fini et compris les précédentes..." type="info" %}

 *Questions*

  - **Question 11** : Affichez, par ordre alphabétique, les noms des patients qui sont ressortis d'une visite sans prescription.
  - **Question 12** : Affichez les patients qui ont vu un autre médecin que leur médecin référent plus de 3 fois en janvier 2021.
  - **Question 13** : Affichez, pour chaque patient, les spécialités visitées.
  - **Question 14** : Affichez les patients qui n'ont pas visité une des spécialités. 
  - **Question 15** : Affichez les patients qui ont vu des médecins de toutes les spécialités. 
  Faites en sorte que cette requête retourne au moins un tuple."></i>


## Quelques indications sur les différents types de jointure

[![Les différentes jointures en SQL](images/data/thumbnail_jointures.png)](images/data/jointures.pdf){:target="_blank"}

{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé ce TP, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_advanced_sql_correction.html)." markdown="span" type="danger"%} 
