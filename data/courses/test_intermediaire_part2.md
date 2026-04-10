# Évaluation intermédiaire INF 210 — FIP A2
**Architectures technique et logicielle d'applications web en Java** | 2025-2026 | Durée : 2h

---

# Partie 2 (1h30)

**Notions :** mapping objet-relationnel, `@Entity`, `@Id`, `@OneToMany`, `@ManyToOne`, `@Autowired`, annotation Java, JPA Repository, `@Transactional`

---

Cette seconde partie est dédiée au développement d'applications web Java Spring. Vous utiliserez les ordinateurs de l'école en mode examen. Pour vous authentifier, utilisez vos identifiants IMT Atlantique. Vous avez accès aux sites Internet suivants :
- https://hub.imt-atlantique.fr/uv-fip-inf210/
- https://cota.enstb.org/
- https://spring.io/
- https://docs.oracle.com/

---

## Préparation de l'environnement de développement

Récupérez sur Moodle une archive nommée [tournament.zip](https://moodle.imt-atlantique.fr/mod/resource/view.php?id=88662) qui contient à la fois la configuration de l'environnement Docker de développement et une base de l'application à développer.

Dans un terminal, décompressez et extrayez l'archive, puis placez-vous dans le répertoire créé avec les commandes suivantes :

```bash
unzip tournament.zip
rm tournament.zip
cd tournament-manager/
```

Démarrez les services nécessaires au développement de votre application à savoir un service de bases de données et un client pour s'y connecter :

```bash
docker compose up
```

Depuis un autre terminal, vérifiez avec la commande ci-dessous que deux containers sont bien en cours d'exécution :

```bash
docker ps
```

Puis accédez au client PgAdmin à l'url suivante http://127.0.0.1:5051 et contrôlez l'accès au serveur et la présence d'une BD nommée *tournament_db*.

Le contexte de l'application est simple. Une table nommée *player* dans la base de données contient un ensemble de joueurs de basket. L'objectif est de développer une fonctionnalité permettant de créer des équipes aléatoires à partir de ces joueurs. L'utilisateur de votre application indique par un paramètre si les équipes doivent être constituées de 2, 3 ou 5 joueurs.

Depuis un terminal, placez-vous dans le répertoire *tournament_manager/tournament/* qui contient l'ébauche d'application Spring. Exécutez cette application avec la commande suivante :

```bash
./startapp.sh
```

Accédez à l'application web à l'url suivante http://127.0.0.1:8080 et vérifiez que vous visualisez la liste des 18 joueurs stockés dans la BD.

*(voir capture d'écran de l'interface fournie sur papier)*

---

## Question 1

Dans les sources de l'application, une classe *Team* est définie dans le répertoire *entity/*. Pour le moment, même si vous instanciez des équipes, elles ne seront pas persistées dans la base de données.

Complétez la classe *Team* avec les annotations nécessaires pour que les instances de cette classe soient persistées dans la base de données.

Vous devez également compléter la classe *Player* pour lier les deux classes en :

- ajoutant un attribut nommé *team*,
- complétant les paramètres du constructeur pour indiquer l'équipe en plus du nom, du prénom et de la position,
- définissant un *getter* et un *setter*.

Une fois les annotations définies, exécutez de nouveau votre application. Pour vérifier que vos annotations ont bien été prises en compte, contrôlez que la base de données *tournament_db* contient désormais une seconde table pour le stockage des équipes et que le schéma de la table *player* a été complété avec une colonne référençant son équipe.

---

## Question 2

Afin de pouvoir manipuler les instances persistées de la classe *Team*, définissez une classe héritant de *CrudRepository* nommée *TeamCrudRepository.java*. Vous pouvez implémenter et utiliser une classe *DAO* à la place du *CrudRepository* si vous êtes plus à l'aise avec ce *design pattern*.

---

## Question 3

Complétez la méthode *getAllTeams*() de la classe *TeamServiceImp*. Pour tester cette méthode, vous pouvez créer manuellement depuis pgadmin des équipes et vérifier depuis l'interface web qu'elles sont affichées. Pensez ensuite à supprimer les équipes créées manuellement.

---

## Question 4 — Créer des équipes aléatoires

*(voir capture d'écran de l'interface Teams fournie sur papier)*

Dans l'onglet Teams de l'application web, vous allez implémenter la fonctionnalité permettant de créer des équipes avec des joueurs choisis aléatoirement. Lorsque l'utilisateur clique sur le bouton **Create teams**, un contrôleur (pour information dans la classe *MainController.java*) récupère la requête http, le paramètre indiquant le nombre de joueurs par équipe et appelle la méthode suivante du fichier *TeamServiceImp.java* :

```java
@Override
public void createTeams(int nbplayersPerTeam) {
    // TODO Auto-generated method stub
}
```

Complétez le code de la méthode *createTeams* en suivant ces étapes :

1. Récupérez depuis le service *PlayerService*, la liste des joueurs ordonnée de manière aléatoire (méthode *getAllPlayersListRandomOrder()*).

2. Créez autant d'équipes que possible et affectez les joueurs dans l'ordre de la liste récupérée précédemment. Modifiez les instances des joueurs en indiquant l'équipe dans laquelle ils sont affectés. Voici ci-dessous quelques rappels pour la manipulation d'une *ArrayList* en Java :

```java
ArrayList<Player> players = .... ;

int nbplayers = players.size(); // get the size of the list
Player p4 = players.get(3);    // get the fourth element of the list
```

3. Utilisez le *TeamCrudRepository* pour rendre persistantes les instances de la classe Team que vous avez créées.

4. Utilisez le *PlayerService* pour rendre persistantes les modifications que vous avez effectuées sur les joueurs (affectation des équipes).

Finalement, il vous faut compléter la méthode *updatePlayer* de la classe *PlayerServiceImp.java* afin de prendre en compte la mise à jour de l'équipe associée au joueur.

Vérifiez sur l'interface web que votre implémentation est correcte en affichant les équipes créées.

*(voir capture d'écran du résultat possible pour des équipes de trois joueurs fournie sur papier)*

---

## Question 5 — Réinitialiser les équipes

Vous allez désormais implémenter la fonctionnalité permettant de supprimer l'affectation des joueurs dans des équipes. Dans la classe *TeamServiceImp*, vous allez donc compléter le code de la méthode *resetTeams()* en suivant les étapes suivantes :

1. Supprimez toutes les équipes en appelant la méthode *deleteAll()* du *TeamCrudRepository* ou la méthode *delete()* de chaque équipe si vous utilisez un *DAO*.

2. Modifiez les joueurs concernés par la suppression en passant à `null` l'attribut qui référençait l'équipe qui leur était associée.

---

## À rendre

**Déposez sur Moodle une archive (au format zip) de votre projet Spring *tournament-manager*.**
