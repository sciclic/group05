library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

#Create Dash instance

app <- Dash$new()

#Specify App layout
app$layout(
  htmlDiv(
    list(
      htmlH1('Hello world! This is the beginnings of a cool dashboard'),
      htmlH2('This is a subheading of said cool dashboard')
    )
  )
)

#Run app

app$run_server(debug=TRUE)

