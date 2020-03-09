library(tidyverse)
library(dplyr)
library(ggplot2)

#Load in survey_data csv file
survey_data <- read.csv(here::here("data", "survey_data.csv"))
view(survey_data)

