
library(shiny)
data(GaltonFamilies)
library(ggplot2)
library(dplyr)
library(HistData)

###data is to be converted in centimeters
data_gf <- GaltonFamilies
data_gf <- data_gf %>% mutate(father=father*2.54,
                    mother=mother*2.54,
                    childHeight=childHeight*2.54)

###linear model
regmodel <- lm(childHeight ~ father + mother + gender, data=data_gf)

shinyServer(function(input, output) {
        output$parentsText <- renderText({
                paste("When the father's height is",
                      strong(round(input$inFh, 1)),
                      "cm, and mother's is",
                      strong(round(input$inMh, 1)),
                      "cm, then:")
        })
        output$prediction <- renderText({
                df <- data.frame(
                        mother=input$inMh,
                        father=input$inFh,
                                 
                                 gender=factor(input$inGen, levels=levels(data_gf$gender)))
                ch <- predict(regmodel, newdata=df)
                sord <- ifelse(
                        input$inGen=="female",
                        "Daugther",
                        "Son"
                )
                paste0(em(strong(sord)),
                       "'s approx. predicted height ",
                       em(strong(round(ch))),
                       " cm"
                )
        })
        output$barsPlot <- renderPlot({
                sorting <- ifelse(
                        input$inGen=="male",
                        "Son",
                        "Daugther"
                )
                data1 <- data.frame(father=input$inFh,
                                 mother=input$inMh,
                                 gender=factor(input$inGen, levels=levels(data_gf$gender)))
                ch <- predict(regmodel, newdata=data1)
                yvals <- c("Father", sorting, "Mother")
                data1 <- data.frame(
                        x = factor(yvals, levels = yvals, ordered = TRUE),
                        y = c(input$inFh, ch, input$inMh),
                        colors = c("darkblue", "red", "green")
                )
                ggplot(data1, aes(x=x, y=y, color=colors, fill=colors)) +
                        geom_bar(stat="identity", width=0.5) +
                        xlab("") +
                        ylab("Height in cm") +
                        theme_minimal() +
                        theme(legend.position="none")
        })
})