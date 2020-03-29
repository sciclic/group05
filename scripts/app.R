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
survey_data <- read.csv(here::here("data", "survey_dash.csv"))

# FUNCTIONS

# plot 1: satisfaction now

satisfaction_now <- function(survey_data){
  
  data_to_plot <-
    survey_data %>%
    select(satisfaction_now, 
           satisfaction_decision,
           contact_hours,
           supervisor_relationship,
           PhD_weekly_hours,
           work_life_balance,
           reason_PhD) 
  
  satisfaction_now <- data_to_plot %>% ggplot(aes(y=satisfaction_now, fill=satisfaction_now)) + 
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
  
  satisfaction_now <- ggplotly(satisfaction, tooltip = 'text') %>% config(displayModeBar = FALSE)
  return(satisfaction_now)
  
}

# plot 2: satisfaction decision

satisfaction_decision <- function(survey_data){
  
  satisfaction_decision <- data_to_plot %>% ggplot(aes(y=satisfaction_decision, fill=satisfaction_decision)) +
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
  
  satisfaction_decision <- ggplotly(satisfaction_decision, tooltip = 'text') %>% config(displayModeBar = FALSE)
  return(satisfaction_decision)
  
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
graph1 = dccGraph(id='satisfaction_now',figure = make_plot())
graph2 = dccGraph(id='satisfaction_decision',figure = make_plot1())

# DROPDOWNS

clarityKey <- tibble(label=diamonds$clarity,
                     value=diamonds$clarity)
dropdown <- dccDropdown(
  id = "clarity-dropdown",
  options = map(
    1:nrow(clarityKey), function(i){
      list(label=clarityKey$label[i], value=clarityKey$value[i])
    }),
  value = "Fair"
)

# SLIDERS

cutKey <- levels(diamonds$cut)
slider <- dccSlider(id='my-slider',
                    min=1,
                    max=length(cutKey),
                    marks = setNames(as.list(cutKey), 
                                     c(1:length(cutKey))),
                    value = 2
)

# MARKDOWNS
source <- dccMarkdown("[Data Source](https://ggplot2.tidyverse.org/reference/diamonds.html)")
image_caption <- dccMarkdown('**Diamonds are pretty** and *here* is an image to prove it')
image <- dccMarkdown("![](https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/07/17/13/diamonds-black-background.jpg?w968)")

# SPECIFY APP LAYOUT

app$layout(
  htmlDiv(
    list(
      heading_title,
      heading_subtitle,
      #graphs and markdown components
      graph1,
      graph2,
      dropdown,
      slider,
      image,
      image_caption,
      source
    )
  )
)

# CALLBACKS

# RUN APP

app$run_server(debug=TRUE)

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")

