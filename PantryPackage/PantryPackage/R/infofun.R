#' Gives full recipe information with input of ingredients and dietary restriction
#'
#' @param ingredients A character vector of individual ingredients;
#'                    no limit on length
#'
#' @param diet A character of dietary restrictions. Can be 'vegetarian', 'vegan',
#' 'glutenFree', or 'dairyFree'. By default it is empty.
#'
#' @return Gives recipe information in a list form.
#'
#' @examples
#' FoodYouHave <- c("chickpeas", "tomato", "spinach")
#' recipe <- get_info(FoodYouHave, "vegan")
#'
#' print(recipe)
#'
#' @export
get_info <- function(ingredients, diet = "") {
  library(httr)
  library(PantryPackage)

  if (is.character(ingredients) == FALSE){
    stop("ingredients must be in character form; see ?get_info for help")
  } # error message if incorrect format

  if (is.character(diet) == FALSE){
    stop("diet must be in character form; see ?get_info for help")
  } # error message if incorrect format

  nRecipes <- 1
  ids <- get_id(ingredients, nRecipes) # obtains ids
  notfullinfo <- "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
  fullinfo <- paste0(notfullinfo, ids, "/information")

  responsefull <- VERB("GET", fullinfo,
                       add_headers(
                         'X-RapidAPI-Host' =
                           'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                         'X-RapidAPI-Key' =
                           'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                       content_type("application/octet-stream")) # retrieves the full information

  recipeinfo <- content(responsefull, "parsed")

  if (diet == "") {
    # gives information if dietary field was left empty

    recipeingr <- list() # extracts the list of ingredients used
    for (i in 1:length(recipeinfo[["extendedIngredients"]])) {
      recipeingr[i] <- recipeinfo[["extendedIngredients"]][[i]][["original"]]
    }

    instructions <- list()
    for(i in 1:length(recipeinfo[["analyzedInstructions"]][[1]][["steps"]])){
      instructions[i] <- recipeinfo[["analyzedInstructions"]][[1]][["steps"]][[i]][["step"]]
    }
    realdeal <- list(recipeinfo[["title"]],recipeingr, instructions)
    print(realdeal) # prints the recipe title, ingredients and instructions

  } else if (recipeinfo[[diet]] == TRUE) {
    # information if a match is found

    recipeingr <- list()
    for (i in 1:length(recipeinfo[["extendedIngredients"]])) {
      recipeingr[i] <- recipeinfo[["extendedIngredients"]][[i]][["original"]]
    }

    instructions <- list()
    for(i in 1:length(recipeinfo[["analyzedInstructions"]][[1]][["steps"]])){
      instructions[i] <- recipeinfo[["analyzedInstructions"]][[1]][["steps"]][[i]][["step"]]
    }
    realdeal <- list(recipeinfo[["title"]],recipeingr, instructions)
    print(realdeal)

  } else {
    while (recipeinfo[[diet]] == FALSE) {
      nRecipes <- nRecipes + 1 # updates recipe number
      ids <- get_id(ingredients, nRecipes) # obtains ids
      fullinfo <- paste0(notfullinfo, ids[nRecipes], "/information")

      responsefull <- VERB("GET", fullinfo,
                           add_headers(
                             'X-RapidAPI-Host' =
                               'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                             'X-RapidAPI-Key' =
                               'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                           content_type("application/octet-stream")) # retrieves the full information

      recipeinfo <- content(responsefull, "parsed")

      recipeingr <- list()
      for (i in 1:length(recipeinfo[["extendedIngredients"]])) {
        recipeingr[i] <- recipeinfo[["extendedIngredients"]][[i]][["original"]]
      }

      instructions <- list()
      for(i in 1:length(recipeinfo[["analyzedInstructions"]][[1]][["steps"]])){
        instructions[i] <- recipeinfo[["analyzedInstructions"]][[1]][["steps"]][[i]][["step"]]
      }
      realdeal <- list(recipeinfo[["title"]],recipeingr, instructions)
      print(realdeal)
    }
  }
}






