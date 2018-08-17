#' hanwoo_key
#'
#' A function for set your API key.
#' @param key An API key that you get from data.go.kr.
#' @keywords Hanwoo
#' @export
#' @examples
#' hanwoo_key(key="1KTzXwIIp1Gn1weD3eRnsmoLgP4efuf%2FH27OczlrUCFKKHRYxk4Rn9OXxJpTlNd%2BU%2Fw%3D%3D_PLESE_GET_YOUR_API_KEY_AT_DATA.GO.KR")

hanwoo_key <- function(key) {
  assign("API_key",key,envir=globalenv())
}
