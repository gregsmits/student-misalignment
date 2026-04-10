---
title: Activité pratique - Indexation
keywords: plan d'exécution, EXPLAIN, indexation 
sidebar: data_sidebar
summary:  Le temps d'exécution d'une requête, calcul de la relation résultat, dépend de la taille des données interrogées mais aussi de contraintes sur ces données. Cette activité va vous permettre de comprendre comment interpréter un plan d'exécution de requête et comment accélérer la sélection de tuples via l'utilisation d'index. 
permalink: practice_indexation.html
toc: true
folder: Database
---


# Mise en place de l'activité

Dans cette activité, vous allez réutiliser la base de données *readers_db* mais que vous allez compléter pour mettre en avant l'intérêt des index.

Commencez par ajouter une colonne à la table *lecteur* pour indiquer le nombre d'emprunts qu'il a en cours.

```
ALTER TABLE lecteur add nb_emprunts INTEGER CHECK (nb_emprunts BETWEEN 0 and 11);
```

Ajoutez des valeurs alétoires aux tuples de la table *lecteur* :

```
UPDATE lecteur set nb_emprunts = floor(random() * 10) + 1;
```

# Plans d'exécution

- **Question 1** : Analysez le plan d'exécution d'une requête retournant les lecteurs dont le nombre d'emprunts est supérieur à 8.

- **Question 2** : Analysez le plan d'exécution d'une requête retournant les lecteurs dont le nombre d'emprunts est supérieur à 8 et qui ont actuellement un emprunt en cours (leur identifiant est mentionné dans la colonne *lecteur_id* de la table livre).

# Index

## Création d'un index

- **Question 3**  : créez un index sur la colonne *nb_lecteur* puis analysez le plan d'exécution d'une requête retournant les lecteurs dont le nombre d'emprunts est supérieur à 8. Qu'en concluez-vous pour le moment ?

## Ajoutons quelques tuples

Vous allez générer des tuples aléatoirement pour augmenter la taille de la table *lecteur* :
Dans le code ci-dessous, il est indiqué que la séquence commence à 100 mais vous pouvez adapter cette initialisation si votre table lecteur contient déjà plus de 100 valeurs.

```
CREATE SEQUENCE id_lecteur START 100;

do $$
begin
   for i in 1..1000 loop
        INSERT INTO lecteur VALUES 
            (nextval('id_lecteur'), substring(MD5(random()::text), 0, 10), (random() * 10)::int +1);
   end loop;
end;
$$
```

- **Question 4**  : Analysez le plan d'exécution de la même requête retournant les lecteurs dont le nombre d'emprunts est supérieur à 8. 

# Recherche full text

Vous allez désormais étudier comment accélérer la recherche dans des données textuelles à partir de mots clefs. Cette fonctionnalité est notamment très utile pour la mise en place de moteurs de recherche.

## Colonne *ts_vector*

Testez les étapes suivantes pour mettre en place une recherche *full text* sur le titre des livres :

- Ajoutez une colonne dans la table *livre* dédiée à la recherche sur les lexèmes du titre,
```
ALTER TABLE livre ADD search TSVECTOR;
```
- Construisez le vecteur pour chaque titre de livre,
```
UPDATE livre SET search = to_tsvector(titre);
```
- Testez une recherche par mot clef dans les titres de livre.
```
SELECT * FROM livre WHERE search @@ to_tsquery('amour');
```

De nombreuses fonctionnalités permettent de paramétrer la recherche *full text* en incluant notamment des pondérations sur les mots clefs, des formulations logiques, etc. (voir [recherche full text](https://www.postgresql.org/docs/current/textsearch-controls.html)).

Pour tester ces autres fonctionnalités, ajoutez une colonne *synopsis* à la table *livre* et insérez des valeurs textuelles assez longues pour plusieurs tuples. 


{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé ce TP, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_indexation_correction.html)." markdown="span" type="danger"%} 
