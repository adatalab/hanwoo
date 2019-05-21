#' hanwoo_info
#'
#' This function scrap the information of Hanwoo from data.go.kr. Please get your API key and request for applicate at data.go.kr.
#' @param cattle Number of cattle you get the inform.
#' @param type Type for data; "list" OR "df" (dataframe).
#' @keywords Hanwoo
#' @export
#' @import XML
#' @import tibble
#' @import lubridate
#' @examples
#' hanwoo_info(cattle = "002083191603", type = "list")
#' hanwoo_info(cattle = "002083191603", type = "df")

hanwoo_info <- function(cattle, type = "df") {

  ## list or dataframe ----
  if (type == "list" | type == 1) {
    df <- list()
  }

  if (type == "df" | type == 2) {
    df <- data.frame()
  }

  ## import basic informations ----
  url1 <- paste("http://data.ekape.or.kr/openapi-data/service/user/mtrace/breeding/cattle?cattleNo=", cattle, "&ServiceKey=", API_key, sep = "")
  xmlfile1 <- xmlParse(url1)
  xmltop1 <- xmlRoot(xmlfile1)
  get_inform <- xmlToDataFrame(getNodeSet(xmlfile1, "//item"), stringsAsFactors = FALSE)
  
  get_inform$birthYmd <- lubridate::ymd(get_inform$birthYmd)
  get_inform$butcheryYmd <- lubridate::ymd(get_inform$butcheryYmd)
  get_inform$vaccineLastinjectionYmd <- lubridate::ymd(get_inform$vaccineLastinjectionYmd)
  get_inform$butcheryWeight <- as.integer(get_inform$butcheryWeight)

  ## import an issueNo ----
  url2 <- paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/issueNo?animalNo=", cattle, "&ServiceKey=", API_key, sep = "")
  xmlfile2 <- xmlParse(url2)
  xmltop2 <- xmlRoot(xmlfile2)
  get_issueNo <- xmlToDataFrame(getNodeSet(xmlfile2, "//item"), stringsAsFactors = FALSE)
  Issue_No <- gsub(" ", "", as.character(get_issueNo$issueNo)) # OR Issue_No<-stringr::str_trim(as.character(get_issueNo$issueNo))
  
  get_issueNo$abattDate <- lubridate::ymd(get_issueNo$abattDate)
  get_issueNo$issueDate <- ymd(get_issueNo$issueDate)
  get_issueNo$judgeDate <- ymd(get_issueNo$judgeDate)

  ## import the carcass characteristics (by using the IssueNo) ----
  url3 <- paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/cattle?issueNo=", Issue_No, "&ServiceKey=", API_key, sep = "")
  xmlfile3 <- xmlParse(url3)
  xmltop3 <- xmlRoot(xmlfile3)
  get_hanwoo <- xmlToDataFrame(getNodeSet(xmlfile3, "//item"), stringsAsFactors = FALSE)
  
  get_hanwoo$abattDate <- ymd(get_issueNo$abattDate)
  get_hanwoo$issueDate <- ymd(get_hanwoo$issueDate)
  get_hanwoo$judgeDate <- ymd(get_hanwoo$judgeDate)
  get_hanwoo$weight <- as.integer(get_hanwoo$weight)
  get_hanwoo$windex <- as.numeric(get_hanwoo$windex)

  ## fill informs ----
  if (type == "list" | type == 1) {
    df[[1]] <- tibble::as_tibble(get_inform)
    df[[2]] <- tibble::as_tibble(get_issueNo)
    df[[3]] <- tibble::as_tibble(get_hanwoo)
  }

  if (type == "df" | type == 2) {
    cbind.fill <- function(...) {
      nm <- list(...)
      nm <- lapply(nm, as.matrix)
      n <- max(sapply(nm, nrow))
      do.call(cbind, lapply(nm, function(x)
        rbind(x, matrix(, n - nrow(x), ncol(x)))))
    }

    df <- cbind.fill(get_inform, get_issueNo, get_hanwoo)
    df <- tibble::as_tibble(df)
  }

  ## return ----
  return(
    tryCatch(
      df,
      error = function(e) NULL
    )
  )
}
