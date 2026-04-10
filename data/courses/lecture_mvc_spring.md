---
title: L'architecture logicielle dans Spring
keywords: couches logicielles, architecture logicielle, MVC, Spring
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_mvc_spring.html
summary: Le patron de conception Modèle Vue Contrôleur est prépondérant, notamment pour les applications web. Cette section présente comment ce modèle est implémenté dans le framework Spring.
---

<!-- Objectifs pédagogiques

- expliquer du point de vue du développement les différents éléments nécessaire pour implémenter le patron MVC avec Spring
- expliquer luel(s) rôle(s) joue Spring dans les applications de l'UE
- expliquer ce que c'est qu'un contrôleur Spring et à quoi il sert -->

## Découpage fonctionnel d'une application Spring

Lors de la présentation des [architectures techniques des applications web](lecture_technical_architecture.html) nous avons introduit la notion d'_Application management server_ (ou serveur d'applications). Il s'agit d'un service qui s'occupe, entre autres, de la gestion de l'exécution des composants logiciels de l'application, c.-à-d. leur cycle de vie (création/destruction). Spring en est un exemple. Il facilite le développement d'applications Java web et il sera utilisé tout le long de l'UE. De plus, lorsqu'une application Spring de type web est démarrée, Spring démarre automatiquement un serveur Tomcat (ou Jetty selon la configuration) pour assurer la fonction de serveur Web. Ainsi, l'architecture technique des applications que vous developperez dans l'UE sera de type _2-tiers_ où la gestion des interactions avec les clients (web) ainsi que la gestion des composants logiciels des applications seront assurées par le même serveur (Spring avec un serveur Tomcat integré).

![Architecture deux tiers](images/web_architecture/2tiers2.png)

Par ailleurs, pour faciliter le développement d'applications respectant le principe de séparation des responsabilités au niveau de l'architecure logicielle, la décomposition fonctionnelle du code en [couches](lecture_software_architecture.html) (présentation, application ou métier et données) et l'utilisation du patron MVC sont inhérentes au framework Spring. Les principaux éléments à connaître facilitant cette structuration sont :

- couche données : bien que Spring n'intègre pas de serveur pour la persistance de données, il offre plusieurs éléments pour en faciliter l'accès :

  - les _entités_ (annotation _@Entity_), qui sont des classes Java représentant les données manipulées par l'application et persistées dans une base de données relationnelle
  - les _Data Access Object_ (DAO) qui sont des classes Java implémentant le patron DAO et qui fournissent donc les fonctionnalités de création, modification, suppression et ajout d'entités persistées
  - les _répertoires_ (annotation _@Repository_) sont des classes Java de collections d'objets d'un même type. Il est fréquent que les responsabilités de _DAO_ et _Repository_ soient regroupées, le répertoire fournissant l'ensemble des fonctionnalités de manipulation des entités. Spring fournit des interfaces, notamment _CrudRepository_, pour guider la définition des répertoires

- couche application : les fonctionnaliés de l'application sont regroupées en classes (Java) appelées _services_ (annotation _@Service_) chacune fournissant un sous-ensemble des points d'entrée de la logique métier,

- couche présentation : elle est matérialisée par des clases Java appelées _contrôleurs_ (annotation _@Controller_ ou _@RestController_) et, éventuellement, par les vues (par exemple des pages HTML) nécessaires à la visualisation des données.

<!-- Le modèle MVC couplé à des directives de séparation des responsabilités et de conception par contrats (spécifier dans une interface les fonctionnalités qu'un service s'engage à fournir) a conduit à des recommandations de structuration du code des applications web, notamment avec Spring. -->

<!-- La figure ci-dessous illustre le squelette d'une application Spring web autour des éléments suivants :

- les modèles (annotation _@Entity_) sont les classes représentant les données manipulées dans l'application
- les _Data Access Object_ (DAO) qui fournissent les fonctionnalités de création, modification, suppression et ajout d'entités persistées. Il s'agit d'un patron de conception et non d'un composant spécifique à Spring
- les répertoires (_@Repository_) sont des classes de collections d'objets d'un même type. Il est fréquent que les responsabilités de _DAO_ et _Repository_ soient regroupées, le répertoire fournissant l'ensemble des fonctionnalités de manipulation des entités. Spring fournit des interfaces, notamment _CrudRepository_, pour guider la définition des répertoires
- les services (_@Service_) qui fournissent les points d'entrée des fonctionnalités de la logique métier
- les contrôleurs (_@Controller_ et _@RestController_) sont les points d'entrée de l'application en définissant l'appariement (_mapping_) entre URL et fonctionnalités des services exposés -->

La figure ci-dessous illustre l'organisation de ces différents éléments au sein d'une application.

<img src="images/web_architecture/springClasses.png" width="90%" alt="Application schema"/>

La couche données est abordée dans les séances [data](data_home.html) de l'UE pour les aspects bases de données relationelles et dans celles consacrées à JPA ([cours](lecture_jpa.html) et travail pratique [pratique](practice_jpa.html)) pour ce qui est des entités, DAO et répertoires Spring. Nous présentons ci-dessous la démarche à suivre pour implémenter le patron MVC en Spring dans la couche présentation.

<!-- # Architecture Spring pour le développement

Dans le cadre des applications web de l'UV INF210, l'architecture utilisée sera de type _2-tiers_ où la gestion des interactions avec les clients ainsi que la gestion des composants logiciels des applications seront assurées par le même serveur.

![Architecture deux tiers](images/web_architecture/2tiers.png)

Lorsqu'une application Spring de type web est démarrée, Spring démarre automatiquement un serveur Tomcat (ou Jetty) pour assurer la fonction de serveur Web.

Spring gère également le cycle de vie des différents composants logiciels de votre application, remplissant ainsi le rôle de serveur d'applications. Vous verrez que, moyennant quelques modifications de la configuration, une application Spring peut être déployée sur un serveur d'applications dit lourd (comme Glassfish, Wildfly, etc.).

# Les applications Spring dans le cloud et les micro-services

Le principe de séparation des responsabilités au niveau de l'architecture technique va au delà de la séparation en _tiers_ où chaque _tier_ est dédié à un service majeur de l'application.

Nous verrons que la séparation des responsabilités au niveau logiciel conduira à un découpage en composants logiciels minimalistes en charge d'une fonctionnalité ciblée et indépendante. Pour tirer partie de ce découpage logiciel, les solutions en termes d'architecture logicielle ont fortement évoluées pour apporter davantage de flexibilité et de scalabilité (montée en charge).

Une solution qui devient un standard est de déployer une telle application dans une infrastructure technique (et logicielle) de type _cloud_. En fonction de la charge à supporter, en termes de requêtes clients, de taille des données, de temps des traitements, chaque _tier_ (processus indépendant dans l'architecture _cloud_) exécutant un composant logiciel peut être dupliqué. On aboutit ainsi à des architectures _N-tiers_. Un composant central d'une telle architecture logicielle s'occupe d'orchestrer les duplications ainsi que les redirections des requêtes vers les _tiers_ disponibles.

![Architecture N tiers pour le cloud et les micro-services](images/web_architecture/cloudArchitecture.png) -->

## MVC dans Spring

La décomposition fonctionnelle du code en couches (présentation, application, données) est inhérente au framework Spring, notamment lors de l'utilisation du module web et le patron MVC est au coeur de la structuration d'une application. La figure suivante illustre le processus MVC mis en place dans une application web implémentée avec Spring et met en lumière la structuration en couches.

<!-- a structuration de la couche présentationd'une application Spring web repose également sur trois niveaux ayant respectivement les responsabilités de gérer les données, le traitement sur les données et la présentation des données et traitement aux utilisateurs. Ce guide de structuration implémente le modèle dit Modèle-Vue-Contrôleur (MVC) : -->

La figure suivante illustre le processus MVC mis en place dans une application web implémentée avec Spring.

![procédure MVC](images/web_architecture/RequestLifecycle.png) <br/>
_[Figure issue de terasolunaorg](https://terasolunaorg.github.io/guideline/1.0.1.RELEASE/en/Overview/SpringMVCOverview.html) consultée le 08/01/24_

1- Toute requête _HTTP_ arrivée sur un serveur Spring est reçue par le _DispatcherServlet_

2- Il la renvoie au _HandlerMapping_ qui se charge d'identifier le contrôleur en charge de cette requête et l'indique au _DispatcherServlet_

3- Le _DispatcherServlet_ demande au _HandlerAdapter_ de gérer le traitement métier

4- Le _HandlerAdapter_ est sollicité pour invoquer le contrôleur

5- Le _Controller_ effectue les traitements métier (en sollicitant la couche application), construit le modèle qui va stocker les données à retourner accompagné du nom de la vue qui va les représenter

6- Le _DispatcherServlet_ invoque le _ViewResolver_ pour trouver et retourner la vue correspondant au nom retourné par le _Controller_ (fichier HTML, JSP, etc.)

7- Le _DispatcherServlet_ demande au processus de génération du rendu de retourner la vue finale

8- Le composant de génération de rendu des vues retourne la réponse au client

## Developper du MVC avec Spring

En tant que développeur et concepteur des architectures technique et logicielle, vous n'avez pas à gérer l'ensemble de ce processus de traitement des requêtes, de nombreux composants sont fournis par Spring (_DispatcherServlet_, _HandlerMapping_, _ViewResolver_). Vous devez plutôt vous concentrer sur les aspects indiqués par la suite.

### Création des contrôleurs

Les contrôleurs sont des classes Java avec l'annotation _@Controller_ ou _@RestController_. Elles correspondent aux classes qui reçoivent les requêtes des clients. En général, un contrôleur s'occupe de gérer un sous-ensemble cohérent des reqûetes. Par exemple, pour une application de gestion du personnel d'une entreprise, vous pouvez créer un contrôleur `PeopleController.java` qui devra gérer toutes les requêtes (au sens URL) qui concernent des opérations sur les informations des employés.

<!-- définissant les appariements (_mapping_) entre les URL invoquées par le client et la méthode (au sens Java) qui traitera chaque requête. Par exemple, pour une application de gestion du personnel d'une entreprise, vous pouvez créer un contrôleur `PeopleController.java` qui devra gérer toutes les requêtes (au sens URL) qui concernent des opérations sur les informations des employés. -->

```java
@Controller
public class PeopleController {
  ...
}
```

### Définition des appariements URL - méthode

Pour que le _HandlerMapping_ puisse identifier le contrôleur responsable de traiter une requête, ceux-ci doivent définir des appariements (_mappings_) entre URLs et méthodes (une méthode par URL). Par exemple, dans le code ci-dessous, lorsque le client envoie une requête HTTP `GET` à l'URL `.../people`, le _HandlerMapping_ identifie le contrôleur `PeopleController` comme devant traiter la requête. Le _HandlerAdapter_ invoque donc la méthode `listOfPeople` du `PeopleController`.

```java
@Controller
public class PeopleController {
  ...
  @RequestMapping(value = "/people", method = RequestMethod.GET) // Appariement URL-méthode
	public ModelAndView listOfPeople(){
        ...
    }
  ...
}
```

### Traitement de la requête du client

Il s'agit d'implémenter la méthode qui traite la requête. Dans cette implémentation, la logique métier doit être invoquée pour récupérer les données demandées par client mais elle doit construire également le modèle (c.-à-d. un ou plusieurs objets) qui sera retourné au client. Ce qui est rendu par la méthode peut être, soit le modèle et la vue (par exemple, une page HTML) pour le visualiser, soit le modèle directement.

#### Modèle et vue (_@Controller_)

Les méthodes des contrôleurs de type `@Controller` rendent le modèle et la vue qui permet de le visualiser. C'est le cas typique des interactions entre un navigateur web et un serveur Spring. L'exemple ci-dessous montre comment retourner un modèle (liste de _Person_) dont les attributs pourront être affichés dans la vue _people_ (`people.html`).

```java
@Controller
public class PeopleController {
  ...
  @RequestMapping(value = "/people",  method = RequestMethod.GET) // Appariement URL-méthode
	public ModelAndView listOfPeople(){
    // Logique métier : chercher toutes les personnes
    List<Person> li = pDAO.findAll("name", "ASC");

    // Construction du modèle et la vue rendus par la méthode
    ModelAndView mav = new ModelAndView("people.html");
    mav.addObject("peopleList", li);
    return mav;
	}
  ...
}
```

Enfin, dans le cas des applications web, la définition de la vue est une page HTML qui est capable de recupérer le modèle et de le mettre en forme pour être visualisé dans la page. Il existe plusieurs manières de rendre ceci possible. Une des plus utilisées dans Spring est l'utilisation des _templates_ Thymeleaf. Ci-dessous, un extrait de la page `people.html` qui met en forme la liste des personnes passées par le contrôleur. Vous trouverez plus d'informations sur Thymeleaf [ici](https://www.thymeleaf.org/).

```html
<table>
  <tr th:each="pers : ${peopleList}">
    <td th:text="${pers.id}" />
    ...
  </tr>
</table>
```

#### Modèle sans vue (_@RestController_)

Les méthodes des contrôleurs de type _@RestController_ retournent le modèle uniquement et pas une vue pour le visualiser. C'est le cas typique des interactions entre applications en utilisant une API REST. L'objet rendu et représenté dans un format d'échange de données (JSON par défaut). La transformation de l'objet [sérialisable](https://docs.oracle.com/javase/8/docs/api/java/io/Serializable.html) en JSON e.g., est automatique avec Spring, même si parfois, il est nécessaire de faire quelques ajustements.

<!-- L'implémentation d'un service associé à une API REST est très simple en Spring. Par rapport à l'exemple précédent, deux modifications sont à effectuer : -->

```java
@RestController
public class PeopleController {
  ...
  @RequestMapping(value = "/people",  method = RequestMethod.GET) // Appariement URL-méthode
  @ResponseBody // L'objet doit être inclu dans le corps de la requête HTTP de retour
  List<Person> listOfPeople() {
    return pDAO.findAll("name", "ASC");
  }
  ...
}
```

Ainsi, invoquer l'URL _localhost:8081/people_ correspond à un appel distant par HTTP de la méthode _listOfPeople_ et retourne la liste des personnes formatée en JSON.

```
smits@salsa-27-45 ~ % curl -v localhost:8081/people
*   Trying 127.0.0.1:8081...
* Connected to localhost (127.0.0.1) port 8081 (#0)
> GET /getpersons HTTP/1.1
> Host: localhost:8081
> User-Agent: curl/8.1.2
> Accept: */*
>
< HTTP/1.1 200 OK
< Connection: keep-alive
< Transfer-Encoding: chunked
< Content-Type: application/json
< Date: Mon, 04 Dec 2023 12:47:04 GMT
<
[ {
  "id" : 3,
  "job" : "Ing",
  "name" : "Tanguy",
  "phone" : "1567",
  "service" : {
    "id" : 2,
    "name" : "DSD"
  },
  "firstName" : "Philippe"
}, {
  "id" : 1,
  "job" : "EC",
  "name" : "Segarra",
  "phone" : "1338",
  "service" : {
    "id" : 1,
    "name" : "Info"
  },
  "firstName" : "Mayte"
},
...
]
```

<!-- # Découpage fonctionnel d'une application Spring

Le modèle MVC couplé à des directives de séparation des responsabilités et de conception par contrats (spécifier dans une interface les fonctionnalités qu'un service s'engage à fournir) a conduit à des recommandations de structuration du code des applications web, notamment avec Spring.

La figure ci-dessous illustre le squelette d'une application Spring web autour des éléments suivants :

- les modèles (annotation _@Entity_) sont les classes représentant les données manipulées dans l'application
- les _Data Access Object_ (DAO) qui fournissent les fonctionnalités de création, modification, suppression et ajout d'entités persistées. Il s'agit d'un patron de conception et non d'un composant spécifique à Spring
- les répertoires (_@Repository_) sont des classes de collections d'objets d'un même type. Il est fréquent que les responsabilités de _DAO_ et _Repository_ soient regroupées, le répertoire fournissant l'ensemble des fonctionnalités de manipulation des entités. Spring fournit des interfaces, notamment _CrudRepository_, pour guider la définition des répertoires
- les services (_@Service_) qui fournissent les points d'entrée des fonctionnalités de la logique métier
- les contrôleurs (_@Controller_ et _@RestController_) sont les points d'entrée de l'application en définissant l'appariement (_mapping_) entre URL et fonctionnalités des services exposés

La figure ci-dessous illustre l'organisation de ces différents éléments au sein d'une application.

![Spring application](images/web_architecture/springClasses.png) -->
