#shiny app for the pantry function

library(shiny)
library(PantryPackage)

diets <- c("None", "Pescatarian" ,"Vegetarian", "Vegan", "Gluten Free",
              "Dairy Free", "Soy Free", "Pork Free")

ui <- fluidPage(
    title = "What's in the pantry?",
    textInput("ingredient", "What do you have?",
              placeholder = "e.g., tomato"), # ingredient input
    selectInput("diet", "dietary restrictions?",
                choices = diets), # diet input
    textOutput("recipe")
    )

server <- function(input, output) {

  recipeinfo <- reactive({
    food <- renderText(strsplit(input$ingredient, ",\\s*")[[1]])
    restr <- if (input$diet == "None") {
      restr <- NULL
    } else {
      renderText(as.character(input$diet))
    }
    return(get_info(ingredients == food, diet == restr))
  })

  output$recipe <- renderUI({recipeinfo})
  }

# Run the application
shinyApp(ui = ui, server = server)
