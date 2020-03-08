library(tidyverse)
library(here)

# Download file
download.file(url = "https://ndownloader.figshare.com/files/18543320?private_link=74a5ea79d76ad66a8af8",
              destfile = (here::here("data", "Nature_PhD_Survey.xlsx")),
              mode = 'wb')
# Read file
survey_raw <- readxl::read_xlsx(here::here("data", "Nature_PhD_Survey.xlsx"))

# Save as CSV for easier loading
write_csv(survey_raw, path = (here::here("data", "survey_raw.csv")))

# Print message
print("This script works!")
