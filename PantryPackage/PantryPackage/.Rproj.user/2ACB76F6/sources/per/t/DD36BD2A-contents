install.packages("httr")
library(httr)

url <-
  "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients"

queryString <- list(
  ingredients = "cucumber, spinach, tomato", # required parameter
  ranking = "1", # 1 = maximize used ingredients
  # 2 = minimize missing ingredients first
  ignorePantry = "true", #ignore salt, sugar, flour etc.
  number = "1" # number of recipes to return
)

response <- VERB("GET", url,
                 add_headers(
                   'X-RapidAPI-Host' =
                     'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                   'X-RapidAPI-Key' =
                     'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                 query = queryString, content_type("application/octet-stream"))

content(response, "parsed")


summaryrecipe <-
  "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/281307/summary"

responsesum <- VERB("GET", summaryrecipe,
                 add_headers(
                   'X-RapidAPI-Host' =
                      'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                   'X-RapidAPI-Key' =
                     'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                 content_type("application/octet-stream"))

content(responsesum, "text")


fullinfo <-
  "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/281307/information"

responsefull <- VERB("GET", fullinfo,
                     add_headers(
                       'X-RapidAPI-Host' =
                         'spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
                       'X-RapidAPI-Key' =
                         'b729bf5802mshd4d7b8537e441f3p1850d9jsnc8b828bd5f3a'),
                     content_type("application/octet-stream"))

content(responsefull, "text")






