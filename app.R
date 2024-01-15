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
                   tabsetPanel(
                     h3("Quelques chiffres"), # Titre colonne
                     br(),
                     br(),
                     valueBoxOutput("maBox1"), # Boites de valeur 
                     valueBoxOutput("maBox2"),
                     valueBoxOutput("maBox3"),
                     h3("Une vision générale"), # Titre colonne
                     br(),
                     br(),
                     plotOutput("ReviewPlot") # Plot du nombre de review par an
                   )
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
               leafletOutput("map") # Carte Leaflet
             )
    )
  )
)

# Définition du serveur Shiny
server <- function(input, output) {
  # Mises APERCU DES DONNÉES :  
  # Mettre à jour la valeur de la boîte pour le nombre d'avis en 2023
  output$maBox1 <- renderValueBox({
    valueBox(
      value = 26155, "Nombre d'avis en 2023",
      icon = icon("calendar"))
  })
  
  # Ajoutez ici le code pour maBox2 et maBox3
  
  # Afficher le bar plot sur le menu home 
  # Ajoutez ici le code pour ReviewPlot
  
  # Afficher la carte en fonction de l'area sélectionnée
  output$map <- renderLeaflet({
    leaflet(donnees_filtrees) %>%
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
