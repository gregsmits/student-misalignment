---
title: Architectures microservice 
keywords: architecture logicielle, micro-services
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_software_architecture_microservices.html
summary: La structuration des applications web en micro-services devient incontournable pour gérer des applications destinées à des usages massifs et voués à évoluer. Le principe des ces architectures est de regrouper les fonctionnalités par services qui doivent être développés de manière la plus indépendante possible.
---

<!-- Objectifs pédagogiques

- expliquer la notion d'architecture logicielle et la distinquer de celle d'architecture technique
- expliquer le rôle des différentes couches dont repose souvent la structure d'une apoplication web
- expliquer la notin de patron de conception et son intérêt dans le developpement logiciel
- expliquer le patron MVC et le positionner par rapport aux 3 couches d'une application
- expliquer la notion d'architecture par micro-services -->

Une application web d'ampleur est vouée à évoluer en termes de fonctionnalités tout d'abord et d'usage. Il est souvent difficile de prévoir la charge de chaque service (nombre de requêtes) et donc de dimensionner l'architecture physique qui supporte le logiciel.
C'est pour répondre à cette nécessaire évolutivité fonctionnelle et d'efficacité que les architectures par micro-services se sont développées.


## Les architectures par micro-services

Pour répondre à des besoins de flexibilité et de passage à l'échelle (capacité à gérer des l'audemandes et des données de volumes croissants), les architectures logicielles et techniques (notamment le cloud) ont évolué en parallèle. Le principe central reste celui de la séparation des responsabilités, mais en allant encore plus loin dans le découpage des responsabilités. Les architectures logicielles dites par micro-services visent à isoler chaque service (ensemble cohérent de fonctionnalités sur un composant). Ainsi, chaque micro-service peut être déployé sur un élément de traitement (_thread_, processus, _container_, VM, etc.). Les technologies du *cloud* constituent alors un réceptacle parfait pour ce genre de structure logicielle. Un service est exécuté par une ressource matérielle (souvent un conteneur) et son indépendance fait qu'il peut être dupliqué à volonté pour répondre à une hausse des demandes, où bien voir ses ressources de calcul et de stockage évoluer dynamiquement.

Concevoir une architecture par micro-services ou bien passer d'une application monolitique à un ensemble de services nécessite de:
- décomposer la couche métier en services indépendant,
- gérer les requêtes et les partages de données entre services.

Si le découpage en micro-services offre une large souplesse d'extension des fonctionnalités et de gestion des capacités de traitement de chaque service, il implique aussi une gestion particulière des fonctionnalités métiers et des transactions inter-services.


![Micro-services](images/web_architecture/microservices_base.png)

### Conception d'architectures micro-service

Choisir quelles fonctionnalités regrouper au sein d'un service et déterminer les limites de ces services est la clef pour garantir une structuration par micro-services pertinente. Voici quelques principes communs aux différents patrons:
 - un service doit regrouper un petit nombre de fonctionnalités liées,
 - les fonctionnalités et méthodes qui évoluent ensemble doivent être regroupées pour réduire le nombre de services concernés par une évolution,
 - les services doivent être le moins couplés possibles à nouveau pour éviter d'avoir à répercuter les évolutions d'un service sur les autres, ceci permet également de garantir des temps de réponse bas,
 - chaque service doit pouvoir être testé indépendamment.

La conception d'une architecture par micro-services s'appuie généralement sur le découpage en activités métiers, où les services suivent l'organisation de l'entreprise ou de son activité (ex. : un service pour la gestion du catalogue produit, la gestion des commandes, la gestion des livraisons, etc.).

Lorsque l'on veut passer d'une application monolitique à une application en micro-services, l'approche préconisée est d'extraire un par un les services du bloc monolitique pour les isoler.

### Gestion des données dans une architecture micro-service

Un microservice est donc responsable d'un ensemble de fonctionnalités et des données afférentes. La question de la séparation des données a une implication très forte sur les implémentations des services. Plusieurs stratégies peuvent être envisagées :

- une base de données par service pour stocker uniquement les données manipulées par le service.
    - séparation rigoureuse des responsabilités,
    - maintient des propriétés ACID de la BD,
    - mais gestion délicate des transactions inter-services, imaginez par exemple la réservation d'une place de spectacle qui doit solliciter les services dédiés aux clients, à la billetterie et au paiement.
- une base de données partagée entre services.
    - gestion simplifiée des transactions inter-services et réduction des communications (par API) entre services,
    - protection des données des autres services en définissant un utilisateur (i.e. rôle) ou un schéma de BD par service et en accordant uniquement un accès en lecture aux données non gérées par le service,
    - mais perte de la flexibilité d'évolution des services.


### Gestion des transactions inter-services


Une architecture par micro-services reposant également sur une séparation rigoureuse des données avec une BD par service nécessite une gestion particulière des transactions couvrant plusieurs services.

Le patron de conception **saga** fournit une solution à ce problème. Il consiste à gérer les transactions locales sur chaque service et le passage de messages entre les services pour assurer la cohérence globale des données. Chaque service gère sa transaction locale et informe les services concernés en cas de succès ou d'échec. Deux implémentations de cette stratégie sont généralement envisagées. Dans le mode chorégraphie, à la fin d'une transaction locale, le micro-service informe directement les micro-services concernés qu'une étape de la chaîne de transactions est réalisée, l'étape suivant commence à réception de ce message. Dans un mode orchestré, c'est un gestionnaire centralisé qui invoque les étapes successives de la chaîne de transaction.

Voici un exemple avec une application composée d'un service recevant des commandes de billets. Il doit demander au service des billets s'il y a suffisamment de billets disponibles, puis demander le paiement pour finalement confirmer la réservation. Voici une image de ce flux de travail où vous pouvez remarquer la présence de points d'entrée à chaque service pour confirmer à la fois le succès d'une transaction locale dépendante. Il faut évidemment prévoir également les cas d'erreur pour par exemple libérer des billets réservés si le paiement échoue.

![Micro-services](images/web_architecture/saga.png)


Une alternative au patron **saga** est de construire un service de composition. Son rôle est de recevoir les requêtes puis d'interroger les services concernés et d'agréger en mémoire les résultats qu'il reçoit.

### Gestion des services

Un intérêt des architectures par microservices est de pouvoir dupliquer, remplacer, mettre en pause des micro-services.
La question se pose alors de fournir à chaque  micro-service un service d'annuaire pour leur permettre de récupérer l'emplacement (IP, port) des micro-services avec lesquels ils doivent interagir. C'est le rôle d'un **service de découverte (Service Discovery)**.

Le service le plus utilisé, notamment dans les développement Java Spring, est le service **Eureka** implémenté et partagé en open source par la société Netflix. 
Eureka est un serveur qui fournit aux clients les fonctionnalités suivantes :
- enregistrer des services (registration),
- découvrir les services disponibles (discovery),
- gérer la dynamique (services qui arrivent/disparaissent).

Un micro-service s'enregistre auprès du serveur Eureka puis lui confirme sa disponibilité à intervalles réguliers.


## Les principes de communication REST

Lorsque que l'on veut fournir des moyens de communication dits synchrones entre (micro-)services et éventuellement des clients, il est nécessaire de fournir des points d'entrée de communication. Ces points d'entrée sont ensuite reliés à des fonctionnalités de la couche métier.

L'approche prédominante dans les applications web pour fournir un accès aux fonctionnalités de la couche métier est d'exposer une API (Application Programming Interface) REST (Representational State Transfer). 

REST n'est ni un protocole de communication, ni un cadre de développement mais un ensemble de principes à respecter pour garantir trois propriétés importantes à votre implémentation : Simplicité, fiabilité et évolutivité.

La simplicité vient du fait que chaque fonctionnalité exposée par le serveur à travers son API est associée à un "point d'entrée" (endpoint) défini via une URL. La fiabilité est apporté par ce découpage en points d'entrée qui peuvent ainsi être testés indépendamment. L'évolutivité est également garantie par la possibilité de compléter, via des URL distinctes, les points d'entrée.

L'approche REST repose sur les principes suivants :
- architecture clients-serveur où le protocole [HTTP](https://fr.wikipedia.org/wiki/Hypertext_Transfer_Protocol) est utilisé pour communiquer, 
- communication sans-état (*stateless*), ce qui signifie que les requêtes sont traitées de manière indépendant sans conservation des données du client.
- utilisation d'un format de représentation des résultats des requêtes indépendant des langages de programmation utilisés par les clients et le serveur. [JSON](lecture_json.html) est souvent utilisé.

Un contrôleur REST est ainsi, comme l'illustre la figure ci-dessous, un ensemble de points d'entrées, souvent regroupés thématiquement.

![REST API](images/web_architecture/apirest.png)

## Les principes de communication asynchrone entre (micro-)services

Dans une architecture micro-services, la communication par messages et évènements permet aux services d’échanger des informations de manière asynchrone et découplée. Plutôt que d’appeler directement un autre service (comme avec une API REST), un micro-service publie un évènement lorsqu’une action importante se produit (par exemple la création d’une commande). Des outils comme Apache Kafka jouent alors le rôle de broker de messages : ils reçoivent ces évènements et les diffusent aux micro-services intéressés, appelés consommateurs. Dans les applications web basées sur Spring, notamment avec Spring Boot et Spring Kafka, chaque micro-service peut produire ou consommer des messages sans connaître les autres services, ce qui améliore la scalabilité, la résilience et la maintenabilité du système. Cette approche favorise une architecture orientée évènements, où les services réagissent aux changements plutôt que de dépendre directement les uns des autres.


![Architecture orientée évènements](images/web_architecture/archi_ms_evt.png)

{% include callout.html content="**Approfondissements** <br/><br/>Pour étudier plus en détails les différentes stratégies de conception d'architectures micro-service, consultez ce [site](https://microservices.io/). Afin de mieux documenter vos choix de conception d'API REST, il est nécessaire d'avoir recours à des [formalismes et des spécifications](https://www.openapis.org/). " markdown="span" type="warning"%}
