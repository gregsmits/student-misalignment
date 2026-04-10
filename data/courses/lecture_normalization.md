---
title: Normalisation et découpage d'une relation universelle
keywords: modèle relationnel, UML, modélisation
sidebar: data_sidebar
summary: Cette section décrit une démarche pragmatique permettant d'aboutir à un schéma relationnel possédant des propriétés intéressantes (intégrité, disponibilité, non-redondance). Cette démarche repose sur une succession de décompositions en partant de la relation universelle.
toc: true
permalink: lecture_normalization.html
folder: Database
---

# Introduction 

La construction d'un schéma relationnel par [modélisation conceptuelle](lecture_conceptual_modeling.html) du métier constitue la méthode à privilégier, notamment lorsque le contexte applicatif est complexe et repose sur une phase d'interaction entre les experts métier et BD.
Cependant, dans de nombreux cas, une approche plus pragmatique peut être utilisée. Elle considère comme point de départ le dictionnaire de données à partir duquel une relation universelle est établie.

{% include callout.html content="**Relation universelle**<br/><br/>
Une relation universelle, souvent point de départ d'un processus de découpage par normalisation, regroupe simplement l'ensemble des attributs mentionnés dans le dictionnaire de données." markdown="span" type="primary"%}

#### Relation universelle **Personnel**

  | numéro    | nom    | ville    | fonction  | idG    | designation   | villeG
  | ------    | ------ |  ------  | ------    | ------ | ------        | ------
  | 1         | Dias   | Plouzané | DevOps    | G1     | SoftDev4.0    | Brest
  | 1         | Dias   | Plouzané | SysAdm    | G2     | LinGnu        | Paris
  | 2         | Monti  | Brest    | DevOps    | G1     | SoftDev4.0    | Brest
  | 3         | Stu    | Gouesnou | mng       | G1     | SoftDev4.0    | Brest
  | 4         | Pierou | Landéda  | mng       | G2     | LinGnu        | Paris
  | 4         | Pierou | Landéda  | cons      | G1     | SoftDev4.0    | Brest
  | 5         | Djid   | Bres     | DevOps    | G1     | SoftDev4.0    | Brest


Évidemment, une telle relation universelle est inexploitable efficacement. Elle comporte de nombreuses redondances (voir [le modèle relationnel](lecture_relation_model.html)) et rend l'exécution de certaines requêtes (voir [l'interrogation de données relationnelles](lecture_sql.html)) complexes voire impossibles.

Comme l'illustre le schéma ci-dessous, la méthode repose sur plusieurs étapes :<br/>
1- identification des relations (dépendances fonctionnelles) entre attributs,<br/>
2- découpage des relations par application de phases imbriquées de normalisation.<br/>

![Processus de construction d'un schéma relationnel par découpage](images/data/normalisation_process.png)


# Dépendance fonctionnelle

La notion centrale de cette méthode de découpage par normalisation en partant de la relation universelle est la dépendance fonctionnelle entre attributs.


## Définition

Soit $$R: \{A_1, A_2, \ldots, A_n\}$$ une relation universelle comportant $$n$$ attributs.

{% include callout.html content="**Dépendance fonctionnelle**<br/><br/> Une dépendance fonctionnelle entre deux sous-ensembles d'attributs $$X$$ et $$Y$$ ($$X, Y \subset \{A_1, A_2, \ldots, A_n\}$$) est notée $$X \rightarrow Y$$  et exprime la contrainte qu'à une valeur de $$X$$ ne peut correspondre qu'au plus une valeur de $$Y$$. On dit $$X$$ détermine $$Y$$ ou bien encore que $$Y$$ est déterminé par $$X$$.
" markdown="span" type="primary"%}


Les dépendances fonctionnelles sont identifiées en s'appuyant sur une connaissance de la sémantique de chaque attribut. Elles ne peuvent pas être inférées automatiquement car elles expriment des contraintes très fortes sur les liens de détermination entre les attributs. Les dépendances fonctionnelles utilisées dans une démarche de normalisation ne sont donc valables que pour un contexte applicatif donné. Une dépendance fonctionnelle ne doit pas être valable uniquement pour une extension à un temps $$t$$ de la relation universelle mais valable tout le temps. Il s'agit d'une règle métier sur la sémantique des données.

{% include callout.html content="**Exemple**<br/>Précisons pour notre exemple de relation universelle les éléments suivants :<br/>
- chaque client a un numéro attitré,<br/>
- un groupe n'a qu'un siège social (*villeG*),<br/>
- un client peut travailler dans plusieurs groupes mais occupe qu'une seule fonction par groupe.<br/>

Alors on peut établir les dépendances fonctionnelles suivantes (liste non exhaustive de dépendances valides) :<br/>
- $$\{numéro\}\rightarrow \{nom,ville\}$$<br/>
- $$\{numéro, nom\}\rightarrow \{ville\}$$<br/>
- $$\{idG\}\rightarrow \{designation, villeG\}$$<br/>
- $$\{idG, numéro\}\rightarrow \{fonction\}$$
<br/>" markdown="span" type="success" %}


## Quelques propriétés des dépendances fonctionnelles

Une dépendance fonctionnelle possède les propriétés suivantes :<br/>
- *Réflexivité* $$X \rightarrow X$$<br/>
- *Augmentation* si $$X \rightarrow X$$ alors $$X \bigcup Z \rightarrow X \bigcup Z$$<br/>
- *Transitivité* si $$X \rightarrow Y$$ et $$Y \rightarrow Z$$ alors $$X \rightarrow Z$$<br/>

De ces trois premières règles, on peut en déduire :
- *Additivité* si$$ X \rightarrow Y$$ et $$X \rightarrow Z$$ alors $$X \rightarrow Y \bigcup Z$$<br/>
- *Pseudo-transitivité* si $$X \rightarrow Y$$ et $$Y \bigcup W \rightarrow Z$$ alors $$X \bigcup W \rightarrow Z$$<br/>
- *Décomposition* si $$X \rightarrow Y \bigcup Z$$ alors $$X \rightarrow Y$$ et $$X \rightarrow Z$$<br/>

Ces règles sont connues sous le terme de règles d'inférence d'Armstrong et permettent d'identifier la couverture minimale des dépendances fonctionnelles. 

## Types de dépendances fonctionnelles


{% include callout.html content="**Dépendance fonctionnelle élémentaire**<br/><br/> Une dépendance fonctionnelle $$X \rightarrow Y$$ est élémentaire si $$\nexists X' \subset X$$ tel que $$X' \rightarrow Y$$.
" markdown="span" type="primary"%}

![DF non élémentaire](images/data/gdfe.png)

{% include callout.html content="**Exemple**<br/>Dans l'exemple illustré ci-dessus la dépendance fonctionnelle $$\{A_1, A_2\} \rightarrow \{A_3\}$$ n'est pas élémentaire car $$\{A_2\}$$ détermine à lui seul $$\{A_3\}$$.
<br/>" markdown="span" type="success" %}


{% include callout.html content="**Dépendance fonctionnelle directe**<br/><br/> Une dépendance fonctionnelle $$X \rightarrow Y$$ est direct si $$\nexists Z$$ tel que $$X \rightarrow Z$$ et $$Z \rightarrow Y$$. 
Une DF $$X \rightarrow Y$$ non directe est redondante car même en la supprimant on peut déterminer la valeur de $$Y$$ à partir de $$X$$ en passant par $$Z$$.
" markdown="span" type="primary"%}

![DF non élémentaire](images/data/dfnd.png)

{% include callout.html content="**Exemple**<br/>Dans l'exemple illustré ci-dessus la dépendance fonctionnelle $$\{A_1\} \rightarrow \{A_2\}$$ n'est pas directe et est donc redondante car $$\{A_1\} \rightarrow \{A_3\}$$ et $$\{A_3\} \rightarrow \{A_2\}$$.
<br/>" markdown="span" type="success" %}

## Graphe des dépendances fonctionnelles élémentaires et directes


{% include callout.html content="**Graphe des dépendances fonctionnelles élémentaires et directes**<br/><br/> Ce graphe est une représentation graphique des dépendances fonctionnelles élémentaires et directes conservées. Il sera très utile pour visualiser le découpage de la relation universelle lors des étapes de normalisation.
" markdown="span" type="primary"%}

![DF non élémentaire](images/data/gdfed.png)

L'image ci-dessus illustre un graphe des dépendances fonctionnelles où sont retirées celles qui ne sont ni élémentaires ni directes.

## Clef de la relation universelle

Avant de débuter la phase de découpage par normalisation de la relation universelle en s'appuyant sur le graphe des dépendances fonctionnelles et directes, il est nécessaire d'identifier la clé primaire de la relation universelle.

{% include callout.html content="**Clef de la relation universelle**<br/><br/> La clef primaire de la relation universelle s'identifie à partir du graphe des dépendances fonctionnelles. Elle correspond au sous-ensemble minimal d'attributs de la relation qui permet d'atteindre tous ses attributs. Plus formellement la clef $$C\subseteq R$$ d'une relation $$R$$ est telle que $$C \rightarrow R$$ et $$\nexists C' \subset C, C' \rightarrow R$$.
" markdown="span" type="primary"%}

Dans l'exemple du graphe précédent, la clef primaire est $$\{A_1, A_2\}$$.

# Normalisation par découpage

Des formes normales hiérarchiques ont été définies pour décomposer une relation universelle initiale sans perte d’information et sans redondances. Ces formes normales s’appuient sur les propriétés et les différents types de dépendances fonctionnelles.

## Première forme normale

{% include callout.html content="**Première forme normale**<br/><br/> Une relation $$R$$ est en première forme normale si elle possède une clé primaire et si tout attribut est atomique, c'est-à-dire non décomposable.
" markdown="span" type="primary"%}

Pour corriger le non respect de la première forme normale, l'attribut non atomique est séparé horizontalement dans la relation ou bien verticalement dans une relation dédiée.
Le découpage horizontale est une solution limitée dans la mesure où elle est faiblement extensible et implique la présence de nombreuses valeurs nulles.

![Première forme normale](images/data/1nf.png)

{% include callout.html content="**Exemple**<br/>Dans l'exemple illustré ci-dessus, regrouper les différentes fonctions qu'un client peut avoir dans un attribut nommé *jobs* empêche le respect de la première forme normale. Si le nombre maximum de fonctions réalisables est très limité, un découpage horizontal peut être appliqué mais généralement l'autre stratégie est utilisée. On peut désormais observer que les relations issues du découpage ont une clef primaire et tous les attributs sont atomiques. Elles sont donc en première forme normale.
<br/>" markdown="span" type="success" %}

## Deuxième forme normale

{% include callout.html content="**Deuxième forme normale**<br/><br/> Une relation $$R$$ est en deuxième forme normale si elle est en première forme normale et si tout attribut ne faisant pas partie de sa clef primaire dépend pleinement (i.e. de manière élémentaire) de la clef.
" markdown="span" type="primary"%}

Lorsqu'une relation ne satisfait pas cette deuxième forme normale, un découpage est effectué. Ce découpage consiste à regrouper dans une nouvelle relation les attributs qui dépendent d'une partie de la clef primaire de la relation, cette partie de clef primaire formera la clef primaire de la nouvelle relation créée.

![## Deuxième forme normale](images/data/2nf.png)


{% include callout.html content="**Exemple**<br/>À partir du graphe des dépendances fonctionnelles ci-dessus, on identifie que la clef primaire est $$\{A_1, A_2\}$$. Comme $$A_6$$ ne dépend que d'une partie de la clef de la relation (encore universelle ici), alors on crée deux relations :<br/>

- $$R_1 : \{ \underline{A_1} , A_3, A_4, A_5, A_7\}$$<br/>
- $$R_2 : \{ \underline{A_2} , A_6\}$$

<br/>" markdown="span" type="success" %}

## Troisième forme normale

{% include callout.html content="**Troisième forme normale**<br/><br/> Une relation $$R$$ est en troisième forme normale si elle est en deuxième forme normale et si tout attribut ne faisant pas partie de sa clef primaire dépend directement de la clef et non par l'intermédiaire d'un autre attribut.
" markdown="span" type="primary"%}



Lorsqu'une relation ne satisfait pas cette troisème forme normale, un découpage est effectué. Ce découpage consiste à regrouper dans une nouelle relation les attributs qui dépendent directement d'un attribut non clé. Cet attribut au départ de la dépendance fonctionnelle sera la clef primaire de la nouvelle relation créée.


C'est lors de cette étape du passage à la troisième forme normale que l'on peut identifier les attributs sur lesquels une contrainte d'intégrité référentielle doit être définie. Il s'agit des attributs desquels arrive et parte des dépendances fonctionnelles. 


Attention !!! Lors du découpage, il est possible que la clef primaire de la relation universelle ne soit plus présente dans aucune relation. Il faut alors créer une relation pour stocker ces attributs qui, ensemble, permettent d'atteindre tous les attributs. Cette situation est peu fréquente mais à prendre en compte.

![## Troisième forme normale](images/data/3nf.png)


{% include callout.html content="**Exemple**<br/>À partir du graphe des dépendances fonctionnelles ci-dessus, on constate que dans la relation $$R_1 : \{ \underline{A_1} , A_3, A_4, A_5, A_7\}$$, $$\{A_7\}$$ dépend directement de $$\{A_5\}$$ et non directmeent de la clef primaire de la $$R_1$$ (i.e. $$\{A_1\}$$). On va donc créer une nouvelle relation $$R_3 : \{ \underline{A_5} , A_7\}$$.<br/>
Le schéma relationnel final en troisième forme normale sera alors :<br/>
- $$R_1 : \{ \underline{A_1} ,\, A_3, A_4, \#A_5\}$$<br/>
- $$R_2 : \{ \underline{A_2} ,\, A_6\}$$<br/>
- $$R_3 : \{ \underline{A_5} ,\, A_7\}$$<br/>
- $$R_4 : \{ \underline{\#A_1 ,\, \#A_2}\}$$
<br/>" markdown="span" type="success" %}



{% include callout.html content="<b>Pour continuer ... </b><br/><br/>
Il est admis qu'un schéma relationnel est exploitable s'il respecte la troisième forme normale. Ce niveau de normalisation ne permet pas de pallier tous les problèmes liés à l'exploitation de données, d'où l'existance d'autres [formes normales de plus haut niveau](https://fr.wikipedia.org/wiki/Forme_normale_(bases_de_donn%C3%A9es_relationnelles\)).<br/>

De plus, cette méthode pragmatique de découpage est à priviligier pour des contextes applicatifs avec peu de données ou bien pour vérifier la conformité de partie d'un schéma relationnel vis-à-vis des règles de normalisation. Il s'agit donc d'un complément et non d'un substitut à la [méthode par modélisation conceptuelle](lecture_conceptual_modeling.html)." markdown="span" type="warning"%}