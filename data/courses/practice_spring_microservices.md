---
title: "Développement d'une application web par micro-services"
keywords: Spring, micro-services
sidebar: web_architecture_sidebar
summary: L'objectif de cette activité pratique est de découvrir la structuration d'applications à l'aide de micro-services et de comprendre l'isolation des fonctionnalités.
toc: true
permalink: practice_spring_microservices.html
---


<!-- {% include callout.html content="**Pré-requis**<br/><br/>


- Maîtriser l'[environnement technique de développement](technical_environment_home.html)<br/>
- Connaître la notion d'architecture [technique N-tiers](lecture_technical_architecture.html) et [logicielle multi-couche](lecture_software_architecture.html)
- Connaître le modèle [MVC](lecture_mvc_spring.html)

" markdown="span" type="danger"%} -->

# Contexte de l'activité pratique

L'objectif de cette activité pratique est d'étudier la structuration d'une application web Spring reposant sur des micro-services. Vous partirez d'une ébauche d'application qui ne sépare pas complètement les différents micro-services puisqu'une BD partagée est utilisée. Vous complèterez tout d'abord les fonctionnalités de cette application pour ensuite opérer des modifications plus profondes sur l'architecture de l'application afin de rendre les micro-services complètement indépendants.


## Présentation de l'application

 Comme l'illustre la figure ci-dessous, le contexte applicatif est simple. Il s'agit de fournir des fonctionnalités de référencement de spectacles et de réservations de billets. Vous allez donc implémenter dans un premier temps deux services :
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

#### **Question 1**

Vous êtes familié avec la configuration des applications Spring (fichier `application.properties`).
Avant de pouvoir utiliser et tester ces applications, analysez les configurations des applications pour identifier le port associé aux applications `show_ms`, `booking_ms` et `webapp_serv`.

Déterminez également les informations de la base de données à laquelle les applications vont se connecter. 
Connectez-vous au service [pgadmin4](http://localhost:5051/browser/) pour créer la base de données nécessaire à l'exécution des applications.

Une fois la BD créée, exécutez les applications suivantes (`mvn spring-boot:run`) :
  1. `eureka_serv` 
  2. `show_ms`
  3. `booking_ms`
  4. `webapp_serv`

Pour vérifier le bon fonctionnement de ces applications, commencez par accéder au service [*Eureka*](http://127.0.0.1:8761/) et confirmer que les micro-services `show_ms` et `booking_ms` sont bien référencés au registre *Eureka*.

## Réservation de billets avec une BD partagée

Vous allez désormais ajouter une fonctionnalité au service `webapp_serv` afin de permettre la réservation de billets. Une réservation prend en entrée les informations suivantes :
  - un identifiant de spectacle,
  - un nom de la personne faisant la réservation,
  - un nombre de places.
  
Une réservation doit être une opération atomique consistant à :

  1. vérifier qu'un spectacle existe avec cet identifiant,
  2. vérifier qu'il reste suffisamment de places pour honorer la réservation,
  3. insérer une nouvelle réservation,
  4. décrémenter le nombre de places disponibles pour le spectacle.

Une réservation doit donc être réalisée dans un contexte transactionnel qui doit encapsuler toutes les opérations nécessaires à la mise en place de la réservation. Vous devez vous assurer des règles de cohérence suivantes :

- une réservation concerne un spectacle existant,
- une réservation est validée si le nombre de places restantes pour le spectacle est supérieur au nombre de sièges demandés.


Pour le moment, garantir la cohérence des données de la base est assez simple car elle est partagée entre les micro-services `showms` et `bookingms`. Il suffit en effet de regrouper l'ensemble de ces quatre actions dans un même contexte transactionnel.

#### **Question 2**

Vous trouverez dans le contrôleur `fr.imt_atlantique.inf210.webappserver.controller.MainController` un exemple de code pour interroger le serveur *Eureka* afin de récupérer l'uri des micro-services auxquels on souhaite accéder.

Complétez l'application afin de pouvoir effectuer des réservations depuis un service fourni par l'application `webapp_serv`. 

