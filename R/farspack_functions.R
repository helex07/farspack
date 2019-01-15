#' Read .csv file
#'
#' The function loads US FARS data \url{https://www.nhtsa.gov/research-data/fatality-
#' analysis-reporting-system-fars}  and turns flat file into a data frame. If file doesn't
#' exist, a warning message will appear.
#'
#' @param filename The name of data file as a character string.
#'
#' @return The data file as a data frame.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' data_2013 <- fars_read(filename = "accident_2013.csv.bz2")
#' }
#'
#' @export
fars_read <- function(filename) {
  if (!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}

#' Give name to a data file
#'
#' The function creates a file name for the specific year and prints it.
#' The file name contains the year when the accidents occured.
#'
#' @param year The year of the accidents as an integer.
#'
#' @return The file name as a character string.
#'
#' @examples
#' \dontrun{
#' make_filename(year = 2013)
#'}
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' Create a data file for a specified date of accidents.
#'
#' The function creates a subset that contains accidents occured in the particular years
#' and sorted by months. A warning message is issued if the specified year is not in the
#' original dataset.
#'
#' @param years The years of the accidents as a list or vector of integers
#'
#' @return The accidents for given years sorted by month as list of data frames with
#' integers and numeric elements. Returns NULL if entered year doesn't exist in the data
#' set.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' fars_read_years(years = 2013:2015)
#' fars_read_years(years = c(2013, 2014, 2015))
#' fars_read_years(years = list(2013 2014, 2015))
#' }
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate_(dat, year = ~ year) %>%
        dplyr::select_(.dots = c("MONTH", "year"))
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' Calculate number of accidents per month for the particular years.
#'
#' The function is summarising  the accidents for the selected years and counts the number
#' of reports per month.
#'
#' @inheritParams fars_read_years
#'
#' @return The number of the accidents per month for each particular year as a data frame.
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom magrittr %>%
#' @importFrom dplyr summarize
#' @importFrom tidyr spread
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013:2015)
#' fars_summarize_years(c(2013, 2014, 2015))
#' fars_summarize_years(list(2013, 2014, 2015))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by_(~ year, ~ MONTH) %>%
    dplyr::summarize_(n = ~ n()) %>%
    tidyr::spread_(key_col = "year", value_col = "n")
}

#' Map the accidents
#'
#' The function builds a map of the reported accidents in the selected state for the
#' particuar year. A warning message is produced if entered state code is invalid, as well
#' as if there is no any reported accidents for the given period of time.
#'
#' @param state.num The state index as an integer
#'
#' @inheritParams make_filename
#'
#' @return The geographical map of the state with plotted traffic accidents. Each point
#' represents a single case from the FARS data file for one specific year.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @examples
#' \dontrun{
#' fars_map_state(state.num = 10, year = 2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if (!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter_(data, ~ STATE == state.num)
  if (nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
