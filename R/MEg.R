#' MEg
#'
#' This function calculate the net energy for growth of Hanwoo.
#' @param bw body weight (kg).
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' MEg(bw=150,dg=0.8)

MEg <- function(bw,dg) {
  NEg <- 0.0533 * bw^0.75 * dg
  q <- 0.5304 + 0.0748 * dg
  kf <- 0.78 * q + 0.006
  E <- NEg/kf
  attr(E,"unit") <- "Mcal"
  return(E)
}
