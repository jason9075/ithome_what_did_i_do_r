library(shiny)

shinyUI(fluidPage(

    fluidRow(
        column(3, 
               h4("過濾"),
               sliderInput('price', '價格多少以上',
                           min=0, max=12000, value=300,
                           step=100, round=0),
               selectInput('payment', '付款方式', c("信用卡", 
                                                "ATM轉帳", 
                                                "貨到付款", 
                                                "現金", 
                                                "無",
                                                "其他"))
        ),
        column(9, 
               tableOutput('ordersTable')
        )
    )
    
))
