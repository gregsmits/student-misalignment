---
title: L'algèbre relationnel
keywords: algèbre relationnel
sidebar: data_sidebar
summary: Ce cours présente l'algèbre relationnelle permettant de formaliser des besoins d'informations pouvant être exprimés sur des données relationnelles.
toc: true
permalink: lecture_relational_algebra.html
folder: Database
---


{% include callout.html content="**Pré-requis**<br/><br/>
- [Connaître le modèle relationnel](lecture_relational_model.html)" markdown="span" type="danger"%}

# Introduction

Dans l'article “A relational model of data for large shared data banks" paru en 1970, E.F. Codd ne s'est pas contenté d'étendre la théorie des ensembles pour proposer un stratégie de structuration des données sous forme de relations (tableaux). Il a également défini une algèbre pour manipuler ces données, cette algèbre servant ensuite de base théorique pour le développement de langages d'interrogation de données relationnelles (voir [le langage SQL](lecture_sql.html)).

L'algèbre relationnelle est composée d’opérateurs et de lois pour manipuler les données stockées dans des
relations :
- opérateurs ensemblistes (union, intersection, différence),
- opérateurs relationnels (projection, sélection, jointure).

Une propriété importante de cette algèbre est qu'elle apporte un système de calcul fermé, c'est-à-dire qu'une expression formée à partir de cette algèbre prendra en paramètre une ou plusieurs relations et retournera toujours une relation.

![Expression de l'algèbre relationnelle](images/data/relationalAlgebra.png)


{% include callout.html content="**Définition** Une **expression de l'algèbre relationnelle** est une séquence d'opérations appliquées sur une ou plusieurs relations pour produire une relation résultat. L'ordre dans lequel les opérations sont appliquées est imposé. Dans une expression, un opérateur de l'algèbre ne peut apparaître qu'une seule fois (sauf pour les expressions imbriquées qui sont composées de plusieurs expressions)." markdown="span" type="primary" %}


# Opérateurs 


Soit $$R: \{A_1, A_2, \ldots, A_n\}$$ une relation comportant $$n$$ attributs.
## Projection


{% include callout.html content="**Définition** La **projection sur des attributs** est la seule opération obligatoire dans une expression de l'algèbre relationnelle et ce sera toujours la dernière opération appliquée. Cette opération matérialisée par le symbole $$\pi$$ consiste à former une nouvelle relation à partir d'une relation en entrée en ne conservant que certains attributs.
$$Res = \pi_{A^1, ..., A^k} (R) = \{ t.A^1, ..., t.A^k | t\in R, k <= n\}$$
" markdown="span" type="primary" %}


![Opération de projection](images/data/projection.png)


## Sélection

{% include callout.html content="**Définition** L'opérateur de **sélection**, noté $$\sigma$$, applique un critère booléen $$\psi$$ sur une relation $$R$$ pour produire une relation $$Res$$ qui ne contient que les tuples pour lesquels $$\psi$$ est vrai.<br/>
	$$Res = \pi_*( \sigma_\psi (R) ) = \{ t | t\in R, \psi(t) = vrai\}$$ 
" markdown="span" type="primary" %}

![Opération de sélection](images/data/selectionop.png)

Le processus de sélection teste le critère $$\psi$$ sur chaque tuple de $$R$$ et place dans $Res$ ceux qui y répondent.

## Composition de tuples

L'opérateur de composition de tuples n'est pas implicitement mentionné dans une expression de l'algèbre relationnelle mais il est utilisé par les opérateurs permettant de rassembler des données issues de plusieurs relations.

{% include callout.html content="**Définition** L'opérateur de **composition de tuples** consiste à former un tuple $$t$$ à partir de deux tuples $$t^i= \langle v_i^1, v_i^2, ..., v_i^{n}\rangle$$ et $$t^j= \langle v_j^1, v_j^2, ..., v_j^{m}\rangle$$. L'opérateur de composition est noté par un $$\bullet$$ :<br/>
	$$t = t^i \bullet t^j = = \langle v_i^1, v_i^2, ..., v_i^{n}, v_j^1, v_j^2, ..., v_j^{m}\rangle$$
" markdown="span" type="primary" %}


![composition de deux tuples](images/data/composition.png)


## Produit cartésien


{% include callout.html content="**Définition**	L'opérateur de **produit cartésien**, noté $$\bigotimes$$, consiste à regrouper deux relations $$R^1$$ et $$R^2$$ pour former une relation $$Res$$ qui contient toutes les compositions possibles entre les tuples de $$R^1$$ et de $$R^2$$.
	$$Res = \pi_* (R^1 \bigotimes R^2) = \{ t^1 \bullet t^2 | t^1 \in R^1\, et\, t^2 \in R^2\}$$ <br/>

Du produit cartésien de $$R^1$$ et $$R^2$$, on sait que $$|Res| = |R^1| \times |R^2|$$ et $$arite(Res) = arite(R^1) + arite(R^2)$$
" markdown="span" type="primary" %}


![Produit cartésien](images/data/cartesien.png)


## Jointure

{% include callout.html content="**Définition**	L'opérateur de **jointure**, noté $$\Join$$, consiste à regrouper deux relations $$R^1$$ et $$R^2$$ pour former une relation $$Res$$ qui ne conserve de leur produit cartésien que les lignes répondant à un critère booléen de sélection $$\psi$$.
	$$Res = \pi_* (R^1 \Join_{\psi} R^2) = \{ t^1 \bullet t^2 | t^1 \in R^1\, et\, t^2 \in R^2\, et\, \psi \text{ est vrai pour } t^1 \bullet t^2\}$$
" markdown="span" type="primary" %}


Si $$\psi$$ contient une égalité entre deux attributs de tables différentes portant le même nom, on parle alors de jointure naturelle, sinon on parle de theta jointure.

![Jointure](images/data/jointure.png)




## Union

{% include callout.html content="**Définition**	L'opérateur ensembliste d'**union**, noté $$\bigcup$$, permet de fusionner deux relations $$R^1$$ et $$R^2$$ pour former une relation $$Res$$.
	$$Res =\pi_* (R^1 \bigcup R^2) = \{ t | t \in R^1\, ou\, t \in R^2\}$$
" markdown="span" type="primary" %}


Les relations $$R^1$$ et $$R^2$$ doivent être union-compatibles, c'est-à-dire avoir le même nombre d'attributs et de même types.


## Intersection

{% include callout.html content="**Définition**	L'opérateur ensembliste d'**union**, noté $$\bigcap$$, permet de fusionner deux relations $$R^1$$ et $$R^2$$ pour former une relation $$Res$$.
	$$Res = \pi_*(R^1 \bigcap R^2) = \{ t | t \in R^1\, et\, t \in R^2\}$$
" markdown="span" type="primary" %}


Les relations $$R^1$$ et $$R^2$$ doivent être intersection-compatibles, c'est-à-dire avoir le même nombre d'attributs et de même type.


## Différence

{% include callout.html content="**Définition**	L'opérateur ensembliste de **différence**, noté $$-$$, permet de fusionner deux relations $$R^1$$ et $$R^2$$ pour former une relation $$Res$$.
	$$Res = \pi_*(R^1 - R^2) = \{ t | t \in R^1\, et\, t \notin R^2\}$$
" markdown="span" type="primary" %}

Les relations $$R^1$$ et $$R^2$$ doivent être différence-compatibles, c'est-à-dire avoir le même nombre d'attributs et de même type. Évidemment, cet opérateur n'est pas symétrique.


## Fonction d'agrégation

{% include callout.html content="**Définition** Une **fonction d'agrégation** permet de calculer une valeur à partir d'un ensemble de tuples. Ces fonctions seront principalement utilisées dans l'opérateur de projection pour créer un attribut calculé dans la relation résultat :
	$$Res = \pi_{A^1, ..., f(A^k)} (R) = \{ t.A^1, ..., f(t.A^k) | t\in R, k <= n\}$$ <br/>
Un nom d'attribut plus explicite peut être associé au résultat de ce calcul :
	$$Res = \pi_{A^1, ..., f(A^k) \text{ as } nvNom} (R) = \{ t.A^1, ..., f(t.A^k) | t\in R, k <= n\}$$
" markdown="span" type="primary" %}	

Principales fonctions d'agrégation :<br/>
    - $$sum(att)$$ pour effectuer la somme des valeurs prises par les différents tuples sur l'attribut $$att$$,<br/>
    - $$avg(att)$$ pour effectuer la moyenne des valeurs prises par les différents tuples sur l'attribut $$att$$,<br/>
    - $$max(att)$$ pour retourner la valeur maximale prise sur l'attribut $$att$$,<br/>
    - $$min(att)$$ pour retourner la valeur minimale prise sur l'attribut $$att$$,<br/>
    - $$count(*)$$ retourne la cardinalité de l'ensemble d'attributs.<br/>

Les valeurs non renseignées (NULL) sont ignorées, sauf pour $$count(*)$$.<br/>

{% include callout.html content="**Exemple**<br/>Voici quelques exemples d'expressions intégrant une fonction d'agrégation :<br/>
    - $$\pi_{count(*) \text{ as } nbTuples} (R)$$ pour connaître le nombre de tuples dans $$R$$,<br/>
    - $$\pi_{sum(mark) / count(*) \text{ as } average} (R)$$ pour avoir la moyenne des valeurs de l'attribut $$mark$$. Ce qui est équivalent à $$\pi_{avg(mark) \text{ as } average} (R)$$
<br/>" markdown="span" type="success" %}

## Groupement de tuples

{% include callout.html content="**Définition**	L'opérateur de **groupement de tuples**, noté $$\gamma$$, s'applique sur une relation $$R$$ pour former des groupes de tuples partageant la même valeur sur un ensemble d'attribut $$\{A^1, A^2, ..., A^n\}$$.<br/>
	$$\gamma_{A^1, A^2, ..., A^n}(R) = \{G^1, G^2, ..., G^m\},$$<br/>
    $$ \forall t_i, t_j \in G^k, i \neq j, k=1..n, t_i.A^1 = t_j.A^1, t_i.A^2 = t_j.A^2,  ..., t_i.A^n = t_j.A^n$$<br/>
	$$\pi_{A} (\gamma_{A^1, A^2, ..., A^n}(R) )$$, où $$A \subseteq {A^1, A^2, ..., A^n}$$.
" markdown="span" type="primary" %}


L'opérateur de groupement retourne un ensemble de groupes de tuples et non une relation. Cet ensemble de groupes est transformé en relation par application d'un opérateur de projection, qui peut inclure uniquement :<br/>
    - les attributs sur lesquels le regroupement a été effectué ($$\{A^1, A^2, ..., A^n\}$$),<br/>
    - d'autres attributs sur lesquels on applique obligatoirement une fonction d'agrégation.



## Filtrage de groupes

{% include callout.html content="**Définition**	L'opérateur de **filtrage de groupes de tuples**, noté $$\kappa$$, s'applique sur un ensemble de groupes formé par application de l'opérateur $$\gamma$$. <br/>

	$$\kappa_{\psi}( \{G^1, G^2, ..., G^m\}) = \{G \in \{G^1, G^2, ..., G^m\}, \psi(G) \text{ est vrai}\}$$<br/>
	$$ \pi_A ( \kappa_{\psi}(\gamma_{A^1,A^2, \ldots, A^m})(R))$$,  où $$A \subseteq \{A^1,A^2, \ldots, A^m\}\cup \{\text{fct. agg.}\}$$.
" markdown="span" type="primary" %}

 
Cet opérateur est associé à une condition $$\psi$$ et retourne l'ensemble des groupes qui satisfont cette condition $$\psi$$. $$\psi$$ est un prédicat booléen  pouvant porter uniquement :<br/>
    - sur la valeur des attributs utilisés pour le regroupement ($$A^1, A^2, ..., A^n$$),<br/>
	- et/ou sur la valeur retournée par l'application d'une fonction d'agrégation appliquée sur un attribut non concerné par le regroupement.


## Expression algébrique imbriquée

Le résultat d'une expression algébrique, i.e. une relation, peut être utilisé à l'intérieur d'une autre expression algébrique. On parle alors d'expressions imbriquées.


{% include callout.html content="**Exemple**<br/>Voici un exemple d'expression algébrique reposant sur le résultat d'une autre expression :<br/>
    - $$\pi_{*}( \sigma_{A_1 = (\pi_{min(A_1)} (R)) } (R))$$ pour récupérer les tuples de $$R$$ ayant la plus petite valeur sur l'attribut $$A_1$$.
    " markdown="span" type="success" %}

{% include callout.html content="**Pour continuer ...** Découvrir l'utilisation de cette algèbre à l'aide du [langage SQL](activity_sql.html)." %}
