library('PantryPackage')

context('Core Pantry functionality')

test_that("get_id returns a vector of different ids", {
  
  nRecipes <- 5
  ingredients <- c("tomato", "cucumber")
  ids <- get_id(ingredients, nRecipes)
  
  expect_true(length(unique(ids)) == nRecipes)
})