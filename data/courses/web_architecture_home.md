---
title: Architectures d'applications web
keywords: n-tiers, n-layers, microservices
toc: false
sidebar: web_architecture_sidebar
permalink: web_architecture_home.html
summary: Cette partie de l'UV aborde les notions d'architecture logicielle et d'architecture technique des applications, notamment web. Vous verrez comment les principes généraux sont implémentés dans le framework Java Spring.
---

<a target="_blank" href="images/prerequisite_archiweb/prerequisite_archiweb_2025.html"><img border=0 src="images/prerequisite_archiweb/prerequisite_archiweb_2026.png" usemap="#GraffleExport"></a>

La partie [Data](data_home.html) du cours est consacrée à la persistance des données et à leur manipulation. Cette partie de l'UV est consacrée à la construction d'une application au dessus du système de gestion de la persistance des données.

<!--Objectifs pédagogiques

- expliquer le principe de séparation de responsabilités et son intérêt dans les applications Web. -->

## Structuration d'une application web

La structuration d'une application fournissant un accès utilisateur à des données persistantes se décline en deux axes :

- [l'architecture technique](lecture_technical_architecture.html) de déploiement des composants logiciels sur le matériel disponible pour les exécuter
- [l'architecture logicielle](lecture_software_architecture.html) de structuration du code de l'application

La pierre angulaire de ces deux architectures est le principe de séparation des responsabilités.

{% include callout.html content="**Définition** - Séparation des responsabilités<br/>Ce principe vise à segmenter les architectures technique et logicielle afin de rendre chaque composant responsable d'une tâche ciblée. Le résultat est plus robuste et surtout extensible car il devient plus aisé de remplacer l'instanciation d'un composant par un autre.
" markdown="span" type="primary" %}
<!-- 
## Échange de données

La séparation entre les composants de l'application web implique le recours à des mécanismes de transfert de données entre ces composants. Pour assurer une certaine flexibilité de l'application, le format des données transférées doit être indépendant des choix d'implémentation (langage, architecture) de ses composants. Cet échange d'objets, sans logique métier, entre composants est assuré via des [Data Transfert Object (DTO)](lecture_dto.html). -->
