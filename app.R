# Inclusions des scripts R :

source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Global.R")
source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Packages.R")

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
                     valueBoxOutput("MaBox3"),# Boite de valeur sur le nombre d'avis neitres récoltés en 2023
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
    ),
    # Onglet Temporalité
    tabPanel("Temporalité",
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
    
    raw_data <- read.csv(infile$datapath, header = TRUE, sep = ";")
    
    # Filtrer les données pour l'année 2023
    data_2023 <- raw_data %>%
      filter(date == 2023)
    
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
}
# Lancer l'application Shiny
shinyApp(ui = ui, server = server)
