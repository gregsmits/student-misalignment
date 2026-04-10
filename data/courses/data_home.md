---
title: Persistance de données
keywords: Relational model, SQL
toc: false
sidebar: data_sidebar
permalink: data_home.html
summary : Cette section agrège les notions liées à la persistance des données manipulées dans une application web.
---

<a target="_blank" href="images/prerequisite_data/prerequisite_data_2025.html"><img border=0 title="Clicker pour agrandir" src="images/prerequisite_data/prerequisite_data_2025.jpg"></a>


Les données manipulées dans le code d'une application (web dans notre cas) sont stockées en mémoire vive et ne sont donc plus accessibles lorsque l'application est terminée et ne peuvent pas être partagées (facilement) avec d'autres programmes. Une partie important de l'UV INF 210 est consacrée à la persistance des données d'une application.

{% include callout.html content="**Persistance**<br/><br/>
Stratégie de sauvegarde et de restauration des données afin de les rendre indépendantes de l'état de l'application qui les manipule. La persistance est obtenue en confiant la gestion des données à un mécanisme externe (gestionnaire de fichiers ou de données structurées).
" markdown="span" type="primary"%}

La stratégie de persistance utilisée par la plupart des applications web repose sur un Système de Gestion de Bases de Données (SGBD). Plus précisément, nous utiliserons une structuration relationnelle des données, solution adaptée à une majorité des contextes applicatifs.

Comme l'illustre le schéma suivant, la gestion de la persistance des données d'une application dans un SGBD Relationnel (SGBDR) nécessite de :
- disposer d'un schéma relationnel des données garantissant une exploitation complète et efficace des données,
- maîtriser les outils et techniques permettant de manipuler efficacement et dans un environnement concurrent les données confiées à un SGBD.

![La persistance des données à l'aide d'un SGBDR](images/data/data_persistence.png)

Cette section dédiée à la persistance des données est découpée en trois parties :<br/>
1- [le modèle relationnel de structuration des données et son algèbre associée](lecture_relational_model.html),<br/>
2- [les méthodes de modélisation et de normalisation d'un schéma relationnel](lecture_modeling_normalization.html),<br/>
3- [les outils et techniques de manipulation de données relationnelles](lecture_db_tools.html).
