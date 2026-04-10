---
title: Tester une application multi-couche
keywords: tests unitaires, tests d'intégration 
sidebar: web_architecture_sidebar
toc: false
permalink: lecture_tests.html
---

<!-- Pre-requisites: lecture_software_architecture -->
## Rappels rapides sur les tests
Les tests font partie intégrante du développement logiciel, et donc du développement d'applications Web. Ils garantissent que vos applications fonctionnent comme prévu et continuent à le faire au fur et à mesure de leur évolution :

- Fiabilité : ils garantissent que votre application fonctionne correctement et de manière fiable
- Détection des bogues : ils permettent d'identifier les problèmes éventuels dès le début du développement.
- Refactoring : ils permettent de refactoriser le code en toute confiance, sans risquer de perturber les fonctionnalités existantes
- Documentation : des tests bien rédigés constituent une documentation pour votre code.

Comme vous le savez, il existe différents types de tests :

- Tests unitaires : tests de composants individuels, tels que des classes ou des méthodes, de manière isolée.
- Tests d'intégration : vérification du bon fonctionnement des différents composants ou services ensemble.
- Tests fonctionnels : tests des fonctionnalités de l'application du point de vue de l'utilisateur.
- Tests de bout en bout : tests de l'ensemble de l'application, y compris ses dépendances externes, dans un environnement similaire à celui de production.

Lors de certains enseignements vous avez déjà pratiqué la mise en place de tests unitaires, notamment dans le cadre d'applications Java et avec JUnit (voir l'[espace Moodle associé](https://moodle.imt-atlantique.fr/course/view.php?id=576&section=3#tabs-tree-start)). Dans cette UE, nous allons explorer comment tester les applications Spring / Spring Boot avec des bonnes pratiques. En particulier, nous nous intéresserons à deux types de tests : les tests unitaires et les tests d'intégration.

## Tester une application multi-couche

A la différence de ce que vous avez pu étudier précédemment (pour les aspects test), une application Spring/Spring Boot est constituée de plusieurs couches logicielles. Dans notre cas, les applications que vous devez manipuler et/ou implémenter incluent des contrôleurs REST, des services, la gestion des données persistantes et la base de données sous-jacente. Pour tester des telles applications de manière efficace en environnement *mocké* (tests unitaires) ou non (tests d'intégration), la meilleure pratique est de mettre en place la technique du *test slicing*. Il s'agit d'une pratique qui consiste à exécuter seulement une partie des tests, plutôt que la suite complète, en fonction d'un critère donné, dans l'objectif de réduire le temps d’exécution tout en ciblant les tests réellement pertinents. Les critères de découpe de la suite de tests en *slices* (tranches) sont très variés et incluent une découpe selon :

- le code modifié (sélection des tests impactés)
- des tags/annotations (ex. “unit”, “slow”, “security”)
- des modules/fonctionnalités
- le risque ou la criticité
- le type de tests (unitaires, intégration)

Ainsi, nous n’exécutons que la tranche nécessaire, plutôt que toute la suite de tests, notamment dans un *pipeline* d'intégration continue outillée. Par exemple, lorsque dans un projet nous modifions la fonction de paiement, nous n'exécuterons uniquement les tests liés au paiement et pas ceux liés au *reporting*, au login ou aux autres fonctions. 

{% include callout.html content="**Pour rappel**, un environnement *mocké* dans le cadre des tests logiciels, utilise des objets simulés (*mocks*) pour remplacer des composants réels (bases de données, API externes, services lents) afin d'isoler le code à tester, de contrôler les dépendances et de simuler des scénarios spécifiques (erreurs, réponses prédéfinies), permettant des tests unitaires plus rapides, fiables et reproductibles sans dépendre de systèmes externes." markdown="span" type="info"%}

Quelques bonnes pratiques générales pour le test d'applications qui s'exécutent dans le contexte d'un *framework* particulier (dans notre cas Spring avec Spring Boot).

- **Maintenir l'isolation des tests**. Assurez-vous que les tests sont indépendants les uns des autres. C'est certainement une bonne pratique que vous connaissez déjà mais c'est particulièrement important dans le cadre des applications que nous utilisons dans cette UE. Chaque test doit configurer son contexte requis, l'exécuter et supprimer toutes les ressources qu'il crée. Cela empêche un test d'influencer le résultat d'un autre.

- **Tirer partie des facilités proposées par le framework**. Tous les *frameworks* offrent des facilités pour écrire des tests. Utilisez-les, ça simplifie la programmation et/ou la configuration de l'application pour réaliser les tests. Par exemple, Spring Boot fournit des annotations de test telles que `@SpringBootTest`, `@DataJpaTest` et `@WebMvcTest` qui simplifient le *slicing* des tests. Utilisez-les pour ne charger que les parties nécessaires du contexte de votre application afin de rendre les tests plus efficaces.

- **Ecrire et exécuter des tests unitaires pour vos classes avant les tests d'intégration**. Avant de faire tout autre type de tests, chacune des classes que vous développez doit être testée indépendamment des autres. Inversement, ce n'est pas parce chaque classe a été testée et validée de manière isolée que son interaction avec d'autres classes de l'application répondra aux besoins. Par exemple, supposons deux composants, un (testé et validé) qui lit et rend une température en degrés Celsius et un deuxième (testé et validé) qui récupère une température et l'affiche en degrés Farenheit (`Temperature: <value>°F`). Ils sont utilisés pour une application de conversion de température qui lit la température en Celsius et les affiche en degrés Farenheit. Même si les tests unitaires des deux composants passent, les tests d'intégration peuvent ne pas passer puisque les tests unitaires ne vérifient pas que la conversion Celsius-Fahenheit est correcte. Donc, les deux types de tests sont importants et nécessaires pour s'assurer qu'une application est opérationnelle.