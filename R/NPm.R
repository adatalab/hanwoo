#' NPm
#'
#' This function calculate the net protein for maintain of Hanwoo. NPm = CPm * 0.51
#' @param bw body weight (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' NPm(bw=150)

NPm <- function(bw) {
  CPm <- 5.56 * bw^0.75 
  NP <- CPm * 0.51
  attr(NP,"unit") <- "g/d"
  return(NP)
}
