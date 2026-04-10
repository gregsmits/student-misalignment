---
title: Atelier sur PostgreSQL dans un environnement dockerisé
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: true
sidebar: technical_environment_sidebar
permalink: practice_postgresql.html
summary: "Cet atelier a pour objectif de présenter le SGBDR utilisé dans cette UV, à savoir PostgreSQL, dans un environnement dockerisé."
---


Un serveur est une machine offrant un (ou plusieurs) service(s). Par ailleurs, un conteneur est un environnement d'exécution indépendant de tout autre (mémoire dédiée, interfaces virtuelles dédiées d'accès au matériel). Voici pour rappel ci-dessous une illustration de l'environnement Docker utilisé pour exécuter le serveur SGBDR (PostgreSQL) offrant un service d'accès à des bases de données (_Postgres_) et un conteneur pour l'application web pgAdmin (_pgAdmin_) qui permet facilement à un utilisateur d'accéder à des SGBDR PostgreSQL. Ici on a une architecture 1-_tier_, un seul serveur, mais elle pourrait être généralisée. Dans ce cas, on parle d'architectures _N-tiers_, N serveurs, chacun s'exécutant sur une machine différente et étant responsable d'une partie de l'application. Avec Docker il est possible de simuler ce type d'architectures en associant chaque _tier_ à un conteneur.

![Architecture logicielle dockérisée](images/technical_environment/docker_port_mapping.png)

Les conteneurs _Postgres_ et _pgAdmin_ sont dans le même réseau virtuel. Ils peuvent donc communiquer ensemble, ce qui permet depuis _pgAdmin_ de se connecter au serveur PostgreSQL. Vous pouvez depuis votre machine physique, ou une autre machine physique du réseau, accéder à _pgAdmin_ car le port 80 du conteneur et publié (_mappé_) sur le port 5051 de la machine hôte. Par contre, en l'état, il n'est pas possible d'accéder au service _Postgres_ en dehors du réseau virtuel.

## Connexion au SGBDR et création de la BD

Lors de l'activité Docker, vous avez démarré des services PostgreSQL et Ppgadmin4 que vous allez réutiliser ici.

Utilisez l'interface graphique de _pgAdmin_ pour créer une base de données nommée *bikes_db*. 

Copiez ensuite le code suivant et collez-le dans l'éditeur SQL. 
Exécutez ensuite le code pour procéder à la création d'une table nommée `bikes` et à l'enregistrement de quelques données.

```sql
CREATE TABLE bikes (
    id INTEGER PRIMARY KEY,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(30) NOT NULL
);

INSERT INTO bikes VALUES 
    (1, 'KTM','exc'),
    (2, 'KTM','sx' ),
    (3, 'HONDA','crf' ),
    (4, 'KAWASAKI','kx'),
    (5, 'BETA','rr');
```



## Schéma de la base de données

Naviguez dans l'interface web de _pgAdmin_ pour retrouver la base de données _bikes_db_ et puis la structure de la table _bikes_ et afficher son contenu.

![Structure et données d'une table](images/technical_environment/structure_data.png)

Exécutez la requête SQL suivante qui permet d'afficher les différentes marques de moto renseignées dans la table _bikes_ :

```
SELECT DISTINCT brand
FROM bikes
ORDER BY brand DESC;
```
