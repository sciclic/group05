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

make_plot <- function(yaxis = "Quality of Supervisor Relationship"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # gets the label matching the column value
  data <- survey_data
  p <- ggplot(data, aes(x = level_of_satisfaction_with_decision_to_pursue_a_PhD, y = !!sym(yaxis))) +
    geom_jitter(alpha = 0.1) +
    xlab("Satisfaction with decicsion to pursure a PhD") +
    ylab(y_label) +
    ggtitle(paste0("Self-reported sastifaction with decision to pursue a PhD vs ", y_label, " \n (1 being lowest rating)")) +
    theme_minimal()
  
  # passing c("text") into tooltip only shows the contents of the "text" aesthetic specified above
  ggplotly(p)
}



# "happiness variables" plots: satisfaction_now x
## 1 contact hours (x axis would be the different contact hours values, y axis is %, and then bars are coloured by level of satisfaction)
## 2 supervisor relationship
## 3 PhD weekly hours
## 4 work-life balance
## 5 reason why (chose PhD in first place)

# ASSIGN COMPONENTS TO VARIABLES
heading_title <- htmlH1('Finding satisfaction in your PhD')
heading_subtitle <- htmlH2('A data based approach to the sources of satisfaction in graduate school')
description <- dccMarkdown("[description of dataset needed here]")
source <- dccMarkdown("[Data Source](https://www.nature.com/articles/d41586-019-03459-7)")

graph <- dccGraph(
  id = 'satisfaction-graph',
  figure = make_plot() # gets initial data using argument defaults
)


# SPECIFY LAYOUT ELEMENTS

div_header <- htmlDiv(
  list(heading_title,
       heading_subtitle
  ), style = list(
    backgroundColor = '#337DFF', ## COLOUR OF YOUR CHOICE
    textAlign = 'center',
    color = 'white',
    margin = 5,
    marginTop = 0
  )
)

div_sidebar <- htmlDiv(
  list(
       description,
       htmlBr(),
       htmlBr(),
       source
  ), style = list('flex-basis' = '30%')
)

div_main <- htmlDiv(
  list(htmlLabel('Select predictor of satisfaction:'),
       yaxisDropdown,
       graph
  )
)


# SPECIFY APP LAYOUT

app$layout(
  div_header,
  htmlDiv(
    list(
      div_sidebar,
      div_main
    ), style = list('display' = 'flex')
  )
)


# CALLBACKS
app$callback(
  #update figure of gap-graph
  output=list(id = 'satisfaction-graph', property='figure'),
  #based on values of year, continent, y-axis components
  params=list(input(id = 'y-axis', property='value')),
  #this translates your list of params into function arguments
  function(yaxis_value) {
    make_plot(yaxis_value)
  })


# RUN APP
app$run_server(debug=FALSE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")
