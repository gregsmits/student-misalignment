---
title: Documentation Docker
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: true
sidebar: technical_environment_sidebar
permalink: documentation_docker.html
summary: "Docker est un service exploitant des fonctionnalités du noyau Linux (namespaces, et cgroups) pour fournir des mécanismes d'isolation et de contrôle de processus. Il permet d'exécuter en parallèle des environnements indépendants sur une même machine."
---

Vous pouvez piloter le service _Docker_ depuis l'application graphique _Docker Desktop_ ou bien en ligne de commandes, stratégie que nous vous conseillons.
Voici quelques notions fondamentales et leurs commandes associées à connaître, notions que vous pouvez compléter en lisant la [documentation officielle](https://docs.docker.com/).

## Virtualisation vs. conteneurisation

_Docker_ est une service de conteneurisation disponible sous GNU/Linux, Windows (depuis la version 10) et OS X. Un conteneur correspond à l'isolation d'une application dans un contexte le plus léger possible, c'est-à-dire ne contenant que les dépendances nécessaires au fonctionnement de l'application (voir figure ci-après).

![VM versus conteneurs](images/technical_environment/vm_vs_containers.png)

L'utilisation de Docker pour le développement d'applications web a au moins deux intérêts. Le premier est d'unifier le contexte de développement indépendamment de l'architecture et de la configuration des machines sur lesquelles l'application sera exécutée. Il est ainsi possible de configurer un contexte de développement (via une image Docker) et la partager entre développeurs pour s'assurer que tout le monde travaille dans le même environnement. Nous allons dans cette UV utiliser Docker pour exécuter et isoler des services, notamment pour gérer la base de données et vos applications.
{% include callout.html content="Dans la suite de cette activité vous trouverez des commandes pour *Docker*. Vous n'avez pas besoin de les exécuter, elles sont là pour information. Une [activité pratique](practice_docker.html)  est disponible vous permettant d'utiliser de manière pratique les différentes commandes." type="info"%}

## Images

Docker utilise la notion d'_image_ pour partager et réutiliser des applications ou des services. Une image est un regroupement de l'ensemble des dépendances (binaires et librairies) nécessaires pour l'exécution d'une application ou d'un service. Des images (officielles ou non) peuvent être partagées dans des registres, notamment celui de Docker appelé [Docker Hub](https://hub.docker.com/).

Afin d'être utilisée, une image doit tout d'abord être copiée sur l'ordinateur sur lequel l'application sera exécutée. Attention, ces images stockées localement peuvent prendre beaucoup de place.

- Récupération d'une image officielle (_alpine_, un Linux minimaliste) avec la commande `docker pull alpine`
- Affichage des images disponibles localement : `docker image ls`

![Docker image](images/technical_environment/alpineImage.png)

## Conteneurs

Un _conteneur_ est une instanciation isolée d'une image Docker. Contrairement à une image qui est une archive en lecture seule, un conteneur ajoute une couche en lecture/écriture qui permet de stocker des données au sein du conteneur (données pouvant être externalisées à l'aide de [volumes](https://docs.docker.com/storage/volumes/)).

Un conteneur peut avoir plusieurs statuts, notamment être : en cours d'exécution, en pause, arrêté ou supprimé. Lorsqu'un conteneur est supprimé, toutes les données qu'il contenait sont également supprimées. Par contre, un conteneur peut être arrêté et redémarré sans perte de données.

- Lister les conteneurs en cours d'exécution ou en pause : `docker ps` ou `docker container ls`
- Lister tous les conteneurs même ceux arrêtés : `docker ps -a` ou `docker container ls -a`
- Exécuter un conteneur à partir de l'image _alpine_ par exemple en mode interactif pour disposer d'un _shell_ au sein de ce conteneur : `docker run -it alpine /bin/sh`

![Docker container](images/technical_environment//container_alpine.png)

## Dockerfile et Docker-compose

Au delà des images publiées dans des registres, Docker permet la création d'images personnalisées. La personnalisation s'effectue à l'aide d'un fichier nommé `Dockerfile` dont le point de départ est toujours une image existante (localement ou à récupérer d'un registre). Par exemple, pour créer une image ayant le tag _monalpine:0.1_, il faut exécuter la commande `docker build -t monalpine:0.1 .` dans le répertoire où se trouve le fichier `Dockerfile` qui contient les instructions pour construire l'image.

Un contexte de développement ou de production repose souvent sur plusieurs services éventuellement inter-connectés. _Docker-compose_ est un outil permettant de démarrer plusieurs services à partir d'un unique fichier de configuration nommé `compose.yaml`. Par exemple, pour construire les images référencées et démarrer les services décrits dans un fichier `compose.yaml`, il faut exécuter la commande `docker compose up` dans le répertoire où se trouve le fichier.
