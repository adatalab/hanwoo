## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(dplyr)

names(hanwoo::hanwoo_kpn)

hanwoo_kpn <- readxl::read_excel("kpn-nias-2302.xlsx") %>%
  janitor::clean_names(case = "lower_camel", ascii = FALSE)

glimpse(hanwoo::hanwoo_kpn)
glimpse(hanwoo_kpn)

ncol(hanwoo::hanwoo_kpn)
ncol(hanwoo_kpn)

data.frame(
  old = names(hanwoo::hanwoo_kpn),
  new = names(hanwoo_kpn)
)

names(hanwoo::hanwoo_kpn)
names(hanwoo_kpn)

usethis::use_data(hanwoo_kpn, overwrite = TRUE)

# save(hanwoo_kpn, file = "hanwoo_kpn.rda")
