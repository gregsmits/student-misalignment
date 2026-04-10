---
title: "Activité pratique sur le mapping objet-relationnel et Spring JPA (notions avancées)"
keywords: ORM, JPA, hibernate,
sidebar: web_architecture_sidebar
summary: Au cours de cette activité, vous allez définir un mapping entre les classes de votre application et une base de données relationnelles fournie. Cette partie de l'activité aborde des notions avancées liées à ce mapping (cycle de vie des beans managés, cadre transactionnel, méthodologie, etc.).
toc: true
permalink: practice_jpa_advanced.html
---



# Rappel sur le contexte de l'activité pratique

Au cours de cette activité, vous allez continuer à utiliser le projet Spring *comrec* fourni dans l'[environnement de développement dockerisé](https://gitlab-df.imt-atlantique.fr/inf210/docker-environment!), environnement que vous avez dû déjà mettre en place et testé précédemment.


## Le projet *comrec*

L'application *Gestion des commissions* (projet *comrec*) consiste à répartir une enveloppe ﬁnancière entre un ensemble d'employés sous la responsabilité d'un même gestionnaire. Le gestionnaire et l'enveloppe à distribuer doivent être des paramètres à fournir lors de l'exécution de l'application.

![Le projet *gestpers*](images/web_architecture/comrec.png)

### Les classes de l'application


L'application *comrec* comporte quatre classes :

- les personnes (*Person*)
- les employés (*Emp*) qui forment un sous-type de *Person*,
- les vacataire (*CasualEmp*) également un sous-type de *Person*.
- et les départements (*Dept*).

Les classes *Emp* et *CasualEmp* sont donc des sous-classes de *Person*.
Un employé est affecté à un département et un employé a un manager qui est également un employé. Un employé manager a une liste d'employés dont il est responsable.

Le schéma conceptuel suivant formalise la structuration de l'application.

{% include image.html file="bd/schemaConceptuelData.png" alt="Schéma conceptuel de données" caption="Figure 1 - Schéma conceptuel de données" %}


### Organisation des sources

Les sources de l'application *« Gestion des commissions »* sont composées des répertoires et ﬁchiers suivants :

- Le paquetage `entities`. Vous y trouverez la hiérarchie des classes `Person.java`, `Emp.java`, `CasualEmp.java` et `Dept.java` ;
- Le paquetage `dao` qui contient les classes `EmpDAO.java` et `DeptDAO.java` ;
- Le paquetage `main` qui contient la classe `Main.java` ;
- Le ﬁchier `application.properties` se trouve dans le répertoire `src/main/resources/`. Il décrit la connexion à la base de données et des paramètres de jpa

 {% include image.html file="bd/bd_tp_jpa_classes_appli.png" alt="Diagramme de classes de l'application" caption="Figure 2 - Diagramme de classes de l'application" %}


# Recherche et gestion du cache

Nous avons étudié la méthode `part1()` de la classe `Main` dans le premier exercice du TP. Son objectif est de peupler la base de données avec des employés et des départements. Elle utilise pour ceci une instance des DAO qui eux utilisent une instance de la classe `EntityManager`.


L'objectif de la méthode `part2()` de la classe `Main`, est de reconstituer un objet `Emp` correspondant au paramètre de la méthode (`empno`). Cet employé correspond au gestionnaire responsable des employés auxquels on veut attribuer une commission. Analysez le code de cette méthode.

Vous pourrez également tester la méthode `part3()` qui énumère les collaborateurs du manager choisi à l'étape `part2()`.

##### **Question 3.1**

<!-- Quel est l'état de l'objet `emp` de cette méthode ? -->

Vous allez désormais exécuter la méthode `part4()` de l'application afin de distribuer 10000 euros entre les collaborateurs de l'employé d'identifiant 5 (*Ford*).

Analysez les affichages générés et schématisez sur un papier les liens entre objets qui ont été créés en  mémoire à l'issue de l'exécution de la méthode.

<!--
##### **Question 3.2**

Déplacez les lignes `tx.commit()` et `JPAUtil.closeEntityManager()` juste après la récupération des informations de la base de données (après l'appel à la méthode `getById`). L'objet `emp` est, après avoir fermé l'`EntityManager`, dans l'état `detached`, i.e., il n'est pas synchronisé avec la ligne correspondante dans la base de données.

Exécutez à nouveau l'application. Que constatez-vous ?
Pour comprendre ce comportement lisez le contenu de la page [ici](https://www.java2novice.com/hibernate/eager-vs-lazy-fetch-type/) et essayez de représenter à nouveau les objets Java qui ont été créés en mémoire à l'issue de l'exécution de la ligne 45.

Replacez les lignes `tx.commit()` et `JPAUtil.closeEntityManager()` à leur position initiale dans le code. -->

## Retour sur le contexte transactionnel


Dans cette partie, nous examinons les modalités de synchronisation des données entre mémoire et stockage en cas de modiﬁcation d'un objet dans l'état `managed` ou `detached`. Nous examinons successivement le cas des propriétés simples puis celui des associations.

Exécutez l'application jusqu'à la méthode `part3()`.

L'objectif de cette méthode, est de récupérer les employés sous la responsabilité de l'employé passé en paramètre. Ce dernier vient d'être récupéré de la base de données dans la méthode `part2()`. Lisez les parties *Managed Entity Object* et *Advanced Topics -> Detached Entities* de la documentation [www.objectdb.com/java/jpa/persistence](http://www.objectdb.com/java/jpa/persistence), en particulier le paragraphe *Explicit Merge*. Analysez maintenant le code de la méthode `part3()` puis le code de la méthode `getCollaborators()` de `EmpDAO`.

##### **Question 3.3**


Pourquoi les appels à la méthode `entityManager.merge();` sont nécessaires ?

Prenez le temps d'étudier cette question très importante et assurez-vous d'avoir compris deux notions importantes :
- la différence entre les statuts `managed` et `detached` des objets (i.e. bean),
- et la récupération synchrone (`FetchType=EAGER`) vs. asynchrone (`FetchType=LAZY`) des objets liés à l'objet manipulé. 

Pour bien comprendre la notion de récupération assynchrone, des objets liés, modifiez la configuration de votre application (fichier *application.properties*) et passez à *true* les paramètres suivantes :
- `spring.jpa.show-sql=true`
- `spring.jpa.properties.hibernate.format_sql=true`

Exécutez de nouveau la `part3()` de l'application et observez les requêtes SQL exécutées.

<!-- Parce que l'employé et ses collaborateurs sont des objets qui viennent d'une partie de code qui n'est pas exécuté au sein d'une transaction. Ils sont donc detached. Il faut les remettre dans le contexte de l'entity manager  -->

##### **Question 3.4**

Exécutez la méthode `part4()` de l'application.

L'objectif de cette méthode est d'aﬀecter une commission aux employés passés en paramètre. Exécutez l'application. Vériﬁez le contenu des attributs des objets `Emp` concernés puis analysez le contenu de la table `employees` de la base de données à l'aide de pgAdmin.

Que constatez-vous ? Justiﬁez votre réponse.

<!-- Aucune commission n'a été affectée aux employés. Parce que tout à été fait en mémoire et pas en BD -->

##### **Question 3.5**

Exécutez la méthode `part5()` de l'application.

Elle doit actualiser la base de données avec la nouvelle commission des collaborateurs du manager choisi. Exécutez l'application. Vériﬁez le contenu des attributs des objets `Emp` concernés (depuis l'affichage produit par l'application dans le terminal) puis analysez le contenu de la table `employees` de la base de données à l'aide de l'outil pgAdmin.

Que constatez-vous ? Justiﬁez votre réponse.

<!-- Aucune commission n'a été affectée aux employés dans la base de données. -->

Comment pouvez vous résoudre le problème ?


<!-- 
### Exercice 3 (*troisième partie : contexte transactionnel et mises à jour*)

Dans les exercices précédents, l'essentiel de l'eﬀort a porté sur les classes et annotations nécessaires pour assurer la persistance de classes Java et l'accès à leurs instances.

Par ailleurs, comme nous l'avons vu, pour accéder à une donnée persistante, il est nécessaire d'accéder à la base de données dans le cadre d'une transaction (on dit aussi qu'il faut être dans un contexte transactionnel). Une fois l'accès réalisé, c'est la classe `EntityManager` de JPA qui gère le maintien de la cohérence entre la donnée stockée et son image mémoire. La question se pose si on décide de couper la connexion avec la base de données (lorsqu'on sort du contexte transactionnel) ...

Dans cet exercice, nous allons revenir sur la gestion du contexte transactionnel des applications et le lien entre les objets Java et leur stockage relationnel.

Vous trouverez dans [docs.oracle.com/html/E13981_01/undejbs003.htm#BABIAAGE](http://docs.oracle.com/html/E13981_01/undejbs003.htm#BABIAAGE) le cycle de vie des instances des classes persistantes selon les spéciﬁcations JPA. Un objet est dans l'état `new` lorsqu'il est créé en mémoire (en utilisant un des constructeurs de la classe). Lorsqu'une opération `persist` sur l'`EntityManager` est eﬀectuée pour cet objet, sont état passe à `managed`. Cela veut dire qu'une nouvelle ligne correspondant à l'objet est créée dans la table adéquate de la base de données. La copie mémoire de l'objet est synchronisée avec cette ligne et l'`EntityManager` trace les modiﬁcations faites sur celui-ci et les rend persistantes sur la base de données lors d'un `commit`.

Un objet dans l'état `managed` peut être supprimé de la base de données par l'opération `remove` sur l'`EntityManager`. Il passe alors à l'état `removed`.

Un objet dans l'état `managed` peut passer à l'état `detached` lorsque la connexion avec l'`EntityManager` est fermée. La copie mémoire de l'objet est alors désynchronisée avec la donnée stockée dans la base de données et l'`EntityManager` ne répercute pas les modiﬁcations réalisées sur l'objet.

Enﬁn, un objet qui est `detached` peut revenir à l'état `managed` en eﬀectuant une opération `merge` sur l'`EntityManager`. Si des modiﬁcations ont été réalisées dans l'objet en dehors du contexte transactionnel, elles seront répercutées dans la base de données lors d'un `commit`. -->
