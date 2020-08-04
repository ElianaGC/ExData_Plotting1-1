#Reading the data
#memory_required <- 2075259 * 9 * 8 /10^6 # in MB

#libraries
library(tidyverse)
library(lubridate)

fileUrl<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#reading the data
temp <- tempfile()
download.file(fileUrl,temp)
filList <- unzip(temp) 
data <- read.csv('./household_power_consumption.txt', header=TRUE, sep = ";", na.strings="?")

#subsetting
data2<-data %>% mutate(Date=dmy(Date), Time=hms(Time)) %>%
        filter(Date == ymd('2007-02-01') | Date == ymd('2007-02-02')) 

# plotting
dev.set()
png(filename = "./plot1.png", width = 480, height = 480,
    units = "px", pointsize = 12, bg = "white")
hist(as.numeric(data2$Global_active_power), col='red', 
     main='Global Active Power', xlab='Global Active Power (kilowatts)', 
     ylab='Frequency',breaks =13)
dev.off()
