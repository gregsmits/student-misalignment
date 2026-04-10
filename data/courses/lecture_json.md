---
title: JSON
keywords: n-tiers, n-layers, microservices, dto, JSON
toc: false
sidebar: web_architecture_sidebar
permalink: lecture_json.html
summary: Cette section introduit la syntaxe d'un document JSON, format de données utilisé pour la sérialisation d'objets.
---

[JSON](http://www.json.org/) est un format textuel de représentation de données à la fois interprétable facilement par un humain et automatiquement analysable par un programme. Tous (ou presque) les langages de programmation proposent des fonctions de manipulation de données écrites en JSON.

# Structure et contenu d'un document JSON

Un document JSON décrit un objet, derrière lequel peut être accessible un graphe d'objets. Les données qui décrivent un objet en JSON sont délimitées par des accolades et forment un ensemble d'associations _clef : valeur_ comme l'indique l'illustration ci-dessous :

![Un objet en JSON](images/web_architecture/object.png)

- Source : [http://www.json.org/](http://www.json.org/) le 09/01/2024

Une valeur associée à une clef peut être de différents types, notamment un objet pour représenter un graphe d'objets :

![Types de valeur associables à une clef](images/web_architecture/value.png)

- Source : [http://www.json.org/](http://www.json.org/) le 09/01/2024

Une clef peut être associée à plusieurs valeurs regroupées dans un tableau :

![Tableau de valeurs](images/web_architecture/array.png)

- Source : [http://www.json.org/](http://www.json.org/) le 09/01/2024

Voici ci-dessous un exemple de données formattées en JSON décrivant quelques départements de l'IMT Atlantique :

```json
{
   "schoolName" : "IMT Atlantique Brest",
   "deparments" : [
       {
            "id" : 1,
            "name" : "Info"
       },
       {
            "id" : 2,
            "name" : "DSD"
       },
       {
            "id" : 3,
            "name" : "MEE"
       }
   ]
}
```

{% include callout.html content="**Approfondissements**<br/><br/>

- [La saga JSON racontée par CrockFord (50mn): https://www.youtube.com/watch?v=-C-JoyNuQJs](https://www.youtube.com/watch?v=-C-JoyNuQJs)

" markdown="span" type="warning"%}
