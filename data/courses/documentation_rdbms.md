---
title: Introduction aux Systèmes de Gestion de Bases de Données (SGBD)
keywords: système gestion bases données SGBD
sidebar: technical_environment_sidebar
summary: Ce cours introduit la notion de Système de Gestion de Bases de Données (SGBD)
toc: true
permalink: documentation_rdbms.html
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>- Lire et comprendre le document [De la gestion des données aux systèmes d'information](documentation_si.html)<br/>" markdown="span" type="danger"%} -->

## Qu'est-ce qu'un système de gestion de bases de données (SGBD) ?

{% include callout.html content="**Définition** - Système de Gestion de Base de Données (SGBD)<br/>On appelle SGBD un logiciel qui permet de :<br/>- Définir la structure des données et administrer les droits des utilisateurs sur ces données<br/>- Stocker, modifier et accéder aux données de manière efficace en garantissant l'intégrité des données dans un contexte multi-utilisateurs<br/>- Développer des applications sur ces données" markdown="span" type="primary" %}

Un SGBD n'est pas seulement un système de stockage ou de sauvegarde, puisqu'il doit aussi offrir des services de recherche, de modification et, au-delà, de gestion des données (définition des structures, autorisations, etc.).

### Objectifs d'un SGBD

L'objectif d'un SGBD est de permettre à différents utilisateurs de partager leurs données en un ensemble de données logiquement cohérent sous réserve d'une certaine qualité de service, en particulier :

- qualité de service en interrogation : performance et pertinence du résultat
- qualité en mise à jour : maintien de l'intégrité, même dans un environnement d'accès concurrents
- qualité en administration : gestion des structures, des droits d'autorisation

Il est nécessaire de mettre en oeuvre des solutions particulières car les solutions de stockage classique, qui permettent de rendre des données persistantes, ne permettent pas de répondre aux exigences en terme de qualité (gestion des droits d'accès ou interrogation multi-fichiers, par exemple).

### Fonctionnalités d'un SGBD

On peut voir un SGBD comme un logiciel qui « encapsule » les données et offre un moyen de « gérer » ces données. Dans les SGBD relationnels, cette gestion se fait grâce à un langage, le langage SQL, qui a fait l'objet de plusieurs standardisations depuis 1986.
Ce langage SQL permet aussi bien :

- d'interroger les données (requêtes `SELECT`) ou de les modifier (requêtes `INSERT`, `UPDATE`, `DELETE`) grâce à son LMD (*Langage de Manipulation de Données*)
- de structurer les données, grâce à son LDD (*Langage de Définition de Données*) (par exemple, création de tables `CREATE`, de contraintes, d'index, etc.)
- d'administrer les accès au service de gestion des données (gestion des rôles) et aux données elles-mêmes(`GRANT`, `REVOKE`), c'est la partie du langage que l'on appelle le LCD (*Langage de Contrôle des Données*)
- d'accéder aux données à partir d'un programme, grâce à ses interfaces programmatiques ou autres langages associés (non présentés dans cette UV)

## Les SGBD sont-ils incontournables ?

### Une réponse efficace à un besoin existant

Initialement créés dans un objectif de partage de données et de forts débits de mise à jour, les SGBD ont vu leur utilisation largement banalisée au fur et à mesure que leur utilisation devenait de plus en plus simple.

### Une brique fondamentale des systèmes d'information pendant des années

L'apparition de SGBD relationnels simples à installer et à administrer (MySQL en est l'exemple typique), de langages facilitant la programmation d'applications web à données persistantes (PHP), de paquetages facilitant le déploiement cohérent d'un serveur SGBD et d'un serveur web, ont permis à nombre d'utilisateurs de créer leur propre base, sans qu'ils aient pour autant les contraintes de partage des premières applications.

### Aujourd'hui un composant technique de base qui fait face à des nouveaux challenges

A l'inverse, la gestion de données persistantes a rencontré de nouveaux challenges. Certes, on n'utilise pas un SGBD relationnel pour stocker des données sur une carte SD, mais les nouveaux supports de stockage viennent avec leurs contraintes propres et posent eux-mêmes des problèmes de performance d'accès qui ne sont pas si éloignés des problématiques anciennes de performances et d'accès.

Inversement, la montée en volume des données traitées par des systèmes comme Google, Facebook, Amazon, etc. pose évidemment des difficultés qui ne peuvent pas être résolues par les SGBD relationnels.

Enfin, les entreprises mettent aujourd'hui l'accent sur la cohérence des décisions prises par rapport aux informations de leur SI, ce qui pose le problème de l'utilisation des données non plus dans les seuls processus opérationnels mais aussi les processus de décision de l'entreprise.

## Une démarche orientée système

Pendant de nombreuses années, la modélisation des données de l'entreprise était la base du système d'information. Les applications n'étaient envisagées que par rapport à cette représentation des données : enchainements d'écrans statiques.

Les choses ont radicalement changé au fur et à mesure que les SGBD se sont fiabilisés et banalisés.

Le monde du logiciel a mis en avant les besoins fonctionnels des utilisateurs par rapport aux données ainsi qu'une vision système (montée en puissance d'UML, développement des architectures techniques, etc.).

Plus récemment encore, les processus métier viennent structurer et mettre de la cohérence dans le SI.

Dans ce contexte, les SGBD restent un élément fondamental du système informatique, car ils restent souvent la « mémoire » de l'entreprise (son catalogue, ses fiches clients, etc.). Mais leur gestion et leur évolution ne peut se faire de manière indépendante des applications qui les manipulent. Cette cohérence entre le monde du stockage des données (largement dominé par le paradigme relationnel) et celui de l'application (en cours de domination par le paradigme objet) reste un aspect complexe à gérer.
