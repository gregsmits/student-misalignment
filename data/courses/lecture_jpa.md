---
title: JPA avec Spring
keywords: données persistantes, JPA, ORM, architecture logicielle, MVC, Spring
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_jpa.html
summary: Cette section aborde la problématique de l'appariement (mapping) des données manipulées en mémoire par l'application et leur « jumeau » persisté dans une base de données. La solution technique préconisée est de recourir à un ORM (« Object Relational Mapping»), c.-à-d. l'association entre un objet de l'application et une relation (table) de la base de données.
---

<!-- Objectifs pédagogiques

- expliquer la notion d'ORM, son rôle et intérêt et les inconvénients
- expliquer ce que c'est JPA et citez deux/trois exemples de fournisseurs JPA
- expliquer la notion d'entité et ses états _gérée_ et _détachée_
- expliquer l'utilité des annotations `@OneToMany` et `@ManyToOne` de JPA
- expliquer le rôle de l'_Entity Manager_ de JPA
- expliquer les stratégies de chargement d'entité en JPA -->

## Principe d'un ORM

Un ORM (_« Object Relational Mapping »_), comme son nom l'indique, est une solution technique pour faire le lien entre le monde objet et le monde des bases de données relationnelles. Il est donc capable 1) de se connecter à une base de données relationnelles, 2) d'associer les objets, classes et attributs manipulés par une application avec des lignes, des tables, des colonnes et des contraintes d'une base de données relationnelle et de 3) produire automatiquement les requêtes SQL relatives aux actions CRUD (_Create/Read/Update/Delete_) sur vos objets et de les engager en base de données.

L'intérêt principal est de masquer au développeur le fait que l'objet manipulé dans une application corresponde à un tuple d'une base de données, rendant ainsi indépendant la manipulation des objets et les choix du mécanisme de persistance.

Les avantages à utiliser un ORM sont les suivants :

- abstraction quasi totale du langage SQL : c'est le rôle de l'ORM de produire le code SQL équivalent aux actions sur les objets de l'application,

- indépendance vis-à-vis de la base de données utilisée : comme l'application ne contient pas de code SQL, elle n'est pas liée à une base de données précise. Vous êtes donc libres de changer votre serveur de bases de données relationnelles à tout moment.

Par contre, il y a des risques à utiliser un ORM :

- techniquement un ORM est une nouvelle couche logicielle : ça peut donner lieu à plus de code à exécuter,

- les concepts proposés par les ORM sont de très haut niveau et relativement subtils (cache de données, _lazy loading_, ...) : mal utilisés, ces mécanismes peuvent fortement dégrader les performances de vos programmes. Il est donc impératif de bien maîtriser l'ORM utilisé afin d'éviter des gros pièges.

## Java Persistence API (JPA)

Il existe des ORM pour quasiment tous les langages de programmation, il en existe donc pour Java. Lorsque vous développez une application orientée objet en Java et que vous utilisez une base de données relationnelle pour stocker de manière persistante les données (notamment les attributs des objets manipulés par l'application), vous devez faire correspondre des objets, classes et attributs avec des tables, des lignes, des colonnes et des contraintes.

Pour ce faire, Java SE offre une API, JDBC (_« Java DataBase Connectivity »_) qui peut être considérée comme de bas niveau : il faut dans votre application, écrire le code Java 1) pour se connecter à la base de données, 2) pour répercuter dans la bonne colonne de la bonne table les modifications faites dans chaque attribut de chaque objet de votre application, 3) pour récupérer dans un attribut la valeur stockée dans la bonne colonne de la bonne table ...

Pour éviter ce travail aux développeurs, Java SE propose une couche d'abstraction au dessus de JDBC : JPA (_« Java Persistence API »_). Bien entendu JPA ne permet d'adresser que des bases de données relationnelles (à l'instar de JDBC).

{%include image.html file="web_architecture/jpa-apis.png" max-width="300" alt="Relation entre JPA et JDBC" caption="Figure 1 - Relation entre JPA et JDBC" %}

Plus concrètement, JPA est une spécification d'ORM pour Java. JPA étant une spécification (dit autrement, un document PDF), il en existe plusieurs implémentations (on parle de fournisseurs JPA). Les trois les plus connus sont Hibernate (RedHat), Eclipse Link (de la fondation Eclipse et implémentation de référence de JPA) et Open JPA (de la fondation Apache). Nous utiliserons Hibernate lors des activités pratiques.

<!-- Un ORM, comme son nom l'indique, permet de faire le lien entre le monde objet et le monde des bases de données relationnelles. Il doit permettre de produire automatiquement les requêtes SQL relatives aux actions CRUD (_Create/Read/Update/Delete_) sur vos objets et de les engager en base de données. Il existe des ORM pour quasiment tous les langages de programmation et donc aussi pour Java.

JPA étant une spécification (dit autrement, un document PDF), il en existe plusieurs implémentations. Les trois plus connues sont Hibernate (RedHat), Eclipse Link (de la fondation Eclipse) et Open JPA (de la fondation Apache). Nous utiliserons Hibernate lors des activités pratiques.

Les intérêts à utiliser un ORM compatible JPA sont les suivants :

- Abstraction quasi totale du langage SQL : c'est le rôle de l'ORM de produire le code SQL équivalent à vos actions sur vos objets

- Indépendance vis-à-vis de la base de données utilisée : comme vous ne produisez pas le code SQL, vous n'êtes pas lié à une base de données précise. Les ORM JPA peuvent travailler sur toutes les bases de données manipulables par JDBC. Vous êtes donc libres de changer votre SGBDR à tout moment

- Meilleure productivité : comparé à JDBC, vous avez beaucoup moins de code à produire (et notamment avec le SQL)

Par contre, il y a des risques à utiliser JPA :

- JPA consiste en une surcouche logicielle par-dessus JDBC : ça peut donner lieu à plus de code à exécuter

- Les concepts proposés par JPA sont de très haut niveau et relativement subtils (cache de données, _lazy loading_, ...) : mal utilisés, ces mécanismes peuvent fortement dégrader les performances de vos programmes. Il est donc impératif de bien maîtriser votre ORM afin d'éviter des gros pièges -->

<!-- L'objectif de ce TP est de comprendre les grands principes des ORM en utilisant un ORM concret, Hibernate. Pour ce faire, vous serez amenés à découvrir :

- où et comment est explicité le lien entre les classes d'un logiciel orienté objet et le stockage relationnel ;
- où et comment conﬁgurer la connexion à la base de données ;
- où et comment prendre en compte la persistance des données dans le code de l'application. -->

## Connexion à la base de données

Pour qu'un ORM puisse se connecter à une base données, il faut que le programmeur fournisse, dans un fichier de configuration, les informations nécessaires à cette connexion. Dans le cas de Spring (qui ne suit pas de manière stricte les spécifications JPA sur cet aspect), c'est le fichier `application.properties` dans `src/java/ressources` qui doit contenir cette information. On doit y retrouver notamment l'adresse où se trouve la base de données, et le login et mot de passe que l'application doit utiliser pour se connecter. Le code ci-dessous montre un exemple des informations contenues dans ce fichier et qui concernent la connexion à la base de données : il s'agit d'un serveur de base de données PostGreSQL, qui s'exécute en local sur le port 5432, le nom de la base de données est `comrec_db` et l'ORM se connectera en utilisant le login `pguser` et le mot de passe `pgpwd`.

```
spring.datasource.url=jdbc:postgresql://localhost:5432/comrec_db
spring.datasource.username=pguser
spring.datasource.password=pgpwd
spring.datasource.driver-class-name=org.postgresql.Driver
```

## Association objet - base de données relationnelle

<!-- Les annotations principales Spring JPA -->

Comme mentionné précédemment, un ORM (et donc tout fournisseur JPA) doit fournir les moyens de faire correspondre des classes, objets et attributs (les éléments du monde objet en termes de programmation) à des tables, lignes, colonnes (et contraintes) d'une base de données relationnelle. Plus concrètement, ce _mapping_ doit faire correspondre :

- une classe (dans le sens programmation) avec une table de la base de données,
- un objet (une instance d'une table) avec une ligne et
- un attribut d'un objet avec une colonne d'une table de la base de données.

En JPA, les annotations sont couramment utilisées pour définir ce _mapping_, un fichier de configuration XML est également envisageable mais non privilégié.

### _Mapping classe - table_

<!-- Voici ci-dessous une présentation illustrée des principales annotations Spring JPA qui seront expérimentées lors des activités pratiques. -->

Dans le jargon JPA, les classes qui doivent être persistées dans une base de données relationnelles sont appelées _entités_. Pour déclarer une classe comme une entité, il suffit de la précéder de l'annotation _@Entity_. Ainsi, par exemple, lorsque le code ci-dessous est exécuté par l'implémentation JPA, une table _Dept_ sera créée dans la base de données (même nom que la classe) et les instances de cette classe seront persistées comme des tuples de la table.

```java
@Entity
public class Dept {
    ...
}
```

Lorsqu'on souhaite donner à la table un nom différent de celui de la classe, l'annotation _@Table_ doit être utilisée. Ici, les instances de la classe `Dept` seront persistées comme des lignes de la table `departments`.

```java
@Entity
@Table(name = "departments")
public class Dept {
    ...
}
```

### _Mapping attribut - colonne_

Par défaut, tous les attributs d'une entité sont persistés, le nom de la colonne correspondante dans la base de données étant le même que celui de l'attribut. Pour modifier ce nom, il suffit de précéder l'attribut par l'annotation _@Column_ comme dans le code ci-dessous, où la colonne de la table `departments` sera `dept_name` et pas `dname`.

```java
@Entity
@Table(name = "departments")
public class Dept {
    ...
	@Column(name="dept_name")
	private String dname;
	...
}
```

### Les contraintes d'intégrité

Nous considérons ici deux types de contraintes :

- les contraintes de clé primaire. Il s'agit du cas du _mapping_ attribut/s - clé primaire d'une table
- les contraintes de clé référentielle. Il s'agit du cas du _mapping_ des associations entre les classes.

##### Mapping attribut - clé primaire

Pour indiquer qu'un attribut doit correspondre à la clé primaire de la table, il faut le précéder de l'annotation _@Id_. Ainsi, dans le code ci-dessous, la classe `Dept` a un attribut `deptNumber` qui correspond à la colonne `dept_no` qui sera la clé primaire de la table. Les valeurs de la clé dovient par contre être attribuées manuellement lors de l'insertion d'un nouveau tuple (un nouveau département). Cela convient généralement lorsqu'une entité possède un identifiant naturel. Par exemple, un ISBN est attribué à tous les livres publiés. Si nous devions créer un référentiel de livres, nous pourrions l'utiliser comme identifiant et l'attribuer manuellement à chaque livre.

```java
@Entity
@Table(name = "departments")
public class Dept {
    ...
    @Id
	@Column(name = "dept_no")
	private Long deptNumber;

	@Column(name="dept_name")
	private String dname;
	...
}
```

Pour tout le reste (et c'est, en principe, le cas pour les départements), l'implémentation JPA peut générer automatiquement des valeurs lors de l'insertion de nouvelles entités. Pour ce faire, il faut ajouter une annotation _@GeneratedValue_ ou _@GeneratedValue(strategy = GenerationType.AUTO)_. Dans le code ci-dessous, c'est l'implémentation JPA qui décide quelle stratégie sera utilisée pour la génération des valeurs pour la clé primaire. Vous trouverez [ici](https://symphony.is/about-us/blog/jpa-pitfalls-generating-ids) les trois stratégies de génération de valeurs de clé primaire disponibles dans JPA.

```java
@Entity
@Table(name = "departments")
public class Dept {
    ...
    @Id
	@GeneratedValue
	@Column(name = "dept_no")
	private Long deptNumber;

	@Column(name="dept_name")
	private String dname;
	...
}
```

##### Mapping des associations entre classes

D'autres annotations permettent d'établir des associations entre objets, matérialisant ainsi les contraintes d'intégrité référentielle (clefs étrangères). Nous présentons ici deux de ces annotations, pour introduire les notions principales mais vous pouvez trouver des informations sur les autres annotations [ici](https://gayerie.dev/epsi-b3-orm/javaee_orm/jpa_relations.html#).

Pour introduire ces annotations, nous allons considérer les classes de la figure ci-dessous. On trouve, entre autres, la classe `Dept` et une classe `Emp` qui représente les employés d'une entreprise. L'association `work at` est une association bidirectionnelle et indique, pour un département, les employés qui y travaillent et pour un employé, à quel département il est rattaché.

{% include image.html max-width=300 file="web_architecture/schemaConceptuelData.png" alt="Schéma conceptuel de données" %}

En objet, cette association se traduit par un attribut `private Dept dept` dans la classe `Emp` et un autre `private List<Emp> emps` dans la classe `Dept`. Pour _mapper_ cette association, deux annotations sont nécessaires (voir le code ci-dessous), _@ManyToOne_ et _@OneToMany_. La première indique que plusieurs instances d'une classe (`Emp`) peuvent être reliées à la même instance d'une autre classe (`Dept`). La deuxième annotation indique qu'une instance d'une classe (`Dept`) peut être reliée à plusieurs instances d'une autre classe (`Emp`), le paramètre `mappedBy="dept"` indiquant quel attribut de la classe `Emp` correspond à l'association bidirectionnelle (ici l'attribut `dept`). Ce _mapping_ se traduit par la création, dans la table `employees`, d'une clé étrangère vers la table `departments`.

```java
@Entity
@Table(name="employees")
public class Emp {
	...
	@ManyToOne
	private Dept dept;
	...
}

@Entity
@Table(name = "departments")
public class Dept {
    ...
    @OneToMany(mappedBy="dept")
	private List<Emp> emps;
	...
}
```

<!-- - _@ManyToOne_ pour indiquer que plusieurs instances peuvent être reliés à une même instance cible. Ici, dans une classe `Emp`, on a un attribut `dept` correspondant à une colonne `dept_fk` qui est clé étrangère vers la table _mappée_ par la classe `Dept`. `@ManyToOne` indique que plusieurs employés peuvent être membres du même département.

```
    @ManyToOne
	@JoinColumn(name = "dept_fk")
	private Dept dept;

``` -->

<!-- - _@OneToOne_ pour indiquer un lien entre deux instances de classes différentes. Ici, dans une classe `Dept`, on a un attribut `addr` correspondant à une colonne `addr_dept_fk` qui est clé étrangère vers la table _mappée_ par la classe `Address`. `@OneToOne` indique que chaque département a une seule et unique adresse.

```
    @OneToOne
	@JoinColumn(name = "addr_dept_fk")
	private Address addr;
``` -->

<!-- - _@ManyToMany_ pour indiquer que plusieurs instances d'une classe peuvent être reliées à plusieurs instances d'une autre classe. -->
<!-- ```
    @ManyToMany
	private List<Emp> collaborators;

```-->

<!-- Lors de la construction en mémoire d'un objet correspondant à un tuple de la BD, on peut préciser si les tuples auxquels il est relié doivent être également récupérés à l'instanciation (mode de récupération _FetchType.EAGER_) ou bien de manière différé (_FetchType.LAZY_).
Par défaut, les associations annotées _@OneToMany_ et _@ManyToMany_ utilisent la récupération _FetchType.LAZY_. Alors que les associations _@OneToOne_ et _@ManyToOne_ utilisent la stratégie _FetchType.EAGER_.

``` -->

## L'_Entity Manager_

Les annotations JPA que nous avons vues, ne servent à rien si elles ne sont pas exploitées programmatiquement. Dans JPA, l’interface centrale qui va exploiter ces annotations est l’interface `EntityManager`. À partir d’une instance d'_EntityManager_, nous pouvons manipuler les entités afin de les créer, les modifier, les charger ou les supprimer. Pour cela, nous disposons de six méthodes (`find`, `persist`, `merge`, `detach`, `refresh` et `remove`), l'`EntityManager` prendra en charge la relation avec la base de données et la génération des requêtes SQL nécessaires.

Le modèle de programmation avec JPA est le suivant. Lorsqu'on souhaite travailler avec des entités :

1. on recupère une instance de l'`EntityManager`. Vous verez comment on le fait dans le cadre de cette [activité pratique](practice_jpa.html),
2. on crée un contexte transactionnel, c.-à-d. on ouvre une transaction,
3. on fait les opérations souhaitées sur l'/les entité/s,
4. on valide ou on annule le contexte transactionnel, c.-à-d. on valide ou annule la transaction.

### Le contexte transactionnel

Vous avez un [cours d'introduction](lecture_transaction.html) et une activité entière consacrée aux [transactions](practice_transaction.html) dans l'UV, mais en attendant, pour comprendre le fonctionnement en JPA voici quelques éléments de base. Tout d'abord, une transaction est un ensemble d'opérations faites sur des données dans une base de données. Ces opérations vont toutes être validées (`commit`) ou toutes annulées (`rollback`). Par exemple, le code ci-dessous correspond à des requêtes SQL faites sur la base de données avec des départements. Après le `commit()` un nouveau département sera présent dans la table `departments` et le département `1` s'appelera `DSD`. Par contre, si au lieu du `commit` on a un `rollback()`, alors rien ne sera fait dans la base de données.

```java
INSERT INTO departments (d_name) VALUES ("MO");
UPDATE SET d_name = 'DSD' WHERE dept_no = 1;
commit();
```

Ce mécanisme des transactions est pris en compte dans JPA. Le code ci-dessous montre comment on crée un contexte transactionnel (ouvre une transaction) et comment on valide et annule une transaction.

```java
EntityManager em = ... // Instanciation d'un EntityManager

em.getTransaction().begin(); // On ouvre une transaction

try {
    // Utilisation des méthodes de l'EntityManager

    // Si pas d'erreur, on valide la transaction
    em.getTransaction().commit();
}
catch (RuntimeException e) {
	// Si quelque chose se passe mal, alors on annule la transaction
    em.getTransaction().rollback();
    throw e;
}
```

Les entités manipulées dans un contexte transactionnel via l'`EntityManager` sont dites _gérées_ par l'`EntityManager`, c.-à-d. la valeur des attributs sera synchronisé avec celui de la base de données. Une fois la transaction validée (ou annulée) les entités sont dites _détachées_, c.-à-d. leur lien avec la base de données est perdu.

### Les méthodes de l'_Entity Manager_

Nous présentons ici une partie des méthodes uniquement, celles dont vous aurez besoin pour la suite des activités de l'UV. Vous trouverez plus de détails sur ces méthodes et toutes les autres [ici](https://blog.paumard.org/cours/jpa/index.html) et [ici](https://gayerie.dev/epsi-b3-orm/javaee_orm/intro.html).

#### La méthode _find_

Elle permet de rechercher une entité dans la base de données en donnant sa clé primaire. Par exemple, la ligne 1. du code ci-dessous, demande à l'`EntityManager` de chercher dans la base de données le département dont la clé primaire vaut `1`. Le résultat est une instance de la classe `Dept`.

Une entité créée de cette manière est dite _gérée_ par l'_EntityManager_, c.-à-d. il y a cohérence entre les valeurs des attributs de l'instance et celles des colonnes correspondantes dans la base de données **tant que le contexte transactionnel reste ouvert** (c.-à-d. la transaction n'a pas été validée ou annulée). Dans notre code, avant la ligne 1. aucun contexte transactionnel n'a été créé, JPA en crée alors un le temps d'exécution de la méthode `find`. Une fois l'exécution terminée, la transaction est validée (ou annulée si erreur), mais puisqu'il s'agit d'une lecture, cela n'a aucun impact sur l'intégrité des données de la base.

```java
EntityManager em = ... 	// Instanciation d'un Entity Manager
 ...
1. Dept d = em.find(Dept.class, 1);
System.out.println("Departement name " + d.getDName()); // Affiche le nom du département 1
...

```

##### Stratégies de chargement d'entités

Lorsque JPA doit charger une entité depuis la base de données (par exemple avec le code vu précédemment), la question est de savoir quelles informations doivent être chargées. Doit-il charger tous les attributs d’une entité ? Parmi ces attributs, doit-il charger les entités qui sont en relation avec l’entité chargée ? Ces questions sont importantes, car la façon d’y répondre peut avoir un impact sur les performances de l’application.

Dans JPA, l’opération de chargement d’une entité depuis la base de données est appelée _fetch_. Un _fetch_ peut avoir deux stratégies : _eager_ ou _lazy_. On peut décider de la stratégie pour chaque membre de la classe grâce à l’attribut `fetch` présent sur beaucoup d'annotations de _mapping_.

- _eager_ signifie que l’information doit être chargée systématiquement lorsque l’entité est chargée. Cette stratégie est appliquée par défaut notamment pour _@ManyToOne_.

- _lazy_ signifie que l’information ne sera chargée qu’à la demande (par exemple lorsque la méthode `get` de l’attribut sera appelée). Cette stratégie est appliquée par défaut notamment pour _@OneToMany_.

Par exemple, dans le code ci-dessous, lors de l'appel à la méthode `find` (ligne 1.), le département est créé mais aussi les objets `Emp` correspondant aux employés du département. Sans le paramètre `fetch = FetchType.EAGER` de l'annotation `@OneToMany` ces objets n'auraient pas été récupérés de la base de données et la ligne 2. aurait levée une exception de type _Entity not managed_.

```java
@Entity
@Table(name="employees")
public class Emp {
	...
	@ManyToOne
	private Dept dept;
	...
}

@Entity
@Table(name = "departments")
public class Dept {
    ...
    @OneToMany(mappedBy="dept", fetch = FetchType.EAGER)
	private List<Emp> emps;
	...
}

...
1. Dept d = em.find(Dept.class, 1);
2. System.out.println("Employés du département : " + d.getEmps())

```

#### La méthode _persist_

Elle permet de modifier la base de données pour tenir compte de la création d'une nouvelle entité en positionnant, en fonction des annotations utilisées, la valeur de l’attribut représentant la clé primaire. Par exemple, dans le code ci-dessous :

- la ligne 2. crée une instance en mémoire de la classe `Dept` (aucune opération dans la base de données n'est réalisée). La valeur de l'attribut `deptNumber` de l'instance sera `null` puisqu'elle doit être générée par la base de données,
- la ligne 3. demande à JPA de créer un nouveau tuple dans la table `departments`. L'entité persistée est récupérée dans la variable `d`, son attribut `deptNumber` aura donc la valeur de la clé primaire générée par la base de données.

```java
1. EntityManager em = ... 	// Instanciation d'un Entity Manager

try{
	em.getTransaction.begin();  // Ouverture d'une transaction

	2. Dept d = new Dept("Info"); // Création en mémoire de l'instance. La valeur de l'attribut deptNumber est null

	3. em.persist(d); // Création d'une nouvelle ligne dans la table departments. deptNumber vaut la clé primaire

	em.getTransaction().commit(); // Validation de la transaction

} catch (RuntimeException e){
	em.getTransaction().rollback(); // Annulaation de la transaction si problème
}

```

#### La méthode _merge_

Cette méthode est parfois considérée comme la méthode permettant de réaliser les `UPDATE` des entités en base de données. Il n’en est rien et la sémantique de la méthode `merge` est très différente : elle attache une entité à l'`EntityManager` ; l'entité fera, après le `merge`, à nouveau partie des entités _gérées_ (_managed_) par l'`EntityManager`.

Le code ci-dessous montre un exemple typique d'utilisation de cette méthode. L'entité `d` est récupérée de la base de données (ligne 1.) et on souhaite faire des opérations sur cette entité, par exemple changer le nom du département. Puisqu'il s'agit d'une opération de modification, on crée une transaction (ligne 2.), on modifie l'objet en mémoire (ligne 3.) et on demande à valider la transaction (ligne 4.). Le résultat est néanmoins une exception de type _Entity not Managed_ puisque l'entité `d` ne fait pas partie des entités gérées par l'`EntityManager` au moment du `commit` ...

```java
EntityManager em = ... 	// Instanciation d'un Entity Manager

1. Dept d = em.find(Dept.class, 1) // Recherche du département `1` dans la base de données

try{
	2. em.getTransaction.begin();  // Ouverture d'une transaction
	3. d.setName("DSD"); // Modification du nom du département en mémoire
	4. em.getTransaction().commit(); // Validation de la transaction
} catch(RuntimeException e){
	em.getTransaction().rollback(); // Annulation de la transaction si problème
}
...

```

Une solution au problème est d'appeler la méthode `merge` pour rattacher l'instance au nouveau contexte transactionnel (ligne 3.). Ainsi, lors du `commit` l'`EntityManager` pourra répercuter les modifications dans la base de données puisque `d` fait partie de ses entités.

```java
EntityManager em = ... 	// Instanciation d'un Entity Manager

1. Dept d = em.find(Dept.class, 1) // Recherche du département `1` dans la base de données

try{
	2. em.getTransaction.begin();  // Ouverture d'une transaction
	3. em.merge(d);
	4. d.setName("DSD"); // Modification du nom du département en mémoire
	5. em.getTransaction().commit(); // Validation de la transaction
} catch(RuntimeException e){
	em.getTransaction().rollback(); // Annulation de la transaction si problème
}
...
```

# Méthodologique pour rendre une classe persistante

La démarche indiquée ci-dessous est volontairement itérative pour simpliﬁer la détection d'erreurs. Nous vous recommandons fortement de toujours suivre cette méthode :

- Ajouter les annotations nécessaires à une persistance minimale de la classe, à savoir les annotations qui permettent de gérer le nom de la table, l'identiﬁant (ne pas oublier le constructeur vide) et les propriétés simples (ne pas prendre en compte les associations dans un premier temps).
- Créer une collection persistante si nécessaire.
- Commentez éventuellement les méthodes qui ne peuvent pas encore être implantées.
- Tester la création et la persistance d'un objet de la nouvelle classe persistante.
- Pour chaque association non traitée, procéder de la manière suivante :
  - gérer la persistance de l'association, en prenant en compte les deux sens de l'association (donc deux classes) ;
  - prendre en compte l'impact de cette association sur les méthodes des classes métier ;
  - tester le comportement sur les objets mémoire et sur la base de données.
