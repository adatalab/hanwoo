#' hanwoo_stock
#'
#' This function get the stock calf and beef price of hanwoo. Data from ekapepia.com. It needs the Google OAuth access credentials.
#' @keywords Hanwoo
#' @export
#' @import googlesheets4
#' @import lubridate
#' @import tibble

#' @examples
#' hanwoo_stock()



hanwoo_stock <- function(){

  url <- "https://docs.google.com/spreadsheets/d/1baViBjPUz1wyicG-I-vN5RhyoCcFt-6lw550evTowEg/edit?usp=sharing"

  stock <- read_sheet(url) %>%
    mutate(
      date = ymd(date),
      year = year(date),
      week = isoweek(date),
      wday = wday(date, label = TRUE)
    ) %>%
    arrange(desc(date))

  cat("Data from ekapepia.com; last updated: 2022-09-13 by Youngjun Na")
  return(stock)

}
