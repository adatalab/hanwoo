library(tidyverse)
library(lubridate)

Kcalendar <- read_csv("data-raw/Kcalendar/korea-calendar.csv")

glimpse(Kcalendar)

Kcalendar <- Kcalendar %>%
  mutate(
    손있는날 = gsub(",", "", 손있는날)
  )

usethis::use_data(Kcalendar, overwrite = TRUE)

