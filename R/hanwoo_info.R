#' hanwoo_info
#'
#' This function scrap the information of Hanwoo from data.go.kr. Please get your API key and request for applicate at data.go.kr.
#' @param cattle Number of cattle you get the inform.
#' @param type Type for data; "list" OR "df" (dataframe).
#' @keywords Hanwoo
#' @export
#' @import XML
#' @import tibble
#' @importFrom lubridate ymd
#' @import dplyr
#' @examples
#' hanwoo_info(cattle = "002083191603", type = "list")
#' hanwoo_info(cattle = "002115280512", type = "df")

hanwoo_info <- function(cattle, type = "df") {

  ## import basic informations ----
  get_inform <- paste("http://data.ekape.or.kr/openapi-data/service/user/mtrace/breeding/cattle?cattleNo=", cattle, "&ServiceKey=", API_key, sep = "") %>%
    xmlParse() %>%
    xmlRoot() %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE)

  get_inform$birthYmd <- lubridate::ymd(get_inform$birthYmd)
  get_inform$butcheryYmd <- lubridate::ymd(get_inform$butcheryYmd)
  get_inform$vaccineLastinjectionYmd <- lubridate::ymd(get_inform$vaccineLastinjectionYmd)
  get_inform$butcheryWeight <- as.integer(get_inform$butcheryWeight)

  ## import an issueNo ----
  get_issueNo <- paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/issueNo?animalNo=", cattle, "&ServiceKey=", API_key, sep = "") %>%
    xmlParse() %>%
    xmlRoot() %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE)

  Issue_No <- gsub(" ", "", as.character(get_issueNo$issueNo)) # OR Issue_No <- stringr::str_trim(as.character(get_issueNo$issueNo))

  get_issueNo$abattDate <- lubridate::ymd(get_issueNo$abattDate)
  get_issueNo$issueDate <- ymd(get_issueNo$issueDate)
  get_issueNo$judgeDate <- ymd(get_issueNo$judgeDate)

  ## import the carcass characteristics (by using the IssueNo) ----
  get_hanwoo <- paste("http://data.ekape.or.kr/openapi-data/service/user/grade/confirm/cattle?issueNo=", Issue_No, "&ServiceKey=", API_key, sep = "") %>%
    xmlParse() %>%
    xmlRoot() %>%
    getNodeSet("//item") %>%
    xmlToDataFrame(stringsAsFactors = FALSE)

  if(is.null(get_hanwoo[1,1]) == FALSE){
    get_hanwoo$abattDate <- ymd(get_issueNo$abattDate)
    get_hanwoo$issueDate <- ymd(get_hanwoo$issueDate)
    get_hanwoo$judgeDate <- ymd(get_hanwoo$judgeDate)
    get_hanwoo$weight <- as.integer(get_hanwoo$weight)
    get_hanwoo$windex <- as.numeric(get_hanwoo$windex)
  }

  ## fill informs ----
  if (type == "list" | type == 1) {
    df <- list()

    df[[1]] <- as_tibble(get_inform)
    df[[2]] <- as_tibble(get_issueNo)
    df[[3]] <- as_tibble(get_hanwoo)
  }

  if (type == "df" | type == 2) {

    if(is.null(get_hanwoo[1,1]) == FALSE) {
      ## -insfat ----
      if(is.null(get_inform$insfat) == TRUE) {
        df <- select(get_hanwoo, "judgeBreedNm", "judgeSexNm", "abattNm", "gradeNm", "qgrade", "wgrade", "weight", "windex") %>%
          mutate(insfat = NA) %>%
          cbind(select(get_inform, "birthYmd", "butcheryYmd", "farmNo", "farmNm", "farmAddr"))

        df <- cbind(cattleNo = cattle, df) %>% as_tibble()
      ## +insfat ----
      } else {
        df <- cbind(
          select(get_hanwoo, "judgeBreedNm", "judgeSexNm", "abattNm", "gradeNm", "qgrade", "wgrade", "weight", "windex"),
          select(get_inform, "insfat", "birthYmd", "butcheryYmd", "farmNo", "farmNm", "farmAddr")
        )

        df <- cbind(cattleNo = cattle, df) %>% as_tibble()
        df$insfat <- as.numeric(df$insfat)
      }
    } else {

      df <- tibble(
        judgeBreedNm = as.factor(NA),
        judgeSexNm = as.factor(NA),
        abattNm = as.character(NA),
        gradeNm = as.factor(NA),
        qgrade = as.factor(NA),
        wgrade = as.factor(NA),
        weight = as.numeric(NA),
        windex = as.numeric(NA),
        insfat = as.numeric(NA),
        birthYmd = lubridate::ymd(NA),
        butcheryYmd = lubridate::ymd(NA),
        farmNo = as.character(NA),
        farmNm = as.character(NA),
        farmAddr = as.character(NA)
      )

      df$birthYmd <- get_inform$birthYmd
      df$butcheryYmd <- get_inform$butcheryYmd
      df$farmNo <- get_inform$farmNo
      df$farmNm <- get_inform$farmNm
      df$farmAddr <- get_inform$farmAddr

      df <- cbind(cattleNo = cattle, df) %>% as_tibble()
    }
  }

  ## return ----
  return(
    tryCatch(
      df,
      error = function(e) NULL
    )
  )
}
