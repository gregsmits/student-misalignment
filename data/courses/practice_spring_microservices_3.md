---
title: "Développement d'une application web par micro-services"
keywords: Spring, micro-services
sidebar: web_architecture_sidebar
summary: L'objectif de cette activité pratique est d'étudier la mise en place d'une communication asynchrone entre micro-services à l'aide d'un service de gestion de messages.
toc: true
permalink: practice_spring_microservices_3.html
---


<!-- {% include callout.html content="**Pré-requis**<br/><br/>


- Maîtriser l'[environnement technique de développement](technical_environment_home.html)<br/>
- Connaître la notion d'architecture [technique N-tiers](lecture_technical_architecture.html) et [logicielle multi-couche](lecture_software_architecture.html)
- Connaître le modèle [MVC](lecture_mvc_spring.html)

" markdown="span" type="danger"%} -->

# Contexte de l'activité pratique

L'objectif de cette activité pratique est d'étudier la structuration d'une application web Spring reposant sur des micro-services. Vous partirez d'une ébauche d'application par micro-services partageant une même base de données pour opérer des modifications afin de rendre les micro-services complètement indépendants.


## Présentation de l'application

 Comme l'illustre la figure ci-dessous, le contexte applicatif est simple et reprend celui de l'[activité d'initiation aux micro-services](practice_spring_microservices.html). Il s'agit de fournir des fonctionnalités de référencement de spectacles et de réservations de billets. Vous allez donc implémenter dans un premier temps deux services :
- un service de gestion des spectacles,
- et un service de réservation de billets.

![Architecture 1](images/web_architecture/microservices_architecture1.png)

La seule fonctionnalité à développer consiste à accepter des demandes de réservation de billets pour des spectacles.

La conception de l'application est perfectible, mais l'objectif est uniquement pédagogique. On considère qu'un spectacle (`show`) est décrit par un nom et un nombre de sièges restant. Une réservation (`booking`) est décrite par un identifiant de spectacle concerné, un nombre de places réservées et un nom de client. L'idée est de séparer les responsabilités des deux services. Le service `showms` s'occupe du spectacle et du nombre de places restantes, alors que le service `bookingms` stocke les réservations des clients.

### Mise en place de l'application

Vous allez repartir de l'application `ms_shared_db`. Faites-en une copie nommée `ms_shared_db_async` pour la transformer en application par micro-services indépendants. Ce répertoire contient plusieurs applications Spring : 
  - `eureka-server` un service dédié à l'enregistrement des micro-services,
  - `show_ms` un micro-service dédié à la gestion de spectacles,
  - `booking_ms` un micro-service pour effectuer la réservation de billets,
  - `webappserv` qui expose(ra) des fonctionnalités web pour la gestion des spectacles et des réservations.

Vous devez exécuter les containers Docker de BD postgresql et pgadmin utilisés depuis le début de l'UE.


# Isolation des micro-services

Les micro-services présents dans l'application `ms_shared_db` ne sont pas complètement indépendants, ils partagent une même BD. Dans cette activité pratique, chaque micro-service deviendra indépendant et accèdera à sa propre BD contenant uniquement les données qui le concernent. Vous mettrez ensuite en place une gestion des transactions entre micro-services implémentant le patron de conception SAGA.
Ici le patron SAGA sera implémenté en mode orchestré via un gestionnaire (`broker`) de messages *kafka* afin de rendre les étapes du processus de réservation indépendantes et exécutées de manière asynchrone.

## Préparation de l'application

Vous aurez toujours besoin des containers Docker *postgres* et *pgadmin4*. Préparez l'application en effectuant les actions suivantes :
1. Recopiez le répertoire `ms_shared_db` que vous nommerez `ms_separated_dbs_async`.
2. Créez deux BD nommées `show_db` et `booking_db`.

## Exécution indépendante des micro-services

Votre répertoire `ms_separated_dbs_async` contient plusieurs applications : `eureka_serv`, `webapp_serv`, `show_ms` et `booking_ms`.

Vous pouvez supprimer le répertoire `eureka_serv` qui ne sera pas utilisé dans cette implémentation. 

#### **Question 1**

Avant de pouvoir exécuter les micro-services `show_ms` et `booking_ms`, vous devez modifier leur fichier de configuration respectif (`application.properties`) afin que chaque application se connecte à sa BD.

Une fois cette modification faite, exécutez les deux applications et vérifiez :

1. que les micro-services sont référencés auprès du service *Eureka*,
2. que dans les BD `show_db` et `booking_db`, une table a été créée (table `show` dans la BD `show_db` et table `booking` dans la bd `booking_db`).

# Rendre asynchrone les étapes d'une transaction entre micro-services

Lors de l'exercice précédent, le processus de réservation est monolithique et synchrone. Si une étape du protocole est lente, elle bloque tout le processus gérant la réservation. 
Une amélioration consiste à exploiter un gestionnaire d'évènements pour rendre asynchrone les étapes du protocole. Cette adaptation permettra également d'intégrer plus simplement plusieurs instances d'un même micro-service et mettre en place des stratégies d'équilibrage de charge (*load-balancing*) pour apporter un meilleur passage à l'échelle.

Une solution assez répendue pour implémenter de une gestion asynchrone du patron SAGA est d'utiliser [*kafka*](https://spring.io/projects/spring-kafka). *Kafka* est un service implémenté par *apache* pour gérer un ensemble distribué de processus d'écriture et de consommation de messages. Ces messages seront utilisés pour signaler tout changement d'état des procédures de réservation des spectacles.

## Préparation de l'application

Vous pouvez compléter l'application précédente ou bien repartir d'une copie afin de conserver les différentes implémentations réalisées.

Pour utiliser *kafka*, ajoutez la dépendance suivante dans le fichier `pom.xml` des applications `show_ms`, `booking_ms` et `webapp_serv`.
```xml
<dependency>
  <groupId>org.springframework.kafka</groupId>
  <artifactId>spring-kafka</artifactId>
</dependency>
```

La figure ci-dessous schématise l'architecture de l'application que vous allez déployer. Comme vous pouvez le constater, les communications entre `webapp_serv` et les microservices `show_ms`, `booking_ms` ne seront plus directes mais passeront par des messages gérés par *kafka*. 
On va donc considérer que tous les échanges entre les micro-services se déroulent de manière asynchrone via *kafka*.
Ce qui signifie que les micro-services `show_ms` et `booking_ms` n'auront plus à exposer d'API REST. Vous pouvez donc supprimer les répertoires `controler` de ces deux applications. Le serveur *Eureka* va également devenir inutile. Par contre, dans certaines applications, il est nécessaire de maintenir des appels synchrones entre micro-services. Dans ce cas, il faut conserver *Eureka* pour que les micro-services se trouvent en plus du gestionnaire de messages.

![Schema Kafka architecture](images/web_architecture/kafka_architecture.png)

Évidemment, il faut disposer d'un serveur *kafka*. Utilisez l'image officielle pour démarrer un service *kafka* dans un container Docker. Voici la commande à exécuter :
```bash
docker run -p 9092:9092 apache/kafka:latest
```

## Communiquer via un serveur *kafka*

Vous allez être guidé dans la mise en place des premiers messages permettant de déclarer l'initialisation d'une procédure de réservation. 

#### Activer *kafka* dans l'application

Une première modification à réaliser est d'activer la détection automatique de code dédiés aux communications avec *kafka*.
Ajoutez, comme illustré ci-dessous, l'annotation `@EnableKafka` à la classe principale de chaque application pour activer la détection automatique de code.


```java
package fr.imt_atlantique.inf210.webappserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.kafka.annotation.EnableKafka;

//Automatic scan of the packages beneath the main package

@ComponentScan(basePackages = {"fr.imt_atlantique.inf210.webappserver.controller",
		"fr.imt_atlantique.inf210.webappserver.utils",
		"fr.imt_atlantique.inf210.webappserver.service"})
@SpringBootApplication
@EnableKafka
public class WebApplication {

	public static void main(String[] args) {
		SpringApplication.run(WebApplication.class, args);
	}

}
```

#### POJO de communication des données

La première étape est de définir un POJO structurant les données qui décrivent une réservation. La définition de ce POJO doit donc être partagée entre tous les services qui l'exploiteront (i.e. `webapp_serv`, `show_ms` et `booking_ms`).

Voici ci-dessous une proposition de définition d'une telle classe. Les instances de cette classe seront sérialisées et désérialisées, il faut donc que la classe soit définie dans un même package. Vous pouvez donc définir la classe `BookingEvent.java` dans le répertoire `fr/imt_atlantique/inf210/common` et ceci pour tous les services qui l'utilisent.

```java
package fr.imt_atlantique.inf210.common;
import java.io.Serializable;

public class BookingEvent implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long bookingId;
    private Long showId;
    private int nbSeats;
    private String holderName;
    private String status;
    
    public BookingEvent() {
        //Default constructor for serialization/deserialization
    }
    public BookingEvent(Long showId, int nbSeats, String holderName, String status) {
        Long uuid = System.currentTimeMillis(); //simple unique id based on timestamp
        this.bookingId = uuid;
        this.showId = showId;
        this.nbSeats = nbSeats;
        this.holderName = holderName;
        this.status = status;
    }
    
    //getters have to be defined here

}
```

#### Configuration d'un producteur de messages *kafka*

Spring boot rend relativement simple la connexion à un serveur *kafka*. Il suffit de définir, dans une classe de configuration (`@Configuration`), un *Bean* de type `producerFactory` pour qu'une connexion soit établie avec le serveur *kafka*. Voici ci-dessous un exemple assez simple de configuration permettant la connexion au serveur local *kafka* sur le port par défaut 9092. En plus d'indiquer vers quel serveur les messages produits seront distribués, le `Bean` de type `KafkaTemplate` indique le format des messages envoyés. Il s'agit de l'association d'une chaîne de caractères décrivant un état, par exemple *"booking-created"*, *"seats-reserved"*, etc., et un objet associé qui sera sérialisé, ici une instance de `BookingEvent`.

```java
package fr.imt_atlantique.inf210.webappserver.utils;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.apache.kafka.common.serialization.IntegerSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import fr.imt_atlantique.inf210.common.BookingEvent;
import java.util.HashMap;
import java.util.Map;

@Configuration
public class KafkaTemplateConfig {


    @Bean
    public ProducerFactory<String, BookingEvent> producerFactory() {
        Map<String, Object> config = new HashMap<>();
        config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "127.0.0.1:9092");
        config.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        config.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        return new DefaultKafkaProducerFactory<>(config);
    }

    @Bean
    public KafkaTemplate<String, BookingEvent> kafkaTemplate() {
        return new KafkaTemplate<String, BookingEvent>(producerFactory());
    }
}
```

Lorsque le contrôleur de l'application `webapp_ser` reçoit une demande de réservation, une méthode du service doit être invoquée pour produire un message à envoyer au service *kafka*. Il faut tout d'abord disposer d'une instance de `KafkaTemplate` qui sera capable de produire le message et l'envoyer au serveur *kafka*. Ça tombe bien, vous avez précédemment déclaré un `Bean` pour instancier un `KafkaTemplate`. Une fois cette instance injectée, vous pouvez l'utiliser pour produire un message indiquant qu'une réservation est demandée.

```java
    //...
    @Autowired
    private KafkaTemplate<String, BookingEvent> kafkaTemplate;

    //...
    public void createBookingSagaKafka(Long showid, int nbseats, String clientname) {       
        BookingEvent event = new BookingEvent(showid, nbseats, clientname, "BOOKING_REQUESTED");
        kafkaTemplate.send("booking-requested", event);
    }

    //...
```

#### **Question 2**

Procédez aux modifications de l'application `webapp_ser` afin qu'elle redirige toutes les demandes de réservation vers le serveur *kafka*.

Pour tester que les messages sont bien créés sur le serveur *kafka* vous allez utiliser un client consommateur fourni par *apache*. Dans un terminal, exécutez la commande suivante pour démarrer un processus consommateur `/opt/kafka/bin/kafka-console-consumer.sh` dans le container du serveur *kafka*. Vous pouvez utiliser directement le shell du container accessible depuis le `Docker Dashboard` pour exécuter la commande `/opt/kafka/bin/kafka-console-consumer.sh`.

```bash
docker exec -it <IDOFYOURKAFKACONTAINER>  /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic booking-requested
```

Logiquement, vous avez une application Spring (`webapp-ser`) qui peut recevoir des requêtes *http* via son API REST et produire des messages à destination du serveur *kafka*. La commande précédente vous a permis de démarrer un processus consommateur de messages de statut *booking-requested*. La requête *http* suivante devrait donc conduire à la production et la consommation d'un message via le serveur *kafka*. Faites le test:
`curl -X POST http://localhost:8081/newbooking/1/4/JohnDoe`

#### Configuration d'un consommateur de messages *kafka*

Vous allez désormais implémenter un mécanisme de consommation de messages *kafka* dans le micro-service `show_ms`.
La configuration d'un consommateur de messages est tout aussi simple. Vous allez tout d'abord compléter le micro-service `show_ms` pour qu'il reçoive tous les messages dont l'état est `booking-created` afin de procéder à la vérification que le spectacle existe et que suffisamment de sièges sont disponibles. Voici un exemple de code pour définir un consommateur (*listener*) de message :

```java
package fr.imt_atlantique.inf210.showms.utils;

import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.apache.kafka.common.serialization.IntegerSerializer;
import java.util.HashMap;
import java.util.Map;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;

import fr.imt_atlantique.inf210.common.BookingEvent;

@Configuration
public class KafkaTemplaceConfig {

    @Bean
    public ConsumerFactory<String, BookingEvent> consumerFactory() {

        JsonDeserializer<BookingEvent> jsonDeserializer =
                new JsonDeserializer<>(SagaEvent.class);
        jsonDeserializer.addTrustedPackages("*");

        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "show -group");
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        return new DefaultKafkaConsumerFactory<>(
                props,
                new StringDeserializer(),
                jsonDeserializer
        );
    }

    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, BookingEvent>
    kafkaListenerContainerFactory() {

        ConcurrentKafkaListenerContainerFactory<String, BookingEvent> factory =
                new ConcurrentKafkaListenerContainerFactory<>();

        factory.setConsumerFactory(consumerFactory());
        factory.setConcurrency(3);

        return factory;
    }
}
```

Il faut désormais utiliser le consommateur que vous avez configuré pour recevoir les messages *kafka*. Vous pouvez donc définir un service dédié à la gestion des messages et y ajouter la méthode suivante. Cette méthode initie un processus consommateur *kafka* qui invoque la méthode `checkShowAvailability` lorsqu'un message de statut (*topic* dans le jargon *kafka*) `booking-requested` est publié. 

{% include callout.html content="**Load-Balancing** <br/><br/> L'attribut `groupId` est intéressant à comprendre. Si vous avez plusieurs micro-services en charge de traiter les messages de statut `booking-requested` et qui ont le même `groupId`, alors *kafka* active une stratégie d'équilibrage de charge pour répartir la gestion de ces messages aux différents consommateurs. C'est une manière très simple de gérer la montée en charge dans une architecture par micro-services. Vous pouvez également avoir plusieurs micro-services en charge de lire des messages de même statut mais pour faire des tâches différentes. Il faut alors que leurs `groupId` soient différents. 
" markdown="span" type="warning"%}

```java

  @KafkaListener(topics = "booking-requested", groupId = "show-group")
  public void checkShowAvailability(BookingEvent event) {
    try {
      System.out.println("Received booking request, should check the show exists and seats are available: " + event);
      //continue the booking management
    } catch (Exception e) {
            System.out.println("Processing the requested booking failed: " + event);
            //produce error message
    }
  }
```

#### **Question 3**

Mettez en place un service de consommation de messages au sein du micro-service `show_ms` en vous focalisant dans un premier temps sur la réception des messages de topic `booking-requested`.

#### **Question 4**

Vous avez désormais réussi à mettre en place un échange de messages entre micro-services. Continuez l'implémentation pour disposer d'une solution complète, via *kafka*, du protocole de réservation. Voici une proposition de chaîne de statuts (i.e. *topics*):

`booking-requested -> showseats-prereserved -> booking-created -> showseats-reserved -> booking-confirmed`

Ces statuts désignent un déroulement sans erreur d'une transaction entre micro-services. Pour implémenter le patron SAGA, il faut que chaque action réalisée sur la base de données puisse être annulée. Prévoyez donc également la gestion des statuts suivants :
- `show-unconfirmed` pour indiquer que le spectacle demandé n'existe pas. Aucune action sur la base de données est à révoquer mais un message d'erreur est à transmettre au client qui a émis la requête de réservation.
- `seats-unconfirmed` pour indiquer que le spectacle existe mais qu'il n'y a pas assez de places de disponibles. Aucune action sur la base de données est à révoquer mais un message d'erreur est à transmettre au client qui a émis la requête de réservation.
- `booking-unconfirmed` pour indiquer une erreur lors de l'enregistrement de la réservation. Les places pré-réservées doivent donc être libérées.
- `showseats-unconfirmed` pour indiquer une erreur lors de la validation finale de la réservation. Les places pré-réservées doivent donc être libérées et la réservation annulée.


# (Bonus) Déploiement dans une architecture multi-tiers dockerisée


Évidemment, dans une architecture par micro-services, chaque micro-service est exécuté sur un tier dédié. Par rapport aux architectures utilisées dans le reste de l'UE, les applications Java Spring, une pour chaque service/micro-service, seront exécutées dans des containers Docker dédiés. 

La conteneurisation d'un service est assez simple. Une image contenant les outils nécessaires à l'exécution d'une application Spring vous est fournie. La définition de cette image (`Dockerfile`) est fournie dans le répertoire `docker_cnt`. L'image peut ensuite être utilisée pour exécuter des conteneurs dans lequel le code de l'application à exécuter est copié dans le répertoire `/app/` du conteneur.

Le fichier `compose.yaml` contient une configuration d'une architecture dockérisée permettant de démarrer les quatre applications. 

Il y a cependant une modification à apporter à la configuration des applications `webapp_serv`, `show_ms` et `booking_ms`. Ces trois services doivent s'enregistrer auprès du serveur *Eureka* qui auparavant été exécuté sur la même machine que ces trois services, i.e. votre système hôte. Une fois conteneurisé, chaque application a sa propre adresse IP et les applications doivent connaître l'IP du serveur *Eureka* pour s'enregistrer.

La modification a effectuer sur la configuration des applications `webapp_serv`, `show_ms` et `booking_ms` est en commentaire dans leur fichier de configuration respectif. Décommentez ce passage avant de déployer les applications dans des conteneurs à l'aide de la commande suivante :

```bash
docker compose up
```
