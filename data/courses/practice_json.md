---
title: Activité JSON et Java
keywords: JSON, serialisation
toc: false
sidebar: web_architecture_sidebar
permalink: practice_json.html
summary : Au cours de cette activité, vous allez explicitement gérer la sérialisation et la désérialisation d'objets Java.
---



<!-- {% include callout.html content="**Pré-requis**<br/><br/>

- Connaître la notion de [sérialisation d'objets Java en JSON](lecture_json.html)

" markdown="span" type="danger"%} -->


# Illustration de la sérialisation d'objets Java

Au cours de cette activité, vous allez utiliser le projet Spring *studentjson* fourni dans l'[environnement de développement dockerisé](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment), environnement que vous avez dû déjà mettre en place et testé précédemment.


## Sérialisation et désérialisation d'objets Java

Le point d'entrée du programme est la classe *StudentjsonApplication* et réalise les opérations suivantes :

- instanciation d'un objet de la classe *Student*
- sérialisation de l'objet en une chaîne de caractères au format JSON
- sérialisation de l'objet en binaire dans le fichier *student.ser*
- désérialisation du contenu du fichier *student.ser* en une instance de *Student*

##### **Question 1**

Analyser les sources de l'application pour identifier et comprendre ce mécanisme très simple de sérialisation standard.

# Annotations Java pour la sérialisation

Il est possible d'ajouter des annotations à une classe de type entité pour donner des indications au processus de sérialisation automatique. Voici un lien expliquant les annotations possibles [Jackson annotations](https://github.com/FasterXML/jackson-annotations/wiki/Jackson-Annotations).

##### **Question 1**

Ajoutez une propriété surnom à la classe *Student* puis annotez la classe pour aboutir à la sérialisation suivante (la propriété surnom n'est pas sérialisée) :

```json
{
    "id" : 285,
    "Nom" : "Thih",
    "Prénom" : "Djuj",
    "Spécialités":["sport","physics","maths"]
}
```
