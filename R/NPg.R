#' NPg
#'
#' This function calculate the net protein for growth (NPg = RP) of Hanwoo. NPg = dg \* (224.7 - 0.251 \* bw)
#' @param bw body weight (kg).
#' @param dg daily gain (kg).
#' @keywords Hanwoo
#' @export
#' @examples
#' NPg(bw=150, dg=1)

NPg <- function(dg, bw) {
  RP <- dg * (224.7 - 0.251 * bw)
  attr(RP,"unit") <- "g/d"
  return(RP)
}
