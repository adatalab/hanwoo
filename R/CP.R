#' CP
#'
#' This function calculate the crude protein for maintain and growth of Hanwoo. CP = NP/eP
#' @param bw body weight (kg).
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' CP(bw=150, dg=1)

CP <- function(bw, dg) {
  CPm <- 5.56 * bw^0.75 
  NPm <- CPm * 0.51
  RP <- dg * (224.7 - 0.251 * bw)
  NP <- NPm + RP
  eP <- 0.51
  CP <- NP/eP
  attr(CP,"unit") <- "g/d"
  return(CP)
}
