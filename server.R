library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
#set.seed(100)
zipdata <- allzips[sample.int(nrow(allzips), 10000),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
zipdata <- zipdata[order(zipdata$centile),]



function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 0, lat = 51.5, zoom = 11)
  })
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(zipdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
  })
  polutionInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(polutiondata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(zipdata,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  })
  
  #  # Precalculate the breaks we'll need for the two histograms
  #  centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks
  #
  #  output$histCentile <- renderPlot({
  #    # If no zipcodes are in view, don't plot
  #    if (nrow(zipsInBounds()) == 0)
  #      return(NULL)
  #
  #    hist(zipsInBounds()$centile,
  #      breaks = centileBreaks,
  #      main = "SuperZIP score (visible zips)",
  #      xlab = "Percentile",
  #      xlim = range(allzips$centile),
  #      col = '#00DD00',
  #      border = 'white')
  #  })
  
  #  output$scatterCollegeIncome <- renderPlot({
  #    # If no zipcodes are in view, don't plot
  #    if (nrow(zipsInBounds()) == 0)
  #      return(NULL)
  #
  #    print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
  #  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    show_NO2  <- input$chk_NO2
    show_SO2  <- input$chk_SO2
    show_O3   <- input$chk_O3
    show_PM10 <- input$chk_PM10
    show_PM25 <- input$chk_PM25
    
    
    #colorData <- zipdata[[colorBy]]
    #pal <- colorBin("Spectral", colorData, 7, pretty = FALSE)
    
    
    
    # Radius is treated specially in the "superzip" case.
    #radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
    
    
    #leafletProxy("map", data = zipdata) %>%
    # clearShapes() %>%
    #addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
    #  stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    #  addCircles(~longitude, ~latitude, radius=400, layerId=~zipcode,
    #             stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    #  addLegend("bottomleft", pal=pal, values=colorData, title=colorBy, layerId="colorLegend")
    
   # if (show_NO2 == TRUE) {
   #   leafletProxy("map", data = no2) %>%
   #     #clearShapes() %>%
   #     addCircles(~longitude, ~latitude, radius=~no2*15, layerId=~no2,
   #                stroke=FALSE, fillOpacity=0.4, fillColor='green') #%>%
   #   #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
   #   #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
   # }else{
   #   leafletProxy("map", data = no2) %>%
   #     #clearShapes() %>%
   #     addCircles(~longitude, ~latitude, radius=0, layerId=~no2,
   #                stroke=FALSE, fillOpacity=0.0, fillColor='blue') #%>%
   #   #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
   #   #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
   # }
    
    
    if (show_SO2 == TRUE) {
      leafletProxy("map", data = so2) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=~so2*15, layerId=~so2,
                   stroke=FALSE, fillOpacity=0.4, fillColor='red') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }else{
      leafletProxy("map", data = so2) %>%
        clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=0, layerId=~so2,
                   stroke=FALSE, fillOpacity=0., fillColor='red') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }
    
    if (show_O3 == TRUE) {
      leafletProxy("map", data = o3) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=~o3*15, layerId=~o3,
                   stroke=FALSE, fillOpacity=0.4, fillColor='blue') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }else{
      leafletProxy("map", data = o3) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=0, layerId=~o3,
                   stroke=FALSE, fillOpacity=0.0, fillColor='green') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }
    
    
    if (show_PM10 == TRUE) {
      leafletProxy("map", data = pm10) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=~pm10*15, layerId=~pm10,
                   stroke=FALSE, fillOpacity=0.4, fillColor='orange') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }else{
      leafletProxy("map", data = pm10) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=0, layerId=~pm10,
                   stroke=FALSE, fillOpacity=0.0, fillColor='green') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }
    
    
    if (show_PM25 == TRUE) {
      leafletProxy("map", data = pm25) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=~pm25*15, layerId=~pm25,
                   stroke=FALSE, fillOpacity=0.4, fillColor='magenta') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }else{
      leafletProxy("map", data = pm25) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=0, layerId=~pm25,
                   stroke=FALSE, fillOpacity=0.0, fillColor='green') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }
    
    if (show_NO2 == TRUE) {
      leafletProxy("map", data = no2) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=~no2*15, layerId=~no2,
                   stroke=FALSE, fillOpacity=0.4, fillColor='green') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }else{
      leafletProxy("map", data = no2) %>%
        #clearShapes() %>%
        addCircles(~longitude, ~latitude, radius=0, layerId=~no2,
                   stroke=FALSE, fillOpacity=0.0, fillColor='blue') #%>%
      #addCircles(~longitude, ~latitude, radius=40000, layerId=~zipcode,
      #           stroke=FALSE, fillOpacity=0.4, fillColor='blue') %>%
    }
 
  })
  
  # # Show a popup at the given location
  # showZipcodePopup <- function(zipcode, lat, lng) {
  #   selectedZip <- allzips[allzips$zipcode == zipcode,]
  #   content <- as.character(tagList(
  #     tags$h4("Score:", as.integer(selectedZip$centile)),
  #     tags$strong(HTML(sprintf("%s, %s %s",
  #       selectedZip$city.x, selectedZip$state.x, selectedZip$zipcode
  #     ))), tags$br(),
  #     sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
  #     sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
  #     sprintf("Adult population: %s", selectedZip$adultpop)
  #   ))
  #   leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  # }
  
  
  
}
