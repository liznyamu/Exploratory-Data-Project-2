## change directory - to location of rds files
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## Load Data
NEI <- readRDS("summarySCC_PM25.rds")


# Query 1 - plot1.R
#Have total emissions from PM2.5 decreased 
#in the United States from 1999 to 2008?
#Using the base plotting system, make a plot 
#showing the total PM2.5 emission from all sources 
#for each of the years 1999, 2002, 2005, and 2008.

# Query 1 - plot1.png
## open png device, create "plot1.png" on working directory
png(file = "plot1.png", width = 480, height = 480)

# Option 3 - Barplot (totals on each category):-

#Load dyplyr package
suppressWarnings(suppressMessages(library(dplyr)))

## create a data frame tbl
NEI <- tbl_df(NEI)

## "select" Emissions and year from "NEI" data frame tbl
# "group_by" year - on above result
# "summarise" - find total_by_year : sum(), count_by_year : n()
NEI_by_year <- NEI %>% 
  select (Emissions, year) %>%
  group_by(year) %>%
  summarise(Totals_by_year = sum(Emissions), Count_by_year = n())

# 3) barplot
## create a barplot - with vertical bars on NEI_by_year$Totals_by_year
# with names.args set to NEI_by_year$year
barplot(NEI_by_year$Totals_by_year,
        names.arg = NEI_by_year$year , 
        xlab = "Year", ylab = "PM2.5 Emission", 
        main = "PM2.5 Emission Totals by year")

# close png graphical device
dev.off()

## Brief Explanation -- the barplot above shows that the 
# PM2.5 Emission Total (group by Year), have been on a decrease
# which is good - in my opinion

