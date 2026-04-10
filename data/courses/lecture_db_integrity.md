---
title: Intégrité des données
keywords: L'intégrité des données dans une base de données relationnelles
sidebar: data_sidebar
summary: Ce cours vous présente la notion d'intégrité des données, soit un ensemble de règles vérifiées par un SGBDR pour garantir l'exhaustivité, l'exactitude et la cohérence des données.
toc: true
permalink: lecture_db_integrity.html
folder: Database
---

<!--
{% include callout.html content="**Pré-requis**<br/><br/>- [Connaître le modèle relationnel](lecture_relational_model.html)<br/>" markdown="span" type="danger"%} -->


# Intégrité des données

{% include callout.html content="**Définition** - Intégrité<br/>L'**Intégrité** des données désigne le fait que, durant tout le cycle de vie des données, elles seront maintenues par le système dans un état exhaustif, exact et cohérent." markdown="span" type="primary" %}

Un rôle important assuré par un SGBDR est de garantir qu'à tout moment toutes les données sont accessibles (exhaustivité) et de qualité, c'est-à-dire qu'elles satisfont un ensemble de règles (exactitude et cohérence). Ces règles sont de plusieurs types :
- intégrité de relation,
- intégrité de domaine,
- intégrité référentielle,
- intégrité utilisateur.

## Intégrité de relation

L'intégrité d'une relation repose sur une contrainte permettant d'identifier et de différentier chaque tuple qui compose une relation. Il repose sur une notion de clef.

{% include callout.html content="**Définition** - Clef candidate<br/> Une **clef candidate** est un sous-ensemble d'attributs (éventuellement et souvent un singleton) permettant d'identifier de manière unique un tuple. Tous les tuples de la relation ont donc des valeurs différentes sur ce sous-ensemble d'attributs." markdown="span" type="primary" %}

{% include callout.html content="**Définition** - Clef primaire<br/> Une **clef primaire** est choisie parmi les clefs candidates de sorte qu'elle garantira toujours l'unicité des tuples et possèdera toujours une valeur." markdown="span" type="primary" %}

Un tuple d'une relation peut ne pas posséder de valeur pour certains attributs. Cependant, le ou les attributs de la clef primaire seront toujours renseignés.

#### Relation *Client*

  | numéro   | nom      | ville  | téléphone
  | -------- | ----------|  -------- | ----------------
  | 2        | DURANT    |  BREST    | 02 12 34 56 78
  | 6        | MARTIN    |  PARIS    | NULL
  | 22       | BERNARD   |  NICE     | 04 98 76 54 32
  | 54       | FONTAINE  |  RENNES   | NULL

Dans un schéma relationnel, une convention adoptée est de souligner le sous-ensemble d'attributs qui forme la clef primaire.

{% include callout.html content="**Exemple**<br/>Dans l'état actuel de la relation *Client*, les tuples ont des valeurs différentes sur chaque attribut sauf *téléphone*. L'attribut *téléphone* n'est pas une clef candidate. Les autres attributs sont tous individuellement des clefs candidates. Choisir l'attribut *ville* par exemple comme clef primaire interdirait le stockage d'un nouveau client habitant dans l'une des villes déjà présentes. Il est donc évident que *{numéro}* est le sous-ensemble des attributs le plus approprié pour former la clef primaire de la relation *Client*. D'où, le schéma relationnel suivant : *Client {<u>numéro</u>,nom, ville, téléphone}*" markdown="span" type="success" %}


## Intégrité de domaine

{% include callout.html content="**Définition** - Intégrité de domaine<br/> Tout attribut est associé à un type qui indique la nature des valeurs qu'il peut prendre. Une **contrainte d'intégrité de domaine** réduit l'ensemble des valeurs acceptables pour un type de données associé à un attribut." markdown="span" type="primary" %}


{% include callout.html content="**Exemple**<br/>Prenons par exemple, un attribut `age` pour indiquer l'age d'une personne dont le type le plus approprié serait numérique entier désignant un intervalle de valeurs très grand $$\mathbb{Z}$$. Pour s'assurer d'avoir des valeurs cohérentes associées à cet attribut, on souhaiterait resteindre cet intervalle à des valeurs comprises entre $$[0,150]$$ par exemple." markdown="span" type="success" %}

## Intégrité référentielle

L'ensemble des données confiées à une SGBDR est séparé en relations, chacune regroupant des tuples de même nature. L'ensemble de ces données peut être retrouvé en exploitant des liens entre les relations. Ces liens sont formalisés par des contraintes dites d'intégrité référentielle ou plus simplement contraintes de clefs étrangères.


{% include callout.html content="**Définition** - Clef étrangère<br/> Une contrainte de **clef étrangère** établit un lien entre deux sous-ensembles d'attributs (souvent de relations différentes mais pas obligatoirement) pour indiquer que les deux sous-ensembles décrivent les mêmes données. Une clef étrangère est définie sur un ensemble d'attributs dit source et fait référence à un sous-ensemble d'attributs dit cible en imposant que :<br/>

  - les attributs de l'ensemble source aient les mêmes types que les attributs de l'ensemble cible,<br/>
  - l'ensemble d'attributs cible soit associé à une contrainte d'unicité (contrainte de clef primaire ou d'unicité comme nous le verrons dans la partie implémentation),<br/>
  - les valeurs sur les attributs portant la clef étrangère d'un nouveau tuple ajouté dans la relation source doivent déjà être présentes dans la relation cible." markdown="span" type="primary" %}

Nous verrons, qu'en plus, la relation contenant les attributs cible doit exister avant la création de la contrainte sur la relation source, et symmétriquement, la relation source devra être supprimée avant la relation cible. De plus, les tuples qui sont référencés par d'autres tuples ne peuvent pas, par défaut, être supprimés et les valeurs référencées ne peuvent pas être modifiées.

#### Relation *Groupe*

  | numéro   | nom      | siège social
  | -------- | ----------|  --------
  | 1        | Fuilo    |  BREST   
  | 2        | Smart group    |  PARIS   
  | 3       | Indi 4.0   |  Londres     

#### Relation *Client*

  | numéro   | nom       | ville     | téléphone        | grp
  | -------- | ----------|  -------- | ---------------- | -------
  | 2        | DURANT    |  BREST    | 02 12 34 56 78   | 1
  | 6        | MARTIN    |  PARIS    | NULL             | 1
  | 22       | BERNARD   |  NICE     | 04 98 76 54 32   | NULL
  | 54       | FONTAINE  |  RENNES   | NULL             | 3

{% include callout.html content="**Exemple**<br/>Complétons notre exemple précédant en considérant qu'un client peut faire partie d'un groupe.<br/> On stocke dans deux relations distinctes des clients et des groupes. Pour indiquer qu'un client fait partie d'un groupe, on ajoute un lien entre les relations *Client* et *Groupe*. Dans la relation *Client*, il suffit d'indiquer l'identifiant unique du groupe (c.-à-d. sa valeur sur la clef primaire) auquel il appartient. Dans la relation *Client* ainsi modifiée, on ajoute donc un attribut `grp` sur lequel on définit une contrainte de clef étrangère qui fait référence à l'attribut `numéro` de la relation *Groupe*.<br/>Si on essaie de modifier la valeur `grp` du client 54 de *3* à *4*, le système refusera car la référence n'est pas cohérente dans la mesure où il n'existe pas de groupe d'identifiant *4*. De même, il est possible, en l'état, de supprimer le groupe *2* mais pas *3* car il est référencé par au moins un tuple." markdown="span" type="success" %}

Dans un schéma relationnel, il est souvent convenu que les attributs sur lesquels une contrainte d'intégrité référentielle est défini soient précédés par un dièse \# (que vous appelez hashtag), d'où *Client {<u>numéro</u>, nom, ville, téléphone, \# grp}*. Cette syntaxe n'est pas idéale car on ne sait pas à quel attribut `grp` fait référence, c'est pourquoi ces contraintes sont généralement explicitées en langue naturelle en complément du schéma.

## Intégrité utilisateur

Il est également possible de définir des contraintes spécifiques à une application. Ces contraintes ne font pas partie du modèle relationnel mais un SGBDR permet de les définir à l'aide de langages de manipulation de données (par exemple plsql, pgsql, etc.) et de les contrôler. Par exemple, on pourrait vouloir limiter le nombre de clients d'un groupe à 50.


{% include important.html content="Une BD est dite cohérente si à un instant donné toutes les contraintes d'intégrité sont respectées. C’est le SGBD qui vérifie ces contraintes pour maintenir la cohérence (Atomicité **Cohérence** Isolation Durabilité)." %}

<!-- **Pour continuer ...** vous pouvez apprendre à utiliser un [langage déclaratif de manipulation de données](activity_sql.html) (SQL) comprendre les propriétés d'[atomicité](lecture_transaction.html) et d'[isolation](lecture_isolation.html) également assurées par un SGBDR." %} -->
