## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(dplyr)

names(hanwoo::hanwoo_kpn)

hanwoo_kpn <- readxl::read_excel("kpn-nias-2308.xlsx") %>%
  janitor::clean_names(case = "lower_camel", ascii = FALSE)

glimpse(hanwoo::hanwoo_kpn)
glimpse(hanwoo_kpn)

ncol(hanwoo::hanwoo_kpn)
ncol(hanwoo_kpn)

data.frame(
  old = names(hanwoo::hanwoo_kpn),
  new = names(hanwoo_kpn)
) %>%
  mutate(
    diff = ifelse(old == new, TRUE, FALSE)
  ) %>%
  filter(diff == FALSE) %>% View()

names(hanwoo::hanwoo_kpn)
names(hanwoo_kpn)

# 만약 확인해보고.. colname 다른 것들 내용이 일치하면 기존 양식이랑 동일하게 진행
names(hanwoo_kpn) <- names(hanwoo::hanwoo_kpn)

# use_data
usethis::use_data(hanwoo_kpn, overwrite = TRUE)

# save(hanwoo_kpn, file = "hanwoo_kpn.rda")
