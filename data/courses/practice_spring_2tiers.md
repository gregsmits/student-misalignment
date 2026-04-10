---
title: "Développement d'une application web multi-couches avec Spring"
keywords: Spring, multi-couches, ORM, JPA, hibernate,
sidebar: web_architecture_sidebar
summary: En s'appuyant sur une architecture technique composée de deux tiers (un tier BD et un tier application + web) vous allez découvrir et compléter la structure d'application web Java Spring.
toc: true
permalink: practice_spring_2tiers.html
---

<!-- {% include callout.html content="**Pré-requis**<br/><br/>


- Maîtriser l'[environnement technique de développement](technical_environment_home.html)<br/>
- Connaître la notion d'architecture [technique N-tiers](lecture_technical_architecture.html) et [logicielle multi-couche](lecture_software_architecture.html)
- Connaître le modèle [MVC](lecture_mvc_spring.html)

" markdown="span" type="danger"%} -->

# Contexte de l'activité pratique

L'objectif de cette activité pratique est d'étudier la structuration d'une application web Spring et notamment l'articulation entre les fonctionnalités métier exposées, les composants de gestion des données et les vues (interface web).

Cette activité vous permettra également de voir l'intérêt d'un modèle en couches, notamment pour séparer les responsabilités des différents composants logiciels.

## Rappel sur l'architecture technique

L'environnement dockerisé utilisé dans cette UV fournit une architecture 2-_tiers_ pour assurer le fonctionnement de notre application web Spring :

- 1 _tier_ dédié aux données avec le service PostgreSQL
- 1 _tier_ pour la gestion des composants métier (serveur/conteneur d'applications) et la génération des vues de la couche présentation (serveur web)

Le premier _tier_ est dockérisé (conteneur Docker `serv_postgres_cn`) et le second correspond à votre machine puisque Spring démarre un serveur Tomcat pour y exécuter l'application. Une autre [activité pratique](practice_spring_2tiers_ext.html) vous permettra de voir comment externaliser le _tier_ de gestion de l'application.


## Présentation de l'application

L'application que vous utiliserez tout le long de cette activité est une application (simpliste) de gestion du personnel d'une entreprise. Elle stocke dans une base de données relationnelle les informations sur le personnel et le service (département) dans lequel une personne travaille et offre quelques fonctionnalités simples.

### Schéma conceptuel de données

La figure ci-dessous donne une version simplifiée du schéma conceptuel des données manipulées par cette application. Les employés sont regroupés par departement. Dans un département, on peut avoir plusieurs employés alors qu'un employé ne peut appartenir qu'à un seul département à un moment donné.

![Schéma conceptuel simplifié de la BD de l'application gestpers](images/web_architecture/gestpers_conceptual.png)

### Base de données

La base de données utilisée par l'application pour rendre les données manipulées persistantes est très simple et repose sur deux tables stockant respectivement les département (table _dept_) et les employés (table _pers_).

Depuis l'application web [PgAdmin](http://127.0.0.1:5051) de l'environnement dockerisé vous pouvez accéder à la BD nommée _gestpers_db_.

![Base de données gestpers_db](images/web_architecture/gestpers_db.png)

### Fonctionnalités de l'application

L'application doit offrir six fonctionnalités :

- la consultation des départements d'une entreprise,
- l'ajout d'un département,
- la fermeture d'un département,
- la consultation de l'annuaire de l'entreprise (liste du personnel),
- l'embauche d'une personne dans un département,
- le licenciement d'une personne.

La version fournie de l'application (répertoire `gestpers`) propose une implémentation des trois premières fonctionnalités. Après les avoir étudié, vous implémenterez celles concernant la gestion du personnel.

La figure ci-dessous montre l'interface graphique (rudimentaire) d'accès à ces fonctionnalités.

![Interface de l'application *gestpers*](images/web_architecture/app_gestpers.png)

<!--
### Schéma relationnel de données

Le schéma logique de la base de données utilisée par notre
application consiste en deux tables présentées dans la figure
ci-après et une vue (pas représentée dans la figure). La table `services` contient des
informations sur les différents services existant dans la
société (dans le sens département). La table `personnes` contient des informations sur
le personnel travaillant dans la société. Les flèches en
pointillées indiquent l'existence d'une contrainte de clé
étrangère entre les attributs.

{% include image.html file="archi/schema.png" max-width="400" alt="Schéma relationnel de données" caption="Figure 2 - Schéma logique de données" %} -->

# Structuration de l'application

Au-dessus du _tier_ données, l'application est structurée comme suit :

- les classes du paquetage `fr.atlantique.imt.inf211.gestpers.entity` définissent les données (entités) de l'application. Ces données sont persistées dans la base de données, mais cette fonctionnalité n'est pas à gérer au cours de cette activité.
- les classes du paquetage `fr.atlantique.imt.inf211.gestpers.dao` fournissent les méthodes CRUD de manipulation des entités.
- les classes du paquetage `fr.atlantique.imt.inf211.gestpers.service` regroupent les fonctionnalités métier exposées aux clients de la couche application.
- les classes du paquetage `fr.atlantique.imt.inf211.gestpers.controller` contiennent les contrôleurs invoqués par les requêtes des clients. Le contrôleur récupère ensuite les modèles de données pour construire les vues..

Ces quatre paquetages Java sont disponibles dans le répertoire `gestpers/src/main/java` de l'application.

La figure ci-dessous schématise la structuration de ces composants. L'implémentation des composants grisés est fournie.

![Architecture de l'application *gestpers*](images/web_architecture/gestpers_arch.png)

## La couche présentation

Une couche présentation (très rudimentaire) est également fournie et son implémentation est disponible dans le répertoire `gestpers/src/main/resources`. Cette couche présentation est composée de fichiers HTML regroupés dans le répertoire `templates/`, ainsi que de resources supplémentaires (images, css, js) dans le répertoire `static/` et des contrôleurs Spring (des classes annotées `@Controller`) pour faire le lien avec la couche métier.

Les fichiers HTML sont des _templates_ utilisant _thymeleaf_. [_Thymeleaf_](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html) est un moteur de rendu côté server, c'est-à-dire que les vues fournies aux utilisateurs sont générées par un serveur web (ici Tomcat automatiquement démarré par Spring) suite à l'interprétation d'instructions _thymeleaf_ embarquées dans les _templates_ HTML. Ces instructions permettent notamment d'invoquer des contrôleurs et de récupérer les modèles qu'ils génèrent.

Pour illustrer le lien entre l'accès à des URL par le client, les contrôleurs et les modèles construits par ceux-ci (souvent via l'appel à des services), considérons le cas de l'accès à la fonction _lister les départements_. Lorsque sur l'interface de l'application _gestpers_ le client clique sur _list of departments_, une requête HTTP `GET` avec l'URL `departments` (voir fichier `index.html`) est envoyé au serveur. Le _mapping_ entre URL et code Java à exécuter se fait dans les contrôleurs Spring (voir [cours dédié](lecture_mvc_spring.html)). C'est donc le code de la méthode `listOfDepartments` de `DepartmentController.java` qui sera exécuté. Le contrôleur demande la liste des départements au service correspondant pour construire le modèle à transmettre au client (la liste de départements) et indique quelle est la vue (le fichier HTML) qui met en forme le modèle. Le code ci-dessous montre le code de la méthode. Le modèle transmis à Thymeleaf est construit par le contrôleur et prend la forme d'un ensemble de variables de contexte. Voici ci-dessous le code du contrôleur qui permet l'affichage de la liste des départements.

```java
@RequestMapping(value = "/departments", method = RequestMethod.GET)
public ModelAndView listOfDepartments(){
  ModelAndView mav = new ModelAndView("departments.html");
  List<Department> li = sServ.listOfDepartments();
  mav.addObject("departmentslist", li);
  return mav;
}
```

En ce qui concerne la vue, il s'agit ici du fichier `departments.html` qui doit se trouver dans le répertoire `templates/`. Le code ci-dessous montre comment afficher les départements stockés dans la base de données. Ce code est extrait du fichier `departments.html` qui et interprété par le serveur Tomcat pour remplacer les appels à Thymeleaf (attributs de balise préfixés par `th`). Ici le modèle est constitué d'une liste de descriptions de départements (`departmentslist`).

```html
<span th:if="${#lists.size(departmentslist)} == 0">No service stored</span>
<span th:if="${#lists.size(departmentslist)} > 0">
  <table>
    <tr th:each="serv : ${departmentslist}">
      <td th:text="${serv.id}" />
      <td th:text="${serv.name}" />
    </tr>
  </table>
</span>
```

{% include callout.html content="**Attention**, lorsque la requête HTTP inclut des paramètres, il faut les faire correspondre **exactement** (nom et type) avec les paramètres de la méthode Java que doit être exécutée ! Par exemple, si vous regardez le *mapping* pour l'ajout d'un département, la requête HTTP contient un paramètre `name` qui est une chaîne de caractères. La méthode `addDepartmentData` doit absolument avoir un (seul) paramètre `name` de type `String`. Sinon, Spring ne trouvera pas le *mapping* pour l'URL... " markdown="span" type="danger"%}

#### Exécution de l'application

Depuis le répertoire racine de l'application _gestpers_ (`Docker_environment/gestpers/`) exécutez l'application :

- `mvn spring-boot:run`

Puis, rendez-vous sur l'[interface de l'application](http://127.0.0.1:8080) pour tester les fonctionnalités de manipulation des départements.

#### **Question 1**

Tracez la suite d'invocations de méthodes impliquée lorsqu'un utilisateur demande l'ajout d'un département. Validez votre réponse par un enseignant avant de passer à la question suivante.

#### **Question 2**

Poursuivre l'implémentation des fonctionnalités de l'application dédiées à la manipulation du personnel de l'entreprise en vous inspirant de celle des fonctionnalités associées aux départements.

#### **Question 3**

Revenons sur la fonctionnalité de suppression d'un département. Dans la version fournie, supprimer un département ne conduit pas à supprimer ses membres. Ces membres ne sont plus affectés à un départment. Faites le test.

Vous allez désormais modifier le code de la fonctionnalité de suppression d'un département pour supprimer en même temps tous ses membres. Dans la méthode `public void removeDepartement(Integer id)` il faut donc supprimer les membres du département, puis le département lui-même. Pour cela il faut :

1. ajouter une méthode `public Boolean removeMembers(Integer deptId)` dans `PersonDAO.java` qui supprime les membres du département `deptId`,
2. écrire le code de la méthode `removeDepartement` qui consistera donc à appeler la nouvelle méthode créée dans `PersonDAO.java` puis l'équivalente pour le département (`public Boolean remove(Integer id)` de `DepartmentDAO.java`).

Ceci conduit évidemment à plusieurs requêtes de type `DELETE` dans la base de données. Imaginez qu'au milieu de ces requêtes, un autre client, depuis l'interface graphique de votre application web, ajoute un membre à ce département ou souhaite simplement afficher sa description ou sa composition. Il vous faut donc déclarer que l'ensemble des requêtes effectuées pour la suppression d'un département se déroulent dans une unique unité d'exécution en base de données, i.e., une transaction.

{% include callout.html content="**Attention** Dans les codes fournis, les transactions étaient gérées au niveau des DAO car nous n'effectuions que des opérations sur des entités seules, éventuellement avec de la propagation en cascade gérée par la base de données. En pratique, ce sont les fonctionnalités métier définies dans les services qui constituent des opérations atomiques sur les entités. Il faut donc gérer les transactions dans la couche service en encapsulant chaque fonctionnalité dans une transaction (préfixer les méthodes par l'annotation `@Transactional`)." markdown="span" type="danger"%}


#### **Question 4**

Spring JPA propose un mécanisme très efficace, car il y a peu de code à écrire, pour manipuler des instances et des collections d'instances persistées, les interfaces de type *Repository*.
Bien que l'on trouve encore des applications reposant sur un ensemble de classes *DAO* pour fournir des fonctionnalités CRUD, le recours aux classes *Repository* est devenu un standard.

Modifier votre application *gestpers* afin de remplacer :
- les classes DAO par des classes implémentant l'interface *CrudRepository*,
- les méthodes de récupération de collections persistantes (et leurs requêtes JPQL associées) par des classes implémentant l'interface *JpaRepository*.

Utilisez le cours sur les [classes *Repository*](lecture_jpa_repository.html) et la documentation officielle ([*CrudRepository*](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html) et [*JpaRepository*](https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/JpaRepository.html)) pour vous aider.