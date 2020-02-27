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
      # selectInput(inputId = "xDist", 
      #             label = "X Distribution;", 
      #             choices = c("Uniform", "Normal"),
      #             selected = "Uniform", 
      #             multiple = FALSE, 
      #             selectize, 
      #             width,
      #             size), 
      sliderInput(inputId = "slope",
                  label = "Slope:",
                  min = -10,
                  max = 10,
                  value = 1),
      sliderInput(inputId = "yIntercept",
                  label = "Intercept:",
                  min = -5,
                  max = 5,
                  value = 0),
      sliderInput(inputId = "error",
                  label = "Error:",
                  min = .001,
                  max = 5,
                  value = 0.5)
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Scatter", plotOutput("scatterPlot")),
                  tabPanel("X hist", plotOutput("xHist")),
                  tabPanel("Y hist", plotOutput("yHist")),
                  tabPanel("Correlation", verbatimTextOutput("corrTest")), 
                  tabPanel("Regression", verbatimTextOutput("regressionResults"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  dataX <- reactive({
    x <- runif(input$points)
  })
  
  dataY <- reactive({
    y <- rep(input$yIntercept, input$points) +
      rep(input$slope) * as.vector(dataX()) +
      rnorm(input$points, sd = input$error)
  })
  
  output$scatterPlot <- renderPlot({
    # draw the plot
    scatter.smooth(dataX(), dataY(), xlab = "x", ylab = "y")
  })
  
  output$xHist <- renderPlot({
    hist(dataX())
  })
  
  output$yHist <- renderPlot({
    hist(dataY())
  })
  
  output$corrTest <- renderPrint({
    cor.test(dataX(), dataY())
  })
  
  output$regressionResults <- renderPrint({
    summary(lm(formula = dataY() ~ dataX()))   
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

