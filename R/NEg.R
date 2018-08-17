#' NEg
#'
#' This function calculate the net energy for growth of Hanwoo.
#' @param bw body weight (kg).
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' NEg(bw=150,dg=0.8)

NEg <- function(bw,dg) {
  E <- 0.0533 * bw^0.75 * dg
  attr(E,"unit") <- "Mcal"
  return(E)
}
