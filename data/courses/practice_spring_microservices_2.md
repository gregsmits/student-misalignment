---
title: "Développement d'une application web par micro-services"
keywords: Spring, micro-services
sidebar: web_architecture_sidebar
summary: L'objectif de cette activité pratique est d'étudier la gestion des accès aux données dans une architecture par micro-services où chaque micro-service n'a accès qu'à ses données. La communication entre les micro-services est synchrone et s'effectue via leur API REST respective.
toc: true
permalink: practice_spring_microservices_2.html
---


# Contexte de l'activité pratique

L'objectif de cette activité pratique est d'étudier la structuration d'une application web Spring reposant sur des micro-services. Vous partirez d'une ébauche d'application par micro-services partageant une même base de données pour opérer des modifications  afin de rendre les micro-services complètement indépendants.


## Présentation de l'application

 Comme l'illustre la figure ci-dessous, le contexte applicatif est simple et reprend celui de l'[activité d'initiation aux micro-services](practice_spring_microservices.html). Il s'agit de fournir des fonctionnalités de référencement de spectacles et de réservations de billets. Vous allez donc implémenter dans un premier temps deux services :
- un service de gestion des spectacles,
- et un service de réservation de billets.

![Architecture 1](images/web_architecture/microservices_architecture1.png)

La seule fonctionnalité à développer consiste à accepter des demandes de réservation de billets pour des spectacles.

La conception de l'application est perfectible, mais l'objectif est uniquement pédagogique. On considère qu'un spectacle (`show`) est décrit par un nom et un nombre de sièges restant. Une réservation (`booking`) est décrite par un identifiant de spectacle concerné, un nombre de places réservées et un nom de client. L'idée est de séparer les responsabilités des deux services. Le service `showms` s'occupe du spectacle et du nombre de places restantes, alors que le service `bookingms` stocke les réservations des clients.

### Mise en place de l'application

Dans l'archive que vous avez récupérée en début d'UV, nous allons travailler dans le répertoire `ms_shared_db`. Ce répertoire contient plusieurs applications Spring : 
  - `eureka-server` un service dédié à l'enregistrement des micro-services,
  - `show_ms` un micro-service dédié à la gestion de spectacles,
  - `booking_ms` un micro-service pour effectuer la réservation de billets,
  - `webappserv` qui expose(ra) des fonctionnalités web pour la gestion des spectacles et des réservations.

Vous devez exécuter les containers Docker de BD postgresql et pgadmin utilisés depuis le début de l'UE.


# Isolation des micro-services

Les micro-services présents dans l'application `ms_shared_db` ne sont pas complètement indépendants, ils partagent une même BD. Dans cette activité pratique, chaque micro-service deviendra indépendant et accèdera à sa propre BD contenant uniquement les données qui le concernent. Vous mettrez ensuite en place une gestion des transactions entre micro-services implémentant le patron de conception SAGA.


## Préparation de l'application

Vous aurez toujours besoin des containers Docker *postgres* et *pgadmin4*. Préparez l'application en effectuant les actions suivantes :
1. Recopiez le répertoire `ms_shared_db` que vous nommerez `ms_separated_dbs`.
2. Créez deux BD nommées `show_db` et `booking_db`.

## Exécution indépendante des micro-services

Votre répertoire `ms_separated_dbs` contient plusieurs applications : `eureka_serv`, `webapp_serv`, `show_ms` et `booking_ms`.

Vous pouvez exécutez l'application `eureka_serv` et accéder au service [*Eureka*](http://127.0.0.1:8761/).

#### **Question 1**

Avant de pouvoir exécuter les micro-services `show_ms` et `booking_ms`, vous devez modifier leur fichier de configuration respectif (`application.properties`) afin que chaque application se connecte à sa BD.

Une fois cette modification faite, exécutez les deux applications et vérifiez :

1. que les micro-services sont référencés auprès du service *Eureka*,
2. que dans les BD `show_db` et `booking_db`, une table a été créée (table `show` dans la BD `show_db` et table `booking` dans la bd `booking_db`).

## Gestion des transactions entre micro-services

Les micro-services étant désormais indépendants d'un point de vue base de données, la gestion d'une réservation doit désormais être gérée avec précaution pour garantir l'intégrité des données stockées dans les deux BD. Vous allez désormais implémenter le patron de [conception SAGA](lecture_software_architecture_microservices), en mode orchestré, pour synchroniser des transactions locales aux deux micro-services.

Vous allez procéder à une implémentation du patron SAGA *from scratch*. Ceci n'est pas préconisé pour une application professionnelle dans la mesure où des framework comme [AXON](https://docs.axoniq.io/axon-framework-reference/4.12/sagas/) existent. D'un point de vue pédagogique, il sera intéressant cependant de l'implémenter et de comprendre un principe important qui est de prévoir dans chaque service des méthodes de modification compensatoires dites idempotentes. Deux méthodes sont dites idempotentes si l'action de l'une sur les données peut être annulée par l'autre. Ainsi, `methode_action();methode_compensation();` remettra l'application dans l'état où elle se trouvait avant l'exécution de la méthode `methode_action();`.

#### **Question 2**

La figure ci-dessous illustre le protocol de gestion des transactions que vous allez mettre en place. 
![Transaction micro-services](images/web_architecture/transaction_ms.png)

##### Micro-service `show_ms`

Définissez deux points d'entrée dans le contrôleur du micro-service `show_ms` pour :

- réserver des places, l'annotation à utiliser pour déclarer ce point d'entrée est le suivant,

```java
@PatchMapping("/reserveseats/{id}/{nbseats}"))
```

- libérer des places.

```java
@PatchMapping("/freeseats/{id}/{nbseats}"))
```

Puis, complétez le service associé pour implémenter ces deux opérations idempotentes.
Procédez au test de ces fonctionnalités indépendamment, par exemple à l'aide des commandes `curl` suivantes:

```bash
curl --request PATCH http://localhost:8083/reserveseats/1/5
curl --request PATCH http://localhost:8083/freeseats/1/5
```

##### Micro-service `booking_ms`


Définissez deux points d'entrée dans le contrôleur du micro-service `booking_ms` pour :

- sauvegarder une réservation,

```java
@PostMapping("/save/{showId}/{nbSeats}/{clientName}")
```

- annuler une réservation.

```java
@DeleteMapping("/delete/{id}"))
```

Puis complétez le service associé pour implémenter ces deux opérations idempotentes.
Procédez au test de ces fonctionnalités indépendamment, par exemple à l'aide des commandes `curl` suivantes:

```bash
curl -X POST http://localhost:8082/save/1/2/JohnDoe
curl --request DELETE http://localhost:8083/delete/4
```

##### Service `webapp_serv`

L'implémentation du patron SAGA sera réalisée via une classe `Service` de l'application `webapp_serv`
Procédez à cette implémentation en deux temps :

1. Ajoutez un point d'entrée au contrôleur de l'application `webapp_serv` pour traiter des requêtes client de réservation, par exemple, en récupérant des requêtes au format suivant :
```java
@PostMapping("/newbooking/{showid}/{nbseats}/{clientname}")
```

2. Dans une classe de type `Service` implémentez la méthode de gestion de la réservation qui respectera le protocole illustré précédemment. Pensez à isoler chaque étape du protocol dans une méthode dédiée.

Afin de pouvoir tester la bonne gestion des transactions locales aux différents micro-services, générez aléatoirement des exceptions lors de la sauvegarde des réservations. Ces exceptions doivent, selon le protocole SAGA défini, conduire à la libération des sièges qui avaient été pré-réservés pour le spectacle.
