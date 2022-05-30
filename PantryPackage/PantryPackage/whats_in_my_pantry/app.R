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
    textOutput("i"), # for testing
    textOutput("d"),
    textOutput("recipe"),
    actionButton("button", "Get recipe!")
    )

server <- function(input, output) {

  food <- reactive({
    strsplit(input$ingredient, ",\\s*")[[1]] })
    # creates input into a character vector

  restr <- reactive({
    strsplit(input$diet, ",\\s*")[[1]] })
    # creates input into a character vector

    output$i <- renderPrint(food())
    output$d <- renderPrint(restr())

    observeEvent(input$button, {
    output$recipe <-
      renderPrint({
        recipe <- get_info(food(), restr())
        return(recipe[[1]])
      }) # make a for loop with each button press updating the next recipe on the list
  })
}

# Run the application
shinyApp(ui = ui, server = server)
