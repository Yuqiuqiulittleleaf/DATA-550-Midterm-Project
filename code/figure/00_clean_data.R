here::i_am("code/figure/00_clean_data.R")

library(dplyr)
library(readr)
library(here)

cdc_data <- read_csv(here("data", "cdc_data.csv"))

cdc_data2021 <- cdc_data %>%
  mutate(
    date_start = as.Date(date_start),
    date_end = as.Date(date_end)
  ) %>%
  filter(
    date_start >= as.Date("2021-01-01") & date_start <= as.Date("2021-12-31"),
    date_end >= as.Date("2021-01-01") & date_end <= as.Date("2021-12-31")
  )

saveRDS(cdc_data2021, file = here("data", "cdc_data2021.rds"))

