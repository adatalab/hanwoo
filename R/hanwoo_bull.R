#' hanwoo_bull
#'
#' This function scraping the bull information of Hanwoo from data.go.kr.
#' @param KPN KPN number of a bull you get the inform.
#' @param type "list", "all", or "selected"
#' @keywords Hanwoo bull
#' @export
#' @import XML
#' @import dplyr
#' @import lubridate
#' @examples
#' hanwoo_bull(KPN = 950)
#' hanwoo_bull(KPN = 950, type = "selected")

hanwoo_bull <- function(KPN, type = "list") {

  # import bull informations ----
  url1 <- paste("http://chuksaro.nias.go.kr/openapi/brblInfoOk.jsp?dataType=xml&brblNo=","KPN", KPN, sep="")
  xmlfile1 <- xmlParse(url1)
  xmltop1 <- xmlRoot(xmlfile1)
  get_inform <- xmlToDataFrame(getNodeSet(xmlfile1, "//item"), stringsAsFactors = FALSE)

  # return ----
  df <- list()

  epd <- get_inform %>%
    select(BRDR_CRWG, BRDR_LN_Y_AR, BRDR_BCKF_THCN, BRDR_MRSC) %>%
    mutate_all(as.numeric) %>%
    mutate_all(function(x) {x/2}) %>%
    as_tibble()

  df[[1]] <- tibble(kpn = paste0("KPN", KPN)) %>%
    cbind(get_inform) %>%
    as_tibble()

  df[[2]] <- tibble(kpn = paste0("KPN", KPN)) %>%
    cbind(select(get_inform, SCDR_KPN, SLE_AT_NM, BRBL_SPCHCKN_CODE_NM, BIRTH_DATETM)) %>%
    mutate(BIRTH_DATETM = lubridate::ymd(BIRTH_DATETM)) %>%
    cbind(epd) %>%
    as_tibble()


  colnames(df[[2]]) <- c("kpn", "father", "selling", "guarantee", "birthday", "carcass_weight_kg", "longissimus_cm", "backfat_mm", "marbling")

  names(df) <- c("All", "EPD")

  if(type == "list") {
    return(df)
  }

  if(type == "all") {
    return(df$All)
  }

  if(type == "selected") {
    return(df$EVB_selected)
  }
}
