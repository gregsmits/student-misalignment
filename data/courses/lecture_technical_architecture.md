---
title: Architectures techniques des applications web
keywords: n-tiers, architecture technique, cloud,
toc: false
sidebar: web_architecture_sidebar
permalink: lecture_technical_architecture.html
summary: Le déploiement d'une application s'effectue sur une architecture technique, notamment pour disposer des services nécessaires. Cette partie du cours est dédiée à une présentation des différentes solutions techniques envisageables, leurs avantages et limites.
---

<!-- Objectifs pédagogiques

- expliquer la notion d'architecture technique et la distinguer de celle d'architecture logicielle
- donner des exemples de services utilisés couramment par les applications web et expliquer pourquoi l'exemple donné est un service
- expliquer la notion de _tier_ des architectures N-tiers et indiquer et justifier quels éléments(s)/technique(s) joue(nt) ce rôle dans l'UV INF210
- expliquer les avantages et inconvénient des architectures 3-tier par rapport aux 2-tiers et 1-tier -->

## Quelques notions d'architecture technique

Le terme d'**architecture technique** d'une application désigne l'ensemble des éléments matériels et logiciels nécessaire à l'exécution de l'application.

Lorsque l'on développe une application, on s'appuie (au maximum) sur des services existants. Un **service** est une application dédiée à une tâche qui peut être sollicitée à la demande, souvent via un protocole de communication. Pour le développement d'une application web, on a souvent besoin de disposer de services :

- de stockage de données persistantes
- de gestion des composants logiciels
- de contrôle de l'interface web

D'autres services peuvent être nécessaires à une application, comme un service d'indexation des données (par exemple [Elastic Search](https://www.elastic.co/fr/elasticsearch)), de supervision (par exemple [dynatrace](https://www.dynatrace.com/)) ou des services plus spécifiques pour piloter un robot, etc.

Un service doit donc pouvoir être utilisé à la demande par l'application. Cette application joue ainsi un rôle de client pour les services qu'elle utilise. La notion d'architecture _clients/serveur_ est donc prépondérante dans la structuration des dépendances entre composants d'une solution logicielle. La figure ci-dessous illustre le principe général d'une architecture clients/serveur sur le cas des communications entre des clients et un service de gestion de bases de données.

![Architecture clients serveur](images/web_architecture/clients_server.png)

## Architecture N-tiers

Une application, notamment web, repose donc généralement sur un ensemble de services nécessaires au bon fonctionnement global. Chaque service déployé s'appuie forcément sur des éléments matériels, possiblement virtualisés, pour disposer de capacités de calcul, de stockage et de communication.

On appelle _tier_ un élément d'une architecture technique fournissant des capacités de calcul, de stockage et/ou de communication, qui sont nécessaires à l'exécution d'applications et de services. Dans l'UV INF 210, un _container Docker_ joue le rôle de _tier_ car il offre un contexte d'exécution indépendant et dédié à une tâche.

Une première solution consisterait à exécuter l'application développée et l'ensemble des services mobilisés sur un unique _tier_, on parle alors d'architecture 1-tier. Évidemment, cette structuration a de nombreuses limites et notamment de dépendre d'un seul élément matériel pour l'exécution de tous les services. Ceci s'écarte du principe de [séparation des responsabilités](web_architecture_home.html) qui vise, au niveau technique, à exécuter/isoler chaque service sur un _tier_ dédié.

Afin d'améliorer la robustesse de l'architecture technique et surtout son évolutivité (changer le système d'exploitation, le média de stockage, l'organe de calcul d'un service), il est donc d'usage de déployer l'application et les services sur plusieurs _tiers_.

L'illustration ci-dessous schématise une architecture _3-tiers_ avec trois services logiciels :

- _DB Management service_ qui est consacré à l'hébergement du service de gestion des données persistantes,
- _Application management server_ qui est consacré à la gestion de l'exécution des composants logiciels de l'application. Dans le cadre des applications Web, ce service est souvent désigné sous le terme _serveur d'applications_ (Spring, WildFly, JBoss ou encore Tomcat en sont des exemples),
- _Web server_ qui s'occupe de la gestion des interactions web via le protocole de communication HTTP (Apache HTTP Server ou NGINX en sont des exemples).

![Architecture trois tiers](images/web_architecture/ntiers.png)

Dans le cadre des applications web de l'UV INF210, l'architecture utilisée sera de type _2-tiers_ où la gestion des interactions avec les clients ainsi que la gestion des composants logiciels des applications seront assurées par le même serveur.

![Architecture deux tiers](images/web_architecture/2tiers.png)

<!-- # Architecture Spring pour le développement

Dans le cadre des applications web de l'UV INF210, l'architecture utilisée sera de type _2-tiers_ où la gestion des interactions avec les clients ainsi que la gestion des composants logiciels des applications seront assurées par le même serveur.

![Architecture deux tiers](images/web_architecture/2tiers.png)

Lorsqu'une application Spring de type web est démarrée, Spring démarre automatiquement un serveur Tomcat (ou Jetty) pour assurer la fonction de serveur Web.

Spring gère également le cycle de vie des différents composants logiciels de votre application, remplissant ainsi le rôle de serveur d'applications. Vous verrez que, moyennant quelques modifications de la configuration, une application Spring peut être déployée sur un serveur d'applications dit lourd (comme Glassfish, Wildfly, etc.).
 -->

## Les applications dans le cloud et les micro-services

Le principe de séparation des responsabilités au niveau de l'architecture technique va au delà de la séparation en _tiers_ où chaque _tier_ est dédié à un service majeur de l'application.

Nous verrons que la séparation des responsabilités au niveau logiciel conduira à un découpage en composants logiciels minimalistes en charge d'une fonctionnalité ciblée et indépendante. Pour tirer partie de ce découpage logiciel, les solutions en termes d'architecture logicielle ont fortement évoluées pour apporter davantage de flexibilité et de scalabilité (montée en charge).

Une solution qui devient un standard est de déployer une telle application dans une infrastructure technique (et logicielle) de type _cloud_. En fonction de la charge à supporter, en termes de requêtes clients, de taille des données, de temps des traitements, chaque _tier_ (processus indépendant dans l'architecture _cloud_) exécutant un composant logiciel peut être dupliqué. On aboutit ainsi à des architectures _N-tiers_. Un composant central d'une telle architecture logicielle s'occupe d'orchestrer les duplications ainsi que les redirections des requêtes vers les _tiers_ disponibles.

![Architecture N tiers pour le cloud et les micro-services](images/web_architecture/cloudArchitecture.png)
