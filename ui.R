library(shiny)

selection <- c("A", "B", "C")

shinyUI(fluidPage(

    fluidRow(
        column(4, 
               div(style = "background-color: GreenYellow;",
                   h4("黃綠區塊"),
                   sliderInput('sampleSize', 'Sample Size',
                               min=10, max=1000, value=500,
                               step=10, round=0),
                   br(),
                   checkboxInput('check1', '勾選按鈕1'),
                   checkboxInput('check2', '勾選按鈕2')
                )
        ),
        column(4, 
               div(style = "background-color: Coral;",
                   h4("橘色區塊"),
                   selectInput('select1', '選擇1', selection),
                   selectInput('select2', '選擇2', selection),
                   selectInput('select3', '選擇3', selection),
                   br(),
                   numericInput("num", 
                                h3("數字選擇"), 
                                value = 1)
               )
        ),
        column(4, 
               div(style = "background-color: LightBlue;",
                   h4("淡藍區塊"),
                   actionButton("button", "按鈕"),
                   br(),
                   dateInput("date", 
                             h3("Date input")),
                   br(),
                   textInput("text", h3("Text input"), 
                             value = "Enter text...") 
               )
        )
    )
    
))
