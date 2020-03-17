#This Makefile can be used to execute the entire data analysis, from importing dataframe to kniting the report.

# Declare which targets are .phony
.PHONY: all clean

# Run full analysis with all
all: docs/finalreport.html docs/finalreport.pdf

# Load-in Data
survey_raw.csv : scripts/load.R
	Rscript scripts/load.R "https://ndownloader.figshare.com/files/18543320?private_link=74a5ea79d76ad66a8af8"

# Clean Data
survey_data.csv : scripts/clean.R
	Rscript scripts/clean.R --filepath="data/survey_raw.csv"

# Exploratory Data Analysis
images/basic_demographics1.png images/satisfaction_v_supervis_relationship.png images/satisfaction_v_work_life_bal.png : scripts/EDA.R
	Rscript scripts/EDA.R --filepath="data/survey_data.csv"

# Logistic Regression Analysis
images/logisticregression.png images/logisticregression2.png images/logisticregression3.png images/logisticregression4.png images/logisticregression5.png images/logisticregression6.png images/logisticregression7.png : scripts/analysis.R
	Rscript scripts/analysis.R --data_path="data/" --data_file="survey_data.csv"

# Knit report



clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html