---
title: Activité pratique - Transactions
keywords: transactions
sidebar: data_sidebar
summary: L'objectif de cette activité est de présenter les problèmes qui peuvent survenir lors de modifications d'une base de données et de son partage entre différents utilisateurs, spécialement quand ceux-ci veulent modifier ces données simultanément. Le partage d'une base de données répond à des besoins différents du partage d'un fichier dans un système d'exploitation.
toc: true
permalink: practice_transaction.html
folder: Database
---

## Contexte

Rappelons qu'une base de données (relationnelle dans notre cas) est un ensemble cohérent, intègre et souvent volumineux de données. De ce fait, la modification de données est une action délicate car il est très difficile, voire tout à fait impossible, de vérifier visuellement que la modification réalisée ne viole pas l'intégrité des données. La diminution des redondances, voire leur élimination quand c'est possible, permet de réduire les risques d'incohérence. Mais dans tous les cas, il est essentiel que le SGBD propose des outils pour contrôler et maintenir cette intégrité.

Le mécanisme de transactions vise à répondre à ces différentes préoccupations. C'est l'objectif de cette activité de l'explorer et de comprendre son comportement et les degrés de liberté offerts par le SGBD.

La base de données qui sert de support à ce TP est une base d'emprunt de livres par des lecteurs sans gestion des historiques, c.-à-d. qu'à un instant donné la base de données contient les emprunts en cours.

## Mise en place du TP

Les données pour effectuer le cette activité pratique seront stockées sous la forme de deux relations (ou tables) : `lecteur` et `livre`. La table `livre` contient des informations sur les différents livres de la bibliothèque, ainsi que la référence du lecteur qui l'a emprunté. La table `lecteur` contient des informations sur les lecteurs inscrits à la bibliothèque.

### Accès à la BD

L'[environnement de devéloppement dockerisé](documentation_rdbms.html) fourni (téléchargeable [ici](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment)) dispose d'un serveur PostgreSQL et d'un service PgAdmin4. Une fois les conteneurs démarrés, vous devriez trouver un accès au service PgAdmin4. Plusieurs bases de données sont déjà installées et vous allez, dans cette activité, utiliser la base _readers_db_.

![Accès à la base *readers_db*](images/data/readers_db.png)

### Présentation des tables

La table `livre` contient des informations sur les différents livres de la bibliothèque, ainsi que la référence des lecteurs qui les ont empruntés. La table `lecteur` contient des informations sur les lecteurs inscrits à la bibliothèque.

Explorez la structure et le contenu de ces deux tables.

### Présentation des vues

Les vues vous permettent d'accéder plus simplement à certaines informations. Pour interroger une vue utilisez la commande :
`select * from <nom_vue> ;`

Vous avez à votre disposition deux vues :

- La vue `infos` : affichant les numéros de livre et les numéros de leurs emprunteurs
- La vue `infos_livre` : affichant toutes les informations détaillées sur les livres

<!-- Pour observer la structure des vues, utilisez les mêmes commandes que pour les tables. -->

### Présentation des fonctions stockées

Les fonctions stockées permettent d'effectuer des requêtes prédéfinies lors de la création de la base. Pour effectuer cette activité, un certain nombre de fonctions vous sont fournies. Prenez le temps tout au long des exercices de lire leur code. Pour exécuter une fonction stockée sous PostgreSQL utilisez la commande `select nom_procedure(attribut1, .. , attributN)`

Vous disposez des fonctions stockées suivantes :

- `inserer_livre(varchar nom, varchar titre, varchar collection, int ref)`

- `supprimer_livre(int numlivre)`

- `inserer_lecteur(varchar nom)`

- `emprunter(int numlivre, int numlecteur)`

- `rendre(int numlivre)`

{% include important.html content="Lors de l'appel d'une fonction stockée n'écrivez pas le type (`varchar`, `int`, ...) qui n'est donné que pour votre information !" span="markdown" %}

### Création d'un environnement concurrent

Afin de constater ce qui se passe lorsque plusieurs clients interagissent sur la même base de données, vous allez, tout au long de cette activité, simuler un environnement concurrent :

1. Ouvrez deux onglets vers le service [pgadmin](http://127.0.0.1:5051){:target="\_blank"}. L'onglet de gauche se nomme ci-après session $$A$$ et celui de droite session $$B$$.
2. Désactivez, pour les deux sessions, l'option _autocommit_ en allant dans l'espace _Query tool_ et les options d'exécution comme illustré ci-dessous.

![Désactivation de l'autocommit](images/data/autocommit_off.png)

## Valider et annuler une transaction

{% include important.html content="Au cours de cette activité, assurez-vous avant d'emprunter un livre qu'il n'est pas déjà emprunté !" span='markdown' %}

### Validation d'une transaction

Dans la session $$A$$, observez l'état des relations en utilisant la vue `infos`. Ajoutez ensuite un nouveau lecteur (par exemple `Dupont`) et un nouvel emprunt (par exemple `Dupont` emprunte le livre `6` (`Risibles amours`)) à la base (vous pouvez si vous le souhaitez utiliser les fonctions stockées `inserer_lecteur` et `emprunter`.

- **Question 1** : Interrogez les relations dans la session $$B$$ en utilisant la vue `infos`. Que constatez-vous ?

Dans la session $$A$$, validez la mise à jour avec la commande `commit ;`.

- **Question 2** : Que constatez-vous dans la session $$B$$ ?

### Retour à l'état d'origine

Dans la session $$A$$, ajoutez successivement deux nouveaux lecteurs.

- **Question 3** : Sont-ils présents dans la session $$B$$ ?

Dans la session $$A$$, exécutez la commande `rollback ;`.

- **Question 4** : Que constatez-vous dans chacune des sessions ?

- **Question 5** : Quelle(s) propriété(s) des transactions avez vous ainsi testé ?

### Bilan

D'après votre expérience sur les questions précédentes répondez aux questions suivantes **sans exécuter** de requêtes.

Dans la session $$A$$, on demande la collection de `Risibles amours`et on obtient `Folio`. Dans la session $$B$$ on modifie la collection de `Risibles amours` en `Pocket` et on valide la transaction par un `commit ;`.

- **Question 6** : Quelle est désormais la collection de `Risibles amours` ?
  - `Folio`
  - `Pocket`

Dans la session $$A$$, on compte le nombre de livres et on obtient `15`. Dans la session $$B$$, deux livres sont ajoutés et la transaction validée par un `commit ;`.

- **Question 7** : Combien obtient-on désormais de livres au travers de la session $$A$$ ?

  - `15`
  - `16`
  - `17`

## Contraintes applicatives ou de la base de données ?

### Deux emprunts simultanés

Dans la session $$A$$, le lecteur `1` emprunte le livre `7` (appel à la fonction stockée `emprunter(7,1)`) tandis que dans la session $$B$$, le lecteur `2` (`emprunter(7,2)`) emprunte le même livre.

- **Question 8** : Que constatez-vous ?

Effectuez un `commit` dans la session $$A$$.

Interrogez les relations depuis les deux sessions.

- **Question 9** : Que constatez-vous ?

Effectuez un `commit` dans la session $$B$$.

- **Question 10** : Que constatez-vous ? Justifiez votre réponse en vous basant sur le code de la fonction stockée `emprunter`.

### Suppression d'un livre en cours d'emprunt

Dans la session $$A$$, le lecteur `3` emprunte le livre `8` tandis que dans la session $$B$$ le livre `8` est supprimé au moyen de la fonction `supprimer_livre`.

- **Question 11** : Que constatez-vous ?

Effectuez un `commit` dans la session $$A$$ puis interrogez les relations depuis les deux sessions.

- **Question 12** : Que constatez-vous ?

Effectuez un `commit` dans la session $$B$$ puis interrogez les relations depuis les deux sessions.

- **Question 13** : Que constatez-vous ?

- **Question 14** : Regardez le code des fonctions `emprunter` et `supprimer_livre` depuis pgadmin. Comment expliquez-vous le comportement que vous avez observé ?

- **Question 15** : Proposez une nouvelle requête pour la fonction `supprimer_livre` résolvant le problème en vous inspirant de la fonction `emprunter`.

## Un retour sur l'intégrité des données

{% include callout.html content="**Pré-requis**<br/>
Avant de réaliser cette section, vous devez connaître la syntaxe SQL pour modifier des tables, notamment les commandes `INSERT` et `UPDATE`." markdown="span" type="danger"%}

<!-- {% include tip.html content="Pour la question suivante vous allez devoir utiliser la commande SQL `ALTER TABLE`. Pour cela, consultez la documentation qui correspond à votre SGBD :<br/>
- Documentation [PostgreSQL](https://www.postgresql.org/docs/9.6/static/sql-altertable.html)<br/>
- Documentation [Oracle](https://docs.oracle.com/javadb/10.8.3.0/ref/rrefsqlj81859.html)<br/>" span="markdown" %} -->

**Ajout d'une clef primaire**

```sql
ALTER TABLE nom_table ADD CONSTRAINT nom_clef_PK PRIMARY KEY (attributs)
```

**Ajout d'une clef référentielle**

```sql
ALTER TABLE nom_table ADD CONSTRAINT nom_clef_FK
FOREIGN KEY (attributs_clef_referentielle) REFERENCES nom_table_referencee(attributs_clef_primaire);
```

Supprimez le lecteur `2` avec une requête SQL de type `DELETE`.

- **Question 16** : La base de données qui résulte de cette mise à jour est elle intègre ? Justifiez votre réponse.

- **Question 17** : Définissez les contraintes de clés primaires et de clés référentielles sur le schéma de la base de données.

- **Question 18** : Pour la clé primaire de `lecteur`, proposez une requête `INSERT` et une requête `UPDATE` qui testent le bon comportement du système en matière de contrainte d'intégrité.

- **Question 19** : Pour la clé référentielle vers `lecteur`, proposez une requête `INSERT` et une requête `UPDATE` qui testent le bon comportement du système en matière de contrainte d'intégrité.

## Bilan

- **Question 20** : Pour vous, l'intégrité des données, c'est plutôt :
  - Un problème de "codage" des requêtes.
  - Un problème de contraintes d'intégrité au niveau de la base de données (clé primaire, clé étrangère ...).
  - Les deux.

{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité pratique, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_transaction_correction.html)." markdown="span" type="danger"%}
