## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(dplyr)

names(hanwoo::hanwoo_kpn)

hanwoo_kpn <- readxl::read_excel("kpn-nias-2208.xlsx") %>%
  janitor::clean_names(case = "lower_camel", ascii = FALSE)

names(hanwoo_kpn)

usethis::use_data(hanwoo_kpn, overwrite = TRUE)

# save(hanwoo_kpn, file = "hanwoo_kpn.rda")
