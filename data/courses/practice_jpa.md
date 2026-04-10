---
title: "Activité pratique sur le mapping objet-relationnel et Spring JPA"
keywords: ORM, JPA, hibernate,
sidebar: web_architecture_sidebar
summary: Au cours de cette activité, vous allez définir un mapping entre les classes de votre application et une base de données relationnelles fournie.
toc: true
permalink: practice_jpa.html
---

<!-- {% include callout.html content="**Documentation**<br/><br/>
--- Documentation JPA et Hibernate : [http://docs.jboss.org/hibernate/](http://docs.jboss.org/hibernate/) (voir en particulier les
--- paquetages <em>core</em>, <em>entitymanager</em> et <em>annotations</em>). Ce sont ces parties de la documentation qui seront
--- utilisées tout le long de la séance." markdown="span" type="warning"%} -->


# Déroulement de l'activité

Cette activité est composée de trois parties vous permettant de comprendre les mécanismes de persistance des données manipulées dans une application Spring :

- La première partie permet d'identiﬁer tous les composants d'une application JPA sur un exemple simple.
- La seconde partie est un approfondissement des modalités de *mapping* pour la gestion des identiﬁants, de l'héritage et des associations.

La version avancée de l'activité apportera un complément sur les étapes suivantes :

- La troisième partie se focalise sur la gestion de l'environnement transactionnel des échanges avec la base de données, et le maintien de la synchronisation entre les objets en mémoire et les données stockées dans la base.


Cette activité repose principalement sur l'observation de code fourni, mais n'hésitez pas à prendre le temps de le compléter pour tester les fonctions de persistance des données.

# Contexte de l'activité pratique

Au cours de cette activité, vous allez utiliser le projet Spring *comrec* fourni dans l'[environnement de développement dockerisé](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment), environnement que vous avez dû déjà mettre en place et testé précédemment.


## Le projet *comrec*

Pour appréhender JPA, vous utiliserez l'application *Gestion des commissions* (projet *comrec*). Elle consiste à répartir une enveloppe ﬁnancière entre un ensemble d'employés sous la responsabilité d'un même gestionnaire. Le gestionnaire et l'enveloppe à distribuer doivent être des paramètres à fournir lors de l'exécution de l'application.

![Le projet *gestpers*](images/web_architecture/comrec.png)

### Les classes de l'application


Pour aborder ce projet sans avoir au préalable étudié la partie de l'UV dédiée aux données relationnelles, les données manipulées par l'application sont décrites du côté de l'application uniquement. Ceci permet d'éviter l'utilisation du jargon relationnel.

L'application *comrec* comporte quatre classes :

- les personnes (*Person*)
- les employés (*Emp*) qui forment un sous-type de *Person*,
- les vacataire (*CasualEmp*) également un sous-type de *Person*.
- et les départements (*Dept*).

Les classes *Emp* et *CasualEmp* sont donc des sous-classes de *Person*.
Un employé est affecté à un département et un employé a un manager qui est également un employé. Un employé manager a une liste d'employés dont il est responsable.

Le schéma conceptuel suivant formalise la structuration de l'application.

{% include image.html file="web_architecture/schemaConceptuelData.png" alt="Schéma conceptuel de données" caption="Figure 1 - Schéma conceptuel de données" %}


### Organisation des sources

Les sources de l'application *« Gestion des commissions »* sont composées des répertoires et ﬁchiers suivants :

- Le paquetage `entities`. Vous y trouverez la hiérarchie des classes `Person.java`, `Emp.java`, `CasualEmp.java` et `Dept.java` ;
- Le paquetage `dao` qui contient les classes `EmpDAO.java` et `DeptDAO.java` ;
- Le package `main` qui contient la classe `Main.java` ;
- Le ﬁchier `application.properties` se trouve dans le répertoire `src/main/resources/`. Il décrit la connexion à la base de données et des paramètres de jpa

 {% include image.html file="web_architecture/bd_tp_jpa_classes_appli.png" alt="Diagramme de classes de l'application" caption="Figure 2 - Diagramme de classes de l'application" %}

### Les traitements eﬀectués

Les traitements eﬀectués par l'application sont très simples et consistent principalement à aﬀecter une commission à un employé. La classe métier qui implante ce code, `Main.java`, utilise pour cela deux classes « utilitaires », `EmpDAO.java` et `DeptDAO.java`. La première gère l'ensemble d'employés. La deuxième gère l'ensemble de départements.

Les collections sont des objets qui permettent de gérer des ensembles d'autres objets. En Java, vous avez certainement déjà utilisé la classe `LinkedList.java` ou `ArrayList.java` pour gérer un ensemble d'objets. Et bien, dans le jargon des ORM, on utilise le terme *collection persistante* pour faire référence à des classes qui gèrent un ensemble d'objets qui doivent être stockés dans une base de données relationnelle. Dans notre application, les employés et les départements sont des objets qui doivent être stockés dans la base de données. Donc, `EmpDAO.java` et `DeptDAO.java` sont des *collections persistantes*.

La ﬁgure 2 correspond au diagramme de classes de cette application. Les classes `Person`, `Dept`, `Emp` et `CasualEmp` correspondent à celles présentées dans le paragraphe précédent.

{% include important.html content="Il est recommandé de dissocier les classes en charges des opérations CRUD sur les modèles, i.e. les classes DAO, des collections persistantes permettant de manipuler/filtrer les modèles. Dans le framework Spring, ces collections persistantes sont matérialisées par des sous-classes de *Repository*. Pour des raisons de simplification dans cette première activité pratique, ces deux fonctionnalités CRUD + collections persistantes sont regroupées dans les DAO." %}


## Exercices

### Exercice 1 (*découverte de JPA via un cas simple*)

Au cours de cette première étape, vous allez parcourir l'ensemble des éléments à prendre en compte pour développer une application très simple qui utilise Spring JPA/Hibernate et qui stocke de manière persistante les données dans une base de données relationnelle.

#### Le ﬁchier de conﬁguration `application.properties`

Une application Spring est associée à une configuration qui peut être définie en Java dans le code ou bien externalisée dans un fichier de configuration `application.properties` situé dans le répertoire *resources/*.

En analysant le contenu du fichier `application.properties`, vous trouverez les informations suivantes :

- le nom de la base de données PostgreSQL qui sera utilisée
- le login utilisé pour accéder à la base
- le mot de passe correspondant à ce login
- le mode d'interaction entre l'application et la base de données (propriété *ddl-auto*)
- le nom des classes Java dont les instances seront « persistées » (on dit qu'elles seront *mappées* dans la base de données)

Concernant le mode d'interaction *ddl-auto*, quelques précisions sont nécessaires. Ce paramètre indique à Spring JPA comment il doit gérer la base de données lorsque l'application est exécutée :

- `ddl-auto=create` à chaque démarrage de l'application, la base de données est recréée à partir de la structure du code. Ce mode est notamment utilisé lors de la phase de test.
- `ddl-auto=update` à chaque démarrage de l'application, le schéma de la BD est comparé à celui de l'application dont le code a pu évoluer. Dans ce cas la BD est mise-à-jour en fonction du code, ce qui est généralement utilisé lors de la phase de développement.
- `ddl-auto=none` aucun ajustement de la BD est effectué, ce mode est utilisé en production une fois que l'on est certain que la BD est conforme au code Java et inversement.

Vous pouvez notamment voir que l'application est configurée pour demander à Spring de ne pas démarrer un serveur web tomcat : `spring.main.web-application-type=NONE`

##### **Question 1.1**

Au cours de cette activité, il sera intéressant de suivre l'évolution de la BD en fonction des méthodes invoquées dans l'application.
Assurez-vous tout d'abord que les services PostgreSQL et PgAdmin sont démarrés dans votre environnement dockerisé. Une manière de tester est de vous rendre directement à l'url de [PgAdmin](http://127.0.0.1:5051/). Si vous ne voyez pas l'interface PgAdmin, vérifiez que les conteneurs Docker associés à ces deux services sont bien démarrés.


 Depuis l'interface de *PgAdmin4*, authentifiez-vous (utilisateur: *pguser@admin.com* et mot de passe : *pgpwd*), puis clickez sur *Servers* (il faudra remettre le mot de passe) puis sur *Databases -> comrec_db*.

Dans la BD *comrec_db*, allez dans le sous-menu *Schemas $$\rightarrow$$ Public $$\rightarrow$$ Tables*.

 Quelles sont les tables de la base ?

##### **Question 1.2**

Regardez ensuite le code de l'application (méthode `main` et le constructeur). Depuis un terminal positionné
dans le répertoire du projet *comrec* tapez l'instruction *Maven* `mvn spring-boot:run`, un menu interactif devrait vous être proposé. 
Observez le contenu de la base de données puis exécutez la méthode `part1()`.


Rafraîchissez ensuite la vue sur la base de données avec pgAdmin (click droit puis `Refresh`). Listez maintenant les tables stockées et leur contenu.

 {% include important.html content="pour voir le contenu d'une table, sélectionnez-la et, à l'aide du menu contextuel (click droit avec la souris), sélectionnez *View/Edit Data*." %}


##### **Question 1.3**

Modiﬁez avec pgAdmin le nom d'un employé. Pour cela, demander d'aﬃcher le contenu de la table correspondante puis modiﬁez directement la valeur que vous souhaitez. Demandez à sauvegarder les changements puis à rafraîchir pgAdmin pour vous assurer que la modiﬁcation a été prise en compte dans la base de données (voir figure ci-dessous). Relancez ensuite l'exécution de la méthode `part1()` de l'application. Rafraîchissez la page pgAdmin. Que constatez vous ?

{% include image.html file="web_architecture/bd_tp_jpa_icones_sauvegarder_rafraichir.png" alt="" caption="Figure 3 - Icônes pour sauvegarder des modifications puis rafraîchir la page sur pgAdmin" %}

Modifiez la configuration de votre application pour que les modifications faites directement dans la BD ne soient pas écrasées au démarrage de l'application.

#### Le *mapping* entre les classes et les tables

Le lien (ou le *mapping*) entre une classe Java, dont on veut faire persister les instances, et une table du SGBDR qui les stockera, est décrit dans la classe Java au moyen d'annotations. La spéciﬁcation JPA permet aussi de spéciﬁer ce *mapping* en utilisant des ﬁchiers XML mais nous ne verrons pas cet aspect dans cette activité. Les annotations sont privilégiées pour rapprocher les instructions de persistence au plus près du code.

{% include important.html content="une annotation en Java commence par le symbole `@` et est compilée avec la classe qui la contient." %}

Nous allons nous intéresser dans un premier temps au *mapping* de la classe `Dept`.
L'[introduction à JPA dans l'UV](lecture_jpa.html) n'apporte pas tous les détails sur le système d'annotation de JPA. Vous aurez besoin de consulter la documentation officielle d'Hibernate pour saisir certaines subtilités de JPA ([Doc JBoss Hibernate](http://docs.jboss.org/hibernate/annotations/3.5/reference/en/html_single/#entity-mapping-entity)).

##### **Question 1.4**

Quelle annotation permet d'indiquer à Hibernate que les instances de la classe `Dept` doivent être persistées (stockées dans une base de données) ?

##### **Question 1.5**

Dans quelle annotation est déﬁni le nom de la table contenant les départements ?

Annulez les modifications de la question 1.3 et modifiez le nom de la table contenant les départements dans la classe `Dept`, exécutez l'application et vérifiez que le nom de la table dans la base de données a bien changé.

Modifiez la classe `Dept` pour que le nom de la table correspondante soit à nouveau celui d'origine.

##### **Question 1.6**

L'annotation `@Column` est utilisée pour indiquer le nom de la colonne correspondant à un attribut. Par exemple, dans la classe `Dept` l'attribut `deptNumber` sera mappé avec la colonne `dept_no` de la table `departments`. Vérifiez que c'est le cas. Modiﬁez l'annotation pour changer le nom de la colonne dans la base de données.

Quel sera le nom de la colonne correspondant à l'attribut `location` de la classe `Dept` ?

##### **Question 1.7**

En l'absence d'annotation, un attribut d'une classe annotée `@Entity` est-il persisté ? Si oui, comment on indique à Hibernate qu'un attribut ne doit pas l'être ?


##### **Question 1.8**

Quel est le nom de la colonne de la table `departments` qui est clé primaire de la table ? À quel attribut de la classe `Dept` correspond-t'il ? Quelle annotation permet d'indiquer à Hibernate que l'attribut correspond à la clé primaire de la table ?

##### **Question 1.9**

Un des rôles de Hibernate est de créer des objets à partir des lignes d'une table d'une base de données et vice-versa. Quel constructeur de la classe `Dept` peut utiliser Hibernate pour créer ces objets ?

##### **Question 1.10**

En conclusion, quels sont les éléments spéciﬁques d'une classe persistante ?

#### Collections persistantes

Comme mentionné dans l'introduction, les classes `EmpDAO` et `DeptDAO` gèrent les objets employés et départements à persister, respectivement. Elles doivent donc offrir des méthodes CRUD (*Create/Read/Update/Delete*) qui s'appliquent sur la base de données.

##### **Question 1.11**

Quelles sont les méthodes CRUD proposées par la classe `DeptDAO` ?

Dans chacune de ces méthodes vous trouverez l'utilisation de une (ou des) méthode(s) de la classe `EntityManager`. Cette classe est fournie par JPA pour réaliser effectivement le lien avec la base de données.


{% include important.html content="si vous regardez bien le code des méthodes CRUD, vous verrez la présence de l'annotation *@Transactional*. Cette notion vue dans la partie données de l'UV est primordiale. Imaginez que plusieurs utilisateurs exécutent l'application *comrec* pour supprimer, modifier, ajouter des employés. Il faut alors forcément disposer d'un mécanisme pour s'assurer que des accès concurrents à une même base de données ne conduisent pas à des incohérences dans les données. C'est le rôle d'une transaction. Pour effectuer une modification des données dans la base, il faut bloquer l'accès (verrous) à ces données à l'aide d'une transaction. Si d'autres clients veulent accéder, voire modifier ces mêmes données, leurs requêtes pourront être mise en attente que la première transaction se termine. En fin de méthode, soit toutes les modifications effectuées sur la BD dans la méthode sont effectivement sauvegardées dans la base soit elles sont toutes annulées. Elles sont notamment annulées si une exception survient lors de l'exécution de la méthode. Pour le moment, les transactions sont gérées dans les DAO et ouvertes pour chaque méthode modifiant la BD. Cette pratique sera revue ultèrieurement car les transactions doivent être gérées au niveau de la couche service. De plus, par défaut, dans une classe de type @Repository une transaction en lecture seule est ouverte au début de chaque méthode. L'annotation @Transactionnal n'est donc indispensable que pour les méthodes effectuant des modifications des données." %}

##### **Question 1.12**
Regardez le code de la méthode `addDept` de `DeptDAO`. Quelle est la méthode de la classe `EntityManager` qui est utilisée pour ajouter le nouveau département dans la base de données ?

Lisez maintenant la documentation de l'API Java de cette classe [ici](https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManager.html). Dans quels cas il faudra utiliser cette méthode ?


##### **Question 1.13**

Pour chaque opération CRUD ci-dessous identifier la méthode d'*EntityManager* à invoquer pour effectuer l'accès à la BD :
- *Create*
- *Retrieve*
- *Update*
- *Delete*

#### Connexion et contexte transactionnel

L'objectif de l'application *Gestion des commissions* est de répartir une enveloppe d'argent entre les collaborateurs d'un employé de l'entreprise. L'application doit donc être capable de créer des employés et des départements et de les rendre persistants. C'est le rôle de la méthode `part1()` de la classe `Main`. Son principe de fonctionnement est *simple* : créer les instances en mémoire (appels au constructeur des classes), puis demander à la collection persistante de la persister (appel à la méthode `addDept()` e.g.).

##### **Question 1.15**

Quelles sont les manipulations des instances de la classe `Emp` qui sont faites dans `part1()` avant de demander leur persistance ?


##### **Question 1.16**

Et pour vérifier vos connaissances sur la gestion de la persistance des donnéesdans une application Java en utilisant JPA, répondez aux questions suivantes :

- Les classes qui réalisent les opérations CRUD sont-elles les mêmes que celles où est décrit le *mapping* objet-relationnel ?
- Dans les classes qui réalisent les opérations CRUD, quelle objet est utilisée pour accéder à la base de données ?
- Les classes qui réalisent les opérations CRUD sont-elles en charge d'ouvrir ou de fermer les transactions sur la base de données ?
- Les classes qui contiennent les informations de *mapping* objet-relationnel sont-elles en charge d'ouvrir ou de fermer les transactions sur la base de données ?

### Exercice 2 (*deuxième étape : retour sur le mapping*)

Dans cet exercice, nous allons revenir sur le *mapping* dans des cas plus complexes, via l'examen de la classe `Person` et de sa classe ﬁlle `Emp`. En particulier vous aller voir comment on gère avec JPA les associations entre classes et l'héritage.

#### Gestion des identiﬁants / clé primaire

Vous avez vu dans une des questions de l'exercice précédent que l'annotation `@Id` permet d'indiquer quel est l'attribut de la classe qui doit être mappé avec la clé primaire de la table correspondante.

##### **Question 2.1**

Quel est cet attribut pour la classe `Person` ? Quel est le nom de la colonne correspondante dans la base de données ?

##### **Question 2.2**

À quoi sert l'annotation `@GeneratedValue` ? Comment est-elle utilisée dans la classe `Person` ?

Depuis l'interface de *PgAdmin*, retrouvez les éléments de la base de données qui permettent de gérer les *GeneratedValues*.


#### Gestion de l'héritage

La classe `Emp` hérite de la classe `Person` (voir le diagramme de classes de la figure 1). Outre les instructions Java exprimant l'héritage, il y a dans ces classes des annotations qui décrivent comment cet héritage est géré côté SGBDR.

Utilisez la documentation d'Hibernate référencée à la fin de l'atelier.

##### **Question 2.4**

Quel est le type de *mapping* utilisé pour gérer l'héritage `Person` - `Emp` ?


#### Gestion des associations

Nous allons maintenant examiner les associations entre classes persistantes. Un exemple d'association entre classes persistantes dans l'application est celle qui existe entre `Emp` et `Dept` (voir ﬁgure 1).

<!-- Vous savez que, lors de la dérivation d'associations entre classes, on analyse 2 (ou 3 types d'associations) : les 1-N, N-M (et les 1-1). Dans JPA, il est possible de gérer le *mapping* de ces trois types d'associations. -->

##### **Question 2.6**

Quel est l'attribut de la classe `Emp` qui permet de retrouver l'instance de `Dept` à laquelle elle est rattachée ?
<!--private Dept dept;-->

##### **Question 2.7**

Analysez les annotations associées à cet attribut (consultez la section 2.2.5.2 de la documentation JBoss Hibernate), expliquez leur signiﬁcation.

<!--
@ManyToOne Plusieurs Emps associés à une même instance de Dept
@JoinColumn(name = "dept_fk") Nom de l'attribut dans la table Emp contenant la référence vers le département
     -->
##### **Question 2.8**

Analysez maintenant l'attribut `emps` de la classe `Dept` et l'annotation associée (consultez la section 2.2.5.3.1 de la documentation JBoss Hibernate).

##### **Question 2.9**

Expliquez maintenant le rôle des annotations associées aux attributs `manager` et `lower` de la classe `Emp`.

##### **[OPTIONNEL]Question 2.10**

D'après la documentation (consultez la section 2.2.5.3 de la documentation JBoss Hibernate), quels autres types pourraient avoir l'attribut `emps` ?

<!-- Unidirectionnal with a join table -->

##### **Question 2.11**

Nous allons étudier la notion de répercution des actions menées sur une base de données (action en `cascade` sur une annotation d'association comme e.g. `@ManyToOne`).


Vous avez vu dans l'exercice précédent que c'est dans la méthode `part1()` de la classe `Main` que les données (employés et départements) sont ajoutées dans la base de données.

Commentez le code nécessaire de cette méthode de manière à ce que seulement l'employé *King* soit créé dans la base de données (le stockage des départements doit aussi être commenté).

Complétez l'annotation de la propriété d'instance dans la classe *Emp.java* pour ajouter la propriété `cascasde`:

```java
...
@Entity
public class Emp extends Person {
    ...
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "dept_fk")
    private Dept dept;
    ...
```

Exécutez l'application et vériﬁez à l'aide de pgAdmin, que l'employé et son département ont bien été créés.

Supprimez maintenant l'attribut `cascade` de l'annotation `@ManyToOne`. Lancez l'exécution de l'application.

Que constatez vous ? Comment expliquez vous ce comportement ?

##### **Question 2.12**

Corrigez le comportement observé sans ajouter à nouveau l'attribut `cascade`.


<!-- COMPLEMENT AVEC LE CHARGEMENT LAZY EAGER-->


{% include callout.html content="**Pour aller plus loin ...** Consultez la documentation officielle d'Hibernate pour avoir plus de détails sur les annotations JPA [Doc JBoss Hibernat](https://docs.jboss.org/hibernate/stable/annotations/reference/en/html/)." %}
