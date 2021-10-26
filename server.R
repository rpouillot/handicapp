shinyServer <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    if(input$Auditif + input$Moteur + input$Visuel+ input$Mental == 0) return(NULL) 
    if(input$Auditif) dataH <- subset(dataH, as.logical(auditif))
    if(input$Moteur) dataH <- subset(dataH, as.logical(moteur))
    if(input$Visuel) dataH <- subset(dataH, as.logical(visuel))
    if(input$Mental) dataH <- subset(dataH, as.logical(mental))
    dataH <- subset(dataH, ACTIVITE %in% input$activite)
    return(dataH)
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet() %>% 
      addProviderTiles(providers$OpenStreetMap.Mapnik, #providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%
        fitBounds(-4.6, 42.5, 7.84, 51.01) #limite France metro
  })
  
  # A reactive expression that returns the set of adress that are
  # in bounds right now
  dataInBounds <- reactive({
    if(is.null(input$map_bounds) || is.null(filteredData())) return(dataH[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    return(subset(filteredData(),
           lat >= latRng[1] & lat <= latRng[2] &
             long >= lngRng[1] & long <= lngRng[2]))
  })
  
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
    observe({
      if(is.null(filteredData())) {
         leafletProxy("map", data = filteredData() ) %>% clearMarkers() %>% clearMarkerClusters()
           } else {
            leafletProxy("map", data = filteredData() ) %>%
          clearMarkers() %>%  clearMarkerClusters() %>% 
          addMarkers(layerId=filteredData()$index,
                     lng=filteredData()$long, lat=filteredData()$lat,
                     clusterOptions = markerClusterOptions()
                     )
           }
    })
  
    
    observe({
      leafletProxy("map") %>% clearPopups()
      event <- input$map_marker_click
      if (is.null(event)) return()
      
      isolate({
        showPopup(event$id, event$lat, event$lng)
      })
    })


    showPopup <- function(ident, lat, lng) {
      selectedMark <- subset(filteredData(), index == ident)
      content <- paste0(
        "<h5>", selectedMark$ETABLISSEMENT, "</h5>",
        "<h6>", selectedMark$ACTIVITE, "</h6>",
        selectedMark$formatted_address,"<br>",
        "Tel:",selectedMark$TELEPHONE,"<br>",
        "Contact: <a mailto:",selectedMark$EMAILCONTACT,">",selectedMark$EMAILCONTACT,"</a><br>",
        "Site Web: <a href=",selectedMark$SITEWEB,">",selectedMark$SITEWEB, "</a>"
      # )
      )
      leafletProxy("map") %>% addPopups(lng, lat,content, layerId = ident)
    }
    
    
  Nb <- reactive(nrow(dataInBounds()))
  
  output$TableSelection <- renderDT({
    validate(
      need(Nb() != 0, "Aucun établissement sélectionné"),
      need(Nb() <= 100,"Trop d'établissements sélectionnés (>100). Zoomez sur la carte" )
    )
    return(subset(dataInBounds(),
                  select= c("ETABLISSEMENT","ACTIVITE","CONTACT","Courriel","Site","TELEPHONE",        
                            "FAX","ADRESSE","CODEPOSTAL","VILLE","DEPARTEMENT","RESEAU"
                            ))
    )
    },escape=FALSE,  
    options = list(language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/French.json'))
)
    
  output$NbRecords <- renderText(
    return(paste("Nombre d'établissements séléctionés:", Nb()))
  )
    output$test <- renderPrint(
    return(input$activite)
  )

}
