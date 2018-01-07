library(shiny)

shinyServer(function(input, output) {
    
    user = read.csv("input/user.csv", stringsAsFactors=FALSE)
    output$userTable <- renderTable(user)
    
})

