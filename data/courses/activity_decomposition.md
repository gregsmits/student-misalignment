---
title: Activity - Décomposition d'une relation
keywords: décomposition, normalisation
sidebar: data_sidebar
summary: Cette activité a pour objectif de voir comment obtenir, à partir d'une relation de faible qualité en termes de formes normales (i.e., présentant de la redondance), plusieurs relations qui présentent moins de redondance, mais conservent la richesse de l'information initiale (préservation des données) et les contraintes entre ces données (préservation des dépendances fonctionnelles).
toc: true
permalink: activity_decomposition.html
folder: Database
---


## Couverture minimale

{% include callout.html content="**Définition** - Couverture minimale<br/>
La couverture minimale d'un ensemble de dépendances fonctionnelles est un sous-ensemble minimum de dépendances fonctionnelles élémentaires permettant de générer toutes les autres au moyen des propriétés d'Armstrong présentées ci-dessous." markdown="span" type="primary" %}

## Règles d'inférence d'Armstrong sur les dépendances fonctionnelles

Soit un ensemble $$F$$ de dépendances fonctionnelles entre les attributs d'un schéma de relation $$R(X,Y,Z)$$. Nous pouvons définir les propriétés suivantes :

- transitivité : si $$X \rightarrow Y$$, et $$Y \rightarrow Z$$, alors $$X \rightarrow Z$$,
- augmentation : si $$X \rightarrow Y$$, alors $$XZ \rightarrow Y$$ pour tout groupe $$Z$$ d'attributs appartenant au schéma de relation,
- réflexivité : si $$ Y \subset X$$, alors $$X \rightarrow Y$$.

À partir de ces trois axiomes de base, on peut déduire d'autres règles :

- union : si $$X \rightarrow Y$$ et $$Y \rightarrow Z$$, alors $$X \rightarrow YZ$$,
- pseudo-transitivité : si $$X \rightarrow Y$$ et $$WY \rightarrow Z$$, alors $$WX \rightarrow Z$$,
- décomposition : si $$X \rightarrow Y$$ et $$Z \subset Y$$, alors $$X \rightarrow Z$$.

## Algorithme de décomposition d'une relation

{% include callout.html content="**Algorithme** - Décomposition d'une relation<br/>
Soit une relation $$R$$ de clé $$K$$ et son ensemble de dépendances fonctionnelles $$F$$ :<br/>
1. Chercher une [couverture minimale](#couverture-minimale) $$G$$ pour $$F$$.<br/>
2. Réaliser une partition $${F_1, ..., F_n}$$ de l'ensemble des dépendances fonctionnelles tel que dans chaque $$F_i$$ les dépendances aient la même partie gauche.<br/>
3. Créer pour chaque $$F_i$$ une relation $$R_i$$ avec l'ensemble des attributs de $$F_i$$.<br/>
4. Si aucune des relations produites ne contient une clé de $$R$$, ajouter dans la décomposition finale une relation composée des attributs formant la clef de $$R$$." markdown="span" type="primary" %}


Cet algorithme permet une décomposition d'une relation unique en plusieurs relations en troisième forme normale. Jusqu'en troisième forme normale la décomposition se fait sans perte de données et sans perte de dépendances fonctionnelles.


Dans le cours sur la décomposition, cet algorithme a été découpé en plusieurs étapes par application successive des étapes de normalisation (première, deuxième et troisième forme normale).

## Applications

### Premier exemple

Considérons la relation **FOURNISSEUR (<u>n°fournisseur</u>, ville, frais)** sachant qu'un fournisseur ne livre que dans une seule ville et que les frais dépendent uniquement de la ville desservie.

La relation FOURNISSEUR **n'est pas en 3NF** mais en 2NF car une dépendance fonctionnelle entre des attributs qui ne sont pas des clés existe : *ville* $$\rightarrow$$ *frais*.

**Liste de toutes les dépendances fonctionnelles**

- n°fournisseur $$\rightarrow$$ ville
- ville $$\rightarrow$$ frais
- n°fournisseur $$\rightarrow$$ frais (*dépendance transitive*)
- n°fournisseur, ville $$\rightarrow$$ frais (*dépendance non élémentaire*)
- n°fournisseur, frais $$\rightarrow$$ ville (*dépendance non élémentaire*)


**Couverture minimale** (*sous-ensemble mimimum des dépendances fonctionnelles élémentaires non transitives qui permettent de générer toutes les autres*)

- n°fournisseur $$\rightarrow$$ ville
- ville $$\rightarrow$$ frais

**Partition**
Les parties gauches sont déjà groupées !

**Relations crées**

- R1 (<u>n°fournisseur</u>, ville)
- R2 (<u>ville</u>, frais)


**Ajout d'une relation contenant la clé de $$R$$ ?**
La clé de la relation d'origine (<u>n°fournisseur</u>) existe déjà dans la relation *R1*, il n'est donc pas nécessaire de créer une relation supplémentaire.

### Deuxième exemple

Considérons la relation **VEHICULE_FONCTION (<u>n°agent, n°véhicule</u>, nom, prénom, marque_véhicule, puissance_véhicule, couleur_véhicule)** qui permet de gérer pour chaque agent le ou les véhicules qu'il est autorisé à utiliser (éventuellement en partage avec d'autres agents) dans le cadre de ses déplacements professionnels.

La relation VEHICULE_FONCTION **n'est pas en 3NF ni même en 2NF** car des attributs sont en dépendance fonctionnelle avec une parte de la clé uniquement : c'est le cas du *nom* d'un agent qui ne dépend que du *n° de l'agent*.

**Couverture minimale**

- n°agent $$\rightarrow$$ nom
- n°agent $$\rightarrow$$ prénom
- n°véhicule $$\rightarrow$$ marque_véhicule
- n°véhicule $$\rightarrow$$ puissance_véhicule
- n°véhicule $$\rightarrow$$ couleur_véhicule

**Partition**

- n°agent $$\rightarrow$$ nom, prenom
- n°véhicule $$\rightarrow$$ marque_véhicule, puissance_véhicule, couleur_véhicule

**Relations crées**

- R1 (<u>n°agent</u>, nom, prenom)
- R2 (<u>n°véhicule</u>, marque_véhicule, puissance_véhicule, couleur_véhicule)

**Ajout d'une relation contenant la clé de $$R$$ ?**

La clé de la relation d'origine (<u>n°agent, n°véhicule</u>) n'existe dans aucune des relations déduites, il est donc nécessaire de créer une relation supplémentaire qui ne contiendra que les attributs formant cette clé :

- R3 (<u>n°agent, n°véhicule</u>)
Les trois relations pourraient être renommées en *AGENT* (R1), *VEHICULE* (R2) et *AFFECTATION_VEHICULE* (R3).

### À vous de jouer !

Un centre de réparation aéronautique désire réorganiser la gestion des données liées à ses opérations de maintenance. Actuellement la base de données utilisée possède une seule table et la gestion des données devient problématique. Votre mission est de normaliser la base de données existante pour éviter les problèmes d’incohérence des données et de redondance qui ont été constatés. Voici la relation existante :

OPERATION_MAINTENANCE (<u>n°operation, n°intervention, n°technicien</u>, nom_technicien, specialite_technicien, n°avion, compagnie_avion, date_mise_en_service_avion, code_imputation, cout_intervention, date_operation)

- Une opération de maintenance concerne un avion à une date donnée avec un ou plusieurs techniciens ayant effectués une ou plusieurs interventions.
- Une même intervention peut nécessiter plusieurs techniciens.
- Un avion est défini par un numéro, une compagnie aérienne et une date de mise en service.
- Un technicien est défini par un nom et une spécialité.
- Une intervention est associée à un coût et à un code d’imputation.

**Questions**

- **Question 1** : Déterminez l’ensemble des dépendances fonctionnelles de la relation `OPERATION_MAINTENANCE` à partir des informations données.
- **Question 2** : Appliquer l’algorithme de décomposition sur la relation `OPERATION_MAINTENANCE` en présentant chacune de ses étapes.


<!-- #### Appliquez l'algorithme de décomposition aux deux relations ci-dessous :

1.  FOURNISSEUR (<u>n°fournisseur</u>, ville, frais) sachant qu'un fournisseur ne livre que dans une seule ville et que les frais dépendent uniquement de la ville desservie.

2.  VEHICULE_FONCTION (<u>n°agent, n°véhicule</u>, nom, prénom, marque_véhicule, puissance_véhicule, couleur_véhicule) qui permet de gérer pour chaque agent le ou les véhicules qu'il est autorisé à utiliser (éventuellement en partage avec d'autres agents) dans le cadre de ses déplacements professionnels. -->



{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_decomposition_correction.html)." markdown="span" type="danger"%} 
