# Importe les données

print("data charged")
data <- read.csv("/Users/khoudiadiouf/Desktop/SHOPPER.RESSENTI/DATA/TeePublic_review.csv", header = TRUE, sep = ",")
print("data load")

# Affichage des premières lignes du jeu de données

head(data)

# Affichage du résumé de chaque colonne : permet de voir les colonnes à modifier et ou étudier

summary(data)

# Filtrer les données pour l'année 2023 et les stocker dans une variable
data_2023 <- data %>%
  filter(date == 2023)

plot_data <- data %>%
  group_by(date) %>%
  summarise(review = n())

ggplot(plot_data, aes(x = as.factor(date), y = review)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Nombre d'avis par année",
       x = "Année",
       y = "Nombre d'avis") +
  theme_minimal()


num_rows <- nrow(data_2023)

nombre_lignes_2023 <- nrow(data_2023)




#Conserver les données uniquement de 2020,2021,2022 et 2023
donnees_filtrees <- data[data$date %in% c(2020, 2021, 2022, 2023), ]

nombre_lignes_2023 <- nrow(donnees_filtrees[donnees_filtrees$date == 2023, , drop = FALSE])
nombre_lignes_2023 <- as.character(nombre_lignes_2023)