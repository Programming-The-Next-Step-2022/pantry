#' Gives an output of ingredients needed for recipe and a url to the recipe with
#' input of ingredients and dietary restriction
#'
#' @param ingredients A character vector of individual ingredients;
#'                    no limit on length
#'
#' @param diet A character of dietary restrictions. By default it is NULL.
#' If diet label is longer than one word, hyphenate it
#' (e.g., gluten free = Gluten-Free)
#'
#' @return Gives recipe information in a list form.
#'
#' @examples
#' FoodYouHave <- c("chickpeas", "tomato", "spinach")
#' recipe <- get_info(FoodYouHave, "Vegan")
#'
#' print(recipe)
#'
#' @export
get_info <- function(ingredients, diet = NULL) {
  library(httr)
  library(rlang)

  if (is.character(ingredients) == FALSE){
    stop("ingredients must be in character form; see ?get_info for help")
  } # error message if incorrect format

  notfullurl <- "https://api.edamam.com/api/recipes/v2?type=public&q="
  divider <- c("%2C%20")
  foodurl <- as.vector((rbind(ingredients, divider)))
  if (foodurl[length(foodurl)] == "%2C%20") {
    foodurl[-length(foodurl)]
  }
  foodurl <- paste0(foodurl, collapse = "")
  fullurl <- paste0(notfullurl, foodurl,
                    "&app_id=6ad16c8d&app_key=92aca1a09be3235fcd38ccf2984b120a")
  # everything between line 29 and 36 is for url setup

  responsefull <- VERB("GET", fullurl,
                       add_headers("Accept: application/json"))
  recipeinfo <- content(responsefull, "parsed") # retrieves the relevant recipes


  matchrecipe <- c()
  n <- 0
  masterlist <- list()

  if (is.null(diet) == FALSE) { # if diet field is filled out

    for (i in 1:length(recipeinfo[["hits"]])) { # cycles through all retrieved recipes

      if ((diet %in% recipeinfo[["hits"]][[i]][["recipe"]][["healthLabels"]]) == TRUE) {
        # contains all allergy info
        n <- n + 1
        matchrecipe[n] <- i # creates a vector of recipes that fit dietary requirement
      } else {
        next
      }
    }

    for (i in 1:length(matchrecipe)) {
      masterlist[[i]] <- list()
      masterlist[[i]][[1]] <- recipeinfo[["hits"]][[matchrecipe[i]]][["recipe"]][["label"]]
      # Retrieves the recipe label
      masterlist[[i]][[2]] <- recipeinfo[["hits"]][[matchrecipe[i]]][["recipe"]][["url"]]
      # retrieves the recipe url
      masterlist[[i]][[3]] <- recipeinfo[["hits"]][[matchrecipe[i]]][["recipe"]][["ingredientLines"]]
      # retrieves the ingredients
    }

  } else { # if diet field was left empty

    for (i in 1:length(recipeinfo[["hits"]])) {
      masterlist[[i]] <- list()
      masterlist[[i]][[1]] <- recipeinfo[["hits"]][[i]][["recipe"]][["label"]]
      # Retrieves the recipe label
      masterlist[[i]][[2]] <- recipeinfo[["hits"]][[i]][["recipe"]][["url"]]
      # retrieves the recipe url
      masterlist[[i]][[3]] <- recipeinfo[["hits"]][[i]][["recipe"]][["ingredientLines"]]
      # retrieves the ingredients
    }
  }
  return(masterlist)
}
