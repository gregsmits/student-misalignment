---
title: Modélisation conceptuelle de schémas relationnels
keywords: modèle relationnel, UML, modélisation
sidebar: data_sidebar
summary: La modélisation conceptuelle est une approche méthodique et intuitive de structuration des données d'une application. Elle repose sur deux étapes, la (co)construction d'un schéma conceptuel avec l'aide de l'expert métier, puis la dérivation de ce schéma en version logique (ou relationnelle).
toc: true
permalink: lecture_conceptual_modeling.html
folder: Database
---
# Introduction

La modélisation conceptuelle est une procédure d'analyse visant à transformer une description des données du contexte applicatif en un schéma exploitable par un ordinateur. Cette démarche est initiée par un échange entre l'expert métier, celui qui connaît la sémantique des données et de leurs interactions, et un concepteur de base de données, qui lui, maîtrise les contraintes techniques liées à la persistance des données dans une BD.

Une première étape est souvent de construire un dictionnaire de données (cf. [introduction](lecture_modeling_normalization.html)) et d'identifier toutes les contraintes métier à prendre en compte. Une fois ce schéma conceptuel établi, le concepteur de données peut travailler seul pour aboutir à une implémentation dans une base de données, d'où l'importance de ce premier schéma conceptuel servant de point de départ à la démarche.

![Processus de construction d'un schéma relationnel par modélisation conceptuelle](images/data/modelisation_process.png)


# Schéma conceptuel de donées

{% include callout.html content="**Schéma conceptuel**<br/><br/>
Un schéma conceptuel de données est une reformulation d'un contexte applicatif, focalisé sur les données qu'il implique, à l'aide d'un formalisme. Ce schéma explicite les différentes classes de données (regroupement thématique d'attributs) et les liens (associations) qui existent entre ces classes.
" markdown="span" type="primary"%}


## Le langage UML (enfin une partie)

UML est un langage de modélisation de systèmes très complet pouvant être appliqué à la conception de systèmes informatiques. Ici, nous ne verrons que quelques éléments de ce langage nécessaires à la modélisation de bases de données. Une alternative est le modèle [entité-relation](https://fr.wikipedia.org/wiki/Mod%C3%A8le_entit%C3%A9-association) qui peut également être utilisé pour aboutir à un schéma conceptuel.

### Classe et propriétés

{% include callout.html content="**Classe**<br/><br/>
Une classe modélise un objet concret (livre, bibliothèque, rangée, client, etc.) ou abstrait (abonnement, emprunt, etc.) manipulé dans le contexte applicatif concerné." markdown="span" type="primary"%}

{% include callout.html content="**Propriété**<br/><br/>
 Une classe est notamment décrite par les propriétés qui la qualifient (par exemple ISBN, titre, nombre de pages pour un livre).
" markdown="span" type="primary"%}

La première étape lors de la construction du schéma conceptuel consiste à identifier chaque classe et à indiquer quelles données du [dictionnaire](lecture_modeling_normalization.html) la caractérisent.

Une classe et ses propriétés sont représentées comme suit en UML.

![Classe UML pour la conception de base de données](images/data/classe_UML.png)

### Associations

{% include callout.html content="**Association**<br/><br/>
Une association exprime un lien entre deux (association binaire) ou plusieurs classes (association n-aire).<br/> Pour expliciter la sémantique de l'association, un label, généralement un verbe, lui est défini. Le label est associé à une direction qui permet de comprendre le sens de l'association, mais l'association symétrique est décrite en utilisant la version passive du verbe (par ex. Un lecteur *emprunte* un livre, un livre *est emprunté* par un lecteur).<br/> Une association peut, en plus d'exprimer un lien, porter des propriétés.
" markdown="span" type="primary"%}

Voici ci-dessous deux exemples d'associations binaires, à droite une propriété est ajoutée à l'association.

 ![Associations binaires](images/data/associations.png)


Et ci-dessous, une illustration d'une association ternaire indiquant qu'un client signe un contrat avec un département (de l'entreprise).

![Association ternaire](images/data/multi_association.png)

Une association peut être réflexive, c'est-à-dire impliquer de part et d'autre la même association. L'exemple ci-dessous indique qu'un département peut être associé à d'autres départements pour un laps de temps.

![Association réflexive](images/data/reflexive_association.png)


### Cardinalité

Vous avez remarqué que sur le trait d'une association, une indication est positionnée de part et d'autre, il s'agit des contraintes de cardinalité de l'association UML.

{% include callout.html content="**Cardinalité**<br/><br/> Dans la définition d'une association UML, on indique, pour chaque classe, le nombre de fois qu'une instance de la classe peut être impliquée dans une occurrence de l’association, au minimum et au maximum, d'où la notation *minimum..maximum*.
" markdown="span" type="primary"%}

Dans le premier exemple d'association binaire (celui de gauche), les cardinalités indiquent qu'un client est membre d'au moins un groupe mais potentiellement de plusieurs. Un groupe a pour membre aucun client (0) ou plusieurs (*).

La lecture des cardinalités dans une association n-aire (e.g. *signer* entre *Customer*, *Contract*, *Department*) est plus délicate à déchiffrer. Une instance de l'association implique la participation des différentes classes reliées. Les règles de cardinalité d'une branche de l'association sont déterminées en fixant une instance des deux autres classes. Par exemple, une instance de *Customer* peut signer avec une instance de *Department* combien d'instances de *Contract*.

#### Participation



Pour interpréter une cardinalité, on parle de participation de la classe à l'association. On distingue les participations :
- totale (resp. non totale) lorsque la cardinalité minimum est à 1 (resp. 0),
- unique (resp. multiple) lorsque la cardinalité maximale est à 1 (resp. \*).

![Associations binaires](images/data/associations.png)

{% include callout.html content="**Exemple**<br/>Dans les exemples d'association binaire ci-dessus, on dit que :<br/>
- *Customer* a une participation totale (minimum à un) et multiple (maximum à \*) dans l'association *is member* avec la classe *Group*<br/>
- *Group* a une participation non totale (minimum à 0) et multiple (maximum à \*) dans l'association *has as member* avec la classe *Customer*.<br/>" markdown="span" type="success" %}

 et on peut résumer les participations des classes concernées à l'association à travers les types de cardinalités suivants :
- *1:1* lorsque toutes les classes participantes ont une cardinalité maximale à 1 (donc des cardinalités *0..1* ou *1..1*),
- *1:N* lorsqu'au moins une classe a une participation multiple à l'association (donc des cardinalités *0..\** ou *1..\**) et au moins une classe a une cardinalité maximale à 1 (donc des cardinalités *0..1* ou *1..1*),
- *N:M* lorsque toutes les classes ont une participation multiple à l'association (donc des cardinalités *0..\** ou *1..\**).


{% include callout.html content="**Exemple**<br/>
Pour l'exemple précédent, la cardinalité de l'association *is member* est *N:M*.<br/>
" markdown="span" type="success" %}


### Héritage

L'héritage permet de factoriser dans une super-classe des propriétés partagées par plusieurs sous-classes. Un héritage peut-être exclusif, appartenance à une seule sous-classe, ou non-exclusif indiquant la possibilité de faire partie de plusieurs sous-classes en même temps.

![Héritage entre classes](images/data/inheritance.png)


# Schéma logique

Le schéma logique s'obtient dans la méthode proposée par dérivation du schéma conceptuel. Tout en conservant les associations entre classes identifiées lors de l'analyse conceptuelle, l'objectif du schéma logique est de définir la structure en relations de la future base de données ainsi que les contraintes d'intégrité sur et entre les attributs.

{% include callout.html content="**Schéma logique**<br/><br/> Un schéma logique décrit la structure en relations de la base de données et précise les contraintes d'intégrité des données.
" markdown="span" type="primary"%}

## Règle 1 : Dérivation de classe

Toute classe du schéma conceptuel est dérivée en une relation. Dans la relation créée doit apparaître la clef primaire, choisie parmi les clefs candidates (cf. [Le modèle relationnel](lecture_relational_model.html)). La clef primaire est soulignée par convention.

{% include callout.html content="**Exemple**<br/>Les classes *Customer* et *Group* donnent lieu à la création de deux relations pour lesquelles on explicite la clef primaire qui est soulignée. <br/>" markdown="span" type="success" %}

![Dérivation d'une classe](images/data/logical_schema_classes.png)

Pour devancer certaines contraintes techniques, un attribut peut être ajouté à la relation pour jouer le rôle de clef primaire artificielle.

## Règle 2 : Dérivation d'une association de type 1:1

Dans une association entre deux classes, et lorsque l'une d'elles participe de manière totale et unique à l'association (c.-à-d. cardinalité *1..1*) alors cette dernière porte l'association. Concrètement, une référence est ajoutée vers l'unique instance de la classe avec laquelle elle est obligatoirement associée. Sur ce nouvel attribut ajouté à la relation, une contrainte d'intégrité référentiel est définie dans le schéma logique (symbolisée par un \#) et explicitée.

{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessous, un *Group* est associé obligatoirement à une instance de *Customer* qui est le manager. Dans la relation *Group*, une référence vers l'unique *Customer* qui est son manager est ajoutée. On indique en complément que l'attribut `idMng` de *Group* fait référence à l'attribut `id` de *Customer*.
<br/>" markdown="span" type="success" %}

![Dérivation d'une association 1-1](images/data/derivation1-1.png)

Le caractère obligatoire (totale) de l'association dans la relation *Group* (cardinalité minimum à 1) sera pris en compte dans le schéma physique. 

Cette règle s'applique également pour les relations réflexives de type 1:1.

## Règle 3 : Dérivation d'une association de type 1:N


Dans une association entre deux classes avec une participation unique d'un côté (cardinalité maximale à 1) et une participation multiple de l'autre (cardinalité maximale à \*), alors l'association est portée par la classe dont la participation est unique. Concrêtement, une référence est ajoutée vers l'unique instance de la classe avec laquelle elle peut être associée. Sur ce nouvel attribut ajouté à la relation, une contrainte d'intégrité référentiel est définie dans le schéma logique (symbolisée par un \#) et explicitée.


{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessous, un *Customer* fait partie d'au plus un *Group*. Une instance de *Customer* porte donc de manière unique l'association avec *Group*, d'où l'ajout d'un attribut dans la relation *Customer* indiquant l'unique groupe duquel il est membre.
<br/>" markdown="span" type="success" %}
![Dérivation d'une association 1-N](images/data/derivation1-N.png)

La distinction entre une cardinalité *0..1* et *1..1* ne peut pas être faite au niveau logique mais sera prise en compte à la prochaine étape lors du passage au schéma physique.

Cette règle s'applique également pour les relations réflexives de type 1:1.

## Règle 4 : Dérivation d'une association de type N:M

Pour toute association de cardinalité *N:M*, une relation est créée pour stocker les possibles associations multiples. La clef primaire de cette nouvelle relation est la combinaison des clefs primaires des classes qu'elle relie. Si l'association possède des propriétés, elles sont ajoutées à la nouvelle relation.


{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessous, un *Customer* peut faire partie de plusieurs groupes avec dans chacun d'eux une fonction. Comme un *Customer* peut être associé avec de multiples *Group* et vice-versa, une relation est créée pour cette association.
<br/>" markdown="span" type="success" %}

![Dérivation d'une association 1-N](images/data/derivationN-M.png)

Cette règle s'applique également et de la même façon pour les associations de dimension supérieure à 2.

Dans le cas d'une association reflexive de type N:M, il faut également procéder à la création d'une relation pour stocker les associations entre instances de la même classe. 


## Règle 5 : Dérivation de l'héritage de classes

L'analyse conceptuelle des données permet d'identifier des situations possibles de factorisation des données à travers des relations d'héritage. L'héritage doit être traduit au niveau logique par une répartition des données dans des relations pouvant uniquement être liées par des contraintes d'intégrité référentielle.

Trois stratégies de dérivation de l'héritage sont envisageables :

1. Une relation est créée pour la classe mère de l'héritage et une relation également pour chaque classe qui en hérite. Le lien entre classes filles et classe mère repose sur le partage d'un même identifiant ceci garanti par une contrainte d'intégrité référentielle.
2. Une seule relation est créée agrégeant toutes les propriétés des différents classes filles.
3. Une relation est crée pour chaque classe fille dans laquelle on reporte les propriétés initialement factorisées dans la classe mère.

La stratégie 1 est à privilégier lorsque les classes filles possèdent de nombreuses propriétés qui leur sont spécifiques. La deuxième stratégie est préférable dans le cas inverse, c'est-à-dire que les classes filles ont peu de propriétés spécifiques. Pour un tuple correspondant à une classe fille, tous les attributs issus d'une autre classe fille seront associés à des valeurs manquantes (`NULL`). La dernière stratégie est à privilégier lorsque le nombre de propriétés factorisées dans la classe mère est faible.


{% include callout.html content="**Exemple**<br/>Dans l'exemple ci-dessous, un *Customer* peut être de international ou national faisant apparaître des propriétés spécifiques. Les trois solutions de dérivation de cet héritage sont proposées mais la seconde est sans doute plus judicieuse car le nombre de propriétés de chaque classe fille est faible.
<br/>" markdown="span" type="success" %}

![Dérivation d'une situation d'héritage](images/data/heritage.png)
