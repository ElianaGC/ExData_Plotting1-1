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
png(filename = "./plot4.png", width = 480, height = 480,
    units = "px", pointsize = 12, bg = "white")

par(mfrow = c(2, 2), mar = c(4, 4, 2,1), oma = c(0, 0, 2, 0))

plot(data3$date_time[ind], as.numeric(data3$Global_active_power[ind]),type="l",ylab='Global Active Power', xlab='')

plot(data3$date_time[ind], as.numeric(data3$Voltage[ind]),type="l",ylab='Voltage', xlab='datetime')


plot(data3$date_time[ind], as.numeric(data3$Sub_metering_1[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='black',ylim=c(0,40))
lines(data3$date_time[ind], as.numeric(data3$Sub_metering_2[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='red')
lines(data3$date_time[ind], as.numeric(data3$Sub_metering_3[ind]),type="l",ylab='Energy sub metering', xlab=' ', col='blue')
legend("topright",legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),col=c("black","red", "blue"), lty=1,text.font=7,bty = "n")

plot(data3$date_time[ind], as.numeric(data3$Global_reactive_power[ind]),type="l",ylab='Global_reactive_power', xlab='datetime')

dev.off()


############### Another way

power <- read.table("./household_power_consumption.txt",skip=1,sep=";")
names(power) <- c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
subpower <- subset(power,power$Date=="1/2/2007" | power$Date =="2/2/2007")

# Transforming the Date and Time vars from characters into objects of type Date and POSIXlt respectively
subpower$Date <- as.Date(subpower$Date, format="%d/%m/%Y")
subpower$Time <- strptime(subpower$Time, format="%H:%M:%S")
subpower[1:1440,"Time"] <- format(subpower[1:1440,"Time"],"2007-02-01 %H:%M:%S")
subpower[1441:2880,"Time"] <- format(subpower[1441:2880,"Time"],"2007-02-02 %H:%M:%S")


# initiating a composite plot with many graphs
par(mfrow=c(2,2))

# calling the basic plot function that calls different plot functions to build the 4 plots that form the graph
with(subpower,{
        plot(subpower$Time,as.numeric(as.character(subpower$Global_active_power)),type="l",  xlab="",ylab="Global Active Power")  
        plot(subpower$Time,as.numeric(as.character(subpower$Voltage)), type="l",xlab="datetime",ylab="Voltage")
        plot(subpower$Time,subpower$Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")
        with(subpower,lines(Time,as.numeric(as.character(Sub_metering_1))))
        with(subpower,lines(Time,as.numeric(as.character(Sub_metering_2)),col="red"))
        with(subpower,lines(Time,as.numeric(as.character(Sub_metering_3)),col="blue"))
        legend("topright", lty=1, col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), cex = 0.6)
        plot(subpower$Time,as.numeric(as.character(subpower$Global_reactive_power)),type="l",xlab="datetime",ylab="Global_reactive_power")
})
