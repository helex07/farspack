% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/farspack_functions.R
\name{fars_map_state}
\alias{fars_map_state}
\title{Map the accidents}
\usage{
fars_map_state(state.num, year)
}
\arguments{
\item{state.num}{The state index as an integer}

\item{year}{The year of the accidents as an integer.}
}
\value{
The geographical map of the state with plotted traffic accidents. Each point
represents a single case from the FARS data file for one specific year.
}
\description{
The function builds a map of the reported accidents in the selected state for the
particuar year. A warning message is produced if entered state code is invalid, as well
as if there is no any reported accidents for the given period of time.
}
\examples{
\dontrun{
fars_map_state(state.num = 10, year = 2013)
}

}
