---
title: Le patron DTO
keywords: n-tiers, n-layers, microservices, dto
toc: false
sidebar: web_architecture_sidebar
permalink: lecture_dto.html
summary: Cette partie de l'UV aborde la notion de Data Transfert Object (DTO) et présente deux langages permettant la représentation de données transférées entre processus de l'application web.
---

<!-- Objectifs pédagogiques

- expliquer le patron de conception DTO et justifier son intérêt dans le cadre des applications web
- expliquer en quoi consiste la sérialisation/désérialisation -->

# Sérialisation

Un programme manipule en mémoire des objets, potentiellement reliés et formant un graphe d'objets. À la fin d'un programme, ces données stockées en mémoire sont perdues. De même, lorsque un programme doit utiliser une interface distante, il est amené à transférer des objets sur le réseau (via HTTP par exemple). Pour sauvegarder ou transférer des objets à un autre processus, il faut pouvoir les décrire dans un format indépendant du langage de programmation et de telle sorte qu'ils puissent être transmis via un canal de communication.

{% include callout.html content="**Définition** - Sérialisation / désérialisation<br/> La sérialisation est le procédé transformant un objet (ou un graphe d'objets) dans un format permettant sa persistance (dans un fichier par exemple) ou son transfert. La sérialisation peut générer une représentation textuelle ou binaire de l'objet. La désérialisation est le procédé inverse permettant de passer d'un flux de texte (ou binaire) à un objet (au sens programmation)." markdown="span" type="primary" %}

Les deux langages les plus utilisés pour la sérialisation/désérialisatoin d'objets sont :

- [eXtensible Markup Language (XML)](lecture_xml.html) et
- [JavaScript Object Notation (JSON)](lecture_json.html)

# Le patron DTO

Le patron DTO (_Data Transfert Object_) est un patron d'architecture qui se base sur le principe de sérialisation/désérialisation d'objets pour leur transfert via le réseau. Il offre une solution à deux aspects particulièrement importants dans le développement d'applications qui utilisent des interfaces distantes et des applications web en particulier : 1. séparer la couche données de la couche présentation et 2. diminuer la taille du chargement des données.

La solution consiste à créer, pour chaque objet à transférer, un objet de transfert de données (DTO) qui contient uniquement les attributs intéressants pour le client et la logique nécessaire pour la sérialisation/désérialisation de cet objet. Par exemple, pour un objet `Employee` contenant, entre autres, le nom, prénom et mot de passe d'un employé, le client n'a pas besoin de connaître le mot de passe. L'application devra donc avoir un objet `EmployeeDTO` avec uniquement le nom et prénom de l'employé et les méthodes nécessaires à sa sérialisation/désérialisation.
