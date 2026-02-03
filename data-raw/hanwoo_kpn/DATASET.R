## code to prepare `DATASET` dataset goes here

# usethis::use_data(DATASET, overwrite = TRUE)

library(dplyr)

names(hanwoo::hanwoo_kpn)

hanwoo_kpn <- readxl::read_excel("data-raw/hanwoo_kpn/kpn-nias-2602.xlsx", skip = 0) %>%
  janitor::clean_names(case = "lower_camel", ascii = FALSE)

glimpse(hanwoo::hanwoo_kpn)
glimpse(hanwoo_kpn)

ncol(hanwoo::hanwoo_kpn)
ncol(hanwoo_kpn)

tail(hanwoo::hanwoo_kpn)
tail(hanwoo_kpn)

# 이전 버전과 colnames 체크
data.frame(
  old = names(hanwoo::hanwoo_kpn),
  new = names(hanwoo_kpn)
) %>%
  mutate(
    diff = ifelse(old == new, TRUE, FALSE)
  ) %>%
  filter(diff == FALSE)
  # pull(diff) %>% table()

names(hanwoo::hanwoo_kpn)
names(hanwoo_kpn)

names(hanwoo_kpn) <- gsub("명호", "", names(hanwoo_kpn))

# 만약 확인해보고.. colname 다른 것들 내용이 일치하면 기존 양식이랑 동일하게 진행
# names(hanwoo_kpn) <- names(hanwoo::hanwoo_kpn)

hanwoo::hanwoo_kpn
hanwoo_kpn

# use_data
usethis::use_data(hanwoo_kpn, overwrite = TRUE)

# save(hanwoo_kpn, file = "hanwoo_kpn.rda")
