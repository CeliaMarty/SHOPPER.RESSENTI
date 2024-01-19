source(file= "Global.R")
source(file= "Packages.R")

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
                   checkboxInput("fichierImport", "Check", value = FALSE),
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
                   downloadButton("exportPDF", "Exporter le rapport en PDF"),
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
               # Ajoutez un filtre par année
               # ksdggfsdkgfkgfqkdgfhqdfgqdfgqfgqdgfkjgqejkfgqjkdgfjqkdsgfjgqdf
               uiOutput("TestMenyssa"),
               br(),
               br(),
               # Ajoutez un filtre par note
               uiOutput("TestNotes"),
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
               uiOutput("TestTemp"),
               br(),
               textOutput("total_avis"),
               br(),
               textOutput("taux_satisfaction"),
               br(),
               plotOutput("graphique_repartition_mois"),
               br(),
             )
             
    ),
    # Onglet Localisation
    tabPanel("Localisation",
             fluidPage(
               h3 ("Carte interactive montrant l'emplacement des avis collectés en 2023."),
               uiOutput("TestMap"),
               leafletOutput("map")
             )
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
    read.csv(infile$datapath, header = TRUE, sep = ";" ,encoding ="UTF-8")
  })
  
  output$TestMenyssa <- renderUI({
    if(input$fichierImport){
      selectInput("filterYear", "Sélectionnez une année :",
                  choices = unique(raw_data()$date),
                  selected = 2020)
    }
  })
  
  output$TestNotes <- renderUI({
    if(input$fichierImport){
      sliderInput("filterRating", "Filtrer par note :", 
                  min = 1, max = 5, value = c(1, 5), step = 1)
    }
  })
  observeEvent(input$exportPDF, {
    # Fonction pour générer le rapport PDF
    generatePDFReport()  # Remplacez ceci par la fonction réelle pour générer le PDF
    # Déclenche le téléchargement côté client
    shinyjs::jsDownload(jscode = 'downloadPDF();', filetype = 'application/pdf')
  })
  
  
  
  
  
  
  data_2023 <- reactive({
    # Filtrer les données pour l'année 2023
    raw_data () %>%
      dplyr::filter(date == 2023) %>%
      mutate(date = as.Date(date, format = "%Y-%m-%d"))
  })
  
  # Lancer l'application Shiny uniquement si des données sont disponibles
  output$MaBox1 <- renderValueBox({
    valueBox(nrow(data_2023()), "Avis récoltés en 2023",
             icon = icon("pen-to-square"))
  })
  
  data_positifs_2023 <- reactive({
    data_2023() %>%
      dplyr::filter(review.label > 3)
  })
  
  
  output$MaBox2 <- renderValueBox({
    valueBox(nrow(data_positifs_2023()), "Nombres d'avis positifs en 2023",
             icon = icon("thumbs-up"))
  })
  
  
  
  data_neutres_2023 <- reactive({
    data_2023() %>%
      filter(review.label == 3) 
  }) 
  
  
  output$MaBox3 <- renderValueBox({
    valueBox(nrow(data_neutres_2023()), "Nombres d'avis neutres en 2023",
             icon = icon("face-meh-blank"))
  })
  
  
  
  # #    Afficher le bar plot sur le menu home 
  output$PlotReview <- renderPlot({
    ggplot(raw_data(), aes(x = as.factor(date), fill = as.factor(date)))+
      geom_bar() +
      labs(title = "Répartition du nombre d'avis par année",
           x = "Année",
           y = "Nombre d'avis") +
      scale_fill_discrete(name = "Année") +    
      theme_minimal()
  })
  # #  
  # Afficher la carte en fonction de l'area sélectionnée
  output$map <- renderLeaflet({
    filtered_data <- data_2023()
    if (!is.null(input$pays_sélectionné)) {
      filtered_data <- filtered_data %>%
        filter(store_location == input$pays_sélectionné)
    }
    # Calculer le centre de la carte en fonction des coordonnées des pays filtrés
    center_lat <- mean(filtered_data$latitude)
    center_lng <- mean(filtered_data$longitude)
    
    leaflet(filtered_data) %>%
      addTiles() %>%
      addMarkers(
        lat = ~latitude,
        lng = ~longitude,
        clusterOptions = markerClusterOptions(),
      )%>%
      setView(lng = center_lng, lat = center_lat, zoom = 4)
  })
  
  
  output$TestMap <- renderUI({
    if(input$fichierImport){
      selectInput("pays_sélectionné", "Sélectionnez un pays :",
                  choices = unique(raw_data()$store_location),

                  )
      
    }
  })
  #output$pays_sélectionné <- renderMap
  
  
  
  output$TestTemp <- renderUI({
    if(input$fichierImport){
      selectInput("annees_selectionnees", "Sélectionnez une année :",
                  choices = c(2020, 2021, 2022, 2023),
                  selected = 2020)
    }
  })
  
  # Exemple : Graphique de la répartition du nombre d'avis par mois
  output$graphique_repartition_mois <- renderPlot({
    data_selected_year <- raw_data() %>%
      filter(date %in% input$annees_selectionnees)
    
    ggplot(data_selected_year, aes(x = as.factor(month), fill = as.factor(month))) +
      geom_bar() +
      labs(title = "Répartition du nombre d'avis par mois",
           x = "Mois",
           y = "Nombre d'avis") +
      scale_x_discrete(breaks = 1:12, labels = month.abb) +
      scale_fill_discrete(name = "month") +
      theme_minimal()
  })
  
  
  # Exemple de code pour afficher le nombre d'avis en fonction de la sélection de l'utilisateur
  output$total_avis <- renderText({
    # Données filtrées par date
    donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
    #   Total des avis en fonction de la sélection de l'utilisateur
    total_avis <- nrow(donnees_filtrees)
    paste("Total des avis : ", total_avis)
  })
  #Exemple : Taux de satisfaction
  output$taux_satisfaction <- renderText({
    donnees_filtrees <- raw_data()[raw_data()$date %in% input$annees_selectionnees, ]
    total_avis <- nrow(donnees_filtrees)
    
    if (total_avis == 0) {
      "Taux de satisfaction : N/A"
    } else {
      taux_satisfaction <- mean(donnees_filtrees$review.label > 3) * 100
      paste("Taux de satisfaction : ",sprintf("%.2f", taux_satisfaction), "%")
    }
  })
  
  filtered_reviews <- reactive({
    reviews <- raw_data() %>%
      filter(date == input$filterYear,
             review.label >= input$filterRating[1],
             review.label <= input$filterRating[2])
    return(reviews)
  })

  
  
  # Mise à jour de la table interactive en fonction des filtres
  output$avis_table <- renderDT({
    datatable(filtered_reviews()[,c("date", "review", "review.label")], options = list(pageLength = 10))})
  
  
}


# Lancer l'application Shiny
shinyApp(ui = ui, server = server)




