#' Body weight dataset for the Hanwoo steers in KU farm.
#'
#' This dataset contains a subset of the body weight dataset for
#' Hanwoo steer in Konkuk University farm.
#'
#' @format A data frame with 780 rows and 3 variables
#' \describe{
#'   \item{treat}{diet treatment}
#'   \item{month}{month of hanwoo steer}
#'   \item{weight}{Unshrunk body weight of hanwoo steer, kg}
#' }
"weight_ku"

#' Nutritional guide program for the Hanwoo steers.
#'
#' This dataset contains a subset of the Nutritional guide program
#' (National Institute of Animal Science)for the Hanwoo.
#' Body weight,month, average daily gain, and maximum growth
#' information dataset are available.
#'
#' @format A data frame with 24 rows and 10 variables
#' \describe{
#'   \item{stage3}{3 step program for steer}
#'   \item{stage4}{4 step program for steer}
#'   \item{month}{Month of hanwoo steer}
#'   \item{weight}{Unshrunk body weight of hanwoo steer, kg}
#'   \item{adg}{Average daily gain}
#'   \item{feed.intake}{Feed intake, dry matter basis, kg}
#'   \item{max.git}{Maximum growth stage for gastro intestinal tract}
#'   \item{max.muscle}{Maximum growth stage for muscle}
#'   \item{max.weight}{Maximum growth stage for body weight}
#'   \item{max.fat}{Maximum growth stage for intra-muscular fat}
#' }
"program_nias"
