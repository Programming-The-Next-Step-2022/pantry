#' Obtains recipe ID number with the input of ingredients
#' 
#' @param ingredients A character vector of individual ingredients;
#'                    no limit on length
#' 
#' @param nRecipes The number of recipes to retrieve. A whole number. 
#'                 Default = 1
#' 
#' @return Gives an ID number/s of recipes that use the listed ingredients
#' 
#' @examples 
#' FoodYouHave <- c("chickpeas", "tomato", "spinach")
#' ids <- get_id(FoodYouHave, 3)
#' 
#' print(ids)
#'                 
#' @export
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
