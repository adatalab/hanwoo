#' vitD
#'
#' This function calculate the vitamin D requirement of Hanwoo. Vitamin D = 0.0424 * body weight
#' @param bw body weight (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' vitD(bw=150)

vitD <- function(bw) {
  vitD <- 0.006 * bw
  attr(vitD,"unit") <- "1000IU/d"
  return(vitD)
}