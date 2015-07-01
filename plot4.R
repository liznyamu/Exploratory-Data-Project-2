## change directory to location of RDS files
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## Load data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Query 4 - plot4.R
# Across the United States,
# how have emissions from coal 
#combustion-related sources changed from 1999–2008?

## Load dplyr package
suppressWarnings(suppressMessages(library(dplyr)))

##Create a data frame tbl from "SCC" and "NEI" data frames
SCC <- tbl_df(SCC)
NEI <- tbl_df(NEI)

## select variables of interst from "SCC" data frame tbl
NEIofInterest <- select(NEI, SCC, Emissions, year)

##filter SCC$EI.Sector with grepl "Fuel Comb" and "coal" - with ignore case
# link http://stackoverflow.com/questions/22850026/filtering-row-which-contains-a-certain-string-using-dplyr
coalCombustion <- SCC %>%
    filter(
    grepl('Fuel Comb', EI.Sector , ignore.case = TRUE) ,
    grepl('coal', EI.Sector, ignore.case = TRUE)) 

## Merge data frame "NEIofInterest" and "coalCombustion"
# on common variable "SCC"
coalCombustionEmissions <- merge(NEIofInterest, coalCombustion)

## summarise the coalCombustionEmissions
coalCombustionSummary <- coalCombustionEmissions %>%
  group_by(year) %>%
  summarise(Totals_by_year = sum(Emissions), 
            Count_by_year = n())

## changes in coal combustion emissions from 1999 - 2008
# axis labels and graph title
mainTitle = "Coal Combustion Emissions \n 1999 - 2008"
xlabel = "Year"
ylabel = "PM2.5 Emissions"


## Query 4 - plot4.png
## Load ggplot2 package 
library(ggplot2)
#plot summary data 
g <- ggplot(coalCombustionSummary, aes(year, Totals_by_year))
plot4 <- g + geom_point() + geom_path() + labs(title = mainTitle,
                                      x = xlabel,
                                      y = ylabel)
ggsave(plot4, file="plot4.png", width=4.5, height=4.5, dpi=100)

plotLocation <- paste("plot4.png saved in \n Directory : ", getwd(), sep = " ")
message(plotLocation)

