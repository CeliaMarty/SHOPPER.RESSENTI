# SHOPPER.RESSENTI

## Projet
L'application SHOPPER.RESSENTI crée avec l'aide de [Khoudia DIOUF](https://github.com/KhoudiaDiouf/KhoudiaDiouf) permet à l'utilisateur d'explorer de manière intéractive un grand nombre d'avis clients rassemblés TeePublic, une plate-forme en ligne réputée pour sa collection diversifiée d'articles de mode. 

Voici un aperçu de l'application : 

IMAGE


## Comment exécuter l'application

- Avoir R et R studio sur votre machine
- Télécharger l'ensemble du projet depuis le [Répository SHOPPER.RESSENTI](https://github.com/CeliaMarty/SHOPPER.RESSENTI)
- Télécharger le jeu de données via ce lien [ShopperSentiments](https://www.kaggle.com/datasets/nelgiriyewithana/shoppersentiments/data)
- Ouvrir Global.R, Packages.R et app.R
- Assurez vous de charger tout les packages nécéssaires (présents dans le fichier Packages.R)
- Lancer l'application puis insérer le jeu de données, vous pouvez maintenant explorer l'application ! 
  

## Fonctionnalités de l'Application

### Onglet "Accueil"
Cet onglet présente une introduction à l'application, permet à l'utilisateur d'insérer le jeu de dnnées, affiche quelques chiffres clés et comprend un graphique montrant le nombre d'avis récolté chaque chaque année.

### Onglet "Victimes"
Sélectionnez une année dans les deux menus déroulants et visualisez la répartition des délits en fonction du sexe et de l'âge des victimes pour l'année en question.

### Onglet "Localisation"
Cliquez sur un quartier puis sur la carte intéractive vous aurez la représentation de la répartition des délits ainsi que leur type.

### Onglet "Type de délit"
Dans le menu déroulant sélectionnez un type de délit et dans la table intéractive regardez les informations pour chaque délit.

## Remarques 
- Dans l'onglet "Localisation" il y a uniquement les données de 2023 car sinon la carte serait trop surchargée et illisible.
- Dans l'onglet "Type de délit" vous pouvez filtrer par type de délits dans le menu déroulant mais il y également une autre option de filtrage grâce à la barre de recherche située à droite, au dessus de la table. 
