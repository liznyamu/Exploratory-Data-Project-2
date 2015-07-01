## change directory
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## Load Data into R
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


## Query 6 - plot6.R
## Compare emissions from motor vehicle sources in Baltimore City
#with emissions from motor vehicle sources in Los Angeles County,
#California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?

#Load dplyr package
suppressWarnings(suppressMessages(library(dplyr)))

##Create a data frame tbl from "SCC" and "NEI" data frames
SCC <- tbl_df(SCC)
NEI <- tbl_df(NEI)

## select variables of interest from SCC data frame tbl :- SCC and EI.Sector
## use filter() to grepl() for "motor vehicle sources" - 
# the sources are marked as "On-Road" sources on SCC$EI.Sector variable
SCC_motorVehicles <- select(SCC, SCC, EI.Sector) %>%
  filter(grepl('On-Road', EI.Sector, ignore.case = TRUE))

##select Baltimore and Los Angeles, LA NEI data
baltimoreLAEmissons <- NEI %>%
  filter(fips == "24510"| fips == "06037" )

## use %in% operator - to select , 
# Baltimore and Los Angeles, LA, PM2.5 Emissions from motor vehicle,Mv, sources
baltimoreLAMvEmissions <- baltimoreLAEmissons[which(baltimoreLAEmissons$SCC %in% SCC_motorVehicles$SCC), ]

# convert "fips" variable in to a factor variable
baltimoreLAMvEmissions <- mutate(baltimoreLAMvEmissions, fips = as.factor(fips))

#provide valid and meaningful levels to the "fips" column
levels(baltimoreLAMvEmissions$fips) <- c("Los Angeles County", "Baltimore City")

## Summarise the data 
# group_by() "fips" and "year" of PM2.5 Emissions
# summarise on mean (*** indicate why mean() was chosen over sum())
SummaryEmissions <- baltimoreLAMvEmissions %>% 
  group_by(fips, year) %>%
  summarise(Totals_by_year = sum(Emissions, na.rm = TRUE),
            Count_by_year = n())

##The diffrence between the Total of Emissions in Baltimore 
#and in Los Angeles is too great to make a reasonable conclusion
# on which emission experiences a greater change over the 1999 - 2008
#period

## we shall put them on a similar scale/limit using percentages
# with assumption the mean pollution at 1999 is at "100%"
# we shall compute percentage changes since then to 2008
# link : https://class.coursera.org/exdata-015/forum/thread?thread_id=150

baltimoreSummary <- SummaryEmissions %>% 
  filter(fips == "Baltimore City") %>%
  mutate(from1999 = 100 * (
    (Totals_by_year - Totals_by_year[1]) / Totals_by_year[1]) )

losAngelesSummary <- SummaryEmissions %>% 
  filter(fips == "Los Angeles County") %>%
mutate(from1999 = 100 * (
  (Totals_by_year - Totals_by_year[1]) / Totals_by_year[1]) )

## rbind the baltimoreSummary and losAngelesSummary
SummaryEmissions <- rbind(losAngelesSummary, baltimoreSummary)

## Query 6 - plot6.R
# axis labels and graph title
mainTitle = paste("Baltimore City VS Los Angeles County ",
                  "\n Motor Vehicle Emissions \n 1999 - 2008",
                  sep = " ")
xlabel = "Year"
ylabel = "PM2.5 Emissions"

## Load ggplot2 package - messy data
library(ggplot2)
g <- ggplot(SummaryEmissions, aes(year, from1999 ))  
plot6 <- g + 
  geom_point() + 
  facet_grid(. ~ fips) + 
  geom_path() +
  labs(x = xlabel, y = ylabel, title = mainTitle)

ggsave(plot6, file="plot6.png", width=4.5, height=4.5, dpi=100)

plotLocation <- paste("plot6.png saved in \n Directory : ", getwd(), sep = " ")
message(plotLocation)