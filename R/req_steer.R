#' req_steer
#'
#' Calculate the nutrient requirement of Hanwoo steer.
#' @param bw Body weight
#' @param dg Daily gain
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
#' req_steer(bw = 150, dg = 0.8)


req_steer <- function(bw, dg) {
  # Energy
  MEm <- 0.125 * bw^0.75
  NEg <- 0.0533 * bw^0.75 * dg
  q <- 0.5304 + 0.0748 * dg
  kf <- 0.78 * q + 0.006
  MEg <- NEg/kf
  ME <- MEm + MEg
  DE <- ME/0.82
  TDN <- 4.41*DE

  # Protein
  CPm <- 5.56 * bw^0.75 # CP for maintanance
  NPm <- CPm * 0.51 # Net prot. for maintanance
  RP <- dg * (224.7 - 0.251 * bw) # Retained protein
  NP <- NPm + RP # NP requirement
  CP <- NP / 0.51

  # Minerals
  Ca <- (0.0154 * bw + 0.071 * RP + 0.0137 * dg) / 0.5
  P <- (0.0280 * bw + 0.039 * RP + 0.0076 * dg) / 0.85

  # Vitamins
  vitA <- 0.0424 * bw
  vitD <- 0.006 * bw

  df <- tibble(
    sex = "steer",
    BW_kg = bw,
    ADG_kg = dg,
    CP_g = CP,
    TDN = TDN,
    DE = DE,
    ME_Mcal = ME,
    NEg_Mcal = NEg,
    Ca_g = Ca,
    P_g = P,
    vitA_1000IU = vitA,
    vitD_1000IU = vitD
  )

  return(df)
}
