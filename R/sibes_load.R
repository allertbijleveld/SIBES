#' sibes_load
#'
#'@description This function allow an easy load of the three csv-files with SIBES data
#'
#' @param directory_path The path to the folder containing the csv files
#' @param biomass_csv_name String with the name of the csv file 'biota'
#' @param species_csv_name String with the name of the csv file species
#' @param samples_csv_name character vector name of csv file 'samples'
#'
#' @return A list containing three tibbles with the data
#' @export
#'
sibes_load <- function(directory_path,
                       biomass_csv_name ='biota.csv',
                       species_csv_name = 'species.csv',
                       samples_csv_name ='samples.csv'
                        ){
  data_list <- NULL
  if(!is.null(biomass_csv_name))
  {
    tbiota <- data.table::fread( paste(directory_path,biomass_csv_name,sep='/') ,stringsAsFactors=FALSE)
    data_list <- append(data_list,list(tbiota))
    names(data_list)[length(data_list)] = "biota"
  }
  if(!is.null(species_csv_name))
  {
    tspecies <- data.table::fread( paste(directory_path,species_csv_name,sep='/') ,stringsAsFactors=FALSE)
    data_list <- append(data_list,list(tspecies))
    names(data_list)[length(data_list)] = "species"
  }
  if(!is.null(samples_csv_name))
  {
    tsamples <- data.table::fread( paste(directory_path,samples_csv_name,sep='/') ,stringsAsFactors=FALSE)
    tsamples$date <- as.Date(tsamples$date, format="%Y-%m-%d")
	data_list <- append(data_list,list(tsamples))
    names(data_list)[length(data_list)] = "samples"
  }
  return(data_list)
}
