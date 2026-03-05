#' hanwoo_stock
#'
#' This function get the stock calf and beef price of hanwoo. Data from ekapepia.com.
#' @keywords Hanwoo
#' @export
#' @import lubridate
#' @import tibble
#' @importFrom utils read.csv
#' @examples
#' \dontrun{
#' hanwoo_stock()
#' }

hanwoo_stock <- function(){

  stock <- # Read data from URL
      read.csv("https://raw.githubusercontent.com/YoungjunNa/ekape-parsing/main/data_hanwoo_stock/hanwoo-stock.csv") %>%
      tibble() %>%
      mutate(
        date = ymd(date),
        year = year(date),
        week = isoweek(date),
        wday = wday(date, label = TRUE)
      )

  last_date <- max(stock$date)
  cat(paste0("Data from https://ekapepia.com; Last updated: ", last_date,  " by Antller Inc."))
  return(stock)

}
