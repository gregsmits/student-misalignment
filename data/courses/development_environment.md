---
title: Environnement de développement pour l'UV INF 210
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: true
sidebar: technical_environment_sidebar
permalink: development_environment.html
summary: "Cet activité pratique est indispensable pour le reste de l'UV. L'objectif est de mettre en place l'environnement de développement qui sera utilisé dans les activités pratiques sur les données et les architectures d'applications web."
---


## Mise en place de l'environnement de développement

**Cet exercice est très important car vous allez mettre en place et découvrir l'environnement de travail dockerisé qui vous servira pour toutes les activités pratiques de l'UV**.

Si ce n'est pas encore fait, arrêtez et supprimez les conteneurs que vous avez utilisé lors des activités de découverte de Docker, ceci afin d'éviter des conflits d'ouverture de ports.


L'environnement de développement est disponible sur le dépôt gitlab suivant :
 - [Docker environment](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment)

 Clonez sur votre machine ce dépôt :
  - `git clone https://gitlab-df.imt-atlantique.fr/inf210/docker-environment.git`



### Contenu du dépôt

Ce dépôt contient l'environnement de développement utilisé lors de l'UE INF210. Il servira de point de départ des différentes activités pratiques.

### Services Dockerisé

Le développement d'applications web requiert des services annexes tels que :

- un serveur de bases de données pour pérenniser les données des applications,
- un service web pour accéder directement aux bases de données et ainsi contrôler leur contenu,
- un serveur d'applications pour déployer une application en mode production.

Pour ces trois services, nous utiliserons respectivement :
- un serveur PostgreSQL,
- un serveur web avec le client Pgadmin4,
- un serveur Wildfly.

Ces différents serveurs seront exécutés dans des conteneurs Docker.

Le fichier `compose.yaml` contient la configuration de ces conteneurs. Voici ci-dessous un rappel des quelques commandes Docker utiles :


#### Démarrage des services BD et Web

Si vous analysez le contenu du fichier `compose.yaml`, vous verrez que trois services sont configurés :
- `db` pour le serveur de base de données postgresql,
- `pgadmin`, un serveur web fournissant l'application web *PgAdmin4* qui vous servira de client d'accès au serveur de bases de données,
- `wildfly`, un serveur d'applications qui sera utilisé ultérieurement pour tester le déploiement d'applications Spring dans un environnement de production.

Lors des premières activités, vous aurez besoin principalement des services `db` et `pgadmin`.

Démarrez les deux services `db` et `pgadmin` comme suit :
```bash
docker compose up db pgadmin
```

Soit en ligne de commande (`docker ps`) soit depuis l'interface *Docker Desktop*, vérifiez que deux containers sont en cours d'exécution.

Testez désormais l'accès à la base de données en accédant à l'application [*PgAdmin*](http://127.0.0.1:5051).
Dans le fichier `compose.yaml`, vous trouverez les informations nécessaires à l'authentification *PgAdmin* :
```bash
PGADMIN_DEFAULT_EMAIL: pguser@admin.com
PGADMIN_DEFAULT_PASSWORD: pgpwd
```

### Applications Java Spring

Plusieurs applications Java Spring, souvent incomplètes, sont fournies comme point de départ pour les différentes activités pratiques. Ces applications ont été initialisées à partir du portail [Spring initializr](https://start.spring.io/) avec les modules nécessaires.

Vous trouverez notamment les applications suivantes :
- `bandGateway` est dédié à l'étude des tests sur les fonctionnalités des applications Spring JPA
- `comrec` utilisé pour l'étude de Spring JPA
- `gestpers` utilisé pour étudié la structuration en couches des applications Java Spring web
- `gestpers_wildfly` contient une configuration préparée pour expérimenter le déploiement de l'application `gestpers` sur un serveur d'application externe, ici *Wildfly*
- `ms_shared_db` est l'application servant de point de départ pour expérimenter la structuration en micro-services d'applications web
- `studenjson` est une très simple application pour découvrir la sérialisation et désérialisation en json de POJO
- `uigestpers` est un complément de l'application `gestpers` pour étudier la connexion entre les couches présentation et métier.

Une application de base vous sera également fournie pour le projet.

Les projets Spring sont gérés par l'outil `maven`, dont la configuration de chaque application est stockée dans le fichier `pom.xml`. Voici un rappel de quelques commandes utiles :
- `mvn spring-boot:run` depuis le répertoire de l'application pour exécuter l'application
- `mvn clean` pour supprimer les fichiers (pré-)compilés.

Pour tester que tout votre environnement est en place, vous allez exécuter l'application `gestpers`. Pour ce faire, placez-vous dans le répertoire `gestpers/` et exécutez l'application avec la commande suivante :
- `mvn spring-boot:run`

En tant qu'application Spring web, l'exécution de l'application entraîne le démarrage d'un serveur d'applications web `Tomcat` afin de vous donner accès à votre application. Accédez à l'application `gestpers`en vous rendant à l'adresse suivante [http://127.0.0.1:8080](http://127.0.0.1:8080).
Vous devriez voir l'interface, spartiate, suivante :
![Gestpers](images/technical_environment/gestpers.png)

Si vous clickez sur le lien [`List of departments`](http://127.0.0.1:8080/departments), vous verrez apparaître quelques données :

![Gestpers](images/technical_environment/services.png)

Retrouvez d'où viennent ces noms de services.