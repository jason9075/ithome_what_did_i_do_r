library(shiny)
library(tidyr)
library(dplyr)
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
    
    output$addressTable <- renderTable({
        if (is.null(v$addressWithLatLng)) return(v$address)
        v$addressWithLatLng
    })
})

