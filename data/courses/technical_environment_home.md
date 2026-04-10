---
title: Environnement technique
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: false
sidebar: technical_environment_sidebar
permalink: technical_environment_home.html
summary: "Cette page vous présente les deux principaux composants logiciels utilisés, à savoir : le framework Java Spring et le système de gestion de bases de données PostgreSQL."
---

# Structuration de la partie Environnement technique

<a target="_blank" href="images/prerequisite_techenv/prerequisite_techenv_2025.html"><img border=0 title="Clicker pour agrandir" src="images/prerequisite_techenv/prerequisite_techenv_2025.png"></a>

L'Unité de Valeur (UV) INF 210 se focalise sur le développement d'applications web dynamiques, c.-à-d., des applications web qui génèrent et affichent du contenu dynamiquement en réponse aux interactions de l'utilisateur. De nombreux principes qui sont abordés dans l'UV (architecture, patrons de conception, persistance des données, etc.) sont indépendants du langage de programmation et des technologies utilisées. L'ensemble des développements réalisés s'appuiera cependant sur deux technologies :

- le framework Java Spring,
- le Système de Gestion de Bases de Données Relationnelles (SGBDR) PostgreSQL.

## Java Spring et le développement web

### En quelques mots ...

Spring est un framework, un ensemble de fonctionnalités, visant à simplifier le développement d'applications, souvent orientées web. Son rôle est de gérer les différents composants d'un logiciel. Il constitue une alternative aux technologies implémentant les spécifications Jakarta EE (anciennement Java EE) dont la gestion des composants logiciels doit être confiée à un serveur d'applications dédié (par exemple _Glassfish_, _JBoss_, _WildFly_, etc.).

La figure ci-dessous illustre les différents modules fournis par le framework Spring avec un encadré rouge pour ceux qui seront utilisés dans cette UV.

![Les principaux modules du framework Spring](images/technical_environment/spring_modules.png "Les principaux modules du framework Spring")

Spring Boot est une extension de Spring permettant d'automatiser la configuration d'une application. Cette simplification de la création d'applications Java est notamment illustrée par l'outil [Spring Initializr](https://start.spring.io) qui permet de paramétrer et générer un squelette complet d'application.

Cette UV ne se veut pas être une formation à Spring mais bien aux principes de développement d'une application web professionnelle. Nous aurions pu utiliser une autre technologie comme un serveur d'applications Jakarta EE, Python Django, Javascript Node.js ou PHP. Voici donc quelques références pouvant s'avérer utiles si vous souhaitez approfondir vos connaissances sur le framework Spring :

- le framework Spring <https://docs.spring.io/spring-framework/docs/current/reference/html/index.html>
- Spring Boot <https://docs.spring.io/spring-boot/docs/current/reference/html/>

Et voici deux ouvrages qui ont été exploités pour préparer les contenus de l'UV :

- Walls, C. (2022). Spring in action. Simon and Schuster.
- Carnell, J., & Sánchez, I. H. (2021). Spring microservices in action. Simon and Schuster.

## PostgreSQL

Comme mentionné plus haut, les applications web que vous allez développer vont manipuler des données dont la persistance sera confiée à un SGBDR, PostgreSQL dans notre cas. Les principes de développement d'applications web vus dans cette UV sont indépendants de ce choix technologique.

### En quelques mots ...

PostgreSQL est un service, c'est-à-dire un programme qui permet à des logiciels clients de se connecter (via un protocole bien défini) pour utiliser les fonctionnalités qu'il offre. Dans le cas de PostgreSQL, il s'agit de fonctionnalités de manipulation de données telles que :

- l'authentification et la gestion des droits d'accès aux données,
- la gestion des bases de données (regroupements cohérents et indépendants de données),
- l'interrogation des données stockées,
- etc.

La notion de service est importante dans le cadre de cette UV puisque PostgreSQL pourra être exécuté par un _tier_ (cette notion est abordée dans les ressources sur les [architectures web](web_architecture_home.html)) dédié à la persistance des données.

![Service Postgresql](images/technical_environment/service_db.png)

# Préparation de votre environnement de travail

Pour réaliser l'ensemble des ateliers de cette UV, nous vous proposons d'utiliser votre machine personnelle et d'y installer les logiciels nécessaires. Si vous ne souhaitez pas ou ne pouvez pas installer de nouveaux logiciels sur votre machine une machine virtuelle pré-configurée (_TP-INF210-DEV_) peut être mise à votre disposition disponible sur la plateforme <http://vdi.imt-atlantique.fr>. Dans ce cas, demandez à votre encadrant.

## Installation des logiciels sur votre machine personnelle

Vous devez disposer des logiciels suivants :

- _Java Development Kit_ (>= 21) [JDK home page](https://www.oracle.com/java/technologies/downloads/https://www.oracle.com/java/technologies/downloads/). Si vous avez plusieurs versions du JDK installés sur votre machine (Windows), vous pouvez consulter [cette documentation](https://www.happycoders.eu/java/how-to-switch-multiple-java-versions-windows/) pour savoir comment changer la version utilisée
  - testez avec la commande `java --version`
- Maven [Maven home page](https://maven.apache.org/install.html)
  - testez avec la commande `mvn --version`
- Docker [Docker installation guide](https://docs.docker.com/engine/install/)
  - testez avec la commande `docker --version`


<!-- {% include callout.html content="**Approfondissements par la pratique**<br/><br/>
Tester votre installation et l'utilisation des outils avec les ateliers pratiques suivants : <br/>
- utilisation de la VM fournie sur la plateforme *vdi* : [Documentation - vm et vdi](documentation_vdi.html),<br/>
- ma première application Spring avec l'atelier : [Atelier - première application Spring](practice_spring.html),<br/>
- les fonctionnalités de base de *Docker* : [Documentation - notions de base](documentation_docker.html),<br/>
- atelier sur utilisation de *pgAdmin4* pour accéder à un service PostgreSQL *dockerisé* : [Atelier - connexion à PostgreSQL avec pgAdmin4 et Docker](practice_docker_postgresql.html),
" markdown="span" type="warning"%}-->
