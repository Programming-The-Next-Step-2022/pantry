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
    tableOutput("titleurl"),
    tableOutput("ingtable"),
    actionButton("button", "Get recipe!")
    )

server <- function(input, output) {

  food <- reactive({
    strsplit(input$ingredient, ",\\s*")[[1]] })
    # creates input into a character vector

  restr <- reactive({
    strsplit(input$diet, ",\\s*")[[1]] })
    # creates input into a character vector

    n <- reactiveVal(0)
    recipe <- reactive({
      get_info(food(), restr())
    })

    observeEvent(input$button, { #pulls up the recipe

      n(n() + 1) #for the button to update

      output$titleurl <- renderTable({ #renders the title and url of the recipe
        validate( # error message if recipes have been run through
          need(length(recipe) != n(), "Ran out of food :-(")
        )
        recipe <- get_info(food(), restr())
        df <- data.frame(recipe[[n()]][[1]], recipe[[n()]][[2]])
        colnames(df) <- c("Title", "url")
        return(df)
      })

      output$ingtable <- renderTable({ #renders ingredients of the recipe
        validate(
          need(length(recipe) != n(), "Ran out of food :-(")
        )
        recipe <- get_info(food(), restr())
        df2 <- matrix(recipe[[n()]][[3]], ncol = 1)
        colnames(df2) <- c("Ingredients")
        return(df2)
      })
    })

}

# Run the application
shinyApp(ui = ui, server = server)
