# SHOPPER.RESSENTI

## Projet
L'application SHOPPER.RESSENTI crée avec l'aide de [Khoudia DIOUF](https://github.com/KhoudiaDiouf/KhoudiaDiouf) permet à l'utilisateur d'explorer de manière intéractive un grand nombre d'avis clients rassemblés TeePublic, une plate-forme en ligne réputée pour sa collection diversifiée d'articles de mode. 

Voici un aperçu de l'application :
<img width="1440" alt="Capture d’écran 2024-01-19 à 00 34 59" src="https://github.com/CeliaMarty/SHOPPER.RESSENTI/assets/152623002/cc79f7b1-1ca7-4502-8a1e-6db69032cd40">





## Comment exécuter l'application

- Avoir R et R studio sur votre machine
- Télécharger l'ensemble du projet depuis le [Répository SHOPPER.RESSENTI](https://github.com/CeliaMarty/SHOPPER.RESSENTI)
- Télécharger le jeu de données via ce lien [ShopperSentiments](https://www.kaggle.com/datasets/nelgiriyewithana/shoppersentiments/data)
- Ouvrir app.R
- Assurez vous de charger tout les packages nécéssaires (présents dans le fichier Packages.R)
- Lancer l'application puis insérer le jeu de données, vous pouvez maintenant explorer l'application ! 
  

## Fonctionnalités de l'Application

### Onglet "Accueil"
Cet onglet présente une introduction à l'application il permet à l'utilisateur d'insérer le jeu de dnnées. Une fois chargé l'onglet va afficher quelques chiffres clés et un graphique montrant le nombre d'avis récolté chaque année ainsi que des options pour enregistrer les données.

### Onglet "Avis"
Sur cet onglet on retrouve une table intéractive, l'utilisateur va pouvoir chercher des avis spécifiques en fonction des années séléctionnées, des notes des avis. Grâce à la fonction recherche il pourra également chercher selon son besoin. 

### Onglet "Temporalité"
Dans ce 3ème onglet on peut voir la répartion des avis selon les mois et selon les années encore une fois grâce à un filtre qui permet à l'utilisateur de sélectionner une année. L'utilisateur va également avoir accès au nombre d'avis total par année ainsi que le taux de satisfaction par année. 

### Onglet "Localisation"
Cet onglet est composé d'une carte intéractive qui localise le nombre d'avis récolté par endroits en 2023.

