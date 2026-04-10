---
title: Notion de programmation - Spring bean
keywords: Java, Spring
toc: false
sidebar: technical_environment_sidebar
permalink: spring_bean.html
summary: "Un *Spring bean* est un objet java dont la gestion du cycle de vie (création, attachement, destruction) est confiée au conteneur d'IoC Spring."
---


# Spring bean

Un objet java dont le cycle de vie (création, attachement, destruction) est confié au conteneur d'inversion de contrôle de Spring est appelé un *Spring bean* ou *bean*.

![Cycle de vie d'un bean](images/technical_environment/bean_lifecycle.png)

Pour qu'un objet java soit confié au conteneur d'inversion de contrôle de Spring il est possible d'utiliser deux annotations différentes : *@Bean* ou *@Component*.

## @Bean

L'annotation *@Bean* précède une méthode dont le rôle est de fabriquer un *bean* associé à un type et un nom. Sans indication particulière (comme par exemple *@Bean("nomDuSuperBean")*) le *bean* créé portera le nom de la méthode. Au sein de l'application, les *beans* peuvent être injectés dans le code à partir de leur type ou de leur nom en interrogeant le [contexte de l'application](inversion_of_control.html).

```java
    @Bean
    public DeliveryService getADeliveryService() {
		return new DeliveryService();
	}
```

Au démarrage de l'application Spring, un conteneur est démarré, ce qui entraînera l'instantiation de tous les *beans* trouvés dans le code source. La recherche des objets à instantiancier peut être contrôlée par un fichier de configuration *XML* ou bien automatisée depuis le code de l'application, cette dernière méthode étant privilégiée.


## @Component

Alors que l'annotation *@Bean* indique au conteneur les méthodes à invoquer pour instantier les *beans*, l'annotation *@Component* précède la définition d'une classe pour indiquer qu'elle doit également être utilisée pour instancier des *beans*. Le code ci-dessous permet d'indiquer au contexte de l'application qu'un *bean* de type *FoodProvider* est à créer.

```java
@Component
public class FoodProvider implements Provider{

    private Map<String, Float> myFood;

    public FoodProvider(){
        myFood = new HashMap<>();
        myFood.put("Pizza calzone", Float.valueOf("13.0"));
        myFood.put("Pizza sicilia", Float.valueOf("13.5"));
        myFood.put("Burger vege", Float.valueOf("14.0"));
    }

    public Map<String, Float> whatYouGot(Float maxPrice){
        return myFood.entrySet().stream()
		        .filter(f -> f.getValue() <= maxPrice)
                .collect(Collectors.toMap(x -> x.getKey(), x -> x.getValue()));
    }
}
```

## Singleton vs Factory

Quel(s) objet(s) est(sont) créé(s) ? Par défaut, chaque *bean* possède une portée (*scope*) qui indique combien d'objets doivent être créés et quand.
Il existe différentes portées : *singleton*, *prototype*, *request*, *session* et *global session*.

La portée par défaut est *singleton* ce qui signifie qu'une seule instance est créée par *bean* et est ensuite partagée dans l'application. À l'inverse, *prototype* indique qu'une nouvelle instance doit être créée pour chaque injection. Les autres portées sont spécifiques aux applications web (voir [ici](https://docs.spring.io/spring-framework/reference/core/beans/factory-scopes.html) pour plus de détails sur les portées des *beans*).

{% include callout.html content="**Approfondissements**<br/><br/>
- [Spring bean](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java)
" markdown="span" type="warning"%}
