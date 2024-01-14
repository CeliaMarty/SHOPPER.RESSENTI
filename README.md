# SHOPPER.RESSENTI

## Introduction
L'application SHOPPER.RESSENTI offre une expérience interactive pour explorer et comprendre les tendances de criminalité à Los Angeles, de 2020 à 2023.

Voici un aperçu de l'application : 

IMAGE


## Comment exécuter l'application

- Avoir R et R studio sur votre machine
- Télécharger l'ensemble du projet depuis le [Répository R-Shiny](https://github.com/CeliaMarty/Projet-R-Shiny-)
- Télécharger le jeu de données via ce lien [Crime-Data](https://data.lacity.org/Public-Safety/Crime-Data-from-2020-to-Present/2nrs-mtv8/about_data)
- Mettre le fichier dans un dossier DATA que vous créez
- Ouvrir global.R, packages.R et Webapp_DataCrime.R
- Modifier les chemins (1 sur global.R avec l'endroit où est placé le jeu de donées et 2 sur Webapp_DataCrime.R avec l'endroit où est placé le fichier packages et de même pour le fichier global)
- Aller sur Webapp_DataCrime.R et appuyez sur Run App pour lancer l'application. 
  

## Fonctionnalités de l'Application

### Onglet "Accueil"
Cet onglet présente une introduction à l'application, affiche quelques chiffres clés et comprend un graphique montrant le nombre de délits par année.

### Onglet "Victimes"
Sélectionnez une année dans les deux menus déroulants et visualisez la répartition des délits en fonction du sexe et de l'âge des victimes pour l'année en question.

### Onglet "Localisation"
Cliquez sur un quartier puis sur la carte intéractive vous aurez la représentation de la répartition des délits ainsi que leur type.

### Onglet "Type de délit"
Dans le menu déroulant sélectionnez un type de délit et dans la table intéractive regardez les informations pour chaque délit.

## Remarques 
- Dans l'onglet "Localisation" il y a uniquement les données de 2023 car sinon la carte serait trop surchargée et illisible.
- Dans l'onglet "Type de délit" vous pouvez filtrer par type de délits dans le menu déroulant mais il y également une autre option de filtrage grâce à la barre de recherche située à droite, au dessus de la table. 
