---
title: Introduction au langage SQL
keywords: langage SQL
sidebar: data_sidebar
summary: Cette activité a pour objectif de vous faire découvrir la syntaxe de base du langage SQL.
toc: true
permalink: activity_sql.html
folder: Database
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>
- Assimiler les notions présentées dans [Introduction au modèle relationnel](lecture_relation_model.html)<br/>
Il peut être intéressant de disposer d'une compréhension plus large de la manipulation de données relationnelles en consultant le cours sur l'[algèbre relationelle](lecture_relational_algebra.html)" markdown="span" type="danger"%} -->


## La base de données *BIBLIOTHÈQUE*

*Les requêtes SQL à exprimer sont relatives à la base de données
BIBLIOTHEQUE constituée des relations dont le schéma logique est décrit
ci-dessous :*


{% include callout.html content="
ABONNE (<u>id</u>, nom, prenom, telephone, code_postal)<br/>
LIVRE (<u>id</u>, isbn, titre, auteur, annee_edition, prix)<br/>
EMPRUNT (<u>#id_livre, #id_abonne</u>, date-emprunt) : où *id_livre* référence
*LIVRE (id)* et *id_abonne* référence *ABONNE (id)*<br/>" markdown="span" type="success" %}

Aucun historique n'est géré dans cette base : La table ABONNE contient
les informations sur les abonnés actuels de la bibliothèque, et la table
LIVRE contient celles de tous les livres actuellement gérés par la
bibliothèque. La table EMPRUNT contient les emprunts en cours. Lorsqu'un
livre est retourné, le tuple correspondant dans la table EMPRUNT est
effacé.

{% include image.html file="bd/bd_td_intro_SQL_schema_1.png" alt="Schéma logique de la base BIBLIOTHEQUE (sous forme graphique)" caption="Figure 1 - Schéma logique de la base BIBLIOTHEQUE (sous forme graphique)" %}

## Structure générale d'une requête

Les requêtes SQL respectent la structure générale présentée sur la
Figure 2 - Structure générale d'une requête SQL. Les paragraphes
suivants vous guident pas à pas pour découvrir les concepts les plus
importants et donnent des précisions sur la syntaxe.

{% include callout.html content="`SELECT colonnes`<br/>
`FROM tables`<br/>
`[WHERE conditions]`<br/>
`[GROUP BY colonnes [HAVING condition]]`<br/>
`[ORDER BY colonnes [ASC|DESC]];`<br/>
" type="info" %}
<figcaption>Figure 2 - Structure générale d'une requête SQL</figcaption>

Remarque : les expressions entre crochets [ … ] signifient que le mot
clef est optionnel !

## Interrogation d'une table

{% include callout.html content="`SELECT [DISTINCT] colonne_1, ..., colonne_n`<br/>
`FROM nom_table`<br/>
`WHERE conditions`<br/>
`[ORDER BY colonne_x [ASC|DESC], colonne_y [ASC|DESC]]`" type="info" %}
<figcaption>Figure 3 - Interrogation d'une table</figcaption>

*Exemple*

-   Affichez le nom et le prénom de tous les abonnés :<br/>
    `SELECT nom, prenom FROM ABONNE;`

-   Affichez tous les livres écrits par Voltaire :<br/>
    `SELECT * FROM LIVRE WHERE auteur='Voltaire';`

*Questions*

  - **Question 1** : Affichez le <i>titre</i> et l'<i>auteur</i> de tous les livres
  - **Question 2** : Affichez le <i>nom</i>, le <i>code postal</i> et le <i>numéro de téléphone</i> des    abonnés sur Paris (code postaux débutant par 75)
  - **Question 3** : Affichez, sans doublon, l'<i>isbn</i> et l'<i>auteur</i> des livres selon l'ordre
    alphabétique des auteurs et des titres

## Jointures entre plusieurs tables

Lorsque l'on désire récupérer, de manière cohérente, des informations
contenues dans plusieurs tables nous devons utiliser l'opérateur de
jointure.

{% include callout.html content="`SELECT [DISTINCT] colonne_1, ..., colonne_n`<br/>
`FROM nom_table_1 [[AS] alias_1] [INNER] JOIN nom_table_2 [[AS] alias_2]`<br/>
`ON nom_table_1.nom_colonne_x = nom_table_2.nom_colonne_y;`" type="info" %}
<figcaption>Figure 4 - Jointure entre deux tables</figcaption>

L'expression `[[AS] alias]` permet de renommer une table au moyen d'un
alias. Cette notation est utilisée pour faciliter la lecture d'une
requête et pour lever les ambigüités lorsque plusieurs tables ont des
attributs se nommant de la même façon.

*Exemple*

-   Donnez le nom des abonnés ayant fait un emprunt :<br/>
```sql
SELECT A.nom
FROM ABONNE A INNER JOIN EMPRUNT E
ON A.id=E.id_abonne;
```

-   Affichez les dates d'emprunt des exemplaires du livre "<i>Le petit prince</i>" :<br/>
```sql
SELECT E.date-emprunt
FROM EMPRUNT E INNER JOIN LIVRE L
ON E.id_livre=L.id
WHERE L.titre='Le petit prince';
```

*Questions*

  - **Question 4** : Affichez le <i>titre</i> des livres empruntés par l'abonné n°669
  - **Question 5** : Affichez la liste des emprunts sur la ville de Brest (code
    postal 29200)
  - **Question 6** : Affichez le <i>nom</i> et le <i>prénom</i> des abonnés qui empruntent actuellement un exemplaire du livre "Le petit
    prince"

## Calculs et regroupement

{% include callout.html content="`GROUP BY colonne_1, ..., colonne_n`<br/>
`HAVING condition`" type="info" %}
<figcaption>Figure 5 - Mots clefs pour le regroupement</figcaption>

Le mot clef `GROUP BY` permet de réaliser des regroupements selon un ou
plusieurs attributs. Il est donc ainsi possible, au niveau du `SELECT`, de
spécifier une fonction d'agrégation (`count`, `min`, `max`, `sum`, `avg` etc.) qui
s'appliquera à l'ensemble des lignes regroupées.

A noter que le mot clef `HAVING` permet d'exprimer une contrainte sur le
regroupement (c'est-à-dire le résultat de la fonction). Le mot clef
`WHERE` doit toujours être utilisé pour tester les valeurs d'un tuple
existant dans la base.

*Exemple*

-   Affichez le nombre de livres actuellement empruntés :<br/>
    ```sql
    SELECT count(id_livre) FROM EMPRUNT;
    ```

-   Affichez, pour chaque abonné ayant un emprunt en cours, le nombre de
    livres actuellement empruntés :<br/>
    ```sql
    SELECT id_abonne, count(id_livre) FROM EMPRUNT GROUP BY id_abonne;
    ```

-   Affichez, pour chaque abonné ayant plus de 2 emprunts en cours, le
    nombre de livres actuellement empruntés :<br/>
    ```sql
    SELECT id_abonne, count(id_livre) FROM EMPRUNT
    GROUP BY id_abonne HAVING count(id_livre) > 2;
    ```

*Questions*

  - **Question 7** : Affichez le prix total de tous les livres possédés par bibliothèque
  - **Question 8** : Affichez le nombre d'abonnés par code postal
  - **Question 9** : Affichez, par auteur, le nombre de livres (et non pas d'exemplaires)
    possédés par la bibliothèque, qui ont été édités en 2017
  - **Question 10** : Affichez le titre des livres de "Voltaire" présents en plus de 3
    exemplaires

{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](activity_sql_correction.html)." markdown="span" type="danger"%}
