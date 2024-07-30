#' sibes_merge
#' This function merges the tibbels samples and biota on samples data frame using left_join().
#' @param Inputdata List containing the tibbles 'biota' and 'samples'.
#'
#' @return A merged tibble of samples and biota that also contains empty stations.
#' @export
#'
#' @examples
#' data_list <- get('SIBES_dataset')
#' sibes_merge(Inputdata = data_list)
#' 
sibes_merge <- function(Inputdata){
  data_m<- Inputdata$samples %>%
    {if(!is.null(Inputdata$biota)) left_join(.,Inputdata$biota) else .} %>%
    mutate_if(is.numeric,coalesce,0) # allow to replace generated NA by 0
  #  {if(!is.null(Inputdata$biota) & !is.null(Inputdata$species)) left_join(.,Inputdata$species) else .}
  return(data_m)
}
