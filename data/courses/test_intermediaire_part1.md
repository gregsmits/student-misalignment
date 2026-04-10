# Évaluation intermédiaire INF 210 — FIP A2
**Architectures technique et logicielle d'applications web en Java** | 2025-2026 | Durée : 2h

---

**Nom :** ........................................................ **Prénom :** ..................................

*N.B. Examen individuel. Tous les documents sont autorisés mais aucune communication physique ou numérique ne sera tolérée entre étudiants.*

*Le test est composé de deux parties. La première comporte des questions théoriques et des exercices d'application pratique sur des exemples concrets. La deuxième partie porte sur le développement de fonctionnalités dans une application Web Java Spring.*

---

# Partie 1 (30 minutes)

**Notions :** dépendance fonctionnelle, modélisation conceptuelle (modèle conceptuel), dérivation, schéma logique (schéma relationnel), règle de dérivation

---

## Dépendances fonctionnelles

La base de données *athle_db* stocke des données relatives à l'organisation de compétitions d'athlétisme, en décrivant les épreuves, les athlètes, les performances réalisées et les compétitions associées. À ce stade, l'ensemble des données est regroupé dans une unique relation, appelée relation universelle, qui centralise toutes informations sportives et organisationnelles.

Le schéma de cette relation universelle est le suivant :

**athle_univ {idCompetition, nomCompetition, debut, fin, idEpreuve, nomEpreuve, categorie, ville, idAthlete, nomAthlete, nationalite, perf, class}**

L'expert connaissant ces données ajoute les informations suivantes :

1. Une compétition est identifiée par un id (*idCompetition*), a un nom (*nomCompetition*), une date de début (*debut*) et une date de fin (*fin*).

2. Elle est constituée de plusieurs épreuves.

3. Une épreuve est identifiée par un id (*idEpreuve*), elle a un nom (*nomEpreuve*), concerne une certaine catégorie d'athlètes (*categorie*) et se déroule dans une unique ville (*ville*).

4. Un athlète est identifié par un id (*idAthlete*), il a un nom (*nomAthlete*) et une nationalité (*nationalite*).

5. La performance (*perf*) et le classement (*class*) d'un athlète est propre à une épreuve d'une compétition.

### Question 1

En vous basant sur les informations fournies par l'expert, identifiez les dépendances fonctionnelles élémentaires et directes entre les données de la relation universelle. Vous pouvez les représenter sous forme d'un graphe ou d'une liste.

### Question 2

Avec l'ensemble de dépendances fonctionnelles que vous avez identifié, quelle devrait être la clé primaire de la relation *athle_univ* ? Justifiez votre réponse en utilisant le vocabulaire technique précis et adapté introduit dans l'UE.

---

## Modélisation conceptuelle et formes normales

Dans votre entreprise, un de vos collègues travaille sur un projet de création d'une application de gestion et suivi de compétitions de basketball en centralisant les informations relatives aux équipes, aux joueurs, aux matchs et aux performances individuelles. Le résultat de son travail sur la modélisation des données manipulées par l'application est le modèle conceptuel suivant :

*(voir schéma conceptuel fourni sur papier)*

### Question 1

Utilisez les règles de dérivation d'un schéma conceptuel vues dans l'UE pour proposer le schéma logique de données correspondant. Justifiez dans chaque cas le choix de la règle de dérivation appliquée.
