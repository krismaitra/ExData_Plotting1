library(data.table)

## This program assumes the downloaded and unzipped txt file exists in the working directory

#Read the header and convert it from list to character vector
header <- unlist(strsplit(readLines("household_power_consumption.txt", n = 1L), ";"), use.names = FALSE)

# Creates the complete path to the file in the working directory, 
# uses fread and grep to read the data for the two dates to be selected,
# interprets any '?' value as NA,
# attaches the column headers while reading,
# merges the data for the two dates
filename <- paste(getwd(), "household_power_consumption.txt", sep = "/")
data1 <- fread(paste("grep", "\\b1/2/2007", filename), na.strings = "?", 
               col.names = header, data.table = FALSE)
data2 <- fread(paste("grep", "\\b2/2/2007", filename), na.strings = "?", 
               col.names = header, data.table = FALSE)
data <- rbind(data1, data2)
rm(data1, data2)

#Converts the date and time columns into Date and Time variables
data$Time <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

#Plots the required representation
plot(data$Time, data$Sub_metering_2, lty = 1, pch = 46, xlab = "", 
     ylab = "Energy sub metering", col = "red", type = "n")
plot(data$Time, data$Sub_metering_3, lty = 1, pch = 46, xlab = "", 
     ylab = "Energy sub metering", col = "blue", type = "n")
plot(data$Time, data$Sub_metering_1, lty = 1, pch = 46, xlab = "", 
     ylab = "Energy sub metering", type = "n")
lines(data$Time, data$Sub_metering_1)
lines(data$Time, data$Sub_metering_2, col = "red")
lines(data$Time, data$Sub_metering_3, col = "blue")
legend("topright", lty = 1 , col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#Copies to png file of required size, saves and closes it
dev.copy(png, width = 480, height = 480, file = "plot3.png")
dev.off()