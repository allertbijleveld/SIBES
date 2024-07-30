#' sibes_species_search
#' This function use keywords to search the species tibble. This is convenient if only parts of a name are known, or for example, when multiple species need to be selected with a shared keyword
#' @param Inputdata Input data for the function is the output format of sibes_load which is data list of tibbels including "species". If these names are not present, the function returns an error
#' @param Key The keyword to search for as a string. Numeric values also entered as character
#'
#' @return Function returns the found search.
#' @export
#'
#' @examples
#'
#' data_list <- get('SIBES_dataset')
#'
#' sibes_species_search(data_list[["species"]], Key='57|34|67')

sibes_species_search <- function(Inputdata=NULL, Key=NULL){
  if(!is.null(Key)||!is.null(Inputdata))  x <- Inputdata %>% mutate(combined=str_c(Inputdata$name,Inputdata$sibes_id,Inputdata$short_name)) %>% filter(str_detect(combined,regex(Key, ignore_case = TRUE))) %>% subset(select = -combined )
  else x <- "error"
 return(x)
}