#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
source("source.r")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  output$meanAndvar <- renderPlot({
    getmean = input$mean
    getvar  = input$var
    getnum  = input$bins
    samples = rnorm(getnum, getmean, getvar^0.5)
    plot(samples)
  })
  
  output$map <- renderLeaflet({
    lng = input$lng
    lat = input$lat
    NTUmap <- leaflet() %>% 
      addTiles() %>% 
      setView(lng, lat, zoom = 17) %>% 
      addMarkers(lng, lat, popup = input$name)
    NTUmap
  })
   
  output$showTable <- renderTable({
    showTableId = which(getData$tag == input$mapcheck)
    print( getData[showTableId,] )
  })

  output$showMap <- renderLeaflet({
    showTableId = which(getData$tag == input$mapcheck)
    
    lng = getData$Response_X[showTableId]
    lat = getData$Response_Y[showTableId]
    
    markers <- leaflet() %>% 
               addTiles() %>%
               setView(getData$Response_X[1], 
                       getData$Response_Y[1], zoom = 10) %>%
               addMarkers(lng, lat)
    
    markers
  })

})
