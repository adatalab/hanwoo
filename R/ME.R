#' ME
#'
#' This function calculate the metabolizable energy for maintain of Hanwoo.
#' @param bw body weight.
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' ME(bw=150, dg=1)

ME <- function(bw,dg) {
  MEm <- 0.125 * bw^0.75
  NEg <- 0.0533 * bw^0.75 * dg
  q <- 0.5304 + 0.0748 * dg
  kf <- 0.78 * q + 0.006
  E <- NEg/kf + MEm
  attr(E,"unit") <- "Mcal"
  return(E)
}

