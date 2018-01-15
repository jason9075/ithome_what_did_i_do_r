library(shiny)

shinyUI(navbarPage("Shiny 大雜燴",
                tabPanel("地址分析",fluidRow(
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
                            tabPanel("K-means結果分佈圖", plotOutput("classifiedAddressPlot", height = "800px"))
                        )
                    )
                )),
                navbarMenu("電子商務分析",
                   tabPanel("訂單分析",fluidRow(
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
                   )),
                   tabPanel("會員分析",fluidRow(
                       column(3, 
                              h4("user資料"),
                              textInput("phone_number", h3("手機號碼"), value = "")
                       ),
                       column(9, 
                              tableOutput('userTable')
                       )
                   )
                ))
))
