#' Save d3 diagram as png
#' 
#' Saves d3 diagram as a png image using webshot.
#' 
#' @param d3 A d3 object.
#' @param file Location to save image.
#' @param width Width of image.
#' @param height Height of image.
#' @param zoom Zoom before screenshot.
#' @param background Background color of diagram.
#' @param title Title for HTML diagram.
#' 
#' @examples
#' data(energy)
#' 
#' d3 = sankey(energy)
#' save.d3(d3, "energy.png")
#' 
#' @export

save.d3 <-
  function(d3, file, width = 1000, height = 750, delay = 5, zoom = 1, background = "white", title = "D3 Visualization"){
    temp.file = tempfile(fileext = ".html")
    r2d3::save_d3_html(d3, temp.file, background = background, title = title)
    webshot::webshot(temp.file, file = file, vwidth = width, vheight = height, delay = delay, zoom = zoom)
  }
