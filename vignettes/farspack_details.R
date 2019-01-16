## ----get_my_pack---------------------------------------------------------
library(farspack)

## ---- name, echo = TRUE, eval = TRUE-------------------------------------
filename <- make_filename(2013)

## ---- year_read, echo = TRUE, eval = TRUE, warning = FALSE---------------
setwd(system.file("extdata", package = "farspack"))
subset_2013 <- fars_read(filename)

## ---- years_read, echo = TRUE, eval = TRUE, warning = FALSE--------------
setwd(system.file("extdata", package = "farspack"))
all_years <- fars_read_years(years = list(2013,2014,2015))

## ---- accidents_summary, echo = TRUE, eval = TRUE, warning = FALSE-------
setwd(system.file("extdata", package = "farspack"))
all_res <- fars_summarize_years( years = 2013:2015)

## ---- accidents_map, echo = TRUE, eval = TRUE, warning = FALSE-----------
setwd(system.file("extdata", package = "farspack"))
map <- fars_map_state(10,2013)

