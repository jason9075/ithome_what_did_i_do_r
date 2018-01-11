library(shiny)

shinyUI(fluidPage(

    fluidRow(
        column(3, 
               h4("API抓取經緯度"),
               actionButton("request", "取資料")
        ),
        column(9, 
               tableOutput('addressTable')
        )
    )
    
))
