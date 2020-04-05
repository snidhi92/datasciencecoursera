#setwd("D:/Cousera/Reproducible")
#getwd()
# Load data
if (!file.exists("activity.csv") )
{
  dlurl <- 'http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip'  
  download.file(dlurl,destfile='repdata%2Fdata%2Factivity.zip',mode='wb')  
  unzip('repdata%2Fdata%2Factivity.zip')
}

# Read data
data <- read.csv("activity.csv")  
#Calculate the total number of steps taken per day
steps_by_day <- aggregate(steps ~ date, data, sum)
hist(steps_by_day$steps, main = paste("Total Steps Each Day"), col="green",xlab="Number of Steps")

#Mean and median number of steps taken each day
rmean <- mean(steps_by_day$steps)
rmean
rmedian <- median(steps_by_day$steps)
rmedian

#What is the average daily activity pattern?
steps_by_interval <- aggregate(steps ~ interval, data, mean)
plot(steps_by_interval$interval,steps_by_interval$steps, type="l", xlab="Interval", ylab="Number of Steps",main="Average Number of Steps per Day by Interval")
max_interval <- steps_by_interval[which.max(steps_by_interval$steps),1]
max_interval

#Code to describe and show a strategy for imputing missing data
NATotal <- sum(!complete.cases(data))
NATotal
StepsAverage <- aggregate(steps ~ interval, data = data, FUN = mean)
fillNA <- numeric()
for (i in 1:nrow(data)) {
  obs <- data[i, ]
  if (is.na(obs$steps)) {
    steps <- subset(StepsAverage, interval == obs$interval)$steps
  } else {
    steps <- obs$steps
  }
  fillNA <- c(fillNA, steps)
}
new_activity <- data
new_activity$steps <- fillNA
StepsTotalUnion <- aggregate(steps ~ date, data = new_activity, sum, na.rm = TRUE)
hist(StepsTotalUnion$steps, main = paste("Total Steps Each Day"), col="blue", xlab="Number of Steps")


#Create Histogram to show difference. 
hist(steps_by_day$steps, main = paste("Total Steps Each Day"), col="green", xlab="Number of Steps", add=T)
legend("topright", c("Imputed", "Non-imputed"), col=c("blue", "green"), lwd=10)

rmeantotal <- mean(StepsTotalUnion$steps)
rmeantotal
rmediantotal <- median(StepsTotalUnion$steps)
rmediantotal
rmediandiff <- rmediantotal - rmedian
rmediandiff
rmeandiff <- rmeantotal - rmean
rmeandiff

#Are there differences in activity patterns between weekdays and weekends?
weekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", 
              "Friday")
new_activity$dow = as.factor(ifelse(is.element(weekdays(as.Date(new_activity$date)),weekdays), "Weekday", "Weekend"))
StepsTotalUnion <- aggregate(steps ~ interval + dow, new_activity, mean)
library(lattice)
xyplot(StepsTotalUnion$steps ~ StepsTotalUnion$interval|StepsTotalUnion$dow, main="Average Steps per Day by Interval",xlab="Interval", ylab="Steps",layout=c(1,2), type="l")
