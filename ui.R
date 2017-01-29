library(shiny)

shinyUI(fluidPage(
        titlePanel("Prediction of the childern's hight"),
        sidebarLayout(
                sidebarPanel(
                        helpText("This application predicts child's hight in dependency to the gender and the height of their parents."),
                        helpText("Please select the child's gender"),
                        radioButtons(inputId = "inGen",
                                     label = "Child's gender: ",
                                     choices = c("Girls"="female", "Boys"="male"),
                                     inline = TRUE),
                        helpText("Please select the height of the parents:"),
                        sliderInput(inputId = "inFh",
                                    label = "Father's height in cm:",
                                    value = 150,
                                    min = 150,
                                    max = 200,
                                    step = 1),
                        sliderInput(inputId = "inMh",
                                    label = "Mother's height in cm:",
                                    value = 150,
                                    min = 150,
                                    max = 200,
                                    step = 1)
                ),
                
                mainPanel(
                       
                        plotOutput("barsPlot", width = "100%"),
                        htmlOutput("parentsText"),
                        htmlOutput("prediction"),
                        
                        
                        # Show the plot 
                        
                                tabsetPanel(
                                        tabPanel("Plot", showOutput("plot", "highcharts")),
                                        tabPanel("Summary", verbatimTextOutput("sum")),
                                        tabPanel("Structure", verbatimTextOutput("str")),
                                        tabPanel("Raw Data", dataTableOutput("table"))
                        
                        
                                )
                )
        )
))