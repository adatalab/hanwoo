#' req_bull
#'
#' Calculate the nutrient requirement of Hanwoo bull.
#' @param bw Body weight, kg
#' @param dg Daily gain, kg
#' @keywords Hanwoo
#' @keywords Nutrient requirement
#' @export
#' @import tibble
#' @format
#' \describe{
#'   \item{BW}{Body weight, kg}
#'   \item{ADG}{Avergae daily gain, kg}
#'   \item{CP}{Crude protein}
#'   \item{ME}{Metabolizable energy}
#'   \item{NEg}{Net energy for growth}
#'   \item{Ca}{Calcium}
#'   \item{P}{Phosphorus}
#'   \item{vit}{Vitamin}
#' }
#' @examples
#' req_bull(bw = 150, dg = 0.8)


req_bull <- function(bw, dg) {
  # Energy
  MEm <- 0.1307 * bw^0.75
  NEg <- 0.0429 * bw^0.75 * dg
  q <- 0.5304 + 0.0748 * dg
  kf <- 0.78 * q + 0.006
  MEg <- NEg/kf
  ME <- MEm + MEg
  
  # Protein
  CPm <- 5.56 * bw^0.75 # CP for maintanance
  NPm <- CPm * 0.51 # Net prot. for maintanance
  RP <- dg * (224.7 - 0.209 * bw) # Retained protein
  NP <- NPm + RP # NP requirement
  CP <- NP / 0.51
  
  # Minerals
  Ca <- (0.0154 * bw + 0.071 * RP + 0.0137 * dg) / 0.5
  P <- (0.0280 * bw + 0.039 * RP + 0.0076 * dg) / 0.85
  
  # Vitamins
  vitA <- 0.0424 * bw
  vitD <- 0.006 * bw
  
  df <- tibble(
    sex = "bull",
    BW_kg = bw, 
    ADG_kg = dg,
    CP_g = CP,
    ME_Mcal = ME,
    NEg_Mcal = NEg,
    Ca_g = Ca,
    P_g = P,
    vitA_1000IU = vitA,
    vitD_1000IU = vitD
  )
  
  return(df)
}
