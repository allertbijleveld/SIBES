#' sibes_plot_map
#'
#' @param Inputdata A tibble or data.frame containing "x" and "y" coordinates and the data to plot
#' @param attribute The name of the column with data to plot
#' @param InputdataProj CRS format of "x" and "y" in the data
#' EPSG:4326 	(The standard latitude/longitude projection based on the WGS84 datum)
#' EPSG:28992 	(The standard Amersfoort / RD New -- Netherlands - Holland - Dutch projection based on the WGS84 datum)
#' EPSG:32631 	(WGS 84 / UTM zone 31N Between 0°E and 6°E, northern hemisphere between equator and 84°N, onshore and offshore. Algeria. Andorra. Belgium. Benin. Burkina Faso. Denmark - North Sea. France. Germany - North Sea. Ghana. Luxembourg. Mali. Netherlands. Niger. Nigeria. Norway. Spain. Togo. United Kingdom (UK) - North Sea.)
#' @param MapProj CRS format of the map plot
#'
#' @return A plotted map and color scale bar
#' @export
#'
sibes_plot_map <- function(Inputdata, attribute, ticks=5, InputdataProj = 4326, MapProj=28991, cex_map=0.2, cex_legend_labels=1){
  if(!is.null(Inputdata[[attribute]]) & !is.null(Inputdata$x) & !is.null(Inputdata$y)){

	# Define Optimal Cuts
		breaks <- pretty(Inputdata[[attribute]], n=ticks)
		ticks<-length(breaks)
				
	## make color scale
		rbPal <- grDevices::colorRampPalette(c("#FFFFD9", "#EDF8B1", "#C7E9B4", "#7FCDBB", "#41B6C4", "#1D91C0", "#225EA8", "#253494", "#081D58"))
		cuts<-cut(Inputdata[[attribute]], breaks = ticks)
		colramp<-rbPal(ticks)
	
    ## create temporary data frame and add colours 
		temp_data <- Inputdata
		temp_data$mycol <- colramp[as.numeric(cuts)]	
			
	## make colour bar 
		color_bar(
				lut = colramp[seq(1, ticks, length=length(breaks))],
				ticks = breaks,
				cex_legend_labels = cex_legend_labels
				)    
		Cont_Color_bar<- recordPlot()

    ## make data spatial 
		temp_data <- data.frame(temp_data,sf::st_coordinates(sf::st_transform(sf::st_set_crs(sf::st_as_sf(data.frame(temp_data$x, temp_data$y),coords=c(1:2)),InputdataProj),crs = MapProj)))

    #Load the Wadden Sea shapefile:
		land <- get("Wadden_sea_map")
		land <- sf::st_transform(x=land,crs=MapProj)
		mudflats <- sf::st_as_sf(get("mudflats"))
		mudflats <- sf::st_transform(x=mudflats,crs=MapProj)

	## make the plot 
		plot(sf::st_geometry(land), main = attribute,
			cex.main=1, xlab="", ylab="", axes=T, col="darkgray",
			xlim=c(range(temp_data$X)[1]-0.05*diff(range(temp_data$X)),
            range(temp_data$X)[2]+0.05*diff(range(temp_data$X))),
			ylim=c(range(temp_data$Y)[1]-0.05*diff(range(temp_data$Y)),
            range(temp_data$Y)[2]+0.05*diff(range(temp_data$Y))))
		plot(sf::st_geometry(mudflats), add=TRUE, col="lightgray")
		#Add stations
		points(temp_data$X,temp_data$Y,
			   pch=15, cex=cex_map,
			   col=temp_data$mycol)

    WaddenSeaBiomassMap <- recordPlot(attach = c('sf','prettymapr'))
  }
  else {WaddenSeaBiomassMap <- "error"}

  return(WaddenSeaBiomassMap)
}
