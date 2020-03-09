library(tidyverse)
library(janitor)
library(dplyr)
library(here)
library(stringr)

## Load the csv
survey_raw <- read.csv(here::here("data", "survey_raw.csv"))

# Fix names for easier analysis (. and : don't read well) - and save this into a "clean" object
survey_data <- janitor::clean_names(survey_raw)

# Select only variables that we will be exploring
survey_data <- 
  survey_data %>%
  select(c("q1", # which degree are you stuyding
           "q4", "q5", # are you studying in the country you grew up in (yes/no) and where do you live now
           "q12_1":"q12_11", # what prompted you to study outside your country of upbringing
           "q13", "q14", "q15_a":"q15_n", # do you have a job & if so why (q15_x are the options)
           "q18_a", "q20", "q21_f", "q22_h", "q23", "q24", "q25", # satisfaction markers
           "q28", "q29", "q30_a":"q32_7", "q33":"q35_7", "q56", "q57")) # mental health + harrasment/bullying questions

# Change blanks to NA
survey_data <- survey_data %>%
  mutate_at(vars(colnames(.)),
            .funs = funs(ifelse(.=="", NA, as.character(.))))

# Fix redundancy (e.g. columns 15-24 are "What prompted you to study outside your country of upbringing?", but each column only has 1 reason as an answer - intuitive to combine these for posterior analysis)
survey_data <-
  survey_data %>%
  mutate(reasons_to_study_outside_your_country_of_upbringing = coalesce(q12_1, q12_2, q12_3, q12_4, q12_5, q12_6,
                                                                        q12_7, q12_8, q12_9, q12_10, q12_11)) %>%
  select(-c(q12_1:q12_11)) # drop old columns

survey_data <-
  survey_data %>%
  mutate(reasons_for_having_a_job = coalesce(q15_a, q15_b, q15_c, q15_d, q15_e, q15_f,
                                               q15_g, q15_h, q15_i, q15_j, q15_k, q15_l,
                                               q15_m, q15_n)) %>%
  select(-c(q15_a:q15_n))

survey_data <-
  survey_data %>%
  mutate(who_was_the_perpetrator = coalesce(q32_1, q32_2, q32_3,
                                            q32_4, q32_5, q32_6, q32_7)) %>%
  select(-c(q32_1:q32_7))

survey_data <-
  survey_data %>%
  mutate(which_have_you_experienced = coalesce(q35_1, q35_2, q35_3,
                                            q35_4, q35_5, q35_6, q35_7)) %>%
  select(-c(q35_1:q35_7))

# Fix colnames
survey_data <-
  survey_data %>%
  rename(degree = q1,
         studying_in_your_home_country = q4,
         current_living_location = q5,
         job_alongside_studies = q13,
         main_reason_job = q14,
         level_of_satisfaction_with_decision_to_pursue_a_PhD = q18_a,
         level_of_satisfaction_since_starting_grad_school = q20,
         supervisor_relationship = q21_f,
         work_life_balance = q22_h,
         how_does_your_program_compare_to_your_expectations = q23,
         PhD_weekly_hours = q24,
         one_on_one_contact_w_supervisor = q25,
         have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD = q28,
         did_you_seek_help_within_your_institution = q29,
         mental_health_and_wellbeing_services_at_my_uni_are_appropriate_to_PhD_students_needs = q30_a,
         supervisor_awareness_of_mental_health_services = q30_b,
         university_offers_adequate_one_to_one_mental_health_support = q30_c,
         university_offers_a_variety_of_support_resources = q30_d,
         university_supports_work_life_balance = q30_e,
         university_has_long_hours_culture = q30_f,
         experienced_bullying_in_PhD = q31,
         able_to_speak_out_about_bullying_experiences = q33,
         experienced_discrimination_or_harrasment = q34,
         age = q56,
         gender = q57)
  
# Drop 1st row (questions) 
survey_data <- survey_data[-1,]

# Reorder columns
survey_data <-
  survey_data %>%
  select(c('age', 'gender', 'degree', 
           'studying_in_your_home_country', 'current_living_location', 'reasons_to_study_outside_your_country_of_upbringing',
           'job_alongside_studies', 'main_reason_job', 'reasons_for_having_a_job',
           'level_of_satisfaction_with_decision_to_pursue_a_PhD', 'level_of_satisfaction_since_starting_grad_school', 'how_does_your_program_compare_to_your_expectations',
           'supervisor_relationship', 'one_on_one_contact_w_supervisor',
           'work_life_balance', 'PhD_weekly_hours',
           'university_supports_work_life_balance', 'university_has_long_hours_culture',
           'have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD', 'did_you_seek_help_within_your_institution', 'mental_health_and_wellbeing_services_at_my_uni_are_appropriate_to_PhD_students_needs',
           'supervisor_awareness_of_mental_health_services', 'university_offers_adequate_one_to_one_mental_health_support', 'university_offers_a_variety_of_support_resources',
           'experienced_bullying_in_PhD', 'who_was_the_perpetrator', 'able_to_speak_out_about_bullying_experiences',
           'experienced_discrimination_or_harrasment', 'which_have_you_experienced'))

#Fix column "supervisor relationship" to contain only numbers.
for (i in 1:length(survey_data$supervisor_relationship)){
  survey_data$supervisor_relationship[i] <- str_replace(survey_data$supervisor_relationship[i], "7 = Extremely satisfied", "7")
}
for (i in 1:length(survey_data$supervisor_relationship)){
  survey_data$supervisor_relationship[i] <- str_replace(survey_data$supervisor_relationship[i], "4 = Neither satisfied nor dissatisfied", "4")
}
for (i in 1:length(survey_data$supervisor_relationship)){
  survey_data$supervisor_relationship[i] <- str_replace(survey_data$supervisor_relationship[i], "1 = Not at all satisfied", "1")
}

#Fix column "work life balance" to contain only numbers.
for (i in 1:length(survey_data$work_life_balance)){
  survey_data$work_life_balance[i] <- str_replace(survey_data$work_life_balance[i], "7 = Extremely satisfied", "7")
}
for (i in 1:length(survey_data$work_life_balance)){
  survey_data$work_life_balance[i] <- str_replace(survey_data$work_life_balance[i], "4 = Neither satisfied nor dissatisfied", "4")
}
for (i in 1:length(survey_data$supervisor_relationship)){
  survey_data$work_life_balance[i] <- str_replace(survey_data$work_life_balance[i], "1 = Not at all satisfied", "1")
}

#Fix column "level_of_satisfaction_with_decision_to_pursue_a_PhD" to only contain numbers
for (i in 1:length(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD)){
  survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i] <- str_replace(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i], "Very satisfied", "5")
}
for (i in 1:length(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD)){
  survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i] <- str_replace(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i], "Somewhat satisfied", "4")
}
for (i in 1:length(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD)){
  survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i] <- str_replace(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i], "Neither satisfied nor dissatisfied", "3")
}
for (i in 1:length(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD)){
  survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i] <- str_replace(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i], "Somewhat dissatisfied", "2")
}
for (i in 1:length(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD)){
  survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i] <- str_replace(survey_data$level_of_satisfaction_with_decision_to_pursue_a_PhD[i], "Very dissatisfied", "1")
}

# Save object
write.csv(survey_data, here::here("data", "survey_data.csv"))
