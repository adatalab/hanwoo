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



hanwoo_stock <- function(by = "summary"){

  url <- "https://docs.google.com/spreadsheets/d/1baViBjPUz1wyicG-I-vN5RhyoCcFt-6lw550evTowEg/edit?usp=sharing"

  # summary data
  if(by == "summary" | by == 1) {
    stock <- read_sheet(url, sheet = 1) %>%
      mutate(
        date = ymd(date),
        year = year(date),
        week = isoweek(date),
        wday = wday(date, label = TRUE)
      )
  }

  # 배합사료가격
  if(by == "feed" | by == 2) {
    stock <- read_sheet(url, sheet = 2) %>%
      mutate(
        date = ymd(paste0(연도, "-", 월,"-01"))
      ) %>%
      select(date, everything())
  }

  last_date <- max(stock$date)
  cat(paste0("Data from ekapepia.com; Last updated: ", last_date,  " by Antller Inc."))
  return(stock)

}
