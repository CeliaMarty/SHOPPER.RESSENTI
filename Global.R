# Importe les données

print("data charged")
data <- read.csv("/Users/celiamarty/Desktop/SHOPPER.RESSENTI/DATA/TeePublic_review.csv", header = TRUE, sep = ";")
print("data load")

# Affichage des premières lignes du jeu de données

head(data)

# Affichage du résumé de chaque colonne : permet de voir les colonnes à modifier et ou étudier

summary(data)

#Conserver les données uniquement de 2020,2021,2022 et 2023
donnees_filtrees <- data[data$date %in% c(2020, 2021, 2022, 2023), ]

#"Avis" est de type numérique
donnees_filtrees$review <- as.numeric(donnees_filtrees$review)

# Compter le nombre d'avis pour chaque année
nombre_avis_par_annee <- donnees_filtrees %>%
  group_by(date) %>%
  count()

# Affichage de la moyenne globale du nombre d'avis
print(nombre_avis_par_annee)

