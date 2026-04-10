---
title: Atelier sur Docker
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: true
sidebar: technical_environment_sidebar
permalink: practice_docker.html
summary: "Cet atelier a pour objectif de vous présenter par la pratique les composants essentiels manipulés sous Docker (image, conteneur, volume, réseau virtuel, dockerfile, docker-compose)."
---

Pour illustrer le fonctionnement de Docker, vous travaillerez avec PostgreSQL et pgAdmin. Le premier est le Serveur de Gestion de Bases de Données Relationnel (SGBDR) utilisé dans cette UV. Pour faire cet atelier vous n'avez pas besoin de comprendre ce que c'est exactement. Il suffit de savoir qu'il permet de stocker de manière permanente des données. pgAdmin est une application web permettant d'accéder de manière simple aux données stockées dans un serveur PostgreSQL.

## Docker c'est quoi

Docker est un service, c'est-à-dire une application qui s'exécute pour fournir à des clients des fonctionnalités, ici de manipulation de conteneurs. Sous Windows ou OS X, vous avez une application _Docker_ que vous pouvez démarrer en cliquant dessus et logiquement accéder à son tableau de bord.
Sous GNU/Linux, le service est dissocié de l'application fournissant le tableau de bord. Utilisez alors la commande `service docker status` ou vérifiez que le processus _dockerd_ exécutant le service est bien démarré `ps -ef | grep docker`.

## Image et conteneur

Depuis le registre [Docker Hub](https://hub.docker.com/), qui recense les images Docker (officielles), retrouvez le nom de l'image officielle pour le SGBDR PostgreSQL. Une fois trouvée, utilisez la commande `docker pull <nom_image>` pour récupérer une copie locale sur votre machine. Vérifiez avec la commande `docker image ls` que vous disposez bien de l'image recherchée.

![Liste des images Docker disponibles](images/technical_environment/docker_image_ls.png)

{% include callout.html content="Le champ de recherche de l'application *Docker Desktop* permet de naviguer dans vos images locales et dans le Docker Hub." markdown="span" type="primary" %}

Un conteneur correspond à l'exécution d'une image et, contrairement à l'image qui est en lecture seule, contient un espace (une couche) d'écriture de données. La commande `docker container run [options] <nom_image>` permet de démarrer un conteneur à partir d'une image.

Démarrez un conteneur que vous nommerez _Postgres_ à partir de l’image que vous avez récupéré précédemment en indiquant les options suivantes :

- _-e POSTGRES_PASSWORD=pgpwd_ pour spécifier le mot de passe de l'administrateur (rôle `postgres`) du service PostgreSQL

{% include callout.html content="N'oubliez pas que toute la documentation de référence de Docker se trouve [ici](https://docs.docker.com/reference). En particulier, vous y trouverez celle de la commande `docker container run` pour savoir comment donner un nom précis à un *container*." markdown="span" type="primary" %}

Depuis un autre terminal, le premier étant occupé au premier plan par le processus qui exécute votre _container_, listez les _containers_ en cours d'exécution avec la commande `docker container ls` (ou `docker ps`). Vous pouvez également retrouver la liste des containers en cours d'exécution depuis l'interface Docker Desktop.

Vous pouvez :

- lister tous les conteneurs (ceux qui sont en cours d'exécution et ceux qui sont arrêtés) avec la commande `docker container ls -a`
- arrêter un conteneur avec `docker container stop <id_container>`
- démarrer un conteneur avec `docker container start <id_container>`
- supprimer un conteneur avec la commande `docker container rm <id_container>`. Attention, toutes les données du conteneur sont supprimées.

![Liste des containers en cours d'exécution](images/technical_environment/docker_ps.png)

Vous allez désormais récupérer l'image _dpage/pgadmin4_ depuis Docker Hub puis démarrer un conteneur appelé _pgAdmin_ proposant l'application web pgAdmin. Attention, lors du démarrage du conteneur il faut préciser les options suivantes :

- _-e PGADMIN_DEFAULT_EMAIL=pguser@admin.fr -e PGADMIN_DEFAULT_PASSWORD=pgpwd_ pour indiquer les informations de connexion à l'application web pgAdmin. Évidemment vous pouvez mettre le mail et le mot de passe de votre choix

- _-p 5051:80_ pour indiquer que le port 80 du conteneur doit être associé au port 5051 de votre machine hôte comme l'illustre l'image ci-dessous.

![Mapping de ports Docker](images/technical_environment/docker_port_mapping.png)

Vous devriez désormais pouvoir accéder à l'application pgAdmin avec l'URL [http://127.0.0.1:5051](http://127.0.0.1:5051) qui en réalité vous renvoie à l'application web proposée par votre conteneur _pgAdmin_ (qui a sa propre adresse _IP_) sur son port 80. Dans cette application, vous pouvez vous connecter avec les informations de connexion données lors du démarrage du conteneur (dans les paramètres de la commande `docker container run`). Pour l'instant l'application pgAdmin n'a pas les informations nécessaires à sa connexion au service PostgreSQL, vous verrez comment ajouter ces informations dans l'activité de découverte du PostgreSQL dockerisé [ici](practice_postgresql.html).
