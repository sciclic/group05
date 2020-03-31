library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

# CREATE DASH INSTANCE
app <- Dash$new()


# LOAD IN DATASETS
survey_data <- read.csv(here::here("data", "survey_data.csv"))


# FUNCTIONS

make_plot <- function(){
  
  # gets the label matching the column value
  data <- survey_data
  p <- ggplot(data, aes(x = level_of_satisfaction_with_decision_to_pursue_a_PhD, y = supervisor_relationship)) +
    geom_jitter(alpha = 0.1) +
    xlab("Satisfaction with decicsion to pursure a PhD") +
    ylab("Quality of Supervisor Relationship") +
    ggtitle("Self-reported sastifaction with decision to pursue a PhD vs <<VARIBALE>> \n (1 being lowest rating)") +
    theme_minimal()
  
  # passing c("text") into tooltip only shows the contents of the "text" aesthetic specified above
  ggplotly(p)
}


# Storing the labels/values as a tibble
yaxisKey <- tibble(label = c("Quality of Supervisor Relationship", "Work-Life Balance", "Appropriateness of Mental Health Services for my Needs", "Amount to which University has long hour culture"),
                   value = c("supervisor_relationship", "work_life_balance", "mental_health_and_wellbeing_services_at_my_uni_are_appropriate_to_PhD_students_needs", "university_has_long_hours_culture"))

#Create the dropdown
yaxisDropdown <- dccDropdown(
  id = "y-axis",
  options = map(
    1:nrow(yaxisKey), function(i){
      list(label=yaxisKey$label[i], value=yaxisKey$value[i])
    }),
  value = "supervisor_relationship"
)

# "happiness variables" plots: satisfaction_now x
## 1 contact hours (x axis would be the different contact hours values, y axis is %, and then bars are coloured by level of satisfaction)
## 2 supervisor relationship
## 3 PhD weekly hours
## 4 work-life balance
## 5 reason why (chose PhD in first place)

# ASSIGN COMPONENTS TO VARIABLES
heading_title <- htmlH1('Finding satisfaction in your PhD')
heading_subtitle <- htmlH2('A data based approach to the sources of satisfaction in graduate school')

graph <- dccGraph(
  id = 'satisfaction-graph',
  figure = make_plot() # gets initial data using argument defaults
)

# SPECIFY APP LAYOUT

app$layout(
  htmlDiv(
    list(
      heading_title,
      heading_subtitle,
      #graphs and markdown components
      htmlLabel('Select predictor of satisfaction:'),
      yaxisDropdown,
      graph,
      htmlIframe(height=30, width=6, style=list(borderWidth = 0))
    )
  )
)

# CALLBACKS

# RUN APP

app$run_server(debug=TRUE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")
