#' hanwoo_bull
#'
#' This function scraping the bull information of Hanwoo from data.go.kr.
#' @param KPN KPN number of a bull you get the inform.
#' @param type "list", "all", or "selected"
#' @keywords Hanwoo bull
#' @export
#' @import XML
#' @import dplyr
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

  df[[1]] <- tibble(kpn = paste0("KPN", KPN)) %>%
    cbind(get_inform) %>%
    as_tibble()

  df[[2]] <- tibble(kpn = paste0("KPN", KPN)) %>%
    cbind(select(get_inform, SCDR_KPN, BRDR_CRWG, BRDR_BCKF_THCN, BRDR_LN_Y_AR, BRDR_MRSC)) %>%
    as_tibble()

  df[[2]][, -c(1:2)] <- unlist(df[[2]][, -c(1:2)]) %>% as.numeric

  colnames(df[[2]]) <- c("kpn", "father", "carcass_weight_kg", "backfat_mm", "longissimus_cm", "marbling")

  names(df) <- c("All", "EVB_selected")

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
