library(httr)

url <-
  "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients"

# pulls recipe based on ingredients
pantrycontent <- list(
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
                 query = pantrycontent, content_type("application/octet-stream"))

pulledrecipe <- content(pantryrecipe, "parsed")
recipenumber <- length(pulledrecipe) # the number of recipes
id <- pulledrecipe[[recipenumber]][["id"]] # obtains recipe id

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
                       query = pantrycontent, content_type("application/octet-stream"))

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




