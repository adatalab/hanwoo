## code to prepare `DATASET` dataset goes here

hanwoo_kpn <- readxl::read_excel("/Users/youngjunna/Github/adatalab/hanwoo/data-raw/kpn-nias-2108.xlsx")
hanwoo_kpn <- janitor::clean_names(hanwoo_kpn, case = "lower_camel", ascii = FALSE)

usethis::use_data(hanwoo_kpn, overwrite = TRUE)
