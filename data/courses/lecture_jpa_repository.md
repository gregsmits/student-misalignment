---
title: Spring Data JPA - Repository
keywords: Repository, JPA, ORM, CRUD, Spring
toc: true
sidebar: web_architecture_sidebar
permalink: lecture_jpa_repository.html
summary: Cette section aborde la notion de Repository introduite par Spring Data JPA comme une alternative pour manipuler les données persistées d'une application sans avoir besoin d'écrire des classes DAO.
---
<!-- Objectifs pédagogiques

- expliquer la notion de Repository  son rôle et ses avantages
- montrer comment créer et utiliser un repository
- expliquer comment enrichir un repository avec des méthodes spécifiques
-->
# De l'ORM – JPA vers le Repository

Dans la section [ORM – JPA](lecture_jpa.html), nous avons vu le rôle que joue l’ORM dans la réalisation du mapping entre le monde objet et le monde relationnel. Nous avons également étudié la spécification **JPA** pour le langage **Java**, et comment l’utilisation d’une implémentation de JPA comme **Hibernate** peut faciliter le travail du développeur pour manipuler les données de son application.

Dans le code métier de l’application, il n’y a plus lieu d’écrire du code SQL pour communiquer directement avec la base de données ; il faut passer par JPA pour interagir avec l’implémentation de l’ORM.

Dans cette section, nous allons voir que **Spring**, et plus spécifiquement **Spring Data JPA**, va encore plus loin dans la simplification et l’accélération du développement du code responsable de la persistance des données (et donc de l’interaction avec la base de données) en introduisant un nouveau concept nommé **Repository**.

De quoi s’agit‑il ? Et à quoi peut‑il bien servir ?

---

## Qu’est‑ce qu’un Repository ?

Le **Repository** est un concept de **Spring Data JPA**. Il s’agit d’une abstraction d’un système de stockage persistant, se présentant sous la forme d’une collection pour une entité spécifique et offrant les opérations de base d’accès aux données.

Classiquement, et dans quasiment tous les projets, lorsque nous créons une entité (par exemple `Emp` ou `Dept`), nous avons besoin d’écrire du code pour réaliser les quatre opérations de base d’accès aux données, connues sous l’acronyme **CRUD** (*Create, Read, Update, Delete*). Ces opérations consistent à invoquer les bonnes méthodes de l’`EntityManager` via JPA, à retourner le résultat attendu et à gérer les différentes exceptions possibles.

Avec un peu de recul, on constate que ce code est souvent répétitif et fastidieux à écrire. Pour chaque projet et pour chaque entité, il faut réécrire le même squelette de code pour chaque opération CRUD. C’est ce que l’on appelle, dans le jargon informatique, du **boilerplate code**. Trop long à faire !

C’est précisément là qu’intervient le concept de **Repository** proposé par Spring Data JPA. Il s’apparente à un entrepôt de stockage pour une entité spécifique, offrant des méthodes standardisées pour manipuler cette entité, en particulier les opérations CRUD les plus courantes.

Concrètement, un repository est une **interface** (au sens Java du terme) à définir, qui hérite de l’une des interfaces de base fournies par Spring Data JPA. Les interfaces les plus couramment utilisées avec JPA sont `CrudRepository` et `JpaRepository`, chacune offrant un ensemble de fonctionnalités spécifiques.

Le diagramme de classes suivant montre un extrait de la hiérarchie des interfaces fournies par Spring Data JPA. La description de l’interface de base `Repository` est consultable dans la [documentation officielle Spring](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/Repository.html){:target="_blank"}.

![hiérarchie de l'interface Repository](images/archi/repositoryClassTree.jpeg)

## À quoi sert un Repository ?

Le principal atout d’un Repository est de :

- automatiser les opérations CRUD (`save()`, `findById()`, `findAll()`, `delete()`, etc.) sans écrire une seule ligne d’implémentation ;
- réduire drastiquement l’écriture de code répétitif dédié à la persistance des données ;
- rendre le code plus lisible et plus expressif ;
- optimiser les performances grâce à l’utilisation des mécanismes internes de Spring Data JPA pour l’exécution des méthodes déclarées éclarées dans l’interface;
- faciliter la maintenance du code en modifiant uniquement l’interface puisqu’il n’y a pas d’implémentation à écrire;
- permettre l’extension des interfaces de base afin d’ajouter des fonctionnalités spécifiques communes à plusieurs repositories de l’application.

À titre d’activité de découverte, il est conseillé de consulter la documentation Spring des interfaces [CrudRepository](https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html){:target="_blank"}  et [JpaRepository](https://docs.spring.io/spring-data/jpa/docs/current/api/org/springframework/data/jpa/repository/JpaRepository.html){:target="_blank"} afin de comparer les méthodes qu’elles proposent.

## Comment créer et utiliser un Repository ?

Maintenant que nous avons vu ce qu’est un Repository et à quoi il sert, voyons concrètement comment le mettre en place.

Pour créer un repository, il suffit d’étendre l’une des interfaces fournies par Spring Data JPA. Prenons l’exemple de l’entité `Dept`. Pour créer un repository de type CRUD, nous devons écrire le code suivant :

```java
import org.springframework.data.repository.CrudRepository;

import org.springframework.stereotype.Repository;

@Repository
public interface DeptRepository extends CrudRepository<Dept, Long> {
}
```

Dans cette définition de l’interface `DeptRepository`, nous avons précisé le typage générique de `CrudRepository` en déclarant l’entité `Dept` et le type de sa clé primaire (`Long`).

En créant cette interface, nous disposons implicitement de toutes les méthodes définies dans `CrudRepository`.

Pour exploiter ce repository dans un service, il suffit de l’injecter et d’appeler ses méthodes afin de réaliser les opérations CRUD de base.

```java
package fr.atlantique.imt.inf211.comrec.Services;

import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import fr.atlantique.imt.inf211.comrec.entities.Dept;
import fr.atlantique.imt.inf211.comrec.repositories.DeptRepository;

@Component
public class DeptService {
    @Autowired
    DeptRepository deptRepository;

    public Dept createDept(String name, String location) {
        Dept dept = deptRepository.save(new Dept(name, location));
        return dept;
    }

    public void deleteDept(Dept dept) {
        Objects.requireNonNull(dept);
        this.deptRepository.delete(dept);
    }

    public Dept searchByName(String name) {
        return this.deptRepository.findBydName(name).get();
    }
    //...
}

```

## Comment enrichir un Repository avec des méthodes spécifiques ?

Il est possible d’enrichir un repository en ajoutant des méthodes supplémentaires à l’interface. Par exemple, si nous souhaitons avoir une fonctionnalité pour chercher le département par son nom, nous pourrons enrichir l’interface en ajoutant la méthode suivante :

```java
    Optional<Dept> findBydName(String name);
```

Pour cette méthode, Spring Data générera automatiquement la requête JPQL correspondante :

```jpql
SELECT d FROM Dept d WHERE d.name = :name
```

Le code suivant montre la déclaration de l'interface `DeptRepository` enrichie :

```java
import org.springframework.data.repository.CrudRepository;

import org.springframework.stereotype.Repository;

@Repository
public interface DeptRepository extends CrudRepository<Dept, Long> {
    Dept findByName(String name);
}

```
### Convention de nommage des méthodes

Le nom des méthodes ajoutées doit respecter une convention précise permettant à Spring Data de générer automatiquement les requêtes dérivées. La structure générale est la suivante :

```
<action>By<Property><Operator><Condition>
```

| **Partie** | **Exemples** | **Description** |
|------|----------|-------------|
| **action** | find, read, get, query, search, count, exists, delete | Action à réaliser par la méthode |
| **By** | By | Début de la partie condition de la requête |
| **Property** | Name, Loc | Nom de l'attribut de l’entité en respectant de la casse |
| **Operator** | And, Or, Between | Opérateur de jointure des conditions |
| **Condition** | IgnoreCase, Containing, In, Like, OrderBy | odificateur des contraintes conditionnelles |

Par exemple, pour rechercher les départements situés dans une ville donnée et les trier par ordre alphabétique croissant du nom, la méthode peut être nommée :

```java
findByLocOrderByNameAsc(String loc);
```

### Bonnes pratiques
Nous ne pouvons pas tout faire en ajoutant des noms de méthode à une interface mais il convient de respecter les règles de bonnes pratiques suivantes pour dénommer les méthodes :

- choisir des noms de méthodes concis ;
- réserver les noms de méthodes pour des requêtes simples mais pas pour des requêtes complexes comportant des jointures ou des sous-requêtes;
- utiliser l’annotation `@Query` présentée dans la section [ORM - JPA - Repository (notions avancées)](lecture_jpa_repository_advanced.html) pour les requêtes plus complexes ;
- s’assurer que les noms des propriétés correspondent aux noms des attributs de la classe entité Java, et non aux noms des attributs de la base de données ;
- éviter les noms de méthodes excessivement longs, qui nuisent à la lisibilité du code.

Pour plus de détails, la ressource en ligne [Defining Query Methods](https://docs.spring.io/spring-data/jpa/reference/repositories/query-methods-details.html){:target="_blank"}  indique comment nommer les méthodes.

---