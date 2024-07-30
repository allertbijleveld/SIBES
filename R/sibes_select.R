#' sibes_select
#' allows convenient #filtering of a dataset by any number of logical filters.
#' For example, this function can be used to easily filter timestamps in a range, 
#' as well as combine simple spatial and temporal filters.
#' It accepts a character vector of \code{R} expressions that each return a
#' logical vector (i.e., \code{TRUE} or \code{FALSE}).
#' Each filtering condition is interpreted in the context of the dataset
#' supplied, and used to filter for rows that satisfy each of the filter conditions.
#' Users must make sure that the filtering variables exist in their dataset in
#' order to avoid errors.
#' @param data A tibble, dataframe or similar containing the variables to be filtered.
#' @param filters A character vector of filter expressions. An example might be
#' \code{"sampling_station_id < 1000"}. The filtering variables must be in the dataframe.
#' The function will not explicitly check whether the filtering variables are
#' present; This makes it flexible, allowing expressions such as
#' \code{"between(sampling_station_id, 2, 2000)"}, but also something to use at your own risk.
#' A missing filter variables \emph{will} result in an empty data frame.
#'
#' @return A dataframe filtered using the filters specified.
#' @import data.table
#' @export
#'
#' @examples
#'
#' data_list <- get('SIBES_dataset')
#'
#' data_m <- sibes_merge(Inputdata = data_list)
#'
#' data_selected_3 <- sibes_select(data = data_m, filters =c(
#' "between(sampling_station_id, 320,371)", #Location
#' "between(date,as.Date(\"2010-01-01\",format=\"%Y-%m-%d\"),
#'  as.Date(\"2020-08-11\",format=\"%Y-%m-%d\"))"))#Date
#'
sibes_select <- function(data, filters = c()) {

    # convert to data.table
    if (!is.data.table(data)) {
      data.table::setDT(data)
    }

    # apply filters as a single evaluated parsed expression
    # first wrap them in brackets
    filters <- vapply(
      X = filters,
      FUN = function(this_filter) {
        sprintf("(%s)", this_filter)
      },
      FUN.VALUE = "character"
    )
    filters <- stringr::str_c(filters, collapse = " & ")
    filters <- parse(text = filters)
    # evaluate the parsed filters
    data <- data[eval(filters), ]

    # check for class and whether there are rows
    assertthat::assert_that("data.frame" %in% class(data),
                            msg = "filter_covariates: cleaned data is not a dataframe object!"
    )

    # print warning if all rows are removed
    if (nrow(data) == 0) {
      warning("filter_covariates: cleaned data has no rows remaining!")
    }

	return(data)
  }
