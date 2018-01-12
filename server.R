library(shiny)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggmap)
source("draw_map_function.R")

shinyServer(function(input, output) {
    
    v <- reactiveValues(address = read.csv("input/address.csv", stringsAsFactors=FALSE, header=FALSE))
    
    observeEvent(input$request, {
        v$addressWithLatLng <- v$address %>%
            rowwise() %>%
            mutate(LatLng = getLatLng(V1)) %>%
            filter(LatLng!="error") %>%
            separate(LatLng, c("Lat", "Lng"), sep=",") %>%
            mutate(Lat=as.numeric(Lat), Lng=as.numeric(Lng))
    })  
    
    observeEvent(input$do, {
        if (is.null(v$addressWithLatLng)) return()
        
        set.seed(input$seed)
        kmeans = kmeans(x = v$addressWithLatLng[, c('Lat','Lng')], centers = input$k_value)
        v$addressWithKMeans <- v$addressWithLatLng %>%
            ungroup() %>%
            mutate(category=kmeans$cluster)
    })
    
    output$addressTable <- renderTable({
        if (is.null(v$addressWithLatLng)) return(v$address)
        v$addressWithLatLng
    })
    
    output$allAddressPlot <- renderPlot({
        if (is.null(v$addressWithLatLng)) return()
        ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
            geom_point(data=v$addressWithLatLng, aes(x=Lng, y=Lat), colour='red')
    })
    
    output$classifiedAddressPlot <- renderPlot({
        if (is.null(v$addressWithKMeans)) return()
        ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
            geom_point(data=v$addressWithKMeans,
                       size=1.8,
                       aes(x=Lng, y=Lat, colour=factor(category)))
    })
})

