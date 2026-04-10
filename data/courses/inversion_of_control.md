---
title: Inversion de contrôle (Inversion of Control)
keywords: Java, Spring
toc: false
sidebar: technical_environment_sidebar
permalink: inversion_of_control.html
summary: "L'inversion de contrôle est un mécanisme automatisé de gestion des objets et de leurs dépendances. Cette technique de programmation permet de réduire les dépendances entre les objets dans le code du programmeur et de le rendre plus modulable."
---


## L'inversion de contrôle (IoC)

L’inversion de contrôle (_Inversion of control_ ou IoC) est un principe d’architecture conduisant à inverser le flux de contrôle par rapport au développement traditionnel. Habituellement, si on veux développer un programme qui utilise des bibliothèques tierces, on va appeler les objets ou les fonctions de ces bibliothèques dans le programme. Le flux de contrôle est géré par son propre code qui doit réaliser les appels au code tiers.

Dans une approche IoC, le flux de contrôle est orienté du code tiers vers le code de mon application. Le code que je fournis sera sous le contrôle du code tiers. L’IoC est en fait le principe qui est mis en application par la plupart des frameworks. On peut même dire que c’est principalement ce qui distingue un framework d’une bibliothèque. Le framework fournit une ossature, une charpente (d’où son nom) à mon application et je ne dois fournir que le code spécifique qui doit être conforme à ce que le framework attend. Par exemple, en fournissant des classes qui héritent de telles classes ou qui implémentent telles interfaces qui sont définies par le framework.

Donc Spring n’est pas fondamentalement différent des autres frameworks... sauf qu’il met en pratique le principe de l’IoC dans une forme plus générale et moins intrusive en proposant la notion de conteneur IoC. Un conteneur IoC est responsable de la création et destruction des objets des applications et il s’assure que les dépendances entre eux sont correctement créées. Un tel objet, dont le cycle de vie (création et destruction) est géré par le conteneur IoC est appelé [_bean_](spring_bean.html).

{% include callout.html content="**Attention**, ne confondez pas conteneur d'IoC avec un conteneur (*container*) Docker !" markdown="span" type="warning"%}



### Modèle de programmation

Pour les objets d'une classes soient pris en charge par un conteneur IoC, il faut précéder le nom de la classe par l'annotation `@Component` ou une annotation fille (`@Controller`, `@RestController`, `@Service`...). Pour instancier une classe ayant une de ces annotations, on utilise l'annotation `@Autowired`. Vous trouverez ci-dessous un exemple de code classique qui illustre l'utilisation de ces annotations. La classe `DepartmentService` ne crée pas une instance de la classe `DepartementDAO` mais demande au conteneur IoC de le faire à sa place (`@Autowired`). Et le conteneur IoC peut le faire parce que la classe `DepartmentDAO` est précédée de l'annotation `@Component`.

```java
...
public class DepartmentService {

    ...
    @Autowired
    private DepartmentDAO deptDAO;

    public List<Dept> listDept() {
        // faire un traitement nécessaire
        // deptDAO.findDepts()

        ...
    }
    ...
}


@Component
public class DepartmentDAO{
    ...
    public List<Dept> findDepts(){
        ...
    }
    ...
}
```









L'inversion de contrôle permet de découpler la création d'objets composites dont l'assemblage sera assuré automatiquement au moment de l'exécution du programme. Un conteneur d'IoC s'appuie sur un contexte d'application dont le rôle est de stocker les objets (les [*beans*](spring_bean.html)) dont la gestion lui est confiée. Cela permet d'éviter des instantiations explicites des objets dans le code et de rendre l'application ainsi plus modulable. Le conteneur (Spring) en charge de ce mécanisme exploite un graphe de dépendances entre objets qu'il crée automatiquement en scannant le code pour identifier des instructions d'injection de dépendances.


## Contexte d'application

Dans le code ci-dessous, l'annotation *@SpringBootApplication* précédant la déclaration de la classe, déclenche le scan de l'ensemble du paquetage à la recherche d'annotations indiquant la déclaration de *beans* qui doivent être confiés au contexte d'application.

Les *beans* instanciés sont associés à un nom et un type et leur gestion est confiée au contexte d'application. Le contexte d'application gère également la reconstruction des dépendances entre objets définie par un graphe de dépendances entre objets. Dans le *main* du code ci-dessous, un contexte d'application basé sur des annotations est créé puis interrogé pour récupérer le *bean* de type *DeliveryService* nommé *getADeliveryService*.


```java  
@SpringBootApplication
public class ExampleiocApplication {

	public static void main(String[] args) {
		AnnotationConfigApplicationContext appCtx =
			new AnnotationConfigApplicationContext(ExampleiocApplication.class);
    DeliveryService serv = appCtx.getBean("getADeliveryService", DeliveryService.class);
		Map<String, Float> toOrder = serv.order();
		toOrder.forEach( (key, value) ->{
			System.out.println("- " + key + " : "+ value);
		});
	}
}
```


## L'injection de dépendances

Le conteneur d'IoC gère un ensemble de *beans* possédant chacun un nom et un type. Il peut être sollicité à tout moment dans l'application pour récupérer un de ses *beans*. Il existe cependant très souvent des dépendances entre ces objets, comme par exemple pour créer une instance de l'objet *A*, il me faut une instance de l'objet *B*. Ces dépendances sont automatiquement gérées et satisfaites par le conteneur d'IoC à condition qu'il stocke un *bean* de chaque type.


### On faisait comment sans IoC

Pour comprendre le mécanisme de l'inversion de contrôle et de l'injection automatique de dépendances, revenons à un exemple simple sans recours à l'IoC.
Dans l'exemple ci-dessous, la classe *DeliveryService* est liée à une implémentation de l'interface *Provider* (ici *FoodProvider*). Les instances sont explicitement créées dans le *main* est la dépendance entre ces *DeliveryService* et *Provider* est également explicite dans le constructeur de *DeliveryService*.

```java
public class DeliveryService {

    private Provider prov;

    public DeliveryService(Provider p){
        prov = p;
    }

    ...

    public static void main(String[] args) {
        Provider pr = new FoodProvider("Chez Oim");
        DeliveryService ds = new DeliveryService(pr);
        ...
    }

```

### Et avec un IoC

Dans l'exemple ci-dessous, l'annotation *@Bean* indique que la méthode qui suit sert de fabrique pour un objet de type *DeliveryService*. Cependant le constructeur de *DeliveryService* prend en paramètre une instance de type *Provider*. Si un *bean* de ce type existe dans le conteneur il sera récupéré et injecté lors de l'invocation du constructeur de *DeliveryService*.

```java
@SpringBootApplication
public class ExampleiocApplication {

	@Bean
  	public DeliveryService getADeliveryService(Provider p) {
		return new DeliveryService(p);
	}

	public static void main(String[] args) {
		AnnotationConfigApplicationContext appCtx =
			new AnnotationConfigApplicationContext(ExampleiocApplication.class);
		DeliveryService serv = appCtx.getBean("getADeliveryService", DeliveryService.class);
		Map<String, Float> toOrder = serv.order();
		toOrder.forEach( (key, value) ->{
			System.out.println("- " + key + " : "+ value);
		});
	}
}
```


### @Autowired

Dans les applications que vous développerez au cours de cet enseignement, vous aurez recours à l'annotation *@Autowired* pour récupérer auprès du conteneur d'IoC un *bean* d'un certain type. L'exemple ci-dessous permet de récupérer dans la variable *myDeliveryService* une instance de type *DeliveryService*.

```java
public class StreetFoodCompany {

    @Autowired
    private DeliveryService myDeliveryService;

    public void manageOrder(){
        ...
        myDeliveryService.order();
        ...
    }
}
```


## Injection de valeur

Une application Spring peut être paramétrée à l'aide d'un fichier de propriétés nommé `*application.properties` et qui consiste en un ensemble de paires *clé:valeur*. Par défaut, lorsqu'on utilise *Maven* pour gérer son projet de développement, ce fichier est situé dans le répertoire *src/main/resources/*.

Le code suivant permet d'initialiser une variable avec la valeur associée à la clé *developerName* dans le fichier de propriétés :

```java
class Config {
    @Value("${developerName}")
    private String devn;

    ...

```

## Pour aller plus loin ...

Après avoir étudié cette activité et celle sur les [beans](spring_bean.html), récupérez l'archive [ici](resources/technical_environment/example_IoC.zip) et exécutez l'application (`mvn spring-boot:run`). Ce code compile mais échoue à l'exécution. Pourquoi ? Corrigez le code en utilisant les annotation *@Bean*, *@Component* et *@Autowired* à bon escient.

{% include callout.html content="**Approfondissements**<br/><br/>

- [Documentation officielle sur l'inversion de contrôle](https://docs.spring.io/spring-framework/reference/core/beans.html)<br/>
" markdown="span" type="warning"%}
