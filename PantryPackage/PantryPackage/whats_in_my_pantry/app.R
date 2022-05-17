#shiny app for the pantry function

library(shiny)

diets <- list("vegetarian", "vegan", "gluten free", "dairy free")

ui <- fluidPage(
            textInput("ingredient", "What do you have?",
                      placeholder = "e.g., tomato"), # ingredient input
            selectizeInput("diet", "dietary restrictions?",
                           choices = diets, allowEmptyOption = TRUE),#diet input
            textOutput("recipe")
        )

server <- function(input, output) {

  }

# Run the application
shinyApp(ui = ui, server = server)
