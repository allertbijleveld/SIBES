#' color_bar
#' Plot a colorbar "legend".
#' @param lut A vector of colors
#' @param ticks The number of ticks in the legend 
#' @param Title The title of the scale bar
#' @param cex_legend_labels The size of the lables for the color_bar
#'
#' @return Color bar plot with ticks
#' @export
#'
color_bar <- function(lut, ticks, Title='', cex_legend_labels=1) {
  Min <- min(ticks)
  Max <- max(ticks)
  nticks <- length(ticks)+1
  Scale = (length(lut)-1)/(Max-Min)
  par(mar=c(1,1,1,1))
  layout(
    matrix(c(2,1), ncol=2),
    widths=c(4,1)
	)
  plot(c(Min,nticks), c(Min,Max), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main=Title)
  axis(2, ticks, las=2, line = -1, cex.axis = cex_legend_labels)
  for (i in 1:(length(lut)-1)) {
    y = (i-1)/Scale + Min
    rect(0,y,10,y+1/Scale, col=lut[i], border=NA)
  }
}
