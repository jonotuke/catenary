#' Gets points for catenary from image
#'
#' Takes two numbers and adds them to give the
#' sum of them
#'
#' @param x first number
#' @param y second number
#' @return data
#' @author Jono Tuke <simon.tuke@@adelaide.edu.au>
#' @export
#' @note February 17 2013
#' @examples
#' f(2,3)
getImageCat <- function(file){
  img <- readImage(file) 
  display(img,method='raster') 
  
  tmp <- as.data.frame(locator())
  points(tmp,col='red',pch=16)
  return(tmp)
}
library(EBImage) 

tmp <- getImageCat("~/Dropbox/catenary/inst/private_store/ctesiphon_arch.jpg")