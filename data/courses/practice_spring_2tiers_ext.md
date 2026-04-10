---
title: "Déploiment d'une application web multi-couches avec Spring"
keywords: Serveur d'application, cloud, Spring, multi-couches, ORM, JPA, hibernate,
sidebar: web_architecture_sidebar
summary: Cette activité pratique vous permettra d'aborder le déploiement d'une application Java Spring, développée localement, sur un serveur d'applications ou dans une solution cloud. Vous expérimenterez également l'accès depuis un troisième tier aux composants de votre application.
toc: true
permalink: practice_spring_2tiers_ext.html
---

## Objectifs de l'activité pratique

Dans le but d'accélérer le développement d'applications (web), le framework Spring embarque plusieurs services, notamment un serveur web (Tomcat) démarré automatiquement lors de l'exécution d'une application. C'est bien ce serveur que vous avez utilisé lors des activités pratiques avec Spring que vous avez fait dans l'UV. Bien que pratique lors de la phase de développement, l'application, une fois mature, doit être déployée dans une architecture technique dite de production.

Au cours de cette activité, vous allez tout d'abord voir comment séparer davantage les couches application et présentation à travers le développement d'API REST. Vous aurez ainsi mise en pratique le principe des architectures REST présenté dans [ce cours](lecture_software_architecture.html).

Dans un second temps, vous pourrez tester le déploiement d'une application sur un serveur d'applications ou dans une architecture technique de type _cloud_.

## Préparation de l'activité

Vous allez travailler sur l'application _gestpers_. Si vous n'avez pas fini l'[activité pratique sur le développement d'une application web multi-couches avec Spring](practice_spring_2tiers.html), pas de problème, vous vous concentrerez sur les fontionnalités de gestion des départements qui étaient fournies et mettrez de côté la gestion du personnel.

Testez tout d'abord que votre application est fonctionnelle. Positionné dans le répertoire _Docker_environment/gestpers/_, exécutez la commande :

- `mvn spring-boot:run`

Accédez à la vue sur la liste des départements à l'adresse suivante : [http://127.0.0.8080/departments](http://127.0.0.1:8080/departments). Vous devriez logiquement voir s'afficher la liste des départements formattée dans un document HTML.

## Vers des architectures REST pour les micro-services

Dans cette première partie de l'activité, vous allez transformer votre application pour qu'elle offre une API REST. Vous avez deux principales actions à réaliser :

1.  Créer des DTO pour les objets que doivent être échangés entre le client et votre API REST. Vous pouvez reviser la notion de DTO [ici](lecture_dto.html),
2.  Construire de nouveaux contrôleurs qui répondront à des requêtes HTTP par des données formattées en JSON (encapsulées dans une réponse HTTP).

### Définition des DTO

Créez le répertoire `dto` dans `fr/atlantique/inf211/gestpers` et dupliquez le fichier `Department.java`. Nommez cette copie `DepartmentDTO.java` puis procédez aux modifications suivantes :

- ajoutez `implements Serializable` dans la déclaration de la classe,
- supprimez toutes les annotations JPA,
- ajoutez un constructeur à la classe pour créer une instance à partir d'une instance de `Department` :

```java
public DepartmentDTO(Department d) {
		this.id = d.getId();
		this.name = d.getName();
	}
```

### Définition d'un contrôleur REST

Dupliquez le fichier `DepartmentController.java` et nommez cette copie `DepartmentControllerREST.java`.

Puis procédez aux modifications suivantes :

- modifiez le contrôleur en contrôleur de type REST (`@RestController` au lieu de `@Controller`)
- remplacez le code de la méthode `listOfDepartments()` par le code suivant qui modifie l'URL _mappée_ ainsi que le type du retour de la méthode (vous aurez à modifier en conséquence le type de retour des méthode `addDepartmentData()` et `removeDepartementData()`).

```java
  @RequestMapping(value = "/departmentsrest", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public List<DepartmentDTO> listOfDepartments(){
        List<DepartmentDTO> li = sServ.listOfDepartments();
        return li;
	}
```

Relancez-votre application Spring et accédez à ce contrôleur REST via l'URL [http://127.0.0.8080/departmentsrest](http://127.0.0.1:8080/departmentsrest).

Observez le format des données obtenues.

#### **Question 2**

Vous allez désormais compléter votre API REST pour fournir les fonctionnalités CRUD qui complèteront la fonction R que vous venez d'obtenir.

Pour communiquer avec votre API REST, notamment lorsque les requêtes sont de type POST, il est pratique d'utiliser un client de communication comme `curl` ou `postman`. Il vous est conseillé d'installer l'un des deux mais si vous ne le souhaitez pas vous pouvez toujours accéder directement aux URL à partir d'un navigateur.

Voici ci-dessous le code d'une méthode permettant d'ajouter un nouveau département (opération C).

```java
    @RequestMapping(value = "/createdepartment", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public List<DepartmentDTO> addDepartmentData(@RequestParam String name) {
        sServ.addDepartmentREST(name);
        return listOfDepartments();
    }
```

Vous pouvez invoquer cette méthode depuis un terminal avec la commande suivante (ou directement avec un navigateur) :
`curl -X GET 'localhost:8080/createdepartment?name=DSD'`

Vous devriez recevoir en retour la description JSON de la liste des départements disponibles dont celui nouvellement créé. Vous noterez que Spring s'occupe de transformer l'objet `List<DepartmentDTO>` retourné par la méthode, en code JSON.

<!-- le code JSON reçu dans le champ POST de la requête en un objet de type `Department`, tout comme l'objet _Department_ retourné qui est lui même affiché en JSON. -->

À partir de cet exemple, proposez une implémentation des méthodes CU pour les départements, que vous pourrez compléter par les méthodes CRUD pour la gestion des employés.

#### **Question 3**

Jusqu'ici, votre couche présentation communique de manière synchrone avec le serveur web, c'est-à-dire que le client envoie une requête HTTP au serveur, récupère une page HTML complète qu'il affiche. Pour rendre les applications web plus dynamiques, il est possible de mettre en place des communications asynchrones avec le serveur. Dans ce cas, le client envoie une requête HTTP au serveur en arrière plan, permettant ainsi à la page actuelle de continuer à être active, et attend le retour du serveur. Lorsque les données émises par le serveur (HTML, XML, JSON ou autre) sont arrivées, le client (navigateur web) peut modifier tout ou une partie seulement de la page actuellement affichée.

La communication asynchrone repose sur l'utilisation de Javascript et d'[AJAX](<https://fr.wikipedia.org/wiki/Ajax_(informatique)>) (_Asynchronous JavaScript And XML_). Un exemple de mise en place vous est fourni dans la vue `departments.html`.

Retracez l'enchaînement d'appels depuis le click sur le bouton jusqu'à la requête HTTP émise par le _script_ `main.js`. Il vous faut définir une route pour traiter la requête asynchrone envoyée depuis le _script_ `main.js` et produire le modèle de données attendu.

## Vers une architecture 3-tiers

Un serveur d'applications est un tier dédié à l'hébergement d'applications développées selon un standard Jakarta EE. Le serveur doit donc suivre une spécification Jakarta/Java EE 8 ([https://jcp.org/en/jsr/detail?id=366](https://jcp.org/en/jsr/detail?id=366)).

Nous utiliserons dans cette activité, un serveur Red Hat Wildfly (anciennement JBoss) qui sera exécuté dans un conteneur Docker.

#### Démarrage du serveur d'applications

Depuis l'application _Docker Desktop_ ou en ligne de commande (`docker ps`), vérifiez que le conteneur nommé _serv_wildfly_cn_ est démarré. Si ce n'est pas le cas démarrez-le graphiquement depuis l'application _Docker Desktop_ ou bien en ligne de commande (`docker compose up serv_wildfly_cn`).

Le serveur d'applications Wildfly comporte une interface d'administration accessible à l'adresse suivante [http://127.0.0.1:9990](http://127.0.0.1:9990). Une authentification vous sera demandée : utilisateur `admin` et mot de passe `Admin#007`.

#### Préparation du projet pour le déploiement sur Wildfly

Pour exécuter une application sur un serveur d'applications tel que Wildfly, il faut que celle-ci satisfasse les spécifications Jakarta EE. Le projet nommé `gestpers_wildfly` est une adaptation du projet `gestpers` afin que celui-ci puisse être déployé sur un serveur d'applications. Voici pour information les modifications qui ont été faites sur le code source du projet Spring initial `gestpers` :

- la classe principale `EmployeesManagementApplication.java` est définie comme une sous-classe de `SpringBootServletInitializer` qui permet d'exécuter l'application lorsqu'elle est archivée dans une fichier `.war`.

Mais la majorité des modifications concerne la configuration de _Maven_ et son fichier _pom.xml_ :

- Spring ne démarre plus de serveur Tomcat pour exécuter l'application.

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-tomcat</artifactId>
  <scope>provided</scope>
</dependency>
```

- L'application est archivée en _war_.

```xml
<packaging>war</packaging>
```

- La gestion des logs de l'application n'est plus faite par Spring.

```xml
<artifactId>spring-boot-starter-web</artifactId>
	<exclusions>
		<exclusion>
			<artifactId>logback-classic</artifactId>
			<groupId>ch.qos.logback</groupId>
		</exclusion>
	</exclusions>
```

- Le déploiement vers le serveur Wildfly est configuré comme un nouveau plugin

```xml
 <plugin>
				<groupId>org.wildfly.plugins</groupId>
				<artifactId>wildfly-maven-plugin</artifactId>
				<version>4.0.0.Final</version>
				<configuration>
					<username>admin</username>
					<password>Admin#007</password>
				 </configuration>
			</plugin>
```

#### Déploiement sur un serveur d'applications

Pour construire l'archive de votre projet avant de la déployer sur le serveur, utilisez l'instruction _maven_ suivante :
`mvn clean package`

Cette commande supprime les résultats des compilations précédentes (`mvn clean`) et compile puis archive en paquet _war_ l'application (`mvn package`). S'il n'y a pas d'erreur de programmation, alors vous devriez trouver dans le répertoire `gestpers_wildfly/target/` une archive nommée `gestpers-0.0.1-SNAPSHOT.war` qui contient votre application et ses dépendances.

Le déploiement peut s'effectuer depuis l'[interface d'administration de Wildlf]([http://127.0.0.1:9990) ou via l'instruction _maven_ :
`mvn wildfly:deploy`

Vous pouvez accéder à l'application à nouveau depuis l'interface d'administration ou bien directement à l'URL suivante [http://127.0.0.1:8081](http://127.0.0.1:8081).

Le conteneur _wildfly_ agit donc comme un tier serveur d'applications en plus du tier base de données _postgresql_.

#### Passage à une architecture 3-tiers

Une application déployée sur un serveur d'applications comme Wildfly peut être exploitée par un tier extérieur de plusieurs façons, notamment :

- en utilisant RMI (_Remote Method Invocation_) qui permet d'appeler des méthodes d'objets (_Bean_) référencés sur un serveur de registre (_registry_),

```java
  RmiServiceExporter exporter = new RmiServiceExporter();
  exporter.setServiceName("EmployeesService");
  ...
```

- en utilisant des requêtes HTTP interrogeant les fonctionnalités d'une API REST.

Nous illustrerons la dissociation de la couche présentation et de la couche application sur deux tiers différents en exploitant une API REST. L'application que vous avez déployée sur Wildfly contient logiquement une bribe d'API REST permettant de récupérer la liste des départements.

Testez cette fonctionnalité en vous rendant à l'URL [http://127.0.0.1:8081/departmentsrest](http://127.0.0.1:8081/departmentsrest). Vous devriez obtenir en retour une description de départements au format JSON.

Vous allez désormais exploiter un autre projet Spring présent dans votre environnement Docker. Ce projet se nomme _uigestpers_ et contient une interface HTML rudimentaire affichant la liste des départements récupérée depuis l'URL `http://127.0.0.1:8081/departmentsrest`.

Pour exécuter cette application Spring, placez-vous dans le répertoire `uigestpers/` et exécutez la commande maven :
`mvn spring-boot:run`

Depuis l'URL [http://127.0.0.1:8080/](http://127.0.0.1:8080/) vous devriez voir s'afficher la liste des départements. Attention notez bien que l'API REST déployée sur le serveur d'applications Wildfly est disponible sur le port 8081 de votre machine alors que le serveur Tomcat démarré lors de l'exécution de l'application `uigestpers` écoute sur le port 8080. Pour bien différencier les deux, ouvrez dans deux onglets les deux URLs avec les ports 8080 et 8081.

Identifiez la séquence d'appels de méthodes et de requêtes qui est exécutée lorsque l'on demande à Tomcat d'afficher le contenu de l'URL [http://127.0.0.1:8080/](http://127.0.0.1:8080/).

Quelle type d'architecture technique et d'architecture logicielle venez-vous de mettre en place ?

#### Schéma de l'architecture trois couches

La dissociation entre les couches présentation et application a fait apparaître de nouveaux éléments dans l'architecture logicielle par rapport à une architecture 2 tiers, notamment :

- le modèle MVC étant implémenté dans la couche présentation, elle-même isolée sur un tier dédié, les modèles de données (POJO) doivent également être redéfinis côté présentation.
- les modèles (entités) du côté de la couche application (sur le serveur Wildfly) doivent être transmis via HTTP vers la couche présentation (sur le serveur Tomcat). Il faut donc disposer d'un format d'échange des modèles de la couche application vers la couche présentation, c'est le rôle de JSON pour représenter les objets (_Data Transfer Object_) sérialisés par l'API REST.

# Déploiement sur _Clever Cloud_

À découvrir dans l'activité pratique dédiée aux architectures cloud.
