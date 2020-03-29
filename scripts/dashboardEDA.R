
"This script performs some exploratory EDA for the construction of our dashboard. 

Usage: dashboardEDA.R --filepath=<filepath>

" -> doc

# setup
library(here)
library(tidyverse)
library(ggplot2)
library(plyr)
library(devtools)
library(ggsci)
library(hrbrthemes)
library(greybox)

opt <- docopt(doc)

main <- function(filepath){

# LOAD DATA
survey_data <- read.csv(here::here("data", "survey_dash.csv"))

# LAST MINUTE FIX
## rename
survey_data <-
  survey_data %>%
  dplyr::rename(satisfaction_decision = level_of_satisfaction_with_decision_to_pursue_a_PhD,
         satisfaction_now = level_of_satisfaction_since_starting_grad_school,
         contact_hours = one_on_one_contact_w_supervisor,
         reason_PhD = most_important_reason_to_enroll_PhD)

## data to plot
data_to_plot <-
  survey_data %>%
  select(satisfaction_now, 
         satisfaction_decision,
         contact_hours,
         supervisor_relationship,
         PhD_weekly_hours,
         work_life_balance,
         reason_PhD) 

# EDA

# plot 1: satisfaction now
data_to_plot %>% ggplot(aes(y=satisfaction_now, fill=satisfaction_now)) + 
  geom_bar() +
  scale_fill_simpsons(alpha=0.6) +
  theme_bw() +
  theme_ipsum_rc() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(size = 16, hjust = 0.35)) +
  ggtitle("How has your level of satisfaction changed since starting graduate school?") 

ggsave(path=(here::here("images")), filename = "satisfaction_now.png", device = 'png')
print("Save satisfaction_now plot")

# plot 2: satisfaction decision
data_to_plot %>% ggplot(aes(y=satisfaction_decision, fill=satisfaction_decision)) +
  geom_bar() +
  scale_fill_simpsons(alpha=0.6) +
  theme_bw() +
  theme_ipsum_rc() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        legend.position = "none",
        axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        plot.title = element_text(size = 16, hjust = 0.65)) +
  ggtitle("How satisfied are you with your decision to pursue a PhD?") 

ggsave(path=(here::here("images")), filename = "satisfaction_decision.png", device = 'png')
print("Save satisfaction_decision plot")

# cramer's v with 'greybox' package https://cran.r-project.org/web/packages/greybox/vignettes/maUsingGreybox.html
tableplot(data_to_plot$satisfaction_now, data_to_plot$satisfaction_decision) # slightly, but those that were already satisfied w decision are even more satisfied now

# plot 3: satisfaction before & after (satisfaction now x satisfaction then) - following the above rationale

# plot 4: satisfaction now x
## 4.1 contact hours
## 4.2 supervisor relationship
## 4.3 PhD weekly hours
## 4.4 work-life balance
## 4.5 reason why (chose PhD in first place)


# Save object
write.csv(survey_data, here::here("data", "survey_dash.csv"))

#Print complete message
print("EDA for Dashboard is complete!")
}

main(opt$filepath)
