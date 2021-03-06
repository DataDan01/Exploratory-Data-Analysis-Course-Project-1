##Reading in the data.
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile = "./elect.txt.zip")

library(data.table)

unzip("./elect.txt.zip")

elect<-fread("./household_power_consumption.txt",na.strings="?")

##Subsetting and reformatting.
elect.sub<-elect[Date == "1/2/2007" | Date == "2/2/2007"]

library(lubridate)

##Convert the "Date" column, which contains characters, into actual dates.
elect.sub<-elect.sub[,Date:=dmy(Date)]

##Do the same thing for time.
elect.sub<-elect.sub[,Time:=hms(Time)]

##Make everything else into a numeric. 
elect.sub<-cbind(elect.sub[,1:2,with=F],apply(elect.sub[,3:9,with=F],2,as.numeric))

##Creating a new column with the date and time combined. 
elect.sub<-elect.sub[,FullTime:=(elect.sub[,Date] + elect.sub[,Time])]



##Plotting + Exporting the plot to a 480 x 480 PNG
png(filename = "Plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))

##1
plot(x=elect.sub[,FullTime],y=elect.sub[,Global_active_power], ##What to plot
     type="line", ##Plot it as a line
     xlab="", ##Leave the x-axis label blank
     ylab="Global Active Power") ##y-axis label

##2
plot(x=elect.sub[,FullTime],y=elect.sub[,Voltage], ##What to plot
     type="line", ##Plot it as a line
     xlab="datetime", ##Leave the x-axis label blank
     ylab="Voltage") ##y-axis label

##3
plot(x=elect.sub[,FullTime],y=elect.sub[,Sub_metering_1],type="n",xlab="",ylab="Energy sub metering")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_1],col="black")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_2],col="red")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_3],col="blue")
legend("topright",lwd=2,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")

##4
plot(x=elect.sub[,FullTime],y=elect.sub[,Global_reactive_power], ##What to plot
     type="line", ##Plot it as a line
     xlab="datetime", ##Leave the x-axis label blank
     ylab="Global_reactive_power") ##y-axis label

dev.off()