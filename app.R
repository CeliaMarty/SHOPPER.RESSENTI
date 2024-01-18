# Inclusions des scripts R :
library(shiny)
library(dplyr)
library(shinydashboard)
library(shinythemes)
library(magrittr)
library(shinyWidgets)
# Ensemble de packages pour travailler avec les données. 
library(tidyverse)

# Création de cartes interactives
library(leaflet)

# Création de graphiques
library(ggplot2)

# Extension de shiny qui permet de créer des tableaux de bord
library(shinydashboard)

# Package du tidyverse pour effectuer des manipulations avec filter(), mutate(), group_by()...
library(dplyr)

# Tables de données interactives 
library(DT)

source(file= "/Users/khoudiadiouf/Desktop/SHOPPER.RESSENTI/Global.R")
source(file= "/Users/khoudiadiouf/Desktop/SHOPPER.RESSENTI/Packages.R")

# Interface utilisateur
ui <- navbarPage(
  title = "SHOPPER.RESSENTI", # Titre de la page
  tabsetPanel(
    # Onglet Accueil
    tabPanel("Accueil",
             fluidPage(
               themeSelector(),
               sidebarLayout(
                 sidebarPanel(
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   fileInput("fileInput", "Sélectionner un fichier", multiple = FALSE, accept = NULL),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
                   br(),
downloadButton("exportPDF", "Export PDF"),
downloadButton("exportPNG", "Export PNG"),
actionButton("generateReport", "Générer le Rapport"),
),
                 ),
                 mainPanel(
                     h3("Quelques chiffres"), # Titre colonne
                     valueBoxOutput("MaBox1"), # Boite de valeur sur le nombre d'avis récoltés en 2023
                     valueBoxOutput("MaBox2"),# Boite de valeur sur le nombre d'avis positifs récoltés en 2023
                     valueBoxOutput("MaBox3"),# Boite de valeur sur le nombre d'avis neutres récoltés en 2023
                     br(),
                     br(),
                     h3("Une vision générale"),
                     br(),
                     br(),
                     plotOutput("PlotReview")
                   )
               )
             )
    ),
    # Onglet Review
    tabPanel("Avis",
             fluidPage(
               h3("Analyse des Avis"),
               br(),
               br(),
               
               
               # Table interactive avec les détails des avis
               DTOutput("avis_table"),
               
               br(),
               br(),
               br(),
               br(),
               
               # Graphique des sentiments
               plotOutput("sentiments_plot")
             )
             
    ),
    
    # Onglet Temporalité
    tabPanel("Temporalité",
             fluidPage(
               h3("Analyse Temporelle"),
               selectInput("annees_selectionnees", "Sélectionnez les années :",
                           choices = c(2020, 2021, 2022, 2023),
                           selected = 2020),
                        
               br(),
               textOutput("total_avis"),
               textOutput("taux_satisfaction"),
               plotOutput("graphique_mois")
             )
             
    ),
    
    # Onglet Localisation
    tabPanel("Localisation",
             fluidPage(
               h3 ("Carte interactive montrant l'emplacement des avis collectés en 2023."),
               leafletOutput("map") # Carte Leaflet
             )
    )
  )
# Définition du serveur Shiny
server <- function(input, output) {

  #Augmenter la capacité pour l'import du fichier 
  options(shiny.maxRequestSize=100*1024^2)
  
  raw_data <- reactive({
    req(input$fileInput)
    infile <- input$fileInput
    if (is.null(infile)) {
      return(NULL)
    }
    
    raw <- read.csv(infile$datapath, header = TRUE, sep = "," ,encoding ="UTF-8")
    return(raw)
  
  })
  
  data_2023 <- reactive({
  # Filtrer les données pour l'année 2023
  raw_data() %>%
    dplyr::filter(date == 2023) %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"))
  })
  
  # Lancer l'application Shiny uniquement si des données sont disponibles
  output$MaBox1 <- renderValueBox({
    valueBox(nrow(data_2023()), "Avis récoltés en 2023",
             icon = icon("pen-to-square"))
  })
  
   data_positifs_2023 <- reactive({
     raw_data() %>%
       dplyr::filter(review.label > 3) %>%
       })

   
   output$MaBox2 <- renderValueBox({
     valueBox(nrow(data_positifs_2023()), "Nombres d'avis positifs en 2023",
               icon = icon("thumbs-up"))
    })
 #  
   
   
 #  data_neutres_2023<- data_2023  %>%
 #    filter(review.label == 3)
 #  
 #  output$MaBox3 <- renderValueBox({
 #    req(data())
 #    valueBox(nrow(data_neutres_2023), "Nombres d'avis neutres en 2023",
 #             icon = icon("face-meh-blank"))
 #  })
 #  
 #  
 #  # Afficher le bar plot sur le menu home 
 #  output$PlotReview <- renderPlot({
 #    req(data())
 #    ggplot(plot_data, aes(x = as.factor(date), y = review)) +
 #      geom_bar(stat = "identity", fill = "steelblue") +
 #      labs(title = "Nombre d'avis par année",
 #           x = "Année",
 #           y = "Nombre d'avis") +
 #      theme_minimal()
 #  })
 #  
 #  
 #  # Ajoutez ici le code pour ReviewPlot
 #  
 #  # Afficher la carte en fonction de l'area sélectionnée
 #  output$map <- renderLeaflet({
 #    req(data())
 #    leaflet(data_2023) %>%
 #      addTiles() %>%
 #      addMarkers(
 #        lat = ~latitude,
 #        lng = ~longitude,
 #        clusterOptions = markerClusterOptions()
 #      )
 #  })
 #  
 #  
 #  # Observer pour le changement de thème
 #  observe({
 #    shinythemes::themeSelector()
 #  })
 #  
 #  
 #  
 #  
 # 
  # Exemple de code pour afficher le nombre d'avis en fonction de la sélection de l'utilisateur
  output$total_avis <- renderText({
    # Données filtrées par date
    donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]

    # Total des avis en fonction de la sélection de l'utilisateur
    total_avis <- nrow(donnees_filtrees)

    paste("Total des avis : ", total_avis)
  })
 #  
 #  # Exemple : Taux de satisfaction
   output$taux_satisfaction <- renderText({
   donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
   total_avis <- nrow(donnees_filtrees)
     
    if (total_avis == 0) {
     "Taux de satisfaction : N/A"
     } else {
      paste("Taux de satisfaction : ", mean(donnees_filtrees$review.label) * 100, "%")
     }
   })
 #  
 #  # Exemple : Graphique de satisfaction par mois
      output$graphique_mois <- renderPlot({
      donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
     
     ggplot(donnees_filtrees, aes(x = month, y = review.label)) +
       geom_bar(stat = "identity") +
       labs(title = "Graphique de satisfaction par mois",
            x = "Mois",
            y = "Note moyenne de satisfaction")
   })
  
 #  
 #  
 # 
 #  
 #  
 #  # Mise à jour de la table interactive en fonction des filtres
 #  output$avis_table <- renderDT({
 #  datatable(data()[, c("date", "review", "review.label")], options = list(pageLength = 10))
 #  
 # })
 #  
 #  
 #  
 #  # Mise à jour du graphique des sentiments en fonction des filtres
 #  output$sentiments_plot <- renderPlot({
 #    req(data())
 #    
 #    ggplot(data(), aes(x = as.numeric(review.label))) +
 #      geom_bar(fill = "steelblue") +
 #      labs(title = "Répartition des Sentiments",
 #           x = "Sentiment",
 #           y = "Nombre d'Avis") +
 #      theme_minimal()
 #  })
  
  
}


# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
