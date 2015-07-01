## change directory
setwd("~/Documents/Bio Stats/4 Exploratory Data Analysis/project 2 data/exdata-data-NEI_data")

## load data into R
NEI <- readRDS("summarySCC_PM25.rds")

# Query 3 - plot3.R
## Of the four types of sources indicated by the 
#type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in 
#emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 
#1999–2008? 
##Use the ggplot2 plotting system to make a plot 
#answer this question.

## Load dplyr package
suppressWarnings(suppressMessages(library(dplyr)))

## Step 1. convert NEI data frame to a data frame tbl
NEI <- tbl_df(NEI)

## Step 2. "filter" data based on 
# Baltimore City ,Maryland, 'fips' = "24510"
## Step 3. "select" columns of interest :- 
# Emissions , year, type 
BaltimoreSummary <- NEI %>%
  filter(fips == "24510") %>%
  select(Emissions , year, type) %>%
  group_by(year, type) %>%
  summarise(Average_by_type = mean(Emissions, na.rm = TRUE),
            Count_by_type = n())



## Step 3. plot Emissions ~ year | sources
## Load ggplot2 package
library(ggplot2)


# Query 3 - plot3.png
## open png device, create "plot3.png" on working directory
g <- ggplot(BaltimoreSummary, aes(year, Average_by_type, 
                                  color = type))
plot3 <- g + 
  geom_point() +
  geom_path() + 
  ggtitle("Baltimore City - \nTotal PM2.5 Emissions Grouped by Source Type (1999-2008)")

ggsave(plot3, file="plot3.png", width=4.5, height=4.5, dpi=100)

## Brief Explanation
#compre first and last accepted graphs - showed decrease and increase on connected observations