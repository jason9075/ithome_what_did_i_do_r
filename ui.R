library(shiny)

shinyUI(fluidPage(

  headerPanel("用戶資料表"),
  tableOutput('userTable')
  
))
