library(here)

df <- readRDS(here('ships_data.rds'))
rand <- sample(1:nrow(df), 1)
rand_vessel <- df[rand,9]
source(here('R', 'longest_between_observations.R'))

test_that("description", {
  test_df <- longest_between_observations(df, rand_vessel)

  ## Make sure that we're only returning a single record for the longest distance
  test_df_rows <- nrow(test_df$full)
  expect_equal(test_df_rows, 1)
  
  # Check that we get a 2x2 all numeric result set for leaflet
  test_long_df <- test_df$long
  expect_equal(nrow(test_long_df), 2)
  expect_equal(ncol(test_long_df), 3)

  expect_that(test_long_df[ ,1], is.numeric)
  expect_that(test_long_df[ ,2], is.numeric)
  
})
