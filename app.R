#Inclusions des scripts R :

source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Global.R")
source(file= "/Users/celiamarty/Desktop/SHOPPER.RESSENTI/Packages.R")

#Interface utilisateur    
ui <- navbarPage(
  title = "SHOPPER.RESSENTI", # Titre de la page
  tabsetPanel(
    # Onglet Accueil
    tabPanel("Accueil",
             fluidPage(
               themeSelector(),
               # Colonne 1
               column (4,
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       br(),
                       fileInput("fileInput","Selectionner un fichier", multiple = FALSE, accept = NULL)
               ),
               # Colonne2
               column (4,
                       h3("Quelques chiffres"), #Titre colonne
                       br(),
                       br(),
                       valueBoxOutput("maBox1"), #Boites de valeur 
                       valueBoxOutput("maBox2"),
                       valueBoxOutput("maBox3")
               ),
               # Colonne 3
               column (4,
                       h3("Une vision générale"), # Titre colonne
                       br(),
                       br(),
                       plotOutput("ReviewPlot") # Plot du nombre de review par an
               )
             )
    ),
    # Onglet Review
    tabPanel("Avis",
             fluidPage(
               # Colonne 1
               column(12)
             )
    ),
    # Onglet Temporalité
    tabPanel("Temporalité",
             # Colonne 1
             fluidPage(
               column(6,
                       )),
               
               # Colonne 2
               column(6,
               )
             
    ),
    # Onglet Localisation
    tabPanel("Localisation",
             fluidPage(
               leafletOutput("map") # Carte Leaflet
             ),
    )
  )
)
#Définition du server Shiny
server <- function(input, output) {
  
  
  #Mises APERCU DES DONNÉES :  
  # Mettre à jour la valeur de la boîte pour le nombre de délits en 2023
  output$maBox1 <- renderValueBox({
    valueBox(
      value = 26155, "Nombre d'avis en 2023",
             icon = icon("calendar"))
  })
  
  
  #output$maBox2 <- renderValueBox({
  
  #output$maBox3 <- renderValueBox({
  
  # Afficher le bar plot sur le menu home 
  #output$ReviewPlot <- renderPlot({
  
  #Afficher la carte en fonction de l'area sélectionnée
  output$map <- renderLeaflet({
    leaflet(donnees_filtrees) %>%
      addTiles() %>%
      addMarkers(
        lat = ~latitude,
        lng = ~longitude,
        clusterOptions = markerClusterOptions()
      )
  })
  #output$map <- renderLeaflet({
    #leaflet(donnees_filtrees) %>%
      #addTiles() %>%
      #addHeatmap(
        #lat = ~latitude,
        #lng = ~longitude
      #)
  #})
  # Observer pour le changement de thème
  observe({
    shinythemes::themeSelector()
  })
}
#Lancer l'application Shiny
shinyApp(ui = ui, server = server)
