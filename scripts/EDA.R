library(tidyverse)
library(dplyr)
library(ggplot2)
library(stringr)
library(purrr)
library(here)

#Load in survey_data csv file
survey_data <- read.csv(here::here("data", "survey_data.csv"))

#Create images folder
dir.create("images")

view(survey_data)

#Create basic demographics plot, save to images folder
ggplot(survey_data, aes(current_living_location)) +
  geom_bar(width = .8, fill = "steelblue") +
  coord_flip() +
  xlab("Continent") +
  ylab("Number of Graduate Students") +
  theme_minimal() +
  ggsave('basic_demographics1.png', path = here("images"), width = 8, height = 5)

#Create scatterplot of satisfaction vs supervisor relationship
survey_data %>%
  drop_na(level_of_satisfaction_with_decision_to_pursue_a_PhD, supervisor_relationship) %>%
  ggplot(aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, supervisor_relationship)) +
  geom_point(position = "jitter", alpha = .12) +
  xlab("Level of satisfaction with decision to pursue a PhD (1 - 5 scale)") +
  ylab("Supervisor Relationship Satisfaction (1 - 7 scale") +
  theme_minimal() +
  ggsave('satisfaction_v_supervis_relationship.png', path = here("images"), width = 8, height = 5)

#Create scatterplot of satisfaction vs work-life balance
survey_data %>%
  drop_na(level_of_satisfaction_with_decision_to_pursue_a_PhD, work_life_balance) %>%
  ggplot(aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, work_life_balance)) +
  geom_point(position = "jitter", alpha = .12) +
  xlab("Level of satisfaction with decision to pursue a PhD (1 - 5 scale)") +
  ylab("Quality of work-life balance (1 - 7 scale)") +
  theme_minimal() +
  ggsave('satisfaction_v_work_life_bal.png', path = here("images"), width = 8, height = 5)

