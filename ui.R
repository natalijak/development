library(shiny)

shinyUI(fluidPage(
        titlePanel("Prediction of the childern's hight"),
        sidebarLayout(
                sidebarPanel(
                        helpText("The application predicts, using the GaltonFamilies-Data, the child's hight in dependency to the gender and the height of their parents. "),
                        helpText("Please select the child's gender"),
                        sliderInput(inputId = "forFather",
                                    label = "Father's height in centimeters:",
                                    value = 170,
                                    min = 150,
                                    max = 200,
                                    step = 0.1),
                        sliderInput(inputId = "forMother",
                                    label = "Mother's height in centimeters:",
                                    value = 140,
                                    min = 140,
                                    max = 170,
                                    step = 0.1),
                        
                        selectInput("forGender", "Select Child's gender", c("Girls"="female", "Boys"="male"))
                ),
                
                mainPanel(
                        plotOutput("barsPlot", width = "100%"),
                        htmlOutput("Txt_Parents"),
                        htmlOutput("Prediction"),
                        tabsetPanel(type="tab", tabPanel("RawData", dataTableOutput("table")),
                                    tabPanel("Structure", verbatimTextOutput("str")),
                                    tabPanel("Summary", verbatimTextOutput("sum"))
                        )
                       
                )
        )
))