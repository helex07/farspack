context("Check if functions perfom its intended task")
library(farspack)

setwd(system.file("extdata", package = "farspack"))

test_that("Name of file is correct", {
  expect_equal(make_filename(year = 2013), "accident_2013.csv.bz2")
})

test_that("Data file is loaded", {
  expect_is(fars_read(filename = "accident_2013.csv.bz2"), "data.frame")
})

test_that("Data file for specified time is created", {
  expect_is(fars_read_years(years = 2013:2015), "list")
  expect_warning(fars_read_years(years = 2011:2015))
})

test_that("The accidents are summarized", {
  expect_equal(fars_summarize_years(years = 2013:2015)[[1]], c(1:12))
})

test_that("Map is created for state with valid ID", {
  expect_error(fars_map_state(state.num = 57,year = 2013))
})
