#shiny app for the pantry function

library(shiny)
library(PantryPackage)
library(htmltools)

diets <- c("None", "Pescatarian" ,"Vegetarian", "Vegan", "Gluten Free",
              "Dairy Free", "Soy Free", "Pork Free")

ui <- fluidPage(
    title = "What's in the pantry?",

    titlePanel("What's in my pantry?"),
    textInput("ingredient",
              "What do you have? Separate ingredients with a comma",
              placeholder = "e.g., tomato"), # ingredient input
    selectInput("diet", "dietary restrictions?",
                choices = diets), # diet input
    sidebarLayout(
      sidebarPanel(
        tableOutput("title"), #gives title
        tableOutput("ingtable"), #gives the ingredients
        actionButton("button", "Get recipe!"),
        actionButton("reset", "New search?")
        ),

      mainPanel(
        h3("If you want another recipe, click on the 'Get Recipe!' button."),
        h3("If you want to change the ingredients and/or the diet,
           press the 'New search?' button"),
        uiOutput("link")
      )
    )
  )

server <- function(input, output, session) {

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

      output$title <- renderTable({ #renders the title of the recipe
        validate( # error message if recipes have been run through
          need(n() <=  length(recipe()), "Ran out of food :-(")
        )
        df <- data.frame(recipe()[[n()]][[1]])
        colnames(df) <- c("Title")
        return(df)
      })

      output$link <- renderUI({ # gives the url to the recipe
        validate(
          need(n() <=  length(recipe()), "Ran out of food :-(")
        )
        url <- a("Link to the recipe",
                 href = recipe()[[n()]][[2]],
                 target = "_blank")

        tagList(url)
      })

      output$ingtable <- renderTable({ #renders ingredients of the recipe
        validate(
          need(n() <=  length(recipe()), "Ran out of food :-(")
        )
        df2 <- matrix(recipe()[[n()]][[3]], ncol = 1)
        colnames(df2) <- c("Ingredients")
        return(df2)
      })
    })

    observeEvent(input$reset, { # reloads the entire app
       session$reload()
    })
}

shinyApp(ui = ui, server = server)
