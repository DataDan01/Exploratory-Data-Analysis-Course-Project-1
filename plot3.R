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
png(filename = "Plot3.png", width = 480, height = 480)

plot(x=elect.sub[,FullTime],y=elect.sub[,Sub_metering_1],type="n",xlab="",ylab="Energy sub metering")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_1],col="black")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_2],col="red")
lines(elect.sub[,FullTime],elect.sub[,Sub_metering_3],col="blue")
legend("topright",lwd=2,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()