# script to run linear regression & relevant analysis to out project
# plots generated in this script are saved as an image (found in "images" folder)
# model objects are saved as RDS files to load in the final report 
# broom package used to reference the model's statistical findings
# add a line in the Usage section on how to use this script

"This script uses the clean data generated in 'clean.R' to run logistic regression, as our data is not suited for linear regression.

Usage: analysis.R --data_path=<path> --data_file=<datafilename> 
  " -> doc

library(docopt)
library(here)
library(tidyverse)
library(knitr)
library(lubridate)
library(ggplot2)
library(corrplot)
library(dotwhisker)
library(here)
library(broom)

opt <- docopt(doc)

main <- function(data_path, data_file){
  
  ##### READ DATA
  data <- readr::read_csv(glue::glue(data_path, data_file))
  
  #### Create dummy variables & last minute adjustments to data for logistic regression
  survey_data <- data %>%
    mutate(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD = ifelse(as.character(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD) == "Yes", "0", as.factor(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD))) %>%
    # 0 is yes, 1 is no and 2 is prefer not to say
    select(-X1) %>% # drop this column, prob was an error from cleaning
    mutate(experienced_discrimination_or_harrasment = ifelse(as.character(experienced_discrimination_or_harrasment) == "Yes", "0", as.factor(experienced_discrimination_or_harrasment))) %>%
    mutate(experienced_bullying_in_PhD = ifelse(as.character(experienced_bullying_in_PhD) == "Yes", "0", as.factor(experienced_bullying_in_PhD))) 
  
  ##### Model 1: Long hours ~ PhD Satisfaction
  model <- glm(as.factor(university_has_long_hours_culture) ~ as.factor(level_of_satisfaction_with_decision_to_pursue_a_PhD), data = survey_data,
               family = binomial)
  broom::tidy(model)
  saveRDS(model, here::here("data", "glm_model1.rds"))
  
  ##### Estimate predicted probabilities of model 1
  model <- broom::augment(model,
                          newdata = modelr::data_grid(survey_data, level_of_satisfaction_with_decision_to_pursue_a_PhD),
                          type.predict = "response")
  saveRDS(model, here::here("data", "augmented_model1.rds"))
  
  ##### Model 2:  PhD Satisfaction ~ Supervisor Relationship
  model2 <- glm(as.factor(level_of_satisfaction_with_decision_to_pursue_a_PhD) ~ as.factor(supervisor_relationship), data = survey_data,
               family = binomial)
  broom::tidy(model2)
  saveRDS(model2, here::here("data", "glm_model2.rds"))
  
  ##### Estimate predicted probabilities of model 2
  model2 <- broom::augment(model2,
                          newdata = modelr::data_grid(survey_data, supervisor_relationship),
                          type.predict = "response")
  saveRDS(model2, here::here("data", "augmented_model2.rds"))
  
  ##### Model 3:  Anxiety and/or depression ~ Supervisor Relationship
  model3 <- glm(as.factor(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD) ~ as.factor(supervisor_relationship), data = survey_data,
                family = binomial)
  broom::tidy(model3)
  saveRDS(model3, here::here("data", "glm_model3.rds"))
  
  ##### Estimate predicted probabilities of model 3
  model3 <- broom::augment(model3,
                           newdata = modelr::data_grid(survey_data, supervisor_relationship),
                           type.predict = "response")
  saveRDS(model3, here::here("data", "augmented_model3.rds"))
  
  ##### Model 4:  Anxiety and/or depression ~ Studying in your home country
  model4 <- glm(as.factor(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD) ~ as.factor(studying_in_your_home_country), data = survey_data,
                family = binomial)
  broom::tidy(model4)
  saveRDS(model4, here::here("data", "glm_model4.rds"))
  
  ##### Estimate predicted probabilities of model 4
  model4 <- broom::augment(model4,
                           newdata = modelr::data_grid(survey_data, studying_in_your_home_country),
                           type.predict = "response")
  saveRDS(model4, here::here("data", "augmented_model4.rds"))
  
  ##### Model 5:  Work/Life Balance ~ PhD Satisfaction
  model5 <- glm(as.factor(work_life_balance) ~ as.factor(level_of_satisfaction_with_decision_to_pursue_a_PhD), data = survey_data,
                family = binomial)
  broom::tidy(model5)
  saveRDS(model5, here::here("data", "glm_model5.rds"))
  
  ##### Estimate predicted probabilities of model 5
  model5 <- broom::augment(model5,
                           newdata = modelr::data_grid(survey_data, level_of_satisfaction_with_decision_to_pursue_a_PhD),
                           type.predict = "response")
  saveRDS(model5, here::here("data", "augmented_model5.rds"))
  
  ##### Model 6:  Experienced discrimination or harrassment ~ Studying in your home country
  model6 <- glm(as.factor(experienced_discrimination_or_harrasment) ~ as.factor(studying_in_your_home_country), data = survey_data,
                family = binomial)
  broom::tidy(model6)
  saveRDS(model6, here::here("data", "glm_model6.rds"))
  
  ##### Estimate predicted probabilities of model 6
  model6 <- broom::augment(model6,
                           newdata = modelr::data_grid(survey_data, studying_in_your_home_country),
                           type.predict = "response")
  saveRDS(model6, here::here("data", "augmented_model6.rds"))
  
  ##### Model 7:  Experienced discrimination or harrassment ~ Gender
  model7 <- glm(as.factor(experienced_discrimination_or_harrasment) ~ as.factor(gender), data = survey_data,
                family = binomial)
  broom::tidy(model7)
  saveRDS(model7, here::here("data", "glm_model7.rds"))
  
  ##### Estimate predicted probabilities of model 7
  model7 <- broom::augment(model7,
                           newdata = modelr::data_grid(survey_data, gender),
                           type.predict = "response")
  saveRDS(model7, here::here("data", "augmented_model7.rds"))
  
  ##### Plot Model 1 (Long Hours ~ PhD Satisfaction)
  plot1 = ggplot2::ggplot(model, aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, .fitted)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Long Hours Culture & Satisfaction with Pursuing a PhD",
         x = "Level of Satisfaction with Pursuing a PhD",
         y = "Predicted Probability of Long Hours Culture") +
    scale_y_continuous(limits = c(0, 1)) 
  
  ggsave(path=(here::here("images")), filename = "logisticregression.png", device = 'png')
  print("Save plot 1 to images folder")
  
  ##### Plot Model 2 (PhD Satisfaction ~ Supervisor Relationship)
  plot2 = ggplot2::ggplot(model2, aes(supervisor_relationship, .fitted, group=1)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Supervisor Relationship & PhD Satisfaction",
         x = "Supervisor Relationship",
         y = "Predicted Probability of Satisfaction") +
    scale_y_continuous(limits = c(0, 1))
  
  ggsave(path=(here::here("images")), filename = "logisticregression2.png", device = 'png')
  print("Save plot 2 to images folder")
  
  ##### Plot Model 3 (Anxiety and/or depression ~ Supervisor Relationship)
  plot3 = ggplot2::ggplot(model3, aes(supervisor_relationship, .fitted, group=1)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Supervisor Relationship & Anxiety or Depression",
         x = "Supervisor Relationship",
         y = "Predicted Probability of Anxiety or Depression") +
    scale_y_continuous(limits = c(0, 1))
  
  ggsave(path=(here::here("images")), filename = "logisticregression3.png", device = 'png')
  print("Save plot 3 to images folder")
  
  ##### Plot Model 4 (Anxiety and/or depression ~ Studying in your home country)
  plot4 = ggplot2::ggplot(model4, aes(studying_in_your_home_country, .fitted, group=2)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Studying Outside of your Home Country & Anxiety or Depression",
         x = "Study Location",
         y = "Predicted Probability of Anxiety or Depression") +
    theme(plot.title = element_text(size = 10)) +
    scale_y_continuous(limits = c(0, 1))
  
  ggsave(path=(here::here("images")), filename = "logisticregression4.png", device = 'png')
  print("Save plot 4 to images folder")
  
  ##### Plot Model 5 (Work/Life Balance ~ PhD Satisfaction)
  plot5 = ggplot2::ggplot(model5, aes(level_of_satisfaction_with_decision_to_pursue_a_PhD, .fitted, group=1)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Work/Life Balance & Satisfaction with Pursuing a PhD",
         x = "Level of PhD Satisfaction",
         y = "Predicted Probability of Work/Life Balance") +
    scale_y_continuous(limits = c(0, 1)) 
  
  ggsave(path=(here::here("images")), filename = "logisticregression5.png", device = 'png')
  print("Save plot 5 to images folder")
  
  ##### Plot Model 6 (Experienced discrimination or harrassment ~ Studying in your home country)
  plot6 = ggplot2::ggplot(model6, aes(studying_in_your_home_country, .fitted, group=1)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Study Location (Home Country/Abroad) & Discrimination or Harrassment",
         x = "Studying in your home country",
         y = "Predicted Probability of Experiencing Discrimination or Harrassment") +
    theme(plot.title = element_text(size=10)) +
    scale_y_continuous(limits = c(0, 1)) 
  
  ggsave(path=(here::here("images")), filename = "logisticregression6.png", device = 'png')
  print("Save plot 6 to images folder")
  
  ##### Plot Model 7 (Experienced discrimination or harrassment ~ Gender)
  plot7 = ggplot2::ggplot(model7, aes(gender, .fitted, group=1)) +
    geom_line() +
    theme_bw() +
    labs(title = "Relationship Between Gender & Discrimination or Harrassment",
         x = "Gender",
         y = "Predicted Probability of Experiencing Discrimination or Harrassment") +
    theme(plot.title = element_text(size=12)) +
    scale_y_continuous(limits = c(0, 1))
  
  ggsave(path=(here::here("images")), filename = "logisticregression7.png", device = 'png')
  print("Save plot 7 to images folder")
  
}

main(opt$data_path, opt$data_file)