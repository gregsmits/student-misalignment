---
title: Architectures logicielles des applications web
keywords: couches logicielles, architecture logicielle, MVC
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_software_architecture.html
summary: L'architecture logicielle fait référence au découpage et à l'organisation de l'application. Dans le cadre du développement d'applications web, cette architecture logicielle repose souvent sur plusieurs couches inter-connectées et assumant chacune des responsabilités spécifiques.
---

<!-- Objectifs pédagogiques

- expliquer la notion d'architecture logicielle et la distinquer de celle d'architecture technique
- expliquer le rôle des différentes couches dont repose souvent la structure d'une apoplication web
- expliquer la notin de patron de conception et son intérêt dans le developpement logiciel
- expliquer le patron MVC et le positionner par rapport aux 3 couches d'une application
- expliquer la notion d'architecture par micro-services -->

## Les architectures multi-couches

Les applications, et notamment web, reposent souvent sur une structuration articulée autour de trois couches, chacune responsable d'une partie de l'application :

- la **couche présentation** qui gère l'interface graphique et les interactions avec les utilisateurs
- la **couche métier** (ou application) est le cœur de l'application qui reçoit les requêtes et données depuis la couche présentation, effectue les traitements en s'appuyant sur les données stockées et retourne les résultats à la couche présentation
- **la couche données** qui gère la persistance des données (dans le SGBDR dans notre cas)

L'architecture logicielle en trois couches est ainsi souvent schématisée de la manière suivante :

![Architecture logicielles multi-couches](images/web_architecture/nlayers2.png)



## Les patrons de conception

La décomposition fonctionnelle multi-couches d'une application offre un guide pour structurer l'application à un niveau macro. Cependant, de nombreux problèmes de conception apparaissent au sein d'une couche, pour la définition d'un service ou d'un composant. Les problèmes que vous aurez à résoudre auront sans doute déjà été abordés par d'autres développeurs. Les **patrons de conception** constituent des solutions génériques à des problèmes identifiés. Voici trois exemples de problèmes et de patrons pour les résoudre :

- le patron _Singleton_ offre une solution conceptuelle pour garantir que dans une application, une seule instance d'une classe sera disponible. Pour plus d'informations sur le patron _singleton_, voir [ici](https://refactoring.guru/design-patterns/singleton)
- le patron _Fabrique_ vise à fournir une fonctionnalité (une fabrique) qui retournera des objets en fonction du type demandé. Par exemple, en fonction d'un paramètre fourni à la fabrique, un objet de type _ServiceEntreprise_, _ServiceEmployee_, _ServiceProduct_, etc. sera renvoyé. Ces différents types implémentant un même type abstrait ou une interface. Pour plus d'informations sur le patron _fabrique_, voir [ici](https://refactoring.guru/fr/design-patterns/factory-method)
- le patron _DAO_ (_Data Access Object_) vise à rendre la couche métier indépendante des opérations de _bas niveau_ de la couche données. Il consiste à définir un équivalent sous forme d'objet (en mémoire) d'une donnée (c.-à-d. un tuple) stockée dans la couche données et les opérations minimalistes _Create_, _Retreive_, _Update_ et _Delete_ pour manipuler ces objets. Pour plus d'informations sur ce patron, voir [ici](https://www.digitalocean.com/community/tutorials/dao-design-pattern)

### Le patron de conception MVC

Un des plus célèbres patrons de conception est le MVC (Modèle — Vue — Contrôleur). Son but est de séparer la logique du code en trois parties :

- le _Modèle_ : cette partie comprend la couche données et métier. Son objectif est de fournir une interface d’action la plus simple possible,
- la _Vue_ : cette partie regroupe l'ensemble des fonctionnalités de présentation nécessaires pour construire l'interface graphique (web ou autre) avec laquelle le client va interagir. La vue désigne par exemple les pages _JSP_ (_servlet_) permettant la génération des pages HTML rendues à l'utilisateur,
- le _Contrôleur_ : cette partie gère les échanges avec le client. C’est en quelque sorte l’intermédiaire entre le client, le modèle et la vue. Le contrôleur va recevoir des requêtes du client. Pour chacune, il va demander au modèle d’effectuer certaines actions (lire des articles de blog depuis une base de données, supprimer un commentaire) et de lui renvoyer les résultats (la liste des articles, si la suppression est réussie). Puis il va adapter ce résultat et le donner à la vue. Enfin, il va renvoyer le réponse, générée par la vue, au client.

<!-- La décomposition fonctionnelle du code en couches (présentation, application, données) est inhérente au framework Spring, notamment lors de l'utilisation du module web. La structuration d'une application Spring web repose également sur trois niveaux ayant respectivement les responsabilités de gérer les données, le traitement sur les données et la présentation des données et traitement aux utilisateurs. Ce guide de structuration implémente le modèle dit Modèle-Vue-Contrôleur (MVC) : -->

<!-- - le _modèle_ est l'ensemble des classes de l'application visant à représenter (modéliser) les données de l'application. Le modèle intègre également les traitements effectués sur ces données (logique métier).
- la _vue_ regroupe l'ensemble des fonctionnalités de présentation nécessaires pour construire l'interface graphique (web ou autre) avec laquelle le client va interagir. La vue désigne par exemple les pages _JSP_ (_servlet_) permettant la génération des pages HTML rendues à l'utilisateur
- le _contrôleur_ est l'élément central car il est sollicité par la vue pour effectuer des traitements, il invoque les modèles concernés et les retourne à la vue -->

![Schéma du modèle MVC](images/web_architecture/mvc.png)


{% include callout.html content="**Approfondissements** <br/><br/>Voici un point d'entrée vers plusieurs [patrons de conception](https://fr.wikipedia.org/wiki/Patron_de_conception) (logicielle ou architecturale). La conception d'architectures logicielles destinées au *cloud* s'appuie sur les micro-services et les contrôleurs REST, [Spring cloud](https://spring.io/projects/spring-cloud) est un composant dédié du framework." markdown="span" type="warning"%}
