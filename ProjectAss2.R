## change directory
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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

# 1)using dplyr package - group data by year 
## suppress warning messages and load "dplyr" package into R
> suppressWarnings(library(dplyr))
## create a data frame tbl
> NEI <- tbl_df(NEI)
## "select" Emissions and year from "NEI" data frame tbl
# "group_by" year - on above result
# "summarise" - find total_by_year : sum(), count_by_year : n()
> NEI %>% select (Emissions, year) %>%
  +     group_by(year) %>%
  + summarise(Totals_by_year = sum(Emissions), Count_by_year = n())

Source: local data frame [4 x 3]

# year Totals_by_year Count_by_year
# 1 1999        7332967       1108469
# 2 2002        5635780       1698677
# 3 2005        5454703       1713850
# 4 2008        3464206       1976655

> NEI_by_year <- NEI %>% 
  +     select (Emissions, year) %>%
  +     group_by(year) %>%
  +     summarise(Totals_by_year = sum(Emissions), Count_by_year = n())

# 3) barplot
## create a barplot - with vertical bars on NEI_by_year$Totals_by_year
# with names.args set to NEI_by_year$year
barplot(NEI_by_year$Totals_by_year,
        names.arg = NEI_by_year$year , 
        xlab = "Year", ylab = "PM2.5 Emission", 
        main = "PM2.5 Emission Totals by year")

# close png graphical device
dev.off()


