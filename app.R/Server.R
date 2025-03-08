# Define server logic required to draw a coordinate flip bar chart
server <- function(input, output) {
  output$textout = renderText({
    paste0("This is an interactive scatterplot allowing the user to display NBA statistics 
                from every NBA season. The user can select which NBA season they would like to 
                look at, alongisde what statistical category should go on the x and y axis, respectively.")
  })
  output$distPlot = renderPlotly({
    rawfile = paste("nba_raw_", input$season, ".csv", sep = "")
    rf = read.csv(rawfile, header = TRUE)
    names(rf)[names(rf) == "PTS."] = "PTS" 
    names(rf)[names(rf) == input$X] = "x" 
    names(rf)[names(rf) == input$Y] = "y"
    q = paste(input$X, ":", rf$x, input$Y, ":", rf$y)
    
    if (input$Log == TRUE)
      print(ggplotly(ggplot(rf, aes(x = log(x), y = log(y), P = Player, text = q)) + 
                       geom_point(size = input$size, alpha = input$transparency, color = input$Color) + 
                       geom_smooth(method = input$Reg, se = FALSE, color = "black", formula = input$Y~input$X) + 
                       xlab(input$X)  + ylab(input$Y) + labs(title = 'Scatterplot') +
                       theme_get()))
    else {
      p = ggplotly(ggplot(rf, aes(x = x,  y = y, P = Player, text = q)) + 
                     geom_point(size = input$size, alpha = input$transparency, color = input$Color) + 
                     geom_smooth(method = input$Reg, show.legend = TRUE) + 
                     xlab(input$X)  + ylab(input$Y) + labs(title = 'Scatterplot') +
                     theme_get() )
      print(ggplotly(p, tooltip = "NULL"))
    }
    
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
