---
title: Atelier sur Spring Boot
keywords: Docker, postgresql, pgadmin, spring, maven, python
toc: true
sidebar: technical_environment_sidebar
permalink: practice_spring.html
summary: "Cet atelier a pour objectif de vous montrer comment initier un projet d'application Spring (Boot)."
---

## Application web avec Spring Boot

Dans cette activité pratique, vous n'utiliserez pas _Docker_ mais des outils installés (ou à installer) sur votre machine (voir la fin du [document d'introduction](technical_environment_home.html) pour les instructions d'installation). Ces outils, un _JDK_ et _maven_, constituent votre environnement de programmation local.

### Spring _Initializr_

Spring fournit un outil en ligne pour initialiser un projet de développement d'applications _Spring Boot_, [_Spring initializr_](https://start.spring.io/) :

Initialisez un nouveau projet en spécifiant les paramètres illustrés sur la figure suivante (attention notamment à ajouter les deux dépendances qui sont sur la droite dans l'image ci-après) :

![Spring intializr](images/technical_environment/spring_initializr.png)

Demandez ensuite à générer une archive, nommée `testspring.zip`, puis désarchiver-la dans le répertoire de votre choix. Le répertoire créé devrait contenir au moins :

- un fichier `pom.xml`, fichier de configuration (« _Project Object Model_ ») de l'outil [_maven_](https://maven.apache.org/). Ce fichier contient les instructions de gestion des dépendances et des actions réalisables sur l'archive
- un répertoire `src` où se trouve le code source de l'application (`main/java/fr/atlantique/imt/testspring`) et ses tests (`test/java/fr/atlantique/imt/testspring`)

## Gestion de l'application avec Maven

_Maven_ peut être utilisé depuis votre IDE préféré (Eclipse, Visual code, IntelliJ, etc.) ou via un terminal en ligne de commande. C'est dernière option que nous utiliserons ici.

### Exécuter l'application

Dans le répertoire où se trouve le fichier `pom.xml`, exécutez la commande `mvn spring-boot:run`. Elle indique au plugin `spring-boot` de _maven_ d'exécuter l'objectif `run`, c'est-à-dire exécuter votre application. Comme vous avez choisi d'inclure la dépendance web, alors _spring_ va démarrer localement un serveur web _tomcat_. Testez la commande `mvn spring-boot:run` pour observer que _maven_ gère le téléchargement automatique depuis son [dépôt](https://mvnrepository.com/) des dépendances nécessaires puis compile les fichiers de code source qui ont été modifiés.

Si la compilation réussi alors vous trouverez dans le répertoire `target/` le paquet `.jar` qu'il a construit et tous les résultats de la compilation (que nous n'utiliserons pas directement). Vous pouvez également ouvrir l'URL suivante [http://127.0.0.1:8080](http://127.0.0.1:8080) qui permet d'interroger le serveur _tomcat_. Vous tombez sur une erreur retournée par _tomcat_ car le code de l'application n'indique pas encore quel fichier HTML retourner lorsque cette requête HTTP lui est transmise.

### Tester l'application

La commande `mvn test` compile et exécute le code source présent dans le répertoire `test/java/fr/atlantique/imt/testspring`.

### Nettoyer l'application

La commande `mvn clean` supprime le répertoire `target/`.

### Enrichissons un peu l'application

#### Ajout d'un contrôleur

Pour commencer à comprendre le processus de gestion des requêtes HTTP dans une application Spring, nous allons apporter quelques modifications au code. Dans le répertoire `main/java/fr/atlantique/imt/testspring`, créez un répertoire nommé `controller` et dedans un fichier nommé `MainPageController.java` contenant le code suivant :

```java
package fr.atlantique.imt.testspring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class MainPageController {

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String mainPage(){
        return "index.html";
    }

  
    @RequestMapping(value={"/withmodel", "/withmodel/"}, method = RequestMethod.GET)
    public ModelAndView mainPageModel(){
        ModelAndView modelAndView = new ModelAndView("index.html");
        modelAndView.addObject("uv", "inf 210");
        modelAndView.addObject("location", "Brest");
        modelAndView.addObject("year", 2023);

        return modelAndView;
    }
}
```

Ce code indique que lorsque l'URL racine [http://127.0.0.1:8080/](http://127.0.0.1:8080/) de l'application est invoquée (avec une reqûete HHTP `GET`), alors il faut retourner la vue _index.html_. Lorsque c'est l'URL [http://127.0.0.1:8080/withmodel](http://127.0.0.1:8080/withmodel) alors il faut transmettre le modèle contenant quelques données (sous forme d'objet _map_) à la vue _index.html_.

Voici le code de la vue _index.html_ à positionner dans le répertoire `src/main/resources/templates/` :

```html
<!DOCTYPE HTML>
<html>
<head>
    <title>First steps using Spring (UV INF210)</title>
</head>
<body>
    <div>
        Welcome dear FIP students.  </br></br>
        <span th:if="${uv}">
            <table>
                <tr><th>UV</th><th>Location</th><th>Year</th></tr>
                <tr></tr>
                <td th:text="${uv}" />
                <td th:text="${location}" />
                <td th:text="${year}" />
            </tr>
            </table>
        </span>
    </div>
</body>
</html>
```

Redémarrez l'application Spring (`Ctrl+c` suivi de `mvn spring-boot:run`) pour observer la réponse fournie par le contrôleur.

#### Ajout d'un service

Au lieu de donner les informations directement dans le code du contrôleur, celui-ci peut faire appel à un autre composant de l'application pour les obtenir. Nous allons créer ce nouveau composant. Dans le répertoire `main/java/fr/atlantique/imt/testspring`, créez un répertoire nommé `service`. Puis créez dans ce répertoire un fichier nommé `IMainPageService.java` contenant le code suivant (déclaration de l'interface).

```java
package fr.atlantique.imt.testspring.service;


public interface IMainPageService{

    public String getUV();
    public String getLocation();
    public Integer getYear();
}
```

Et finalement, créez un fichier `MainPageService.java` contenant le code suivant (implémentation de l'interface `IMainPageService.java`):

```java
package fr.atlantique.imt.testspring.service;

import org.springframework.stereotype.Service;

@Service
public class MainPageService implements IMainPageService{

    public String getUV(){
        return "INF210";
    }

    public String getLocation(){
        return "Brest";
    }

    public Integer getYear(){
        return 2024;
    }

}
```

Le seul élément particulier ici c'est l'annotation `@Service` qui indique au conteneur IoC que `MainPageService` est un _bean_ et qu'il doit gérer son cycle de vie. Maintenant, modifiez le contrôleur pour qu'il utilise ce nouveau composant.

```java
package fr.atlantique.imt.testspring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestMethod;
import fr.atlantique.imt.testspring.service.IMainPageService;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class MainPageController {

    @Autowired
    private IMainPageService mpService;

    /* Returns the view index.html */
    @RequestMapping(value="/", method = RequestMethod.GET)
    public String mainPage(){
        return "index.html";
    }

    /* Returns the view index.html with a model containing some data*/
    @RequestMapping(value={"/withmodel", "/withmodel/"}, method = RequestMethod.GET)
    public ModelAndView mainPageModel(){
        // Call the component of the application to build the model
        String uv = mpService.getUV();
        String loc = mpService.getLocation();
        Integer year = mpService.getYear();

        ModelAndView modelAndView = new ModelAndView("index.html");
        modelAndView.addObject("uv", uv);
        modelAndView.addObject("location", loc);
        modelAndView.addObject("year", year);

        return modelAndView;
    }
}

```

Ici, le contrôleur n'instancie pas directement la classe `MainPageService.java` mais demande au conteneur IoC de le faire à sa place avec l'annotation `@Autowired`. 
