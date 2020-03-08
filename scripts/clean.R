library(tidyverse)
library(janitor)
library(here)

## Load the csv
survey_raw <- read.csv(here::here("data", "survey_raw.csv"))
View(survey_raw)

# fix names for easier analysis (. and : don't read well) - and save this into a "clean" object
survey_data <- janitor::clean_names(survey_raw)
View(survey_data)

survey_data <- 
  survey_data %>%
  select(-c("id_format", # "smartphone", "tablet", "snap"
            "id_completed", # "case completed in snap" / "completed" / "NA"
            "id_site", # "NA", "newstory", "social1", "instagram", "pilot"...
            "id_start", # time that the interview started at
            "id_end_date", # date of the interview 
            "id_end", # time that the interview ended at
            "id_time", # time of the interview
            "q2", # "hidden"
            "q3_a", # other reasons to join a graduate program (out of given options), it's interesting but all are different so hard to use for analysis
            "q12_1", # "NA", "to study at a specific university" 
            "q12_a", # same as q3_a, but "other reasons to study outside your country of upbringing"
            "q14_a", # same as above, "other reasons to have a job"
            "q16", # "Is there anything else not mentioned that has concerned you since you started your PhD? 
            "q17_a", # "if other, please specify - what do you enjoy more about life as a PhD student?"
            "q26", # "overall, how would you describe the academic system, based on your PhD experience so far?" - open question
            "q35_a", # if other, please specify - about feeling discriminated
            "q39_a", # other reasons why you may be unlikely to pursue an academic career
            "q40_a", # specify what other positions you may occupy after completing your degree
            "q44_a", # other reasons why you may want to pursue a research career
            "q45_a", # "how did you arrive at your current career decision?" open q
            "q46_a", # "How do you learn about available career opportunities that are beyond academia?" open q
            "q47_a", # "Which of the following 3 things would you say are the most difficult for PhD students in your discipline?" open q
            "q48_a", # "Which of the following would you say are the most difficult for PhD students in the country where you are studying?" open q
            "q49_a", # "Which of the following resources do you think PhD students need the most in order to establish a satisfying career?" open q
            "q52_a", # "Which, if any, of the following activities have you done to advance your career?" open q
            "q53_a", # other social media networks that may help you build your career
            "q54_a", # other things that you would differently if starting over your program
            "q55", # open q
            "q58_a", # other ethnicity that best describes you
            "q59_a", # other responsibilities you may have
            "q60", # open q
            "q62", "q63", "q64", # cols asking whether it's ok for nature & springer to contact in the future
            "q65_a")) # numbers replacing names for anonymity

# Save our cleaned dataframe
