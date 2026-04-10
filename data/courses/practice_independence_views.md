---
title: Activité pratique - Indépendance des données - Mécanisme des vues externes
keywords: indépendance des données, vues
sidebar: data_sidebar
summary:  L'objectif de cette activité est de présenter le mécanisme des vues existant dans tous SGBDR et les limites de son utilisation.
permalink: practice_independence_views.html
toc: true
folder: Database
---

## Objectif du TP


L'objectif de ce TP est d'appréhender concrètement l'indépendance de données. Ce principe fondateur des SGBD vise a décorréler la manière dont, au sein d'une base de données, les données sont conçues, visualisées et stockées. Ce principe s'exprime via l'*architecture ANSI/X3/SPARC* (voir Figure 1) qui sépare les niveaux **logique** (conception), **externe** (visualisation) et **physique** (stockage).

{% include image.html file="bd/Architecture_ANSI-X2-SPARC.png" alt="Vue simplifiée de l'architecture ANSI/X3/SPARC" caption="Figure 1 - Vue simplifiée de l'architecture ANSI/X3/SPARC" %}

- Au **niveau logique**, on a le schéma relationnel tel qu'on le manipule couramment. Par exemple, on sait qu'une relation `personnes` est constituée des attributs `id`, `nom`, `prenom`. Cette information est suffisante pour interroger la relation à l'aide de SQL.
- Au **niveau physique**, on s'intéresse au stockage et aux méthodes d'accès définies sur les relations. Par exemple, si au niveau logique, on recherche souvent une personne par son nom, il peut être intéressant d'ajouter au niveau physique un index sur le nom des personnes, qui permettra d'améliorer le temps de réponse de ces requêtes.
- Au **niveau externe**, on s'intéresse à l'adaptation aux utilisateurs. Le regroupement des données de différentes sources au sein d'un SGBD unique permet de réduire les incohérences, mais produit souvent des schémas de données complexes difficiles à appréhender pour les utilisateurs finaux. Il est donc intéressant de pouvoir occulter une partie de cette complexité dans la manière dont on restitue les données auprès des utilisateurs.

L'indépendance des données permet de faire évoluer chacun des niveaux en touchant minimalement, voire pas du tout, aux autres : par exemple, l'ajout ou la suppression d'un index au niveau physique est indépendant de l'ajout ou la suppression d'un attribut au niveau logique.

Dans ce TP, nous allons nous focaliser sur les niveaux logique / externe de l'architecture, et voir les limites pratiques de ce principe.

La section suivante vous permet de mettre en place l'environnement pour réaliser l'activité. Ensuite, les trois sections suivantes sont dédiées respectivement :

- au comportement des vues dans le cadre de la modification de données
- au comportement des vues dans le cadre de la modification du schéma de données
- aux interactions entre modélisation logique et vues externes du point de vue de l'intégrité des données

## Mise en place du TP

Les données pour effectuer le TP seront stockées sous la forme de deux relations :

- `dept (deptno, dname, loc)`
- `emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)`<br/> où `deptno` référence `dept(deptno)` et `mgr` référence `emp(empno)`

Les dépendances fonctionnelles sur ce schéma sont les suivantes :

- `empno --> ename, job, mgr, hiredate, sal, comm, deptno`
- `deptno -> dname, loc`

### Accès à la BD

L'[environnement de devéloppement dockerisé](documentation_rdbms.html) (téléchargeable [ici](resources/technical_environment/docker_environment.zip)) fourni dispose d'un serveur PostgreSQL et d'un service PgAdmin4. Une fois les containers démarrés, vous devriez trouver un accès au service PgAdmin4. Plusieurs bases de données sont déjà installées et vous allez, dans cette activité, utiliser la base *employees_db*.

![Accès à la base *employees_db*](images/data/employees_db.png)

Notez que :

- Dans leur version actuelle, aucune contrainte d'intégrité n'a été définie dans les tables *emp* et *dept*

**Avant de démarrer les exercices, représentez graphiquement le schéma logique décrit linéairement ci-dessus.**

### Mise à jour des données et vues

#### Question 1

Définissez dans la base, à l'aide du langage SQL, les contraintes de clés primaires et référentielles sur le schéma. Pour rappel, vous trouverez [ici](https://www.postgresql.org/docs/current/ddl-constraints.html) quelques éléments de syntaxe pour ajouter ces contraintes.

#### Question 2

En vous appuyant sur les relations `emp` et `dept`, créez la vue `all_emps` donnant l'ensemble des attributs du schéma (`emp`, `dept`) complet.

- En quoi le fait que SQL est un langage fermé vous permet-il d'interroger la vue `all_emps` en SQL ?
- En vous appuyant sur la vue `all_emps`, créez la vue qui donne, département par département (numéro et nom) le nombre d'employés (nommé `nbemps` dans la vue) et le nombre d'emplois différents (`nbjobs`).
- Essayez d'introduire un nouveau tuple dans la vue `all_emps`. Pourquoi, selon vous, est il impossible de le faire ?

#### Question 3

En vous appuyant sur la relation `emp`, créez la vue `salesmen` contenant le nom, le job et le salaire des employés qui sont `SALESMAN` (attribut `job`).

- Cherchez dans `salesmen` les employés dont le nom commence par la lettre T. Vérifiez dans la relation `emp` l'exactitude du résultat.
- Insérez dans la relation `emp` un employé qui est `SALESMAN`. Apparaît-il quand vous examinez la vue `salesmen` ? Pourquoi ?
- Insérez dans la vue `salesmen` un employé qui a votre nom. Analysez le message d'erreur.
    - Quelle modification proposez vous de faire dans la vue pour que cette requête ne renvoie pas d'erreur ?
- Faites la modification et insérez dans la vue `salesmen` un employé qui a votre nom, mais qui est `CLERK` (attribut `job`).
    - Qu'est ce qui a changé dans la vue `salesmen` ?
    - Qu'est ce qui a changé dans la relation `emp` ?
    - Pourquoi ce comportement est-il mauvais du point de vue de l'utilisateur ?
    - Cherchez sur le web comment utiliser la clause `with check option` et proposez une redéfinition de la vue qui corrige ce dysfonctionnement. Mettez la en oeuvre et testez.
- Aurait il été possible de définir la vue `salesmen` sur la vue `all_emps` ? Quelles conséquences cela aurait-il eu sur les mises à jour ?

{% include synthese.html content="<br/>
• Le mécanisme de vues repose sur la propriété de fermeture du langage SQL :  <em>vrai ? faux ?</em><br/>
• Le mécanisme de vue permet à un utilisateur de voir uniquement les données qui le concerne :  <em>vrai ? faux ?</em><br/>
• Le mécanisme de vue permet à un utilisateur de voir les données sous la forme qu'il souhaite :  <em>vrai ? faux ?</em>
" %}

### Modification de schéma et abstraction

L'entreprise modifie son organisation. A l'avenir, un employé peut être amené à partager son activité sur plusieurs départements. Il y effectuera néanmoins le même travail (`job` inchangé). Il est décidé que les différentes affectations de l'employé apparaissent dans la base de données, accompagné d'un ratio.

#### Question 4

Sur la base de ces nouvelles hypothèses, dressez la **liste des dépendances fonctionnelles** et proposez une nouvelle décomposition en *3NF* du schéma (`emp`, `dept`) précédent, préservant les données et les DF.

- Proposez une série d'étapes pour assurer la transition de l'ancien vers le nouveau schéma, sans perdre aucune donnée. Vous pourrez pour cela chercher de l'aide sur la syntaxe de création ou de modification de table (`CREATE TABLE`, `ALTER TABLE`). N'oubliez pas de mettre à jour les contraintes quand cela est nécessaire.
- Mettez à jour les données pour illustrer les capacités du nouveau schéma.

#### Question 5

Que sont devenues les vues `salesmen`, `all_emps` ?

- Redéfinissez la vue `all_emps` (`CREATE OR REPLACE VIEW...`) en prenant en compte les modifications du schéma faites dans la question précédente.

 {% include synthese.html content="<br/>
• En tant qu'administrateur d'une base de données, je peux être amené à redéfinir une vue en cas de modification du schéma logique :  <em>vrai ? faux ?</em><br/>
• En tant qu'utilisateur d'une vue de la base de données, je peux être amené à changer mes requêtes en cas de modification du schéma logique :  <em>vrai ? faux ?</em><br/>
• En cas de modification du schéma logique, une vue supportant les mises à jour conserve cette propriété :  <em>vrai ? faux ?</em><br/>
• En cas de modification du schéma logique, une vue ne supportant pas les mises à jour peut acquérir cette propriété :  <em>vrai ? faux ?</em><br/>
• En cas de modification du schéma logique, les vues concernées par cette modification, sont mises à jour automatiquement :  <em>vrai ? faux ?</em>
" %}

### Modification de schéma versus intégrité

Dans cette dernière section, on décide de limiter au maximum les redéfinitions de vues. Pour ce faire, on limite les modifications de schéma au seul ajout de champ nouveau, censées ne pas entraîner de redéfinition des vues.

On souhaite désormais conserver un historique des affectations des employés aux départements.

#### Question 6

Quelle(s) modification(s) du schéma proposez vous pour stocker cette information dans la base ?

#### Question 7

Quelles alternatives avez vous concernant la définition de la clé de la relation modifiée ?

- Choisissez en justifiant formellement votre réponse, c-à-d en utilisant les dépendances fonctionnelles.

#### Question 8

Réalisez les modifications en prenant garde aux contraintes d'intégrité et testez votre nouveau schéma.

On souhaite maintenant maintenir un historique sur la gestion des emplois (`job`) tenus dans l'entreprise, mais sans changer la structure de la base de données. Désormais, un employé qui change d'emploi sera référencé une nouvelle fois dans la relation `emp`, avec le même numéro d'employé (`empno`), son nouvel emploi (`job`) mais une date d'embauche (`hiredate`) correspondant à son changement de poste.

#### Question 9

Précisez les DFs et les clés de la nouvelle relation `emp`.

- En quelle forme normale est la relation ?

#### Question 10

Dans la pratique, que faut il changer dans le schéma de la base de données pour mettre en oeuvre cette modification ?

- Faites les modifications et testez les. Quel est l'impact sur l'intégrité de la base ?
- Quelle solution serait selon vous préférable à celle qui a été choisie ?

{% include important.html content="Exécutez la commande \q sur les deux sessions pour vous déconnecter de la base de données." span="markdown" %}

 {% include synthese.html content="<br/>
• La structure du schéma logique d'une base de données relationnelle vise à maintenir l'intégrité des données :  <em>vrai ? faux ?</em><br/>
• La modification du schéma logique d'une base de données est une fonctionnalité fondamentale d'un SGBD :  <em>vrai ? faux ?</em><br/>
• Le principe d'indépendance des données est bien supporté pour les interrogations :  <em>vrai ? faux ?</em><br/>
• Le principe d'indépendance des données est bien supporté pour les mises à jour :  <em>vrai ? faux ?</em>
" %}



{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité pratique, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_independence_views_correction.html)." markdown="span" type="danger"%} 
