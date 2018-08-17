#' MEm
#'
#' This function calculate the metabolizable energy for maintain of Hanwoo.
#' @param bw body weight.
#' @keywords Hanwoo
#' @export
#' @examples
#' MEm(bw=150)

MEm <- function(bw) {
  E <- 0.125 * bw^0.75
  attr(E,"unit") <- "Mcal"
  return(E)
}

