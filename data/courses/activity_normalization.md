---
title: Activité - Dépendances fonctionnelles et formes normales
keywords: dépendances fonctionnelles, formes normales, 1NF, 2NF, 3NF
sidebar: data_sidebar
summary: Cette activité vous permettra de découvrir progressivement quelques notions de la théorie de la normalisation qui vont vous donner les outils formels pour minimiser les redondances. 
toc: true
permalink: activity_normalization.html
folder: Database
---


## Contexte

Considérons la relation EMP-DEPT illustrée par un extrait dans le tableau ci-dessous et qui a pour schéma :

EMP-DEPT (empno, ename, job, mgr, hiredate, sal, comm, deptno, dname, loc)

L'expert en données ajoute à cet exemple les informations suivantes :

-   Un employé est identifié par un numéro. Il est décrit par un nom, une date d'embauche, un salaire et une commission.
-   Un département est identifié par un numéro. Il est décrit par un nom et une localisation.
-   Un employé a un et un seul manager.
-   Un employé peut avoir plusieurs jobs, mais un seul par département.

#### Relation universelle *EMP-DEPT*

  |EMPNO  | ENAME   | JOB        | MGR   | HIREDATE    | SAL   | COMM  | DEPTNO  | DNAME       | LOC    |
  |-------| --------| -----------| ------| ------------| ------| ------| --------| ------------| -------|
  |7698   | BLAKE   | MANAGER    | 7839  | 05/01/2081  | 2850  | NULL  | 40      | SALES       | BOSTON|
  |7499   | ALLEN   | SALESMAN   | 7698  | 02/20/2081  | 1600  | 300   | 30      | SALES       | CHICAGO|
  |7521   | WARD    | SALESMAN   | 7698  | 02/22/2081  | 1250  | 500   | 30      | SALES       | CHICAGO|
  |7904   | DOE     | CLERK      | 7566  | 12/11/2099  | 2500  | 300   | 20      | RESEARCH    | DALLAS|
  |7369   | SMITH   | CLERK      | 7902  | 12/17/2080  | 800   | NULL  | 20      | RESEARCH    | DALLAS|
  |7788   | SCOTT   | ANALYST    | 7566  | 12/09/2081  | 3000  | NULL  | 20      | RESEARCH    | DALLAS|
  |7566   | JONES   | MANAGER    | 7839  | 04/02/2081  | 2975  | NULL  | 20      | RESEARCH    | DALLAS|
  |7902   | FORD    | ANALYST    | 7566  | 12/03/2081  | 3000  | NULL  | 20      | RESEARCH    | DALLAS|
  |7839   | KING    | PRESIDENT  | NULL  | 11/17/2081  | 5000  | NULL  | 10      | ACCOUNTING  | DENVER|
  |7934   | MILLER  | CLERK      | 7566  | 01/23/2082  | 1300  | NULL  | 10      | ACCOUNTING  | DENVER|
  |7904   | DOE     | SALESMAN   | 7566  | 12/11/2099  | 2500  | 300   | 30      | SALES       | CHICAGO|
  |7788   | SCOTT   | ANALYST    | 7566  | 12/09/2081  | 3000  | NULL  | 10      | ACCOUNTING  | DENVER|

## Dépendances fonctionnelles


- **Question 1** : Soit la relation EMP-DEPT définie précédemment. Les dépendances fonctionnelles suivantes sont-elles vérifiées : EMPNO $$ \rightarrow $$ ENAME, ENAME $$ \rightarrow $$ EMPNO ?
- **Question 2** : Peut-on dire qu'une dépendance fonctionnelle est symétrique ?
- **Question 3** :  Toujours dans le contexte de la relation EMP-DEPT, déterminez pour chacune des propositions suivantes s'il s'agit d'une dépendance fonctionnelle. Si oui, déterminez si celle-ci est élémentaire ou non.
  1. JOB $$ \rightarrow $$ ENAME
  2. ENAME $$ \rightarrow $$ JOB
  3. DEPTNO $$ \rightarrow $$ MGR
  4. DEPTNO $$ \rightarrow $$ DNAME
  5. EMPNO, DNAME $$ \rightarrow $$ JOB
  6. EMPNO, DNAME $$ \rightarrow $$ MGR
  7. EMPNO, DEPTNO $$ \rightarrow $$ JOB
  8. EMPNO, DEPTNO $$ \rightarrow $$ LOC

- **Question 4** :  Déduisez la clef primaire de la relation EMP-DEPT à partir des informations données en début d'exercice.

## Formes normales


- **Question 5** : Pour chacune des relations suivantes, indiquez si la relation est 1NF en identifiant en quoi chaque structure serait complexe à explorer.
  1. LIVRAISON(<u>n°fournisseur</u>, listeVilles)
  2. LIVRAISON (<u>n°fournisseur</u>, ville)
  3. CLIENT (<u>n°client</u>, nom, prénoms)
  4. CLIENT (<u>n°client</u>, nom, prénom1, prénom2)
  5. CLIENT (<u>n°client</u>, nom, prénom, adresse)

- **Question 6** : Pour chacune des relations suivantes, et d'après vos connaissances sur les données concernées, proposez des dépendances fonctionnelles et indiquez si la relation est 2NF :
  1. PRET (<u>n°isbn, n°adherent, date</u>, nom_adherent, ville_adherent, titre_livre)
  2. PRET (<u>n°isbn, date</u>, n°adherent, nom_adherent, ville_adherent, titre_livre)
  3. PRET (<u>n°isbn, n°adherent, date</u>)
  4. PRET (<u>n°exemplaire, date</u>, n°adherent)

- **Question 7** :  Pour chacune des relations suivantes et d'après vos connaissances sur les données concernées, identifiez les dépendances fonctionnelles et indiquez si la relation est en troisième forme normale ou non; concluez en spécifiant le risque de redondance.
  1. FOURNISSEUR (<u>n°fournisseur</u>, ville, pays) dans le contexte où un fournisseur n'est établi que dans une seule ville (considérez le cas où chaque nom de ville est unique et le cas où des villes de même nom peuvent se retrouver dans différents pays).
  2. PERSONNEL (<u>n°agent</u>, nom, département_recherche, bâtiment)
  3. PERSONNEL (<u>n°agent</u>, nom, département_recherche, statut_agent)
  4. VOL(<u>n°vol</u>, compagnie, heure, destination, modele_avion, nombre_passagers)
  5. VOL(<u>n°vol</u>, compagnie, heure, destination, modele_avion, nombre_places)

- **Question 8** :  Selon vous, quel est l'intérêt d'avoir une relation exprimée en troisième forme normale ?




{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_normalization_correction.html)." markdown="span" type="danger"%} 
