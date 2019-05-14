#' hanwoo_price
#'
#' This function scrap the real-time (within 5 days) price information of Hanwoo from data.go.kr. Please get your API key and request for applicate at data.go.kr.
#' @param date date you get the inform. e.g. 20190510
#' @keywords Hanwoo
#' @export
#' @import XML
#' @import plyr
#' @import lubridate
#' @import tibble

#' @examples
#' hanwoo_price(date = "", type = "list")
#' hanwoo_price(date = "20190510", type = "df")
#' @format
#' \describe{
#'   \item{auctDate}{Auction date}
#'   \item{abattCode}{Market code}
#'   \item{judgeBreedCd}{Breed code}
#'   \item{judgeSexCd}{Sex code}
#'   \item{abattNm}{Market name}
#'   \item{judgeBreedNm}{Breed name}
#'   \item{judgeSexNm}{Sex name}
#'   \item{auct_0aAmt}{1++A price}
#'   \item{auct_0bAmt}{1++B price}
#'   \item{auct_0cAmt}{1++C price}
#'   \item{auct_1aAmt}{1+A price}
#'   \item{auct_1bAmt}{1+B price}
#'   \item{auct_1cAmt}{1+C price}
#'   \item{auct_2aAmt}{1A price}
#'   \item{auct_2bAmt}{1B price}
#'   \item{auct_2cAmt}{1C price}
#'   \item{auct_3aAmt}{2A price}
#'   \item{auct_3bAmt}{2B price}
#'   \item{auct_3cAmt}{2C price}
#'   \item{auct_4aAmt}{3A price}
#'   \item{auct_4bAmt}{3B price}
#'   \item{auct_4cAmt}{3C price}
#'   \item{auct_5dAmt}{D price}
#'   \item{totalAuctAmt}{Mean price}
#'   \item{totalAuctCnt}{Mean animal}
#' }

hanwoo_price <- function(date = "", type = "df") {
  code <- c("0905", "1301", "0809", "1005", "0302", "1201", "0202", "0320", "0323", "0714", "0513", "0613", "1101")

  result <- lapply(code,
    FUN = function(x) {
      url <- paste0("http://data.ekape.or.kr/openapi-data/service/user/grade/liveauct/cattleGrade?ServiceKey=", API_key, "&auctDate=", date, "&abattCd=", x)
      xmlfile <- xmlParse(url)
      xmltop <- xmlRoot(xmlfile)
      get_inform <- xmlToDataFrame(getNodeSet(xmlfile, "//item"), stringsAsFactors = FALSE)

      return(get_inform)
    }
  )

  ## fill informs ----
  if (type == "list" | type == 1) {
    df <- result
  }

  if (type == "df" | type == 2) {
    df <- plyr::ldply(result, data.frame)

    num <- c(
      "totalAuctAmt",
      "totalAuctCnt",
      "auct_0aAmt",
      "auct_0bAmt",
      "auct_0cAmt",
      "auct_1aAmt",
      "auct_1bAmt",
      "auct_1cAmt",
      "auct_2aAmt",
      "auct_2bAmt",
      "auct_2cAmt",
      "auct_3aAmt",
      "auct_3bAmt",
      "auct_3cAmt",
      "auct_4aAmt",
      "auct_4bAmt",
      "auct_4cAmt",
      "auct_5dAmt"
    )

    df[, num] <- as.numeric(as.character(unlist(df[, num])))
    df$auctDate <- lubridate::ymd(df$auctDate)

    order <- c(
      "auctDate",
      "abattCode",
      "judgeBreedCd",
      "judgeSexCd",
      "abattNm",
      "judgeBreedNm",
      "judgeSexNm",
      "totalAuctCnt",
      "totalAuctAmt",
      "auct_0aAmt",
      "auct_0bAmt",
      "auct_0cAmt",
      "auct_1aAmt",
      "auct_1bAmt",
      "auct_1cAmt",
      "auct_2aAmt",
      "auct_2bAmt",
      "auct_2cAmt",
      "auct_3aAmt",
      "auct_3bAmt",
      "auct_3cAmt",
      "auct_4aAmt",
      "auct_4bAmt",
      "auct_4cAmt",
      "auct_5dAmt"
    )

    df <- tibble::as_tibble(df)
    df <- df[order]
  }

  ## return ----
  return(
    tryCatch(df,
      error = function(e) NULL
    )
  )
}
