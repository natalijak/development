library(shiny)
library(HistData)
data(GaltonFamilies)
library(dplyr)
library(ggplot2)

# data is to be converted in centimeters
data_gf <- GaltonFamilies
data_gf <- data_gf %>%  mutate(childHeight=childHeight*2.54,
                                         father=father*2.54,
                                         mother=mother*2.54
)

# linear model
regmodel <- lm(childHeight ~ father + mother + gender, data=data_gf)

shinyServer(function(input, output) {
        output$Txt_Parents <- renderText({
                paste("When the father's height is",
                      strong(round(input$forFather, 1)),
                      "cm, and mother's is",
                      strong(round(input$forMother, 1)),
                      "cm, then:")
        })
        output$Prediction <- renderText({
                data_frame <- data.frame(father=input$forFather,
                                         mother=input$forMother,
                                         gender=factor(input$forGender, levels=levels(data_gf$gender)))
                lm <- predict(regmodel, newdata=data_frame)
                sorting <- ifelse(
                        input$forGender=="female",
                        "Daugther",
                        "Son"
                )
                paste0(em(strong(sorting)),
                       "'s s approx. predicted height",
                       em(strong(round(lm))),
                       " cm"
                )
        })
        output$barsPlot <- renderPlot({
                sorting <- ifelse(
                        input$forGender=="female",
                        "Daugther",
                        "Son"
                )
                data_frame <- data.frame(father=input$forFather,
                                         mother=input$forMother,
                                         gender=factor(input$forGender, levels=levels(data_gf$gender)))
                lm <- predict(regmodel, newdata=data_frame)
                yvals <- c("Father", sorting, "Mother")
                data_frame <- data.frame(
                        x = factor(yvals, levels = yvals, ordered = TRUE),
                        y = c(input$forFather, lm, input$forMother),
                        colors = c("red", "green", "darkblue")
                )
                ggplot(data_frame, aes(x=x, y=y, color=colors, fill=colors)) +
                        geom_bar(stat="identity", width=0.8) +
                        xlab("") +
                        ylab("Height (cm)") +
                        theme_minimal() +
                        theme(legend.position="none")
                
        })
      
        output$table <-renderDataTable({data_gf})
        output$str <-renderPrint({str(data_gf)})
        output$sum <-renderPrint({summary(data_gf)})
        
})