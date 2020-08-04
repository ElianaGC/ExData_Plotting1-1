library(tidyverse)
library(lubridate)


fileUrl<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'

#reading the data
temp <- tempfile()
download.file(fileUrl,temp)
filList <- unzip(temp) 
data <- read.csv('./household_power_consumption.txt', header=TRUE, sep = ";", na.strings="?")

#subsetting

data$date_time<-dmy_hms(paste0(data$Date, data$Time))
data3<-data %>% mutate(Date=dmy(Date), Time=hms(Time)) %>%        
        filter(Date == ymd('2007-02-01') | Date == ymd('2007-02-02')) %>% 
        arrange(date_time)
ind<-wday(data3$Date, label=TRUE)==c('Thu','Fri','Sat')
dev.set()
png(filename = "./plot3.png", width = 480, height = 480,
    units = "px", pointsize = 12, bg = "white")
plot(data3$date_time[ind], as.numeric(data3$Sub_metering_1[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='black',ylim=c(0,40))
lines(data3$date_time[ind], as.numeric(data3$Sub_metering_2[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='red')
lines(data3$date_time[ind], as.numeric(data3$Sub_metering_3[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='blue')
legend("topright",legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),col=c("black","red", "blue"), lty=1)
dev.off()