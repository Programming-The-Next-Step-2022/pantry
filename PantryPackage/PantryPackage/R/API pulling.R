# extracts recipe full info
notfullinfo <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"

fullinfo <- paste0(notfullinfo, as.character(id), "/information")

responsefull <- VERB("GET", fullinfo,
                     add_headers(
                       'X-RapidAPI-Host' =
                         'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                       'X-RapidAPI-Key' =
                         'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                     content_type("application/octet-stream"))

recipeinfo <- content(responsefull, "parsed")


while(recipeinfo[[diet]] == FALSE) { # for now it can update the recipe pulled
  numrecipe <- 1

  pantrycontent <- list(
    ingredients = ingredient, # as named in the shiny app
    ranking = "1",
    ignorePantry = "true",
    number = as.character(numrecipe)
  )

  pantryrecipe <- VERB("GET", url,
                       add_headers(
                         'X-RapidAPI-Host' =
                           'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                         'X-RapidAPI-Key' =
                           'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                       query = pantrycontent,
                       content_type("application/octet-stream"))

  pulledrecipe <- content(pantryrecipe, "parsed")
  id <- pulledrecipe[[numrecipe]][["id"]]

  fullinfo <-
    "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/281307/information"

  responsefull <- VERB("GET", fullinfo,
                       add_headers(
                         'X-RapidAPI-Host' =
                           'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                         'X-RapidAPI-Key' =
                           'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                       content_type("application/octet-stream"))

  recipeinfo <- content(responsefull, "parsed")
  numrecipe <- numrecipe + 1
}

if(recipeinfo[[diet]] == "TRUE") { # if dietary restrictions match
 print(recipeinfo[["title"]]),
  print(recipeinfo[["extendedIngredients"]]),
  print(recipeinfo[["instructions"]])
}


get_info <- function # takes the ids and returns the recipe information
# document the functions!!!!!!!



# A function that takes ingredients and (optional) number of recipes
# create a character vector of the ingredients you wish to use and use in the
# ingredients slot

stuff <- c("tomato", "cucumber")

get_id <- function(ingredients, nRecipes = 1) {
  library(httr)
  library(tidyverse)

  url <-
    "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients"

  pantrycontent <- list(
    ingredients = str_c(ingredients, collapse = ", "),
    ranking = "1",
    ignorePantry = "true",
    number = as.character(nRecipes)
  )

  pantryrecipe <- VERB("GET", url,
                       add_headers(
                         'X-RapidAPI-Host' =
                           'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                         'X-RapidAPI-Key' =
                           'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                       query = pantrycontent,
                       content_type("application/octet-stream"))

  pulledrecipe <- content(pantryrecipe, "parsed")
  recipenumber <- length(pulledrecipe) # the number of recipes

  id <- c()
  for(i in 1:recipenumber) { # adds each id with more recipes requested
    id[i] <- pulledrecipe[[i]][["id"]]
  }

  print(id)
}



