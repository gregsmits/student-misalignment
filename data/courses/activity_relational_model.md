---
title: Activité sur le modèle relationnel et l'intégrité de données
keywords: modèle relationnel, UML
sidebar: data_sidebar
summary: Cette activité a pour objectif de vous faire découvrir les principales notions liées au modéle relationnel et aux contraintes d'intégrité des données
permalink: activity_relational_model.html
folder: Database
---

{% include callout.html content="**Pré-requis**<br/><br/>
- [Intégrité des données](lecture_db_integrity.html)<br/>
- [Le modèle relationnel](lecture_relational_model.html)" markdown="span" type="danger"%}


## Contexte

Considérons une entreprise dans laquelle on désire stocker des données concernant les employés et les départements dans lesquels travaillent ces employés. Nous allons tout au long de ce cas d'étude examiner différentes façons de représenter ces données au moyen de tableaux que nous allons manipuler avec votre tableur favori. Ces exercices doivent vous permettre d'appréhender la modélisation de données persistantes et de comprendre les difficultés liées à une représentation tabulaire des données, telles qu'elles le sont dans les bases de données.

A l'intérieur de l'entreprise, quelques règles de gestion sont mises en œuvre. Vous devrez veiller à les respecter lors de cette étude :

-   Un employé peut appartenir à plusieurs départements
-   Un employé n'a qu'un seul poste dans un même département
-   Un employé n'a qu'un seul manager même s'il occupe plusieurs postes
-   Deux départements, situés dans la même ville, ne peuvent pas avoir le même nom

Les données stockées sont les suivantes :

-   EMPNO : numéro de l'employé
-   ENAME : nom
-   JOB : poste
-   MANAGER : numéro du manager
-   SALARY : salaire en €
-   HIREDATE : date d'embauche
-   COMMISSION : commission en €
-   DEPTNO : numéro du département
-   DNAME : nom du département
-   LOC : localisation du département

{% include note.html content="Téléchargez les fichiers Excel suivants : [`cas1.xlsx`](resources/data/cas1.xlsx) et [`cas2a.xlsx`](resources/data/cas2a.xlsx) et [`cas3.xlsx`](resources/data/cas3.xlsx)." %}

## La notion de clef primaire et candidate

### Cas n°1 : une relation unique

Le fichier `cas1.xlsx` présente de manière partielle une seule feuille de calcul avec la relation suivante :

TABLEAU_1(EMPNO, ENAME, JOB, SAL, MANAGER, HIREDATE, COMMISSION, DEPTNO, DNAME, LOC)

- **Question 1** : Cherchez le lieu de travail de l'employé `DOE`. Dans le pire des cas, combien de lignes devez-vous parcourir ? Peut-il y avoir plusieurs lignes avec la même valeur de l'attribut `ENAME` ? <i class="fa fa-question-circle text-success" data-toggle="tooltip" data-original-title="{{site.data.corrections_bd_td_modele_relationnel_1.q1tip}}"></i>

- **Question 2** : Faites les mises à jour nécessaires pour renommer en `REAL ESTATE` le département dans lequel travaille l'employé `TURNER`. Dans le pire des cas, combien de lignes devez-vous parcourir en lecture ? Combien de lignes avez-vous dû modifier ? À quoi ce dernier nombre correspond-il ? <i class="fa fa-question-circle text-success" data-toggle="tooltip" data-original-title="{{site.data.corrections_bd_td_modele_relationnel_1.q2tip}}"></i>

{% include callout.html content="**Définition** - Clef candidate<br/>
Une clef **candidate** est un attribut ou un ensemble d'attributs minimal identifiant de manière unique chaque tuple d'une relation." markdown="span" type="primary" %}

{% include callout.html content="**Définition** - Clef primaire<br/>
La clef candidate choisie comme identifiant de la relation est appelée **clef primaire**. Une clef primaire est unique et doit être renseignée (elle ne peut pas prendre la valeur `NULL`)." markdown="span" type="primary" %}

Par convention, on souligne (d'un <u>trait plein</u>) la clé primaire d'une relation.

- **Question 3** : Identifiez la ou les clefs candidates de la relation et choisissez une clef primaire.

{% include callout.html content="**Définition** - Donnée redondante<br/>
Une donnée est considérée **redondante** si elle se répète sans apporter d'information supplémentaire." markdown="span" type="primary" %}

- **Question 4** : Considérer les 2 lignes concernant l'employé `SCOTT`. Choisissez la (les) proposition(s) ci-dessous qui vous semble(nt) exacte(s) en justifiant votre choix :
  - Les valeurs de `EMPNO` sont redondantes
  - Les valeurs de `MGR` sont redondantes
  - Les valeurs de `JOB` sont redondantes

## La notion de clef étrangère

{% include callout.html content="**Définition** - Clef étrangère ou clef référentielle<br/>
Dire que l'ensemble $$K_1$$ des attributs de $$R_1$$ est **clef étrangère** et qu'elle référence l'ensemble d'attributs $$K_2$$ de $$R_2$$ impose que 1) les attributs $$K_1$$ ont les mêmes domaines que les attributs $$K_2$$, que 2) $$K_2$$ est associé à une contrainte d'unicité (clef primaire e.g.) et que 3) les valeurs prises sur $$K_1$$ pour chaque tuple correspondes à des valeurs existantes dans $$R_2$$ sur les attributs $$K_2$$." markdown="span" type="primary" %}

Par convention, on fait précéder la clef référentielle d'une relation par un dièse (\#) et on explicite par du texte quel ensemble d'attributs est référencé par la clef étrangère.

{% include callout.html content="**Exemple**<br/>
Client (<u>Numéro</u>, Nom, Adresse, Téléphone)<br/>
Produit (<u>Numéro</u>, Désignation,Prix)<br/>
Vente (<u>Numéro</u>, \#NuméroClient, \#NuméroProduit, Date) où NuméroClient référence Client(Numéro) et NuméroProduit référence Produit(Numéro)<br/>" markdown="span" type="success" %}

### Cas n°2A : première proposition de décomposition en deux relations

Le fichier `cas2a.xlsx` présente deux feuilles de calcul avec les tableaux suivants :

TABLEAU_1(<u>EMPNO</u>, ENAME, JOB, SAL, MANAGER, HIREDATE, COMMISSION, \#DNAME)

TABLEAU_2(<u>DEPTNO</u>, DNAME, LOC)

- **Question 5** : Dans quelle mesure cette nouvelle structure de données peut-elle réduire les redondances rencontrées lors de l'étude du cas n°1 ?

- **Question 6** : Identifier l'attribut utilisé pour faire le lien entre les deux tableaux. Ce choix vous parait-il judicieux ?

- **Question 7** : Pouvez-vous renommer en `REAL ESTATE` le département dans lequel travaille l'employé TURNER ? Pourquoi ?

### CAS n°2B : votre proposition de décomposition en deux relations


- **Question 8** : Proposez une décomposition en 2 relations corrigeant les relations du cas n°2A afin de résoudre le problème que vous avez identifié. Faites valider votre proposition par un enseignant.

- **Question 9** : Cherchez le lieu de travail de l'employé `DOE`. Dans le pire des cas, combien de lignes devez-vous parcourir ? Peut-il y avoir plusieurs lignes avec le même `ENAME` ?

- **Question 10** : Faites les mises à jour nécessaires pour renommer en `REAL ESTATE` le département dans lequel travaille l'employé `TURNER`. Dans le pire des cas, combien de lignes devez-vous parcourir en lecture ? Combien de lignes avez-vous dû modifier ? A quoi ce dernier nombre correspond-t-il ?

- **Question 11** : Quelles données peut-on encore considérer comme redondantes ?

## Une décomposition sans redondance

### Cas n°3 : décomposition en trois relations

Le fichier `cas3.xlsx` présente trois feuilles de calcul avec les tableaux suivants :

TABLEAU_1(EMPNO, ENAME, SAL, MANAGER, HIREDATE, COMMISSION)

TABLEAU_2(DEPTNO, DNAME, LOC)

TABLEAU_3(EMPNO, DEPTNO, JOB)

- **Question 12** : Identifiez, pour chacune des trois relations, les clefs primaires et référentielles si elles existent.

- **Question 13** : Remplissez les feuilles de calculs en vous aidant des données du cas n°1.

- **Question 14** : Dans quelle mesure cette nouvelle structure de données peut-elle réduire les redondances rencontrées lors de l'étude du cas n°2B ?

- **Question 15** : Cherchez le lieu de travail de l'employé `DOE`. Dans le pire des cas, combien de lignes devez-vous parcourir ? Peut-il y avoir plusieurs lignes avec le même `ENAME` ?

- **Question 16** : Faites les mises à jour nécessaires pour renommer en `REAL ESTATE` le département dans lequel travaille l'employé `TURNER`. Dans le pire des cas, combien de lignes devez-vous parcourir en lecture ? Combien de lignes avez-vous dû modifier ? A quoi ce dernier nombre correspond-t-il ?
- **Question 17** : Quelles données peut-on considérer comme redondantes ?

##  Bilan

Remplissez la fiche de synthèse ci-dessous en considérant les critères suivants :

1.  **Consultation** des données : la difficulté à effectuer la requête se compte en nombre de lignes « lues » afin d'obtenir la réponse à la question posée.

2.  **Mise à jour** des données : la difficulté à effectuer la mise à jour se compte en nombre de lignes concernées afin d'effectuer la modification.

Utilisez la légende suivante pour remplir votre tableau :

<table width="60%">
    <thead>
        <th width="30%">Légende</th><th width="30%">Symbole à utiliser</th>
    </thead>
    <tr>
      <td>Situation de référence</td>
      <td>$$\circ$$</td>
    </tr>
    <tr>
      <td>Consultation ou mise à jour plus compliquée</td>
      <td align="center">- et - - </td>
    </tr>
    <tr>
      <td>Consultation ou mise à jour plus simple</td>
      <td align="center">+ et ++  </td>
    </tr>
</table>

- **Question 18** : Remplissez chaque case en comparant le changement par rapport au cas n°1 :

<table width="100%">
    <thead>
        <tr><th width="20%"></th><th width="40%">Consultation des données</th><th width="40%">Mise à jour des données</th></tr>
    </thead>
    <tr>
      <td>Cas n°1</td>
      <td>$$\circ$$</td>
      <td>$$\circ$$</td>
    </tr>
    <tr>
      <td>Cas n°2B</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>Justifiez :</td>
      <td colspan="2"></td>
    </tr>
    <tr>
      <td>Cas n°3</td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>Justifiez :</td>
      <td colspan="2"></td>
    </tr>
</table>

- **Question 19** : Quelle structure de données présentée dans les différents cas jugez-vous la plus pertinente ? Justifiez votre réponse.


{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_relational_model_correction.html)." markdown="span" type="danger"%} 
