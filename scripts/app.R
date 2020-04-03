library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(ggplot2)
library(plotly)
library(ggsci)
library(gapminder)

# CREATE DASH INSTANCE
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


# LOAD IN DATASETS
survey_data <- read.csv(here::here("data", "survey_dash.csv"))


# FUNCTIONS

# plot 1
make_plot <- function(yaxis = "supervisor_relationship"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # gets the label matching the column value
  data <- survey_data
  p <- ggplot(data, aes(x = satisfaction_decision, y = !!sym(yaxis))) +
    geom_jitter(alpha = 0.12,
                color = "#E6C350") +
    xlab("Satisfaction with decision to pursue a PhD") +
    ylab(y_label) +
    ggtitle(paste0("Self-reported satisfaction with decision to pursue a PhD vs ", y_label, " \n (1 being lowest rating)")) +
    theme_minimal() +
    theme(axis.text.x=element_text(angle = 30, hjust=1))
  
  # passing c("text") into tooltip only shows the contents of the "text" aesthetic specified above
  ggplotly(p)
}

# plot 2 
satisfaction_decision <- function(ageslider = "1"){
  sliderTibble <- tibble(label = levels(survey_data$age), value = c(1:length(levels(survey_data$age))))
  slider_label <- sliderTibble$label[sliderTibble$value == ageslider]
  p1 <- survey_data %>% 
    filter(age == slider_label) %>%
    ggplot(aes(y=satisfaction_decision, fill=satisfaction_decision)) + 
    geom_bar() +
    scale_fill_simpsons(alpha=0.6) +
    theme_minimal() +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          legend.position = "none",
          axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          plot.title = element_text(size = 16, hjust = 0.35)) + 
    ggtitle("Self-reported satisfaction with decision to pursue a PhD by age") 
  
  ggplotly(p1) 
  
}

# DROPDOWN
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

# SLIDER
# quickly drop the 'prefer not to say'
x <- c("18-24","25-34","35-44","45-54","55-64",">65")
slider <- dccSlider(id='ageslider',
                    min=1,
                    max=length(x),
                    marks = setNames(as.list(x), 
                                     c(1:length(x))),
                    value = "1"
)


# ASSIGN COMPONENTS TO VARIABLES
heading_title <- htmlH1('Finding satisfaction in your PhD')
heading_subtitle <- htmlH3('A data based approach to the sources of satisfaction in graduate school')
description <- dccMarkdown("   In Nature's yearly survey of over 6000 graduate students, 
positives outweigh the negatives. 
75% of students pursuing graduate research are at least somewhat satisfied with their decision to pursue a career on doctoral research. 
Nonetheless, survey questions that dig into the mental health toll of this career path reveal a perilous journey for most. 
With 36% of respondents reporting the need to seek help for anxiety or depression triggered by their studies, 
and a similar percentage declaring that their university does not promote a healthy work-life balance, 
survey answers in this area raise concerns about the mental health status of doctoral students. 
Harrasment and bullying also remain distressingly commonplace.
   **In our project, we aim to investigate the relationship between these two question areas 
(mental health & feelings of harrasment/bullying) and other variables that we hypothesise may be related to positive and/or negative outcomes.** 
For example, are those pursuing a degree far from home more likely to suffer from anxiety and depression? Are instances of harrasment and/or bullying male-biased? 
In an effort to shed some light into the matter, we will study these questions in detail.")
source <- dccMarkdown("[Data Source](https://www.nature.com/articles/d41586-019-03459-7)")

graph <- dccGraph(
  id = 'satisfaction-graph',
  figure = make_plot() # gets initial data using argument defaults
)

satisfaction_decision <- dccGraph(
  id = 'satisfaction_decision',
  figure = satisfaction_decision() # gets initial data using argument defaults
)


# SPECIFY LAYOUT ELEMENTS

div_header <- htmlDiv(
  list(heading_title,
       heading_subtitle
  ), style = list(backgroundColor = '#E6C350',
                  textAlign = 'left',
                  color = 'white',
                  margin = 0,
                  marginTop = 0,
                  'padding' = 10)
)

div_sidebar <- htmlDiv(
  list(
    description,
    
    htmlBr(),
    
    htmlBr(),
    
    source
  ), style = list('flex-basis' = '25%',
                  backgroundColor = '#A8A497',
                  textAlign = 'left',
                  color = 'white',
                  margin = 5,
                  marginTop = 0,
                  'padding' = 10)
)

div_main <- htmlDiv(
  list(htmlBr(),
       htmlLabel('Select predictor of satisfaction:'),
       yaxisDropdown,
       htmlBr(),
       graph,
       htmlBr(),
       htmlBr(),
       htmlBr(),
       htmlLabel('Filter by age range :'),
       slider,
       htmlBr(),
       satisfaction_decision,
       htmlBr(),
       htmlBr()
  ), style = list('flex-basis' = '70%',
                  'justify-content' = 'center',
                  'padding' = 20)
)


# SPECIFY APP LAYOUT

app$layout(
  div_header,
  htmlDiv(
    list(
      div_sidebar,
      div_main
      #div_main1
    ), style = list('display' = 'flex',
                    backgroundColor = '#FOF6F7FF')
  )
)


# CALLBACKS
app$callback(
  #update figure of satisfaction-graph
  output=list(id = 'satisfaction-graph', property='figure'),
  #based on values of year, continent, y-axis components
  params=list(input(id = 'y-axis', property='value')),
  #this translates your list of params into function arguments
  function(yaxis_value) {
    make_plot(yaxis_value)
  })

app$callback(
  #update figure of satisfaction_decision
  output=list(id = 'satisfaction_decision', property='figure'),
  #based on values of age slider
  params=list(input(id = 'ageslider', property='value')),
  #this translates your list of params into function arguments
  function(ageslider_value) {
    satisfaction_decision(ageslider_value)
  })


# RUN APP
app$run_server(debug=FALSE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")
