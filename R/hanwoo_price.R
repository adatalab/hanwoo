#' hanwoo_price
#'
#' This function scrap the real-time (within 5 days) price information of Hanwoo from data.go.kr. Please get your API key and request for applicate at data.go.kr.
#' @param date date you get the inform. e.g. 20190510
#' @keywords Hanwoo
#' @export
#' @import XML
#' @import plyr
#' @examples
#' hanwoo_price(date = "", type = "list")
#' hanwoo_price(date = "20190510", type = "df")


hanwoo_price <- function(date = "", type = "df") {
  
  code <- c("0905", "1301", "0809", "1005", "0302", "1201", "0202", "0320", "0323", "0714", "0513", "0613", "1101")
  
  result <- lapply(code, 
                FUN = function(x) {
                  url <- paste0("http://data.ekape.or.kr/openapi-data/service/user/grade/liveauct/cattleGrade?ServiceKey=", API_key,"&auctDate=", date, "&abattCd=", x)
                  xmlfile <- xmlParse(url)
                  xmltop <- xmlRoot(xmlfile)
                  get_inform <- xmlToDataFrame(getNodeSet(xmlfile, "//item"), stringsAsFactors = FALSE)
                  
                  return(get_inform)
                })
  

  ## fill informs ----
  if (type == "list" | type == 1) {
    df <- result
  }

  if (type == "df" | type == 2) {
    df <- plyr::ldply (result, data.frame)
  }

  ## return ----
  return(
    tryCatch(df,
      error = function(e) NULL
    )
  )
}
