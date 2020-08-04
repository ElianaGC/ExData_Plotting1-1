library(tidyverse)
library(lubridate)


fileUrl<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#reading the data
temp <- tempfile()
download.file(fileUrl,temp)
filList <- unzip(temp) 
data <- read.csv('./household_power_consumption.txt', header=TRUE, sep = ";",  na.strings="?")

#subsetting
data3<-data %>% mutate(Date=dmy(Date), Time=hms(Time)) %>%
        filter(Date == ymd('2007-02-01') | Date == ymd('2007-02-02')) %>% 
        arrange(Date, Time) %>% 
        mutate(date_time=ymd_hms(paste(Date, Time)))
ind<-wday(data3$Date, label=TRUE)==c('Thu','Fri','Sat')
dev.set()
png(filename = "./plot2.png", width = 480, height = 480,
    units = "px", pointsize = 12, bg = "white")
plot(data3$date_time[ind], as.numeric(data3$Global_active_power[ind]),type="l",ylab='Global Active Power (kilowatts)', xlab='')
dev.off()

