% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sibes_merge.R
\name{sibes_merge}
\alias{sibes_merge}
\title{sibes_merge
This function merges the tibbels samples and biota on samples data frame using left_join().}
\usage{
sibes_merge(Inputdata)
}
\arguments{
\item{Inputdata}{List containing the tibbles 'biota' and 'samples'.}
}
\value{
A merged tibble of samples and biota that also contains empty stations.
}
\description{
sibes_merge
This function merges the tibbels samples and biota on samples data frame using left_join().
}
\examples{
data_list <- get('SIBES_dataset')
sibes_merge(Inputdata = data_list)

}
