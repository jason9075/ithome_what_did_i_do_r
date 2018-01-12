library(shiny)

shinyUI(fluidPage(

    fluidRow(
        column(3, 
               h4("API抓取經緯度"),
               actionButton("request", "取資料"),
               hr(),
               numericInput("seed", h3("種子碼"), value = 20180112),
               numericInput("k_value", h3("k值"), value = 10),
               actionButton("do", "執行")
        ),
        column(9, 
               tabsetPanel(
                   tabPanel("地址表單", tableOutput('addressTable')), 
                   tabPanel("地址分佈圖", plotOutput("allAddressPlot", height = "800px")),
                   tabPanel("K-means結果分佈圖", plotOutput("classifiedAddressPlot", height = "800px")))
        )
    )
    
))
