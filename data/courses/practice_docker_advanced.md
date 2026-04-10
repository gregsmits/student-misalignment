---
title: Atelier sur Docker (dockerfile et dockercompose)
keywords: Docker, postgresql, pgadmin, spring, maven, python, image, container, volume, réseau virtuel, dockerfile, docker compose
toc: false
sidebar: technical_environment_sidebar
permalink: practice_docker_advanced.html
summary: "Cet atelier a pour objectif de vous montrer comment construire une image docker personnalisée et comment déployer une infrastructure logicielle avec plusieurs services."
---


# Dockerfile

[Docker Hub](https://hub.docker.com/) propose des images prêtes à l'emploi. Vous pouvez cependant partir de l'une d'elles pour créer votre propre image, incluant des paquetages supplémentaires, des données pré-chargées, démarrant des services, etc. Pour cette personnalisation, il faut créer un fichier
appelé `Dockerfile` (vous trouverez la documentation de ces fichiers [ici](https://docs.docker.com/engine/reference/builder/)).

<!--Une image Docker est construite en réalité comme une pile d'images à partir d'une image de départ. Il faut utiliser un fichier Il est possible de personnaliser une image à l'aide d'un fichier *Dockerfile* (Documentation sur [Dockerfile](https://docs.docker.com/engine/reference/builder/)).-->

 Vous allez configurer une image avec un serveur PostgreSQL en repartant d’une image de départ Debian. Une méthode pour créer un fichier `Dockerfile` est d’identifier toutes les commandes/configurations à appliquer à partir de l’image de départ et de transformer ces commandes/configurations en instructions dans le fichier `Dockerfile`.

Commencez par créer un répertoire vide nommé *DockerfilePostgres* et récupérez les fichiers [Dockerfile](resources/technical_environment/dockerfile/DockerfilePostgres/Dockerfile) et [databikes.sql](resources/technical_environment/dockerfile/DockerfilePostgres/databikes.sql) que vous placerez dans le répertoire créé.

{% include callout.html content="Vous pouvez donner un nom différent au répertoire mais le nom du fichier `Dockerfile` ne peut pas être modifié sinon les outils *Docker* ne sauront pas le trouver." markdown="span" type="primary" %}

Voici le contenu commenté du fichier `Dockerfile` :

``````
# (Le point de départ est l'image debian)
FROM debian

# Création d'une variable avec la version de PostgreSQL utilisée
ARG POSTGRES_VERSION=15

# Mise à jour du gestionnaire de paquets
RUN apt update

# Installation du paquet PostgreSQL sans interactions
RUN apt install -y postgresql

# Copie du fichier local databikes.sql dans le répertoire /tmp de l'image
COPY databikes.sql /tmp/

# On passe de l'utilisateur root à l'utilisateur postgres
USER postgres

# Démarrage du service postgresql et création de l'utilisateur dockerpg et de la BD testdockerdb puis exécution du script databikes.sql
RUN /etc/init.d/postgresql start && psql --command "CREATE USER dockerpg WITH SUPERUSER PASSWORD 'lannion';" && createdb -O dockerpg testdockerdb && psql -f /tmp/databikes.sql testdockerdb

# Modification de la configuration de PostgreSQL pour accéder des connexions par le réseau
RUN mv /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf /etc/postgresql/$POSTGRES_VERSION/main/pg_hbaOLD.conf
RUN sed 's/^local/#/' /etc/postgresql/$POSTGRES_VERSION/main/pg_hbaOLD.conf > /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.confv
RUN echo "local all  all     md5" >> /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf

# Expose le port 5432 du container (informatif uniquement ici)
EXPOSE 5432

# Création d'un volume pour persister les bases de données
VOLUME  ["/var/lib/postgresql"]

# Commande exécutée au démarrage d'un container à partir de l'image (Attention version 15 hard-codée)
CMD ["/usr/lib/postgresql/15/bin/postgres", "-D", "/var/lib/postgresql/15/main", "-c", "config_file=/etc/postgresql/15/main/postgresql.conf"]
``````

Il est désormais possible de construire une image à partir de ce fichier *Dockerfile* avec la commande :<br/>
`docker build -t pgdbbikes:V1 .`<br/>
 exécutée dans le répertoire où se trouve le fichier *Dockerfile*.

Une fois créée, l'image peut être utilisée pour démarrer un *container* avec un serveur PostgreSQL personnalisé (c.-à-d. avec un utilisateur *dockerpg* et des données dans la table *bikes*) :<br/>
 `docker container run -p 5437:5432 pgdbbikes:V1`<br/>


Vous allez désormais vous connecter au service PostgreSQL depuis un conteneur Pgadmin4. Pour cela, il vous faudra disposer de :
- l'adresse IP du conteneur PostgreSQL (à récupérer depuis le terminel `docker inspect <container_id>` ou depuis l'interface Docker desktop),
- le port d'écoute (5432 par défaut),
- le nom de l'utilisateur de BD et son mot de passe (à chercher dans le Dockerfile).

<!-- Il n'est pas possible de l'utiliser parce qu'ils ne sont pas dans le même réseau virtuel. -->

<!--Pour vérifier le contenu de la base de données, vous pouvez utiliser le *container* *pgadmin4_cn* en ajoutant un *Server* avec comme adresse celle du réseau virtuel utilisé par les *containers*.  Pour connaître cette adresse, exécutez la commande `docker network ls` pour lister les réseaux virtuels, repérez celui utilisé par vos *containers* puis exécutez la commande `docker network inspect <id_network>` pour identifier l'adresse IP du *container* *pgdbbikes:V1*. -->


# Docker compose

*Docker compose* est un autre outil de *Docker* permettant de gérer toute un environnement, c'est-à-dire plusieurs *containers*, des volumes, des réseaux virtuels, etc. Voici ci-dessous un exemple de fichier de configuration de *docker compose* (fichier `docker-compose.yaml`):

``````
services:
  web:
    build:
      context: ./DockerfileApache
    ports:
      - "8083:80"
    depends_on:
      - db
    tty: true
    stdin_open: true

  db:
    container_name: Postgres
    build:
      context: ./DockerfilePostgres

  pgadmin:
    container_name: pgAdmin
    hostname: serv_pgadmin4
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: pguser@admin.com
      PGADMIN_DEFAULT_PASSWORD: pgpwd
    ports:
      - "5051:80"
    depends_on:
      - db
``````

Ce fichier indique que *docker compose* va démarrer trois services nommés *web*, *db* et *pgadmin* respectivement créés à partir des images décrites dans les fichiers `Dockerfile` présents dans les répertoires *DockerfileApache*, *DockerfilePostgres* et de l'image officielle *dpage/pgadmin4*, respectivement.

Vous pouvez récupérer une archive complète pour faire ce test [ici](resources/technical_environment/practice_dockercompose.zip), puis utiliser les commandes suivantes depuis le répertoire dans lequel vous aurez décompressé l'archive :
- `docker compose build` pour construire les images des services *web*, *db* et *pgadmin*
- `docker compose up` pour démarrer les services. Si tout se passe bien, l'adresse http://127.0.0.1:8083/bikes.php devrait vous permettre d'accéder au fichier *bikes.php* géré par le service *web*. Et l'adresse http://127.0.0.1:5051 vous retourne un accès à l'application web pgAdmin.

- `docker compose down` permet de stopper les *containers* démarrés.

# Volumes

Les données (c.-à-d. les fichiers, par exemple) crées dans un *container* sont perdues lorsque celui-ci est détruit (`docker container rm <id_container>`). Par contre, un *container* peut être arrêté (`docker container stop <id_container>`) puis redémarré (`docker container start <id_container>`) sans perte de ses données.

Pour rendre persistantes les données créées dans un *container*, ou bien les partager avec d'autres *containers*, il faut utiliser des volumes. *Docker* propose pour cela deux solutions :
- les *bind mount* qui sont des montages classiques avec un répertoire de votre système de fichiers. Voici l’option à ajouter lors du démarrage d’un *container* : `docker container run --mount type=bind,source=/bindmount/,target=/app/ <nom_image>`
- les volumes mémoire qui sont entièrement gérés par *Docker*. Pour cela faut procéder à la création d’un volume (`docker volume create <nom_vol>`) puis à son attachement à un *container* lors de son démarrage : `docker run - -mount source=<nom_vol>,target=/app <nom_image>`

Testez ces deux types de partage avec un simple *container* contenant l’image <it>alpine</it> (image avec un OS Linux minimaliste avec une <it>libc</it> et un <it>busybox</it>). Vous pouvez utiliser la commande `docker volume inspect` pour vérifier que les volumes sont bien attachés à votre *container*.

# Réseaux virtuels
Les *containers* sont regroupés en réseaux virtuels. Pour connaître les réseaux virtuels existants vous pouvez utiliser la commande `docker network ls` et la commande `docker network inspect <nom_reseau>` pour avoir toutes les informations sur un réseau particulier (ses hôtes, ses adresses, son type, etc.). Le réseau utilisé par l'environnement de développement utilisé dans l'UV est le réseau *docker_environment_vnet_inf210*.<br/>

-	Démarrez un *container* (nommé *servssh*) à partir de l’image <it>alpine</it> en publiant le port 22 du *container* sur le port 2222 de la machine hôte et en précisant comme adresse IP 172.16.0.66. Vous veillerez également à démarrer le *container* en mode interactif avec la commande */bin/bash*.<br/>
-	Configurez votre *container* *servssh* pour ajouter un utilisateur *etu* de mot de passe *imt* et pour qu’il offre un service de connexion ssh (paquet openssh-server).
-	Utilisez la commande `docker network` pour analyser à quel réseau virtuel *servssh* est connecté.
-	Établissez une connexion par ssh à votre *container* *servssh* depuis un *container* (debian) du même réseau et depuis votre machine hôte (ou celle du voisin).<br/>

Vous allez désormais mettre dans un même réseau (*bridge*) un *container* *postgreSQL* et un *container* *debian*
-	Créez un réseau virtuel utilisant le driver *bridge* nommé *myNet*, d’IP 192.168.12.0/24
-	Démarrez deux *containers* *debian* dans le réseau *myNet* et identifiez leur adresse IPV4
-	Vérifiez la connectivité entre les deux *containers* par un *ping* (disponible dans le paquetage `iputils-ping`)
