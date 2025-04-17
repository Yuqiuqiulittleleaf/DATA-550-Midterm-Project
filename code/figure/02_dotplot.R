here::i_am("code/figure/02_dotplot.R")

# Load required libraries
library(dplyr)
library(ggplot2)
library(here)
library(readr)
library(ggrepel)

# Load the processed 2021 dataset
cdc_data2021 <- readRDS(here("data", "cdc_data2021.rds"))

# Summarize the median detection proportion and total population for each state
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
  arrange(desc(total_population_served))

# Prepare data for dot plot: compute mean detection proportion per state
dot_data <- cdc_data2021 %>%
  filter(!is.na(detect_prop_15d), detect_prop_15d >= 0, detect_prop_15d <= 100) %>%
  group_by(wwtp_jurisdiction) %>%
  summarize(
    mean_detect = mean(detect_prop_15d, na.rm = TRUE)
  ) %>%
  left_join(population, by = "wwtp_jurisdiction") %>%
  mutate(log_population = log10(total_population_served))

# Plot: x = log(population), y = mean detection proportion
plot3 <- ggplot(dot_data, aes(x = log_population, y = mean_detect)) +
  geom_point(color = "blue", size = 3) +
  geom_text_repel(aes(label = wwtp_jurisdiction), size = 3, max.overlaps = 100) +
  labs(
    title = "Dot Plot of Median Detection Rate vs Population (2021)",
    x = "Log10 of Total Population Served",
    y = "Mean Proportion Detected (detect_prop_15d)"
  ) +
  theme_minimal()

# Save the plot
ggsave(
  filename = here("output", "figure", "figure2_dotplot.png"),
  plot = plot3,
  width = 7, height = 5
)