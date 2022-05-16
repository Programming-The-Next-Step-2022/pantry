library(httr)

url <-
  "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients"

recipepull <- list(
  ingredients = "chickpeas, spinach, tomato", # required parameter
  ranking = "1", # 1 = maximize used ingredients
  # 2 = minimize missing ingredients first
  ignorePantry = "true", #ignore salt, sugar, flour etc.
  number = "1" # number of recipes to return
)

pantryrecipe <- VERB("GET", url,
                 add_headers(
                   'X-RapidAPI-Host' =
                     'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                   'X-RapidAPI-Key' =
                     'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                 query = recipepull, content_type("application/octet-stream"))

output <- content(pantryrecipe, "parsed")
id <- output[[1]][["id"]]

# with every additional recipe, the function just creates another list

# extracts recipe full info
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


# ASK FOR HELP W THE URL THING



if(recipeinfo[["vegan"]] == "FALSE") { # poor building block for the if function
  queryString <- list(
    ingredients = "chickpeas, spinach, tomato",
    ranking = "1",
    ignorePantry = "true",
    number = "2"
  )
}


