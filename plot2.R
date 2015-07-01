## change directory to location of RDS files
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## Load Data into R
NEI <- readRDS("summarySCC_PM25.rds")


# Query 2 - plot2.R
## Have total emissions from PM2.5 decreased
# in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? 
## Use the base plotting system to make a 
# plot answering this question.


## Load dplyr package
suppressWarnings(suppressMessages(library(dplyr)))

# convert "NEI" data frame to a data frame tbl
NEI <- tbl_df(NEI)

# filter the "NEI" data frame tbl by fips == "24510"
# select the Emissions and year columns
Baltimore_by_year <- NEI %>% 
  filter(fips == "24510") %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Totals_by_year = sum(Emissions), 
            Count_by_year = n())

# Query 2 - plot2.png
## open png device, create "plot2.png" on working directory
png(file = "plot2.png", width = 480, height = 480)

## Create a barplot with vertical bars,
# on total PM2.5 emissions (grouped by year)
barplot(Baltimore_by_year$Totals_by_year, 
        names.arg = Baltimore_by_year$year,
        xlab = "Year", ylab = "PM2.5 Emission Totals",
        main = "Baltimore City, Maryland - PM2.5 Emission Totals by year")

# close png graphical device
dev.off()  

## Brief Explanation : PM2.5 Emissions decreased in 2002 
# and 2008  but had an increase in 2005

