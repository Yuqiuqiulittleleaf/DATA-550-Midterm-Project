here::i_am(
  "code/03_alternative_data.R"
)

library(readr)
library(dplyr)

# 1. 读取原始数据
cdc_data <- read_csv(here::here("data", "cdc_data.csv"))

# 2. 删除 2021 年 1 月份的数据
cdc_data_filtered <- cdc_data %>%
  mutate(
    date_start = as.Date(date_start),
    date_end   = as.Date(date_end)
  ) %>%
  filter(
    date_start >= as.Date("2021-01-01"),
    date_start <= as.Date("2021-12-31"),
    date_end   >= as.Date("2021-01-01"),
    date_end   <= as.Date("2021-12-31"),
    !(format(date_start, "%Y-%m") == "2021-01" | format(date_end, "%Y-%m") == "2021-01")
  )

# 3. 保存到新的 CSV 文件
write_csv(cdc_data_filtered, here::here("data/cdc_data2021_no_january.csv"))
