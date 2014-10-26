library(plyr)
library(reshape2)

## Read in Test data, Activity type (integer), and Subject number
test <- read.table("./data/UCI HAR Dataset//test//X_test.txt")
testActivity <- read.table ("./data//UCI HAR Dataset//test//y_test.txt")
testSubject <- read.table("./data//UCI HAR Dataset//test/subject_test.txt")

## Read in Training data, Activity type (integer), and Subject number.
train <- read.table("./data//UCI HAR Dataset//train//X_train.txt")
trainActivity <- read.table("./data/UCI HAR Dataset//train//y_train.txt")
trainSubject <- read.table("./data/UCI HAR Dataset//train/subject_train.txt")

## Read in variable names for Test data and Activity names
features <- read.table("./data//UCI HAR Dataset//features.txt")
activities <- read.table("./data//UCI HAR Dataset//activity_labels.txt")

## Apply variable names to training measurement data
colnames(train) <- features[[2]]
## Merge Subject number, Activity type (integer) and Traning measurements into one data frame
train <- cbind(trainSubject, trainActivity, train)
## Add names to first and second column for Subject and Activity
names(train)[1:2] <- c("Subject", "Activity")


## Apply variable names to test measurement data
colnames(test) <- features[[2]]
## Merge Subject number, Activity type (integer) and Test measurement into one data frame
test <- cbind(testSubject, testActivity, test)
## Add names to first and second column for Subject and Activity
names(test)[1:2] <- c("Subject", "Activity")

## Merge Train and Test data frames into one data frame
merged <- rbind(train, test)

## Filter data frame to only include columns containing the Standard Deviation (std) or Mean (mean).
## Also, preserve Subject and Activity
subset <- cbind(merged[1:2],merged[grep("std", colnames(merged))], merged[grep("mean", colnames(merged))])


## Loop through subset activity and replace activity integer with name
for (i in 1:length(subset)) {
     subset$Activity <- activities[subset$Activity,2]
}

## Clean up column names using gsub
names(subset) <- gsub("std", "Standard Deviation", names(subset))
## names(subset) <- gsub("-", ".", names(subset))
names(subset) <- gsub("[[:punct:]]", ".", names(subset))
names(subset) <- gsub("Acc", ".Accelerometer.", names(subset))
names(subset) <- gsub("Gyro", ".Gyroscope", names(subset))
names(subset) <- gsub("tBody", "Time.Domain.Body", names(subset))
names(subset) <- gsub("tBody", "Time.Domain.Body", names(subset))
names(subset) <- gsub("tGravity", "Time.Domain.Gravity", names(subset))
names(subset) <- gsub("fBody", "Fourier.Body", names(subset))
names(subset) <- gsub("fBody", "Fourier.Domain.Body", names(subset))
names(subset) <- gsub("fBodyBody", "Fourier.Body", names(subset))


## Create a new tidy data set that displays the average
## of each variable for each activity and subject

## melt data set and set Subject and Activity as ID
molten <- melt(subset, id=c("Subject", "Activity"))

## Cast data set and group by subject and activity
cast <- dcast(molten, Subject + Activity ~ variable, mean)


## Output tidy data set as .txt file
write.table(cast, file = "./data//tidyData.txt", row.name=FALSE)