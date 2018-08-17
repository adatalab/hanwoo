#' vitA
#'
#' This function calculate the vitamin A requirement of Hanwoo. Vitamin A = 0.0424 * body weight
#' @param bw body weight (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' vitA(bw=150)

vitA <- function(bw) {
  vitA <- 0.0424 * bw
  attr(vitA,"unit") <- "1000IU/d"
  return(vitA)
}