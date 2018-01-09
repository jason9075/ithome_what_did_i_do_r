library(shiny)
library(dplyr)

orders = read.csv("input/orders.csv", stringsAsFactors=FALSE, fileEncoding="big5")

shinyServer(function(input, output) {
    
    output$ordersTable <- renderTable({
        orders %>%
            filter(input$price < PRICE, input$payment == PAYMENTTYPE)
    })
    
})

