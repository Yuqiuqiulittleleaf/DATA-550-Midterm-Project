# Set project location
here::i_am("code/figure/01_boxplot.R")

# Load required libraries
library(dplyr)
library(ggplot2)
library(here)
library(readr)

# Load the pre-processed data for the year 2021
cdc_data2021 <- readRDS(here("data", "cdc_data2021.rds"))

# Identify the Top 5 states (reporting_jurisdiction) with the highest population served
population <- cdc_data2021 %>%
  filter(
    !is.na(ptc_15d),
    !is.na(detect_prop_15d),
    detect_prop_15d >= 0 & detect_prop_15d <= 100
  ) %>%
  select(county_names, wwtp_jurisdiction, population_served) %>%
  distinct() %>%  # Keep only one row for each (county, state)
  group_by(wwtp_jurisdiction) %>%
  summarize(total_population_served = sum(population_served, na.rm = TRUE)) %>%
  arrange(desc(total_population_served)) %>%
  slice(1:5)

# Extract non-missing observations from the Top 5 states
top5_data <- cdc_data2021 %>%
  filter(wwtp_jurisdiction %in% population$wwtp_jurisdiction)

# Print summary statistics for each state to check if any IQR = 0
summary_stats <- top5_data %>%
  group_by(wwtp_jurisdiction) %>%
  summarize(
    count = n(),
    mean = mean(detect_prop_15d, na.rm = TRUE),
    median = median(detect_prop_15d, na.rm = TRUE),
    q1 = quantile(detect_prop_15d, 0.25, na.rm = TRUE),
    q3 = quantile(detect_prop_15d, 0.75, na.rm = TRUE),
    iqr = IQR(detect_prop_15d, na.rm = TRUE)
  )
print(summary_stats)

# ----------- Boxplot 1: detect_prop_15d -------------
plot1 <- ggplot(top5_data, aes(x = wwtp_jurisdiction, y = detect_prop_15d)) +
  geom_boxplot(fill = "skyblue")  +
  coord_cartesian(ylim = c(-100, 150)) +
  labs(
    title = "Boxplot of detect_prop_15d in Top 5 Jurisdictions (2021)",
    x = "Jurisdiction",
    y = "detect_prop_15d"
  ) +
  theme_minimal()
print(plot1)

# ----------- Boxplot 2: ptc_15d with jitter points -------------
plot2 <- ggplot(top5_data, aes(x = wwtp_jurisdiction, y = ptc_15d)) +
  geom_boxplot(fill = "skyblue", outlier.shape = NA, varwidth = FALSE, width = 0.6) +
  geom_jitter(width = 0.2, alpha = 0.15, size = 0.8, color = "purple") +
  stat_summary(fun = median, geom = "text", aes(label = round(..y.., 1)),
               vjust = -0.5, color = "white", fontface = "bold", size = 3) +
  coord_cartesian(ylim = c(0, 100)) +
  labs(
    title = "Boxplot of ptc_15d in Top 5 Jurisdictions (2021)",
    x = "Jurisdiction",
    y = "ptc_15d"
  ) +
  theme_bw(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 30, hjust = 1),
    plot.title = element_text(hjust = 0.5)
  )
print(plot2)

# ----------- Save figures to output/figure folder -------------
ggsave(here("output", "figure", "boxplot_ptc15d.png"), plot2, width = 6, height = 4)
ggsave(here("output", "figure", "boxplot_detectprop15d.png"), plot1, width = 6, height = 4)


