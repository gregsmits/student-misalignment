---
title: Une brève introduction à Java Spring
keywords: Java, Spring
toc: true
sidebar: technical_environment_sidebar
permalink: documentation_programming.html
summary: "Spring est un framework Java facilitant et accélérant le développement d'applications. Associé à Spring boot pour automatiser la configuration d'applications, Spring propose des solutions aux différents besoins liés à la construction d'applications modernes : web, cloud, sécurité, persistence des données, etc."
---

## Le framework Spring

_Java 2 Platform Enterprise Edition_ (J2EE), puis _Java EE_ et maintenant _Jakarta EE_, est une spécification qui a été longtemps un standard pour le développement d'applications, notamment web, dans des milieux professionnels. Une application web Jakarta EE s'appuie sur un serveur d'applications (par exemple Glassfish, Wildfly, etc.) dont le rôle est de fournir un environnement d'exécution pour l'application. Pour qu'une application puisse être déployée sur un tel serveur il faut qu'elle satisfasse une spécification stricte, sur la structuration du code notamment (paquetages .ear, .war) et la présence d'une configuration précise (fichier _WEB_INF/web.xml_). Une des principales critiques aux implémentations de cette spécification (aux serveurs d'applications) est leur _lourdeur_ : elles sont tellement complètes qu'elles deviennent gourmandes en ressources et complexes à installer et maintenir.

En réponse à ces critiques, le framework Spring implémente une (petite) partie des spécifications Jakarta EE, celles qui sont nécessaires au développement _front-end_ d'une application web. Pour le reste, il offre ses propres implémentations qui, à la différence de Jakarta EE, sont basées sur un JDK standard. Une des conséquences de ces choix c'est que les applications web Spring peuvent être exécutées par un serveur d'applications Jakarta EE mais également par des serveurs web comme Tomcat (mais aussi Jetty par exemple).

<!--propose une implémentation d'une partie restreinte des spécifications Jakarta EE une solution plus légère puisqu'il est centré sur le développement d'applications web qui intègre les services nécessaires (un serveur web Tomcat exécuté automatiquement au démarrage d'une application web) à l'exécution de l'application tout en proposant des fonctionnalités pour déployer l'application dans d'autres contextes, comme par exemple dans un serveur d'applications ou dans le gestionnaire de type cloud.

Un principe important du développement d'applications avec Spring est de se focaliser sur le développement d'objets (Plain Old Java Objects) sans se focaliser de la façon dont ils seront exploités, rendant ainsi l'application plus modulaire. Par exemple, une méthode d'un objet pourra être invoquée dans une [transaction](transaction.html) de BD ou à distance par le réseau sans avoir à modifier son implémentation. -->

Voici ci-dessous un aperçu des principaux modules qui composent le framework Spring (ceux qui sont en rouge seront utilisés dans cette UV) :

![Les modules du framework spring](images/technical_environment/spring_modules.png)

{% include callout.html content="**Approfondissements**<br/><br/>
Pour une présentation plus complète de Java Spring, voici quelques liens et références supplémentaires :<br/>

- Java Spring (site officiel), [Why Spring?](https://spring.io/why-spring),<br/>
- Ouvrage sur le framework Spring : Walls, C. (2022). _Spring in action_. Simon and Schuster,<br/>
- Ouvrage sur Spring et le cloud : Carnell, J., & Sánchez, I. H. (2021). _Spring microservices in action_. Simon and Schuster." markdown="span" type="warning"%}
