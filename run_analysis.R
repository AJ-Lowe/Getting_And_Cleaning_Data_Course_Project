# Download file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/Alex/Desktop/RStudio/RProgramming/CourseProject/Data/Dataset.zip")

# Unzip file
unzip(zipfile="./Data/Dataset.zip",exdir="./Data")
path <- file.path("./Data", "UCI HAR Dataset")

# Read data for Activity, Subject & Features
ActivityTestData  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrainData <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

SubjectTrainData <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTestData  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

FeaturesTestData  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrainData <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

# Merge Training & Test data sets 
ActivityData <- rbind(ActivityTrainData, ActivityTestData)
SubjectData <- rbind(SubjectTrainData, SubjectTestData)
FeaturesData <- rbind(FeaturesTrainData, FeaturesTestData)

# Name the variables
names(ActivityData) <- c("activity")
names(SubjectData) <- c("subject")
FeaturesDataNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(FeaturesData) <- FeaturesDataNames$V2

# Merge full data set
CombinedData <- cbind(SubjectData, ActivityData)
Data <- cbind(FeaturesData, CombinedData)

# Extract measurements on mean & standard deviation 
FeaturesNamesSubset <- FeaturesDataNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesDataNames$V2)]
selectedNames <- c(as.character(FeaturesNamesSubset), "subject", "activity" )
Data <- subset(Data, select = selectedNames)

# Label data set with descriptive variable names
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("^t", "time", names(Data))

# Create 2nd tidy data set and output it
library(plyr);
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

# Produce codebook
library(knitr)
knit2html("codebook.md")