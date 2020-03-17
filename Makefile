

# Load-in Data
survey_raw.csv : scripts/load.R
	Rscript scripts/load.R "https://ndownloader.figshare.com/files/18543320?private_link=74a5ea79d76ad66a8af8"

# Clean Data
survey_data.csv : scripts/clean.R
	Rscript scripts/clean.R --filepath="data/survey_raw.csv"

# Exploratory Data Analysis
images/basic_demographics1.png images/satisfaction_v_supervis_relationship.png images/satisfaction_v_work_life_bal.png : scripts/EDA.R
	Rscript scripts/EDA.R --filepath="data/survey_data.csv"

# Knit report


clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html