#' hanwoo_qrcode
#'
#' This function generate the QR code
#' @param cattle Number of cattle you want to gerate QR code.
#' @param site "mtrace" or "aiak"
#' @import qrcode
#' @export
#' @examples
#' hanwoo_qrcode(cattle = "002095123103", site = "mtrace")
#' hanwoo_qrcode(cattle = "002095123103", site = "aiak")

hanwoo_qrcode <- function(cattle, site = "mtrace") {

  if (site == "mtrace") {
    url <- paste0("https://www.ekape.or.kr/kapecp/ui/kapecp/one.jsp?searchKeyword=", cattle)
  }

  if(site == "aiak") {
    url <- paste0("https://aiak.or.kr/ka_hims/hims_02.jsp?type=barcode&var=", cattle)
  }

  code <- qr_code(url)
  return(plot(code))
}

