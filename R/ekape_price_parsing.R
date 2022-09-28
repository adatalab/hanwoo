library(readr)
library(stringr)
library(dplyr)
library(rvest)

dd <- rvest::read_html("https://www.ekapepia.com/priceStat/distrPriceBeef.do") |>
  html_table() %>%
  .[[1]] |>
  janitor::clean_names(ascii = FALSE) |>
  # names() |>
  dplyr::slice(-c(1:2))

names(dd) <- c("date",	"암송아지",	"숫송아지",	"농가수취가격_600kg",	"지육_평균",	"지육_1등급",	"도매_등심1등급",	"소비자_등심1등급")

dd %>%
  mutate_at(
    vars(암송아지:소비자_등심1등급), function(x) {parse_number(x)}
  ) |>
  mutate_at(
    vars(암송아지:농가수취가격_600kg),
    function(x) x*1000
  ) |>
  rio::export(file = "price.xlsx")

stock <- hanwoo::hanwoo_stock()

library(ggplot2)
library(lubridate)
stock |>
  filter(암송아지 > 0, 숫송아지 > 0) |>
  mutate(year = year(date)) |>
  ggplot() +
  geom_line(aes(date, 암송아지), color = "red") +
  geom_line(aes(date, 숫송아지), color = "blue")
  # facet_wrap(~year)
