## change directory
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## Load NEI and SCC Data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


## Query 5 - plot5.R
##How have emissions from motor vehicle sources 
#changed from 1999–2008 in Baltimore City?


#Load dyplyr package
suppressWarnings(suppressMessages(library(dplyr)))

##Create a data frame tbl from "SCC" and "NEI" data frames
SCC <- tbl_df(SCC)
NEI <- tbl_df(NEI)

#filter NEI by Baltimore City (fips == "24510")
NEI_Baltimore <- NEI %>%
  filter(fips == "24510")

## select variables of interest from SCC data frame tbl :- SCC and EI.Sector
## use filter() to grepl() for "motor vehicle sources" - 
# the sources are marked as "On-Road" sources on SCC$EI.Sector variable
SCC_motorVehicles <- select(SCC, SCC, EI.Sector) %>%
  filter(grepl('On-Road', EI.Sector, ignore.case = TRUE))

## use %in% operator - to select , Baltimore PM2.5 Emissions from motor vehicle,MV, sources
baltimoreMVEmissions <- NEI_Baltimore[which(NEI_Baltimore$SCC %in% SCC_motorVehicles$SCC), ]

## summarise the data by year
baltimoreMVSummary <- baltimoreMVEmissions %>%
  group_by(year) %>%
  summarise(Average_by_year = mean(Emissions, na.rm = TRUE), Average_count = n())

## Query 5 - plot5.png
## Load ggplot2 package - messy data
library(ggplot2)
# axis labels and graph title
mainTitle = "Baltimore Motor Vehicle Emissions \n 1999 - 2008"
xlabel = "Year"
ylabel = "PM2.5 Emissions"


#plot summary data 
g <- ggplot(baltimoreMVSummary, aes(year, Average_by_year))
plot5 <- g + geom_point() + geom_path() + labs(title = mainTitle,
                                               x = xlabel,
                                               y = ylabel)
ggsave(plot5, file="plot5.png", width=4.5, height=4.5, dpi=100)

plotLocation <- paste("plot5.png saved in \n Directory : ", getwd(), sep = " ")
message(plotLocation)


