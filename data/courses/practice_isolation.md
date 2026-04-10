---
title: Activité pratique - Isolation des transactions
keywords: transactions
sidebar: data_sidebar
summary:  Cette activité vous permettra de découvrir les mécanismes mis en place par le système de gestion de bases de données pour détecter quand des transactions différentes mènent des actions qui influent mutuellement les unes sur les autres.
permalink: practice_isolation.html
toc: true
folder: Database
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>

- Savoir utiliser des [environnements concurrents et les transactions](practice_transaction.html)<br/>
- Connaître la [notion d'isolation des transactions](lecture_isolation.html)
- Assimiler la syntaxe de base de SQL en réalisant l'activité [Introduction au langage SQL](activity_sql.html)<br/>
- Maîtriser l'environnement dockerisé de BD ([pratiquer postgresql](practice_postgresql.html))

" markdown="span" type="danger"%} -->


# Mise en place du TP

Les données pour effectuer cette activité pratique seront stockées sous la forme de deux relations (ou tables) : `lecteur` et `livre`. La table `livre` contient des informations sur les différents livres de la bibliothèque, ainsi que la référence du lecteur qui l'a emprunté. La table `lecteur` contient des informations sur les lecteurs inscrits à la bibliothèque.


## Accès à la BD

L'[environnement de développement dockerisé](documentation_rdbms.html) (téléchargeable [ici](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment)) fourni dispose d'un serveur PostgreSQL et d'un service PgAdmin4. Une fois les *containers* démarrés, vous devriez trouver un accès au service PgAdmin4. Plusieurs bases de données sont déjà installées et vous allez, dans cette activité, utiliser la base *readers_db*.

![Accès à la base *readers_db*](images/data/readers_db.png)


## Création d'un environnement concurrent

Afin de constater ce qui se passe lorsque plusieurs personnes interagissent sur la même base de données, vous allez, tout au long de cette activité, simuler un environnement concurrent :

1. Ouvrez deux onglets vers le service [pgadmin](http://127.0.0.1:5051){:target="_blank"}. L'onglet de gauche se nomme ci-après session $$A$$ et celui de droite session $$B$$.
2. Désactivez, pour les deux sessions, l'option *autocommit* en allant dans l'espace *Query tool* et les options d'exécution comme illustré ci-dessous.

![Désactivation de l'autocommit](images/data/autocommit_off.png)


## Découverte des niveaux d'isolation

Vous avez pu découvrir dans le cours la notion de **sérialisabilité**, qui est le principe sur lequel on s'appuie pour décider que l'exécution simultanée de plusieurs transactions présente ou non un risque d'incohérence en matière d'isolation.

Pourtant, ce principe de sérialisabilité est si contraignant que la norme ANSI/ISO SQL défini différents niveaux d'isolation, dont trois plus faibles que le niveau sérialisable. Si leur utilisation apporte moins de contraintes (et génère moins de conflits), ils risquent néanmoins de laisser passer des situations sources d'erreurs. Ces niveaux sont :

-   `READ UNCOMMITED`
-   `READ COMMITED`
-   `REPETABLE READ`
-   `SERIALIZABLE`

Tous les SGBDR, n'implémentent pas les 4 niveaux d'isolation :

- ORACLE en implémente deux : `READ COMMITED`, qui est le comportement par défaut, et `SERIALIZABLE`, le comportement de référence que vous allez étudier dans ce TP.

- PostgreSQL implémente les 4, mais son implémentation du `READ UNCOMMITED` fait qu'il se comporte comme le `READ COMMITED`. Le niveau par défaut est le `READ COMMITED`.

## Modification des niveaux d'isolation

Pour connaître le niveau d'isolation :`show transaction isolation level;`

Pour le modifier : `SET TRANSACTION ISOLATION LEVEL niveau_souhaité` (SERIALIZABLE, REPEATABLE_READ, READ_COMMITTED, READ_UNCOMMITTED)

{% include important.html content="N'oubliez pas d'exécuter la commande pour fixer le niveau d'isolation à chaque fois qu'il vous est demandé de le faire. Par défaut, Oracle et PostgreSQL reviennent en mode `READ COMMITED` après un `commit ;`." span="markdown" %}

### Lectures reproductibles

#### Niveau SERIALIZABLE

Modifiez le niveau d'isolation en exécutant la commande suivante dans la session $$A$$ :

{% include callout.html content="`SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;`" type="danger" %}

Dans la session $$A$$, affichez le nom du lecteur `1`.

Dans la session $$B$$, modifiez le nom du lecteur `1` au moyen de la commande suivante :

`UPDATE lecteur SET nom ='toto' WHERE num_lecteur=1 ;`

Validez avec la commande `commit ;`.

Dans la session $$A$$, affichez le nom du lecteur `1`.

- **Question 1** : Que constatez-vous ?

Effectuez un `commit ;` dans la session $$A$$ puis affichez de nouveau le nom du lecteur `1`.

- **Question 2** :  Que constatez-vous ?

#### Niveau READ COMMITED

Maintenant vous allez faire la même suite d'opérations mais avec le niveau d'isolation `READ COMMITED`. Vérifiez que dans la session $$A$$ le niveau est bien `READ COMMITED`:

{% include callout.html content="`show transaction isolation level ;`" type="danger" %}

Dans la session $$A$$, affichez le nom du lecteur `1`.

Dans la session $$B$$, modifiez le nom du lecteur `1` au moyen de la commande suivante :

`UPDATE lecteur SET nom ='tata' WHERE num_lecteur=1 ;`

Validez avec la commande `commit ;`.

Dans la session $$A$$, affichez le nom du lecteur `1`.

- **Question 3** : Que constatez-vous ?

Effectuez un `commit ;` dans la session $$A$$ puis affichez de nouveau le nom du lecteur `1`.

- **Question 4** :  Que constatez-vous ?

### Fantômes

#### Niveau SERIALIZABLE

Modifiez le niveau d'isolation en exécutant la commande suivante dans la session $$A$$ :

{% include callout.html content="`SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;`" type="danger" %}

Dans la session $$A$$, comptez le nombre de lecteurs.

Dans la session $$B$$, ajoutez un lecteur. Validez avec un `commit ;`.

Dans la session $$A$$, comptez le nombre de lecteurs.

- **Question 5** :  Que constatez-vous ?

Effectuez un `commit ;` dans la session $$A$$ puis comptez le nombre de lecteurs.

- **Question 6** :  Que constatez-vous ?

#### Niveau READ COMMITED

Maintenant vous allez faire la même suite d'opérations mais avec le niveau d'isolation `READ COMMITED`. Vérifiez que dans la session $$A$$ le niveau est bien `READ COMMITED`:

{% include callout.html content="`show transaction isolation level ;`" type="danger" %}

Dans la session $$A$$, comptez le nombre de lecteurs.

Dans la session $$B$$, ajoutez un lecteur. Validez avec un `commit ;`.

Dans la session $$A$$, comptez le nombre de lecteurs.

- **Question 7** :  Que constatez-vous ?

Effectuez un `commit ;` dans la session $$A$$ puis comptez le nombre de lecteurs.

- **Question 8** :  Que constatez-vous ?

### Bilan du comportement du niveau SERIALIZABLE

D'après votre expérience sur les questions précédentes répondez aux questions suivantes **sans exécuter** de requêtes.

Dans la session $$A$$, on demande la collection de `Risibles amours` et on obtient `Folio`. Dans la session $$B$$ on modifie la collection de `Risibles amours` en `Pocket` et on valide la transaction par un `commit ;`.

- **Question 9** :  Quelle est désormais la collection de `Risibles amours` au travers de la session $$A$$ ?
  - `Folio`
  - `Pocket`

Dans la session $$A$$, on compte le nombre de livres et on obtient `15`. Dans la session $$B$$ un livre est ajouté et la transaction validée par un `commit ;`.

- **Question 10** :  Combien obtient-on désormais de livres au travers de la session $$A$$ ?
   - `15`
   - `16`

## Erreurs de sérialisation et interblocages

Les mécanismes transactionnels s'appuient essentiellement sur l'utilisation de techniques de verrouillage (ce qu'on appelle sémaphore en programmation concurrente).

Le défaut de ces techniques réside essentiellement dans le risque de voir apparaître des interblocages entre des transactions (processus en programmation concurrente) qui accèdent à des ressources identiques :

- En programmation, on anticipe ces risques de conflits au moment de la conception des programmes.
- En bases de données, on part de l'hypothèse que cela n'arrive pas souvent et on ignore les transactions qui vont parvenir au SGBD. La réduction du niveau d'isolation est donc une réponse possible pour réduire ce risque.

Modifiez le niveau d'isolation en exécutant la commande suivante dans la session $$A$$ :

{% include callout.html content="`SET TRANSACTION ISOLATION LEVEL SERIALIZABLE ;`" type="danger" %}

Dans la session $$A$$, affichez le nom du lecteur `1`.

Dans la session $$B$$, modifiez le nom du lecteur `1`.

Dans la session $$A$$, modifiez le nom du lecteur `1` en choisissant un nom différent de la session $$B$$.

- **Question 11** :  Que constatez-vous ?

Effectuez un `commit ;` dans la session $$B$$ puis affichez de nouveau le nom du lecteur `1` dans la session $$A$$.

- **Question 12** :  Que constatez-vous ?

- **Question 13** : Expliquez ce qu'il se serait passé si dans la session $$A$$ le niveau d'isolation avait été `READ COMMITED`.


{% include important.html content="Exécutez la commande \q sur les deux sessions pour vous déconnecter de la base de données." span="markdown" %}

## Bilan sur les transactions et leurs niveaux d'isolation


### Phénomènes survenant lors des transactions


Revenons sur la définition des propriétés que peut avoir une transaction :

-   Lecture sale (`DIRTY READ`) : il est possible de lire des données qui n'ont pas été validées par un commit. L'intégrité des données n'est pas assurée.
-   Lecture non reproductible (`NON REPETABLE READ`) : il est possible au cours d'une même transaction de lire à un temps $$t_1$$ des informations sur une ligne, et à un temps $$t_2$$ des informations différentes.
-   Lecture fantôme (`PHANTOM READ`) : il est possible au cours d'une même transaction de voir au cours du temps apparaître des lignes.

### Niveaux d'isolation ANSI

- **Question 10** :  D'après-vous, qu'appelle-t-on « fantôme » dans le cadre des transactions ?

- **Question 11** : Quelle est la différence de comportement entre le niveau par défaut, `READ COMMITED`, et le niveau `SERIALIZABLE` ?

- **Question 12** : Dans quel contexte pensez-vous pouvoir utiliser le niveau d'isolation `SERIALIZABLE` ?

- **Question 13** : D'après les définitions précédentes et de vos expériences effectuées au cours de ce TP complétez le tableau suivant.

  |Niveau d'isolation  | Lecture sale  | Lecture non reproductible  | Lecture fantôme |
  |--------------------| --------------| ---------------------------| -----------------|
  |Read uncommited     | Possible      | Possible                   | Possible|
  |Read commited       |               |                            | |
  |Repetable read      | Impossible    | Impossible                 | Possible|
  |Serializable        |               |                            | |



{% include callout.html content="**Correction**<br/><br/>
Après avoir réalisé cette activité pratique, ou en cas de blocage, il est conseillé de vérifier ses réponses avec la [correction](practice_isolation_correction.html)." markdown="span" type="danger"%}
<!--
{% include callout.html content="**Approfondissements**<br/><br/>
A la fin de cette activité,  il est **recommandé** de lire les documents suivants :<br/>
- Tom Kyte (ORACLE), [On transaction isolation levels](http://download.oracle.com/docs/cd/B19306_01/server.102/b14220/consist.htm)<br/>
- PostgreSQL, [Isolation des transactions](http://docs.postgresqlfr.org/9.0/transaction-iso.html) (norme ISO)" markdown="span" type="warning"%} -->
