## ----get_my_pack---------------------------------------------------------
library(farspack)

## ---- setup, include=FALSE, echo=FALSE-----------------------------------
require("knitr")
opts_knit$set(root.dir = "~/Desktop/R program spec/R prog Course 3/farspack/inst/extdata")

## ---- name, echo = TRUE, eval = TRUE-------------------------------------
filename <- make_filename(2013)

## ---- year_read, echo = TRUE, eval = TRUE--------------------------------
subset_2013 <- fars_read(filename)

## ---- years_read, echo = TRUE, eval = TRUE-------------------------------
all_years <- fars_read_years(years = list(2013,2014,2015))

## ---- accidents_summary, echo = TRUE, eval = TRUE------------------------
all_res <- fars_summarize_years( years = 2013:2015)

## ---- accidents_map, echo = TRUE, eval = TRUE, warning = FALSE-----------
map <- fars_map_state(10,2013)

