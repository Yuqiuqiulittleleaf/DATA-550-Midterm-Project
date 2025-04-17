here::i_am(
  "code/table/01_make_tables.R"
)

cdc_data2021 <- readRDS(
  file = here::here("data/cdc_data2021.rds")
)

# Tabular analysis

# Load libraries
library(here)
library(dplyr)
library(gtsummary)
library(gt) 

# Create Table 1: Summarize data by sample location
table1 <- cdc_data2021 %>%
  group_by(sample_location) %>% 
  summarize(
    # For each sample_location, population_served is unique, so take the first value.
    population_served = first(population_served),
    # Calculate the average percent change in SARS-CoV-2 RNA
    avg_ptc_15d = mean(ptc_15d, na.rm = TRUE),
    # Calculate the average proportion of tests with SARS-CoV-2 detected
    avg_detect_prop_15d = mean(detect_prop_15d, na.rm = TRUE)
  ) %>%
  # If population_served is too large (>1e6), take its natural logarithm.
  mutate(
    population_served = if_else(population_served > 1e6, log(population_served), population_served)
  ) %>%
  # Round all numeric values to 3 decimal places and convert avg_detect_prop_15d to percentage format
  mutate(
    population_served = round(population_served, 3),
    avg_ptc_15d = round(avg_ptc_15d, 3),
    avg_detect_prop_15d = paste0(round(avg_detect_prop_15d, 3), "%")
  ) %>%
  arrange(desc(population_served))


saveRDS(
  table1,
  file = here::here("data", "table1.rds")
)

# Table 2
# Step 1: Create a county-level summary.
# For each county (unique county_names and corresponding state in wwtp_jurisdiction),
# extract the unique population_served and the median of other variables.
county_summary <- cdc_data2021 %>%
  group_by(county_names, wwtp_jurisdiction) %>%
  summarize(
    # Since population_served is unique for each county, take the first value.
    population_served = first(population_served),
    # Take the median values for ptc_15d, detect_prop_15d, and percentile.
    ptc_15d = median(ptc_15d, na.rm = TRUE),
    detect_prop_15d = median(detect_prop_15d, na.rm = TRUE),
    percentile = median(percentile, na.rm = TRUE),
    .groups = "drop"
  )

# Step 2: Create a state-level summary.
population <- cdc_data2021 %>%
  filter(
    !is.na(ptc_15d),
    !is.na(detect_prop_15d),
    detect_prop_15d >= 0 & detect_prop_15d <= 100
  ) %>%
  select(county_names, wwtp_jurisdiction, population_served) %>%
  distinct() %>%  # 每个 (county, 州) 只保留一行
  group_by(wwtp_jurisdiction) %>%
  summarize(total_population_served = sum(population_served, na.rm = TRUE)) %>%
  arrange(desc(total_population_served)) %>%
  slice(1:5)

# 提取 Top 3 州的非缺失观测值
top5_data <- cdc_data2021 %>%
  filter(wwtp_jurisdiction %in% population$wwtp_jurisdiction)

# 输出各州 detect_prop_15d 概览（用于确认是否存在 IQR = 0 的情况）
table2 <- top5_data %>%
  group_by(wwtp_jurisdiction) %>%
  summarize(
    `Sample count` = n(),
    `Mean detection (%)` = round(mean(detect_prop_15d, na.rm = TRUE), 2),
    `Median detection (%)` = round(median(detect_prop_15d, na.rm = TRUE), 2),
    `Q1 (25th percentile)` = round(quantile(detect_prop_15d, 0.25, na.rm = TRUE), 2),
    `Q3 (75th percentile)` = round(quantile(detect_prop_15d, 0.75, na.rm = TRUE), 2),
    `IQR` = round(IQR(detect_prop_15d, na.rm = TRUE), 2),
    .groups = "drop"
  ) %>%
  arrange(desc(`Median detection (%)`))  # 可改为 desc(IQR) 视你需求

# 保存结果
saveRDS(
  table2,
  file = here::here("data", "table2.rds")
)
