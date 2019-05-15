#' req_steer
#'
#' Calculate the nutrient requirement of Hanwoo steer.
#' @param bw Body weight
#' @param dg Daily gain
#' @keywords Hanwoo
#' @keywords Nutrient requirement
#' @export
#' @import tibble
#' @examples
#' hanwoo_info(bw = 150, dg = 0.8)

req_steer <- function(bw, dg) {
  df <- tibble(
    BW = bw, 
    ADG = dg
  )
  
  df <- dplyr::mutate(
    df,
    CP_g = hanwoo::CP(bw, dg),
    ME_Mcal = hanwoo::ME(bw, dg),
    NEg_Mcal = hanwoo::NEg(bw, dg),
    vitA_1000IU = hanwoo::vitA(bw),
    vitD_1000IU = hanwoo::vitD(bw)
  )
  
  return(df)
}
