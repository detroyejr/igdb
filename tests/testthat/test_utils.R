context("Test Helper Functions")

test_that("rbind2 completes successfully", code = {
  expect_named(
    object = rbind2(iris, mtcars, cars, NULL, data.frame()),
    expected = c(names(iris), names(mtcars), names(cars)),
    ignore.order = TRUE,
    ignore.case = TRUE
    )
})
