# Inclusions des scripts R :
library(shiny)
library(dplyr)
library(shinydashboard)
library(shinythemes)
library(magrittr)

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
                   br(),
                   br(),
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
               # Filtres interactifs
               selectInput("filtre_note", "Filtrer par Note :", 
                           choices = c("Toutes", "1", "2", "3", "4", "5")),
               
               dateRangeInput("filtre_date", "Filtrer par Date :", 
                              start = "2020-01-01", end = "2023-12-31", format = "yyyy-mm-dd"),
               
               br(),
               br(),
               br(),
               
               # Table interactive avec les détails des avis
               DTOutput("avis_table"),
               
               br(),
               br(),
               br(),
               br(),
               
               # Graphique des sentiments
               plotOutput("sentiments_plot"),
             )
             
    ),
    
    # Onglet Temporalité
    tabPanel("Temporalité",
             fluidPage(
               h3("Analyse Temporelle"),
               selectInput("annees_selectionnees", "Sélectionnez les années :",
                           choices = unique(data$date),
                           selected = c(2020, 2021, 2022, 2023),
                           multiple = TRUE),
               br(),
               verbatimTextOutput("total_avis"),
               verbatimTextOutput("taux_satisfaction"),
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
)




# Définition du serveur Shiny
server <- function(input, output) {

  #Augmenter la capacité pour l'import du fichier 
  options(shiny.maxRequestSize=100*1024^2)
  
  data <- reactive({
    req(input$fileInput)
    infile <- input$fileInput
    if (is.null(infile)) {
      return(NULL)
    }
    
    raw_data <- read.csv(infile$datapath, header = TRUE, sep = ",")
    
    # Filtrer les données pour l'année 2023
    data_2023 <- raw_data %>%
      filter(date == 2023)%>%
      mutate(date = as.Date(date, format = "%Y-%m-%d"))
    
    return(data_2023)
  
  })
  
  
  
  # Lancer l'application Shiny uniquement si des données sont disponibles
  output$MaBox1 <- renderValueBox({
    req(data())
    valueBox(nrow(data_2023), "Avis récoltés en 2023",
             icon = icon("pen-to-square"))
  })
  
  data_positifs_2023 <- data_2023 %>%
    filter (review.label > 3)
  
  output$MaBox2 <- renderValueBox({
    req(data())
    valueBox(nrow(data_positifs_2023), "Nombres d'avis positifs en 2023",
              icon = icon("thumbs-up"))
    })
  
  data_neutres_2023<- data_2023  %>%
    filter(review.label == 3)
  
  output$MaBox3 <- renderValueBox({
    req(data())
    valueBox(nrow(data_neutres_2023), "Nombres d'avis neutres en 2023",
             icon = icon("face-meh-blank"))
  })
  
  
  # Afficher le bar plot sur le menu home 
  output$PlotReview <- renderPlot({
    req(data())
    ggplot(plot_data, aes(x = as.factor(date), y = review)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Nombre d'avis par année",
           x = "Année",
           y = "Nombre d'avis") +
      theme_minimal()
  })
  
  
  # Ajoutez ici le code pour ReviewPlot
  
  # Afficher la carte en fonction de l'area sélectionnée
  output$map <- renderLeaflet({
    req(data())
    leaflet(data_2023) %>%
      addTiles() %>%
      addMarkers(
        lat = ~latitude,
        lng = ~longitude,
        clusterOptions = markerClusterOptions()
      )
  })
  
  
  # Observer pour le changement de thème
  observe({
    shinythemes::themeSelector()
  })
  
  
  
  
  # Calculer le total des avis pour les années sélectionnées
  output$total_avis <- renderText({
    req(data())
    
    # Convertir les années en caractères
    selected_years_data <- data() %>%
      filter(as.character(date) %in% as.character(input$annees_selectionnees))
    
    total_avis <- nrow(selected_years_data)
    
    return(paste("Total des avis pour les années sélectionnées : ", total_avis))
  })
  
  
  # Calculer le taux de satisfaction pour chaque année
  output$taux_satisfaction <- renderText({
    req(data())
    
    # Convertir les années en caractères
    selected_years_data <- data() %>%
      filter(as.character(date) %in% as.character(input$annees_selectionnees))
    
    total_avis <- nrow(selected_years_data)
    avis_positifs <- nrow(filter(selected_years_data, review.label > 3))
    
    taux_satisfaction <- avis_positifs / total_avis * 100
    
    return(paste("Taux de satisfaction pour les années sélectionnées : ", round(taux_satisfaction, 2), "%"))
  })
  
  # Générer un graphique qui montre le nombre d'avis pour chaque mois
  output$graphique_mois <- renderPlot({
    req(data())
    
    # Convertir les années en caractères
    selected_years_data <- data() %>%
      filter(as.character(date) %in% as.character(input$annees_selectionnees))
    
    plot_data_mois <- selected_years_data %>%
      group_by(month, date) %>%
      summarise(nombre_avis = n())
    
    # Traduire les mois de chiffres à noms de mois
    plot_data_mois$month <- month.name[plot_data_mois$month]
    
    ggplot(plot_data_mois, aes(x = month, y = nombre_avis, fill = as.factor(year))) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Nombre d'avis par mois",
           x = "Mois",
           y = "Nombre d'avis",
           fill = "Année") +
      theme_minimal() +
      scale_fill_manual(values = c("#619CFF", "#F8766D", "#00BA38", "#FF61A6"))
  })
  
  
  
  
  # Définition de la fonction avis_filtres en dehors du bloc server
  avis_filtres <- function(data, input) {
    req(data, input)
    data_filtered <- data %>%
      filter(
        between(date, as.Date(input$filtre_date[1]), as.Date(input$filtre_date[2])),
        if (input$filtre_note != "Toutes") `review.label` == input$filtre_note else TRUE
        # Ajoutez d'autres filtres selon vos besoins
      )
    return(data_filtered)
  
  }
  
  
  
  # Filtrer les données en fonction des filtres sélectionnés
  avis_data <- reactive({
    req(data())
    avis_filtres(data(), input)
  })
  
  
  # Mise à jour de la table interactive en fonction des filtres
  output$avis_table <- renderDT({
    req(avis_data())
    datatable(avis_data()[, c("date", "review", "review.label")], options = list(pageLength = 10))
  })
  
  # Mise à jour du graphique des sentiments en fonction des filtres
  output$sentiments_plot <- renderPlot({
    req(avis_data())
    
    ggplot(avis_data(), aes(x = as.factor(review.label))) +
      geom_bar(fill = "steelblue") +
      labs(title = "Répartition des Sentiments",
           x = "Sentiment",
           y = "Nombre d'Avis") +
      theme_minimal()
  })
  
  
}


# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
