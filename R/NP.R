#' NP
#'
#' This function calculate the net protein for maintain and growth of Hanwoo. NP = NPm + NPg
#' @param bw body weight (kg).
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' NP(bw=150, dg=1)

NP <- function(bw, dg) {
  CPm <- 5.56 * bw^0.75 
  NPm <- CPm * 0.51
  RP <- dg * (224.7 - 0.251 * bw)
  NP <- NPm + RP
  attr(NP,"unit") <- "g/d"
  return(NP)
}

