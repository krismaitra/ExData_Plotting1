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
par(mfrow=c(2,2))

#Plot 1
with(
    data,
    plot(Time, Global_active_power, lty = 1, pch = 46, 
         xlab = "", ylab = "Global Active Power", 
         lines(Time, Global_active_power))
)


#Plot 2
with(
    data,
    plot(Time, Voltage, lty = 1, pch = 46, xlab = "datetime",
         ylab = "Voltage", lines(Time, Voltage))
)

#Plot 3
with(
    data,
    plot(c(Time,Time,Time), c(Sub_metering_2, Sub_metering_3, Sub_metering_1),
         lty = 1, pch = 46, xlab = "", 
         ylab = "Energy sub metering", 
         col = c("red","blue","black"),
         c(lines(Time, Sub_metering_2, col = "red"),
         lines(Time, Sub_metering_3, col = "blue"),
         lines(Time, Sub_metering_1))
    )
#    plot(Time, Sub_metering_2, lty = 1, pch = 46, xlab = "", 
#         ylab = "Energy sub metering", col = "red", type = "n",
#         lines(Time, Sub_metering_2, col = "red")),
#    plot(Time, Sub_metering_3, lty = 1, pch = 46, xlab = "", 
#         ylab = "Energy sub metering", col = "blue", type = "n",
#         lines(Time, Sub_metering_3, col = "blue")),
#    plot(Time, Sub_metering_1, lty = 1, pch = 46, xlab = "", 
#         ylab = "Energy sub metering", type = "n", 
#         lines(Time, Sub_metering_1))
)
legend("topright", lty = 1 , col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex = 0.8, pt.cex = cex,
       box.lty = 0, inset = 0.01)


#Plot 4
with(
    data,
    plot(Time, Global_reactive_power, lty = 1, pch = 46,
         xlab = "datetime", ylab = "Global_reactive_power",
         lines(Time, Global_reactive_power))    
)

#Copies to png file of required size, saves and closes it
dev.copy(png, width = 480, height = 480, file = "plot4.png")
dev.off()