# script to run linear regression & relevant analysis to out project
# plots generated in this script are saved as an image (found in "images" folder)
# model object is saved as an RDS file to load in the final report 
# broom package used to reference the model's statistical findings
# add a line in the Usage section on how to use this script

"This script uses the clean data generated in 'clean.R' to run linear regression & other analyses.

Usage: analysis.R --data_dir=<path> --datafilename=<datafilename>
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
library(tidyverse)

opt <- docopt(doc)

main <- function(path, datafilename){
  
  ##### READ DATA
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  
  ##### Create Dummy Variables
  survey_data = data %>%
    mutate(studying_in_your_home_country = ifelse(as.character(studying_in_your_home_country) == "Yes", "0", as.factor(studying_in_your_home_country))) %>%
    # 0 is yes and 1 is no
    mutate(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD = ifelse(as.character(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD) == "Yes", "0", as.factor(have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD))) %>%
    # 0 is yes, 1 is no and 2 is prefer not to say
    select(-X1) # drop this column, prob was an error from cleaning
  
  ##### Model
  model<- lm(survey_data$university_has_long_hours_culture ~ survey_data$have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD)
  saveRDS(model, here::here(glue::glue(path, "model.rds")))
  
  ##### Plot
  plot = survey_data %>%
    ggplot(aes(x= university_has_long_hours_culture,y=have_you_sought_help_for_anxiety_or_depression_caused_by_your_PhD))+geom_smooth(method = "lm")+  theme_bw() + geom_point()+
    xlab("University has long hours culture") +
    ylab("Have you sought help for anxiety or depression caused by your PhD?") 
  
  ggsave(filename = "linearregression.png", device = 'png')
  
  print("Save plot to images folder")
  
}

main(opt$path, opt$datafilename)