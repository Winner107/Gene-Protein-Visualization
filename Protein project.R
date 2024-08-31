# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)

# Sample gene expression data
sample_data <- data.frame(
  Gene = paste0("Gene", 1:100),
  ConditionA = rnorm(100, mean = 10, sd = 2),
  ConditionB = rnorm(100, mean = 12, sd = 2)
)

# Define UI for Shiny app
ui <- fluidPage(
  titlePanel("Gene Expression Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput("gene", "Select Gene:", choices = sample_data$Gene),
      actionButton("plot", "Plot Expression")
    ),
    mainPanel(
      plotOutput("expressionPlot")
    )
  )
)

# Define server logic for Shiny app
server <- function(input, output, session) {
  # Observe plot button click and generate plot
  observeEvent(input$plot, {
    selected_gene <- input$gene
    gene_data <- sample_data %>% filter(Gene == selected_gene)
    
    # Convert gene data to long format for ggplot
    gene_data_long <- gene_data %>%
      pivot_longer(cols = c("ConditionA", "ConditionB"), names_to = "Condition", values_to = "Expression")
    
    output$expressionPlot <- renderPlot({
      ggplot(gene_data_long, aes(x = Condition, y = Expression, fill = Condition)) +
        geom_bar(stat = "identity") +
        labs(title = paste("Expression of", selected_gene), x = "Condition", y = "Expression Level") +
        theme_minimal()
    })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
