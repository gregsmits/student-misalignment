---
title: "Activité pratique sur le test de Spring JPA"
keywords: ORM, JPA, hibernate,
sidebar: web_architecture_sidebar
summary: Au cours de cette activité, vous allez définir un mapping entre les classes de votre application et une base de données relationnelles fournie.
toc: true
permalink: practice_spring_tests.html
---

# Déroulement de l'activité

L'objectif de l'activité est de tester les fonctionnalités d'une application qui vous est donnée.

# Contexte de l'activité pratique

Au cours de cette activité, vous allez utiliser le projet Spring *gatewayband* fourni dans l'[environnement de développement dockerisé](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment), environnement que vous avez dû déjà mettre en place et tester précédemment.

## Le projet *gatewayband*

Pour appréhender les tests JPA avec Spring Boot, vous utiliserez l'application *Gateway Band* (projet *gatewayband*). Il s'agit d'une application simplifiée qui permet à ses utilisateurs de suggérer des « tubes » pour des artistes. Si vous êtes fan des Beatles par exemple, vous pourriez suggérer peut-être *« Hey Jude »* ou *« Let It Be »*, par exemple. Ainsi, si d'autres utilisateurs se demandent quelle(s) chanson(s) ils devraient écouter pour se faire une idée de ce qu'est *Les Beatles*, ils peuvent consulter l'application pour savoir quels sont les « tubes » du groupe.

### Les classes de l'application

L'application *gatewayband* comporte plusieurs éléments (cf. figure ci-dessous):

- les artistes (`Artist`) et les chansons (`Song`) qui sont des entités JPA,
- deux *repositories* JPA, un par entité,
- l'interface `MusicService` qui regroupe l'ensemble de fonctionnalités que l'application offre,
- la classe `BaisMusicService` qui implémente l'interface précédente,
- l'interface `Normalizer` et une implémentation `TrimLowerCaseNormalizer` pour *standardiser* les noms (d'artistes et de chansons) manipulés par l'application.

{% include image.html file="web_architecture/gatewaybandClasses.png" alt="Diagramme de classes de l'application Gateway Band" caption="Figure 1 - Diagramme de classes de l'application Gateway Band" %}


### Organisation des sources

Les sources de l'application (`src/main`) sont composées des répertoires et ﬁchiers suivants :

- le paquetage `model`. Vous y trouverez les entités manipulées par l'application, `Artist.java` et `Song.java` ;
- le paquetage `repositories` qui contient les *repositories* JPA pour manipuler les entités ;
- le paquetage `services` qui contient la classe et l'interface offrant les fonctions de l'application ;
- le paquetage `utils` qui contient l'outil pour faciliter la gestion des noms ;
- le ﬁchier `application.properties` se trouve dans le répertoire `src/main/resources/`. Il décrit la connexion à la base de données et des paramètres pour configurer JPA.

La fichier `pom.xml`, à la racine de l'application, contient les dépendances minimales permettant de construire l'application et d'exécuter des tests.

### Les traitements eﬀectués

Les traitements eﬀectués par l'application sont très simples :

- Récupérer les chansons d'un artiste, classées par popularité (la chanson la plus populaire
est le meilleur « tube »)
- Récupérer le nom de toutes les chansons d'un artiste dont le préfixe est donné 
- Récupérer le nom de tous les artistes dont le préfixe est donné
- Récupérer les artistes qui ont une chanson donnée
- Récupérer une chanson particulière d'un artiste
- Enregistrer une nouvelle chanson pour un artiste donné
- Voter pour une chanson comme « tube » pour un artiste donné
- Supprimer une chanson du répertoire d'un artiste
- Supprimer un artiste 

## Exercices

### Exercice 1 (Tests unitaires avec JUnit)

Dans cet exercice vous allez écrire les tests nécesaires pour vérifier si la classe `TrimLowerCaseNormalizer.java` fonctionne correctement. Vous trouverez sa spécification directement dans le code de la classe. Comme il s'agit d'une classe qui est complétement indépendante du reste de l'application et de Spring lui même, vous aurez uniquement besoin d'utiliser la librairie JUnit 5.

##### **Question**
Quels sont les cas de test à implémenter ?

##### **Question**

Modifiez le fichier `pom.xml` pour que les seuls tests exécutés soient ceux que vous venez d'écrire.


### Exercice 2 (Tester les *repository* JPA)

Maintenant que la classe utilitaire est opérationnelle, vous allez tester les deux *repositories* disponibles dans l'application. N'oubliez pas d'ajouter les classes de test dans le bon répertoire dans la hiérarchie du projet. Commencez par écrire et exécuter les tests de `ArtistRepository`. Modifiez le fichier `pom.xml` pour mettre en place le *test slicing* pour la partie JPA.


### Exercice 3 (Tester la couche services)

La dernière étape de test de cette application correspond aux tests de la couche services. Pour notre application elle est constituée d'une seule classe, `BaseMusicService`. Vous trouverez sa spécification directement dans le code de la classe. Vous allez tester cette classe en deux étapes : les tests unitaires puis les tests d'integration.

#### Tests unitaires
Ecrivez les tests unitaires de la classe `BaseMusicService`. Vous devez *mocker* toutes les dépendances de la classe et les injecter dans la classe à tester. Utilisez pour cela la librairie Mockito. Organisez vos sources de test de sorte que vous puissiez utiliser la notion de `profile` de Maven pour mettre en place du *test slicing*.

#### Tests d'integration
Ecrivez les tests d'integration de la classe `BaseMusicService`. Organisez vos sources de test de sorte que vous puissiez utiliser la notion de `profile` de Maven pour mettre en place du *test slicing*.