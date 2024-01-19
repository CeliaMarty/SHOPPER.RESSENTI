# Importe les données

print("Khalil data charged")

#data <- read.csv("/Users/khoudiadiouf/Desktop/SHOPPER.RESSENTI/DATA/TeePublic_review.csv", header = TRUE, sep = ",", encoding ="UTF-8")
# Traitement des charactères spéciaux 

print("data load")

# Affichage des premières lignes du jeu de données


# Affichage du résumé de chaque colonne : permet de voir les colonnes à modifier et ou étudier


# Filtrer les données pour l'année 2023 et les stocker dans une variable
# data_2023 <- data %>%
#   filter(date == 2023)
# 
# plot_data <- data %>%
#   group_by(date) %>%
#   summarise(review = n())
# 
# ggplot(plot_data, aes(x = as.factor(date), y = review)) +
#   geom_bar(stat = "identity", fill = "steelblue") +
#   labs(title = "Nombre d'avis par année",
#        x = "Année",
#        y = "Nombre d'avis") +
#   theme_minimal()
# 
# 
# num_rows <- nrow(data_2023)
# 
# nombre_lignes_2023 <- nrow(data_2023)
# 
# 
# 
# 
# #Conserver les données uniquement de 2020,2021,2022 et 2023
# donnees_filtrees <- data[data$date %in% c(2020, 2021, 2022, 2023), ]
# 
# nombre_lignes_2023 <- nrow(donnees_filtrees[donnees_filtrees$date == 2023, , drop = FALSE])
# nombre_lignes_2023 <- as.character(nombre_lignes_2023)



# 
# library(shiny)
# library(dplyr)
# library(shinydashboard)
# library(leaflet)
# library(DT)
# 
# # Interface utilisateur
# ui <- navbarPage(
#   title = "SHOPPER.RESSENTI",
#   tabsetPanel(
#     tabPanel("Accueil",
#              fluidPage(
#                sidebarLayout(
#                  sidebarPanel(
#                    br(),
#                    br(),
#                    fileInput("fileInput", "Sélectionner un fichier", multiple = FALSE, accept = NULL),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    downloadButton("exportPDF", "Export PDF"),
#                    downloadButton("exportPNG", "Export PNG"),
#                    actionButton("generateReport", "Générer le Rapport")
#                  ),
#                  mainPanel(
#                    uiOutput("homeContent")
#                  )
#                )
#              )
#     ),
#     tabPanel("Avis",
#              fluidPage(
#                h3("Analyse des Avis"),
#                br(),
#                br(),
#                # Ajoutez un filtre par année
#                selectInput("filterYear", "Filtrer par année :", 
#                            choices = c(2020, 2021, 2022, 2023),
#                            selected = 2020),
#                br(),
#                br(),
#                # Ajoutez un filtre par note
#                sliderInput("filterRating", "Filtrer par note :", 
#                            min = 1, max = 5, value = c(1, 5), step = 1),
#                br(),
#                br(),
#                # Table interactive avec les détails des avis
#                DTOutput("avis_table"),
#                br(),
#                br(),
#                br(),
#                br(),
#                # Graphique des sentiments
#                plotOutput("sentiments_plot")
#              )
#     ),
#     tabPanel("Temporalité",
#              fluidPage(
#                h3("Analyse Temporelle"),
#                selectInput("annees_selectionnees", "Sélectionnez une année :",
#                            choices = c(2020, 2021, 2022, 2023),
#                            selected = 2020),
#                br(),
#                textOutput("total_avis"),
#                br(),
#                textOutput("taux_satisfaction"),
#                br(),
#                plotOutput("graphique_repartition_mois"),
#                br(),
#              )
#     ),
#     tabPanel("Localisation",
#              fluidPage(
#                h3 ("Carte interactive montrant l'emplacement des avis collectés en 2023."),
#                leafletOutput("map") # Carte Leaflet
#              )
#     )
#   )
# )
# 
# # Définition du serveur Shiny
# server <- function(input, output) {
#   
#   #Augmenter la capacité pour l'import du fichier 
#   options(shiny.maxRequestSize=100*1024^2)
#   
#   raw_data <- reactive({
#     req(input$fileInput)
#     infile <- input$fileInput
#     if (is.null(infile)) {
#       return(NULL)
#     }
#     
#     raw <- read.csv(infile$datapath, header = TRUE, sep = ";" ,encoding ="UTF-8")
#     return(raw)
#   })
#   
#   # Affichage du contenu des onglets en fonction de la présence du fichier
#   output$homeContent <- renderUI({
#     if (is.null(raw_data())) {
#       return("Contenu à afficher lorsque aucun fichier n'est importé.")
#     } else {
#       # Si un fichier est importé, afficher le contenu habituel de la page d'accueil
#       fluidPage(
#         h3("Quelques chiffres"),
#         valueBoxOutput("MaBox1"),
#         valueBoxOutput("MaBox2"),
#         valueBoxOutput("MaBox3"),
#         br(),
#         br(),
#         h3("Une vision générale"),
#         br(),
#         br(),
#         plotOutput("PlotReview")
#       )
#     }
#   })
#   
#   # Affichage du contenu de l'onglet Avis en fonction de la présence du fichier
#   output$avisContent <- renderUI({
#     if (is.null(raw_data())) {
#       return("Contenu à afficher lorsque aucun fichier n'est importé.")
#     } else {
#       # Si un fichier est importé, afficher le contenu habituel de l'onglet Avis
#       fluidPage(
#         h3("Analyse des Avis"),
#         br(),
#         br(),
#         # Ajoutez un filtre par année
#         selectInput("filterYear", "Filtrer par année :", 
#                     choices = c(2020, 2021, 2022, 2023),
#                     selected = 2020),
#         br(),
#         br(),
#         # Ajoutez un filtre par note
#         sliderInput("filterRating", "Filtrer par note :", 
#                     min = 1, max = 5, value = c(1, 5), step = 1),
#         br(),
#         br(),
#         # Table interactive avec les détails des avis
#         DTOutput("avis_table"),
#         br(),
#         br(),
#         br(),
#         br(),
#         # Graphique des sentiments
#         plotOutput("sentiments_plot")
#       )
#     }
#   })
#   
#   # Affichage du contenu de l'onglet Temporalité en fonction de la présence du fichier
#   output$temporaliteContent <- renderUI({
#     if (is.null(raw_data())) {
#       return("Contenu à afficher lorsque aucun fichier n'est importé.")
#     } else {
#       # Si un fichier est importé, afficher le contenu habituel de l'onglet Temporalité
#       fluidPage(
#         h3("Analyse Temporelle"),
#         selectInput("annees_selectionnees", "Sélectionnez une année :",
#                     choices = c(2020, 2021, 2022, 2023),
#                     selected = 2020),
#         br(),
#         textOutput("total_avis"),
#         br(),
#         textOutput("taux_satisfaction"),
#         br(),
#         plotOutput("graphique_repartition_mois"),
#         br(),
#       )
#     }
#   })
#   
#   # Affichage du contenu de l'onglet Localisation en fonction de la présence du fichier
#   output$localisationContent <- renderUI({
#     if (is.null(raw_data())) {
#       return("Contenu à afficher lorsque aucun fichier n'est importé.")
#     } else {
#       # Si un fichier est importé, afficher le contenu habituel de l'onglet Localisation
#       fluidPage(
#         h3 ("Carte interactive montrant l'emplacement des avis collectés en 2023."),
#         leafletOutput("map") # Carte Leaflet
#       )
#     }
#   })
#   
#   # ... Autres parties du serveur ...
# }
# 
# # Lancer l'application Shiny
# shinyApp(ui = ui, server = server)

# #MON APP
# source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Global.R")
# source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Packages.R")
# 
# # Interface utilisateur
# ui <- navbarPage(
#   title = "SHOPPER.RESSENTI", # Titre de la page
#   tabsetPanel(
#     # Onglet Accueil
#     tabPanel("Accueil",
#              fluidPage(
#                themeSelector(),
#                sidebarLayout(
#                  sidebarPanel(
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    fileInput("fileInput", "Sélectionner un fichier", multiple = FALSE, accept = NULL),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    br(),
#                    downloadButton("exportPDF", "Export PDF"),
#                    downloadButton("exportPNG", "Export PNG"),
#                    actionButton("generateReport", "Générer le Rapport")
#                  ),
#                  
#                  mainPanel(
#                    h3("Quelques chiffres"), # Titre colonne
#                    valueBoxOutput("MaBox1"), # Boite de valeur sur le nombre d'avis récoltés en 2023
#                    valueBoxOutput("MaBox2"),# Boite de valeur sur le nombre d'avis positifs récoltés en 2023
#                    valueBoxOutput("MaBox3"),# Boite de valeur sur le nombre d'avis neutres récoltés en 2023
#                    br(),
#                    br(),
#                    h3("Une vision générale"),
#                    br(),
#                    br(),
#                    plotOutput("PlotReview")
#                  )
#                )
#              )
#     ),
#     # Onglet Review
#     tabPanel("Avis",
#              fluidPage(
#                h3("Analyse des Avis"),
#                br(),
#                br(),
#                # Ajoutez un filtre par année
#                selectInput("filterYear", "Filtrer par année :", 
#                            choices = c(2020, 2021, 2022, 2023),
#                            selected = 2020),
#                br(),
#                br(),
#                # Ajoutez un filtre par note
#                sliderInput("filterRating", "Filtrer par note :", 
#                            min = 1, max = 5, value = c(1, 5), step = 1),
#                br(),
#                br(),
#                # Table interactive avec les détails des avis
#                DTOutput("avis_table"),
#                br(),
#                br(),
#                br(),
#                br(),
#                # Graphique des sentiments
#                plotOutput("sentiments_plot")
#              )
#     ),
#     
#     # Onglet Temporalité
#     tabPanel("Temporalité",
#              fluidPage(
#                h3("Analyse Temporelle"),
#                selectInput("annees_selectionnees", "Sélectionnez une année :",
#                            choices = c(2020, 2021, 2022, 2023),
#                            selected = 2020),
#                br(),
#                textOutput("total_avis"),
#                br(),
#                textOutput("taux_satisfaction"),
#                br(),
#                plotOutput("graphique_repartition_mois"),
#                br(),
#              )
#              
#     ),
#     # Onglet Localisation
#     tabPanel("Localisation",
#              fluidPage(
#                h3 ("Carte interactive montrant l'emplacement des avis collectés en 2023."),
#                leafletOutput("map") # Carte Leaflet
#              )
#     )
#   )
# )
# # Définition du serveur Shiny
# server <- function(input, output) {
#   
#   #Augmenter la capacité pour l'import du fichier 
#   options(shiny.maxRequestSize=100*1024^2)
#   
#   raw_data <- reactive({
#     req(input$fileInput)
#     infile <- input$fileInput
#     if (is.null(infile)) {
#       return(NULL)
#     }
#     
#     raw <- read.csv(infile$datapath, header = TRUE, sep = ";" ,encoding ="UTF-8")
#     return(raw)
#     
#   })
#   
#   data_2023 <- reactive({
#     # Filtrer les données pour l'année 2023
#     raw_data () %>%
#       dplyr::filter(date == 2023) %>%
#       mutate(date = as.Date(date, format = "%Y-%m-%d"))
#   })
#   
#   # Lancer l'application Shiny uniquement si des données sont disponibles
#   output$MaBox1 <- renderValueBox({
#     valueBox(nrow(data_2023()), "Avis récoltés en 2023",
#              icon = icon("pen-to-square"))
#   })
#   
#   data_positifs_2023 <- reactive({
#     data_2023() %>%
#       dplyr::filter(review.label > 3)
#   })
#   
#   
#   output$MaBox2 <- renderValueBox({
#     valueBox(nrow(data_positifs_2023()), "Nombres d'avis positifs en 2023",
#              icon = icon("thumbs-up"))
#   })
#   
#   
#   
#   data_neutres_2023 <- reactive({
#     data_2023() %>%
#       filter(review.label == 3) 
#   }) 
#   
#   
#   output$MaBox3 <- renderValueBox({
#     valueBox(nrow(data_neutres_2023()), "Nombres d'avis neutres en 2023",
#              icon = icon("face-meh-blank"))
#   })
#   
#   
#   
#   # #    Afficher le bar plot sur le menu home 
#   output$PlotReview <- renderPlot({
#     ggplot(raw_data(), aes(x = as.factor(date), fill = as.factor(date)))+
#       geom_bar() +
#       labs(title = "Répartition du nombre d'avis par année",
#            x = "Année",
#            y = "Nombre d'avis") +
#       scale_fill_discrete(name = "Année") +    
#       theme_minimal()
#   })
#   # #  
#   # Afficher la carte en fonction de l'area sélectionnée
#   output$map <- renderLeaflet({
#     leaflet(data_2023()) %>%
#       addTiles() %>%
#       addMarkers(
#         lat = ~latitude,
#         lng = ~longitude,
#         clusterOptions = markerClusterOptions()
#       )
#   })
#   
#   # Exemple : Graphique de la répartition du nombre d'avis par mois
#   output$graphique_repartition_mois <- renderPlot({
#     data_selected_year <- raw_data() %>%
#       filter(date %in% input$annees_selectionnees)
#     
#     ggplot(data_selected_year, aes(x = as.factor(month), fill = as.factor(month))) +
#       geom_bar() +
#       labs(title = "Répartition du nombre d'avis par mois",
#            x = "Mois",
#            y = "Nombre d'avis") +
#       scale_x_discrete(breaks = 1:12, labels = month.abb) +
#       scale_fill_discrete(name = "month") +
#       theme_minimal()
#   })
#   
#   
#   # Exemple de code pour afficher le nombre d'avis en fonction de la sélection de l'utilisateur
#   output$total_avis <- renderText({
#     # Données filtrées par date
#     donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
#     #   Total des avis en fonction de la sélection de l'utilisateur
#     total_avis <- nrow(donnees_filtrees)
#     paste("Total des avis : ", total_avis)
#   })
#   #Exemple : Taux de satisfaction
#   output$taux_satisfaction <- renderText({
#     donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
#     total_avis <- nrow(donnees_filtrees)
#     
#     if (total_avis == 0) {
#       "Taux de satisfaction : N/A"
#     } else {
#       taux_satisfaction <- mean(donnees_filtrees$review.label > 3) * 100
#       paste("Taux de satisfaction : ", taux_satisfaction, "%")
#     }
#   })
#   
#   filtered_reviews <- reactive({
#     reviews <- raw_data() %>%
#       filter(date == input$filterYear,
#              review.label >= input$filterRating[1],
#              review.label <= input$filterRating[2])
#     return(reviews)
#   })
#   
#   # Mise à jour de la table interactive en fonction des filtres
#   output$avis_table <- renderDT({
#     datatable(filtered_reviews()[,c("date", "review", "review.label")], options = list(pageLength = 10))})
#   
#   
# }
# 
# 
# # Lancer l'application Shiny
# shinyApp(ui = ui, server = server)
# 
# 
# 
# 
# # #Mise à jour du graphique des sentiments en fonction des filtres
# # output$sentiments_plot <- renderPlot({
# # ggplot(data(), aes(x = as.numeric(review.label))) +
# # geom_bar(fill = "steelblue") +
# # labs(title = "Répartition des Sentiments",
# # x = "Sentiment",
# # y = "Nombre d'Avis") +
# # theme_minimal()
# # })
# 
# 
# 
# 
