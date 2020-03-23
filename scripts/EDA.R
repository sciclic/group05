"This script loads in a cleaned data file and runs an exploraroty data analysis.

Usage: clean.R --filepath=<filepath>
" -> doc

suppressMessages(library(tidyverse))
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(stringr))
suppressMessages(library(purrr))
suppressMessages(library(here))
suppressMessages(library(corrplot))
suppressMessages(library(docopt))

opt <- docopt(doc)

main <- function(filepath){
  
## Load the csv
survey_data <- read_csv(filepath)

#Load in survey_data csv file

#Create images folder
dir.create("images")

view(survey_data)

#Create basic demographics plot, save to images folder
ggplot(survey_data, aes(current_living_location)) +
  geom_bar(width = .8, fill = "steelblue") +
  coord_flip() +
  xlab("Continent") +
  ylab("Number of Graduate Students") +
  ggtitle("Demographics of survey participants") +
  theme_minimal() +
  ggsave('basic_demographics1.png', path = here("images"), width = 8, height = 5)

#Create scatterplot of satisfaction vs supervisor relationship
survey_data %>%
  drop_na(level_of_satisfaction_with_decision_to_pursue_a_PhD, supervisor_relationship) %>%
  ggplot(aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, supervisor_relationship)) +
  geom_point(position = "jitter", alpha = .12) +
  xlab("Level of satisfaction with decision to pursue a PhD \n (1 - 5 scale [lowest - highest])") +
  ylab("Supervisor Relationship Satisfaction \n (1 - 7 scale [lowest - highest])") +
  ggtitle("Self-reported levels of sastisfaction with PhD decisison vs \nsupervisor relationship satisfaction") +
  theme_minimal() +
  ggsave('satisfaction_v_supervis_relationship.png', path = here("images"), width = 8, height = 5)

#Create scatterplot of satisfaction vs work-life balance
survey_data %>%
  drop_na(level_of_satisfaction_with_decision_to_pursue_a_PhD, work_life_balance) %>%
  ggplot(aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, work_life_balance)) +
  geom_point(position = "jitter", alpha = .12) +
  xlab("Level of satisfaction with decision to pursue a PhD \n (1 - 5 scale [lowest - highest])") +
  ylab("Quality of work-life balance \n (1 - 7 scale [lowest - highest])") +
  ggtitle("Self-reported levels of sastisfaction with PhD career vs \nquality of work-life balance") +
  theme_minimal() +
  ggsave('satisfaction_v_work_life_bal.png', path = here("images"), width = 8, height = 5)

#Print complete message
print("Exploratory Data Analysis complete!")
}

main(opt$filepath)
