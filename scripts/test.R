library(here)
library(readr)
library(tidyverse)
library(plyr)
library(dplyr)
survey_data <- readr::read_csv(here::here("Data", "survey_data.csv"))

survey_data <- survey_data %>%
  mutate(studying_in_your_home_country = ifelse(as.character(studying_in_your_home_country) == "Yes", "0", as.factor(studying_in_your_home_country))) %>%
  # 0 is yes and 1 is no
  mutate(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD = ifelse(as.character(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD) == "Yes", "0", as.factor(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD))) %>%
  # 0 is yes, 1 is no and 2 is prefer not to say
  select(-X1) %>% # drop this column, prob was an error from cleaning
  mutate(experienced_discrimination_or_harrasment = ifelse(as.character(experienced_discrimination_or_harrasment) == "Yes", "0", as.factor(experienced_discrimination_or_harrasment))) %>%
  mutate(experienced_bullying_in_PhD = ifelse(as.character(experienced_bullying_in_PhD) == "Yes", "0", as.factor(experienced_bullying_in_PhD)))

data_to_plot <- survey_data %>% select(c(studying_in_your_home_country, 
                         level_of_satisfaction_with_decision_to_pursue_a_PhD, 
                         supervisor_relationship,
                         work_life_balance,
                         university_supports_work_life_balance,
                         university_has_long_hours_culture,
                         have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD,
                         mental_health_and_wellbeing_services_at_my_uni_are_appropriate_to_PhD_students_needs,
                         supervisor_awareness_of_mental_health_services,
                         university_offers_adequate_one_to_one_mental_health_support,
                         university_offers_a_variety_of_support_resources,
                         experienced_discrimination_or_harrasment,
                         experienced_bullying_in_PhD))

test1 <- survey_data %>% select(c(studying_in_your_home_country, 
                                  level_of_satisfaction_with_decision_to_pursue_a_PhD, 
                                  supervisor_relationship,
                                  work_life_balance,
                                  university_has_long_hours_culture)) %>% rename(c("studying_in_your_home_country" = "studyinghomecountry",
                                                                                 "level_of_satisfaction_with_decision_to_pursue_a_PhD" = "PhDsatisfaction",
                                                                                 "supervisor_relationship" = "supervisorrelationship",
                                                                                 "work_life_balance" = "workvslife",
                                                                                 "university_has_long_hours_culture" = "longhours"))

GGally::ggpairs(test1, aes(colour = studyinghomecountry, alpha = 0.05, params=list(corSize=1)))

