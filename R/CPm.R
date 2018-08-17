#' CPm
#'
#' This function calculate the crude protein for maintain of Hanwoo. CPm = 5.56 * bw^0.75
#' @param bw body weight (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' CPm(bw=150)


CPm <- function(bw) {
  CP <- 5.56 * bw^0.75
  attr(CP,"unit") <- "g/d"
  return(CP)
}
