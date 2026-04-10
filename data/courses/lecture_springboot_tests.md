---
title: Tests avec Spring/Spring Boot
keywords: tests unitaires, tests d'intégration, JUnit (Jupiter), Mockito 
sidebar: web_architecture_sidebar
toc: false
permalink: lecture_springboot_tests.html
---

<!-- Pre-requisites: lecture_tests, practice_jpa-->


Dans le cadre de Spring/Spring Boot, le *test slicing* se fait généralement par couche logicielle qui constitue l'application, c'est ce qui est appelé le *layered slicing*. Ainsi, il offre des outils pour tester facilement les *repositories* de la couche de données, les services, la couche présentation Web mais aussi des API (notamment de type REST).

## Tester les *repositories* de la couche de données
L'objectif des tests des *repositories* est de vérifier que les méthodes ajoutées à ces *repositories* effectuent les opérations souhaitées dans la base de données. Ce ne sont donc pas des tests unitaires à proprement parler mais plutôt des tests d'intégration. Pour pouvoir tester ces classes, il faut configurer : 

1. un SGBDR avec la base de données contenant des données de test,
2. les entités JPA manipulées par les *repositories* et qui sont stockées dans la base de données de test,
3. les *repositories* à tester.

Pour faciliter cette configuration, l'annotation `@DataJpaTest` peut être utilisée lors de la définition d'une classe de test d'un *repository*. Pour comprendre la démarche à suivre, considérons une application avec des entités `User` *classiques* et un *repository* `UserRepository` pour les manipuler.

```java
@Entity
public class User{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    
    public User(){
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("User name cannot be null or empty");
        }
        this.name = name;
    }
}

@Repository
public interface UserRepository extends JpaRepository<User, Long>{
    Optional<User> findByName(String name); // Find a user by the exact name

    @Query("SELECT user FROM User user WHERE user.name LIKE :prefix%")
    List<User> findByNameStartingWith(@Param("prefix") String prefix); // Find users whose name starts by prefix
}

```


{% include callout.html content="Nous avons choisi ici un *repository* de type JPA même si nous n'utilisons pas toutes ses fonctionnalités. Cela nous permet d'utiliser le *test slicing* de Spring pour alléger les tests." markdown="span" type="info"%}


Pour tester la classe `UserRepository.java`, il faut créer une nouvelle classe `UserRepositoryTest.java` contenant les tests. Elle ressemble à une classe de test avec JUnit (dans sa version 5) avec quelques changements :
  - la définition de la classe est précédée de l'annotation `@DataJpaTest`. Avec cette annotation Spring Boot :
  
    - configure automatiquement une base de données de tests et charge tout ce qui est nécessaire pour tester JPA : entités, *repositories* et toute la configuration JPA associée. Par défaut, cette base de données est `H2` et elle est en mémoire (les données ne sont pas persistées), mais il est possible de changer ces options ;
    - crée une transaction au début de chaque méthode de test et réalise un *rollback* à la fin. Chaque méthode de test est donc indépendante des autres. Mais, à nouveau, ce comportement par défaut peut être modifié.

  - une instance de la classe à tester (ici `UserRepository.java`) est injectée dans les tests grâce à l'annotation `@Autowired` ; le programmeur ne doit donc pas l'instancier explicitement dans le code.

Et pour le reste, ce sont des annotations JUnit 5 ...

```java

@DataJpaTest
public class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    void setUp() {
        // Clear the database before each test
        userRepository.deleteAll();

        // Create and save some test data:
        User user1 = new User();
        user1.setName("The Beatles");

        User user2 = new User();
        user3.setName("The Rolling Stones");

        User user3 = new User();
        user3.setName("The Who");

        userRepository.saveAll(List.of(user1, user2, user3));
    }

    @Test
    void testFindByNameStartingWith() {
        // Test the findByNameStartingWith method
        List<User> users = userRepository.findByNameStartingWith("The");

        // Verify the results
        assertEquals(3, users.size(), "Expected 3 users starting with 'The'");
        boolean foundBeatles = false;
        boolean foundRollingStones = false;
        boolean foundWho = false;

        for (User user : users) {
            if (user.getName().equals("The Beatles")) {
                foundBeatles = true;
            } else if (user.getName().equals("The Rolling Stones")) {
                foundRollingStones = true;
            } else if (user.getName().equals("The Who")) {
                foundWho = true;
            }
        }

        assertTrue(foundBeatles, "The Beatles should be in the result");
        assertTrue(foundRollingStones, "The Rolling Stones should be in the result");
        assertTrue(foundWho, "The Who should be in the result");
    }
}
```

{% include callout.html content="Si vous n'êtes pas encore familiers avec JUnit 5, vous trouverez [ici](https://www.geeksforgeeks.org/software-testing/introduction-to-junit-5/) une introduction de base aux principales annotations et configurations pour JUnit 5. Elle suppose que vous avez des bases des tests avec JUnit. Si ce n'est pas le cas, vous pouvez revoir les activités que vous avez réalisées au 1er semestre dans l'[UE SIT210](https://moodle.imt-atlantique.fr/course/view.php?id=576&section=3#tabs-tree-start)." markdown="span" type="info"%}

### Configuration 

Pour pouvoir utiliser l'annotation `@DataJpaTest` dans une application Spring Boot il faut ajouter deux dépendances dans le fichier `pom.xml` du projet :

```
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-jpa-test</artifactId>
	<scope>test</scope>
</dependency>
<dependency>
    <groupId>com.h2database</groupId>
	<artifactId>h2</artifactId>
	<scope>test</scope>
</dependency>
```
La première dépendance apporte les fonctionnalités de test, la seconde est uniquement lié au fait que les données manipulées sont gérées en mémoime par `h2`.

### Exécution des tests
Les tests sont exécutés avec la commande `mvn test`. Toutes les méthodes précedées de l'annotation `@Test` sont alors exécutées. 

### Bonnes pratiques

**Organisation des sources de test**. Dans le cadre d'un projet Spring, tous les tests doivent se trouver dans le répertoire `src/test/java`. Typiquement, l'arborescence *standard* pour les tests des *repositories* JPA est ci-dessous.


```
src
└── test
    └── java
        ├── jpa
        │   └── repository
        │       └── UserRepositoryTest.java
 
```

**Configuration du test slicing**. Pour exécuter des tests en applicant le principe des *tests slicing*, la bonne pratique est d'utiliser les outils de construction d'applications ; dans notre cas ce sera Maven. Dans le code ci-dessous, vous trouverez un exemple de configuration avec Maven. Dans le fichier `pom.xml`, le profil `jpa-tests` est créé qui ajoute le plugin `surefire` qui permet pas mal de choses mais en particulier : 

 - Il détecte et exécute automatiquement les classes de test présentes dans le répertoire `src/test/java` ou celles spécifiées dans sa configuration.

- Il permet de spécifier quels tests doivent être exécutés (par exemple, en utilisant des motifs comme `*Test.java` ou `*IntegrationTest.java`).

- Il génère des rapports détaillés sur les résultats des tests, y compris les tests réussis, échoués, ou ignorés. Ces rapports sont généralement disponibles dans le répertoire `target/surefire-reports`.


```
<profiles>
  <profile>
    <id>jpa-tests</id>
	<build>
	  <plugins>
	    <plugin>
	      <groupId>org.apache.maven.plugins</groupId>
	      <artifactId>maven-surefire-plugin</artifactId>
	      <configuration>
		    <includes>
		      <include>**/*RepositoryTests.java</include>
		    </includes>
		  </configuration>
	    </plugin>
	  </plugins>
	</build>
  </profile>
</profiles>
```

Pour exécuter les tests en utilisant ce profil, vous pouvez utiliser la ligne de commande `mvn test -Pjpa-tests`. Uniquement les classes `*RepositoryTests.java` qui se trouvent dans tout répertoire dans `src/test/java` seront exécutés.

## Tester les classes de la couche services
Pour ces classes, il faut au moins faire deux types de tests :

- des tests unitaires pour vérifier qu'indépendamment des dépendances, leur fonctionnement respecte les spécifications ;
- des tests d'intégration pour vérifier qu'elles intéragissent correctement avec les objets dont elles dépendent.

Les grands principes pour l'écriture de ces tests pour les classes de la couche services sont les mêmes que pour n'importe quelle autre classe :

- pour les tests unitaires il faut *mocker* tous les objets dont la classe dépende pour bien isoler son comportement et donc pouvoir le tester ;
- pour les tests d'intégration il faut vérifier que l'interaction avec les autres objets ne conduit pas à un résultat non conforme aux spécifications.

Pour illustrer les grands principes à appliquer pour les deux types de tests, nous allons supposer que nous avons la classe ci-dessous qui correspond à un service Spring très simple de gestion d'utilisateurs.


``` java
@Service
public class UserService {

    @Autowired
    private final UserRepository userRepository;

    // Create a new user
    public User createUser(String name) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("User name cannot be null or empty");
        }
        User user = new User();
        user.setName(name);
        return userRepository.save(user);
    }

    // Find a user by ID
    public Optional<User> findUserById(Long id) {
        return userRepository.findById(id);
    }

    // Find a user by name
    public Optional<User> findUserByName(String name) {
        return userRepository.findByName(name);
    }

    // Find all users
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    // Delete a user by ID
    public void deleteUserById(Long id) {
        if (!userRepository.existsById(id)) {
            throw new IllegalArgumentException("User with ID " + id + " does not exist");
        }
        userRepository.deleteById(id);
    }
}
```

### Les tests unitaires

Les classes à tester ici sont des composants Spring (ils sont normalement de type `@Service`) et comme tels, ils sont, entre autres, dépendants des *repositories* JPA qu'ils utilisent pour stocker de manière persistante les données. Pour pouvoir les tester il faut donc *mocker* ces *repositories* (et toute autre dépendance). Dans Spring, c'est la librairie `Mockito` qui est utilisée pour créer des *mock* d'objets. Il ne s'agit ici de créer un tutoriel de cette librairie mais de vous donner les éléments les plus importants. Vous trouverez un tutoriel assez complet [ici](https://www.vogella.com/tutorials/Mockito/article.html).

{% include callout.html content="Une librairie équivalent est `EasyMock` que vous avez utilisé dans l'UE SIT210." markdown="span" type="info"%}

Pour écrire les tests unitaires de la classe `UserService.java`, il faut créer une classe `UserServiceTest.java` dont le contenu serait (en partie) celui ci-dessous :

- l'annotation `@ExtendWith(org.mockito.junit.jupiter.MockitoExtension.class)` permet d'activer les fonctionnalités de Mockito dans les tests unitaires et, en particulier, permet d'utiliser `@Mock` pour injecter automatiquement les objets *mockés* dans les objets avec l'annotation `@InjectMocks`. Dans le code ci-dessous, nous indiquons qu'un objet *mocké* `UserRepository` doit être injecté dans un objet `UserService`, l'objet que nous voulons tester ;

- toutes les méthodes de test suivent le même patron : créer le contexte nécessaire à l'exécution des tests, définir le comportement des objets *mockés*, appeler la méthode à tester, puis vérifier que le résultat et l'interaction avec les objets *mockés* correspondent à ce qui est attendu.

```java
@ExtendWith(org.mockito.junit.jupiter.MockitoExtension.class)
class UserServiceUnitTest {

    @Mock
    private UserRepository userRepositoryMock;

    @InjectMocks
    private UserService userService;


    @Test
    void testCreateUser() {
        // 1. Create test context
        String userName = "John Doe";
        User user = new User();
        user.setName(userName);

        // 2. Mock dependencies behavior (repository behavior here)
        when(userRepositoryMock.save(any(User.class))).thenReturn(user);

        // 3. Call the service method to test
        User createdUser = userService.createUser(userName);

        // 3. Verify results: values returned and actions on the mocked dependencies
        assertNotNull(createdUser);
        assertEquals(userName, createdUser.getName());
        verify(userRepositoryMock, times(1)).save(any(User.class));
    }

    @Test
    void testFindUserById() {
        // 1. Create test context
        Long userId = 1L;
        User user = new User();
        user.setId(userId);
        user.setName("John Doe");

        // 2. Mock dependencies behavior (repository behavior here)
        when(userRepositoryMock.findById(userId)).thenReturn(Optional.of(user));

        // 3. Call the service method to test
        Optional<User> foundUser = userService.findUserById(userId);

        // 3. Verify results: values returned and actions on the mocked dependencies
        assertTrue(foundUser.isPresent());
        assertEquals(userId, foundUser.get().getId());
        verify(userRepositoryMock, times(1)).findById(userId);
    }

    @Test
    void testDeleteUserById() {
        // 1. Create test context
        Long userId = 1L;

        // 2. Mock dependencies behavior (repository behavior here)
        when(userRepositoryMock.existsById(userId)).thenReturn(true);

        // 3. Call the service method to test
        userService.deleteUserById(userId);

        // 3. Verify results: values returned and actions on the mocked dependencies
        verify(userRepositoryMock, times(1)).existsById(userId);
        verify(userRepositoryMock, times(1)).deleteById(userId);
    }

...
}
```

### Les tests d'intégration

A la différence des tests unitaires, dans les tests d'intégration, la classe à tester utilise les vrais objets dont elle dépend et pas des objets *mockés*. Dans le cas des classes de la couche service, cela veut dire que le test :

- doit charger le contexte complet de l'application Spring et, donc, que tous les beans définis dans l'application seront initialisés, comme si l'application était réellement démarrée. C'est l'annotation `@SpringBootTest` qui permet de donner cette indication ;

- va utiliser les vrais *repository* JPA et donc que les données manipulées seront persistées dans la base de données. Ce sont donc des annotations `@Autowired` qui sont utilisées pour que Spring fasse l'injection de dépendances avec les vrais *beans*. Enfin, pour s'assurer que les tests ne polluent pas la base de données, l'annotation `@Transactional` garantit que chaque méthode de test s'exécute au sein d'une transaction et que toutes les opérations dans la base de données seront annulées à la fin de l'exécution de la méthode (`roolback()`). Pour le code ci-dessous, à la fin de l'exécution de la méthode `testCreateUser` l'utilisateur `John Doe` n'est pas persisté dans la base de données.

 ```java
 @SpringBootTest
 @Transactional
class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Test
    void testCreateUser() {
        // 1. Create test context
        String userName = "John Doe";

        // 2. Call the service method to test
        User createdUser = userService.createUser(userName);

        // 3. Verify results: values returned and actions on the dependencies
        assertNotNull(createdUser);
        assertEquals(userName, createdUser.getName());
        assertTrue(userRepository.existsById(createdUser.getId()));
    }
}
 ```

### Bonnes pratiques

Comme pour les tests de la couche de données, pour faciliter la mise en place des tests de la couche services, vous devez bien organiser les sources de tests et mettre en place le *test slicing* avec l'outil de gestion de configuration utilisé pour votre application. Pour ce qui est de l'organisation des sources, une organisation *classique* pour les projets Spring est donnée ci-dessous. Ensuite, pour le *slicing* il suffit de créer un nouveau profil dans le fichier `pom.xml` comme décrit pour les tests de la couche de données.

```
src
└── test
    └── java
        ├── unit
        │   └── service
        │       └── UserServiceUnitTest.java
        │
        ├── jpa
        │   └── repository
        │       └── UserRepositoryTest.java
        │
        ├── integration
        │   └── service
                └── UserServiceIntegrationTest.java
```