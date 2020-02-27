#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Correlation Demo"),
   
   # Sidebar with a slider input for number of points 
   sidebarLayout(
      sidebarPanel(
         sliderInput(inputId = "points",
                     label = "Number of points:",
                     min = 10,
                     max = 200,
                     value = 50),
         sliderInput(inputId = "slope",
                     label = "Slope:",
                     min = -10,
                     max = 10,
                     value = 1),
         sliderInput(inputId = "error",
                     label = "Error:",
                     min = .001,
                     max = 5,
                     value = 0.5)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotOutput(outputId = "scatterPlot")
      )
   )
)

# Define server logic

server <- function(input, output) {
  
 output$scatterPlot <- renderPlot({
    # Calculate x, y, with slope and error
    x = runif(input$points)
    y = rep(input$slope, input$points) * as.vector(x) + rnorm(input$points, sd = input$error)

    # draw the plot and write correlation value as x axis label (xlab)
    scatter.smooth(x = x, y = y, 
                   xlab = paste("Corr= ", as.character(cor(x,y)), sep=""), 
                   ylab = "y")
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

