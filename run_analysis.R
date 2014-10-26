#run_analysis.R
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Check if dplyr library loaded, if not install and load
if(!require(dplyr)){
  install.packages("dplyr")
  if(!require(dplyr)) {
    stop("could not install dplyr")  
  }
  library(dplyr)
}

#Define dataset URL and destination filename
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "UCI HAR Dataset.zip"

#If file don't exists, download Raw Dataset
if(!file.exists(destFile)){
  download.file(dataURL, destFile)
}

#If directory don't exists, uzip Raw Dataset
if(!file.exists("UCI HAR Dataset")){
  unzip(destFile)
}


#1.Merges the training and the test sets to create one data set.

#Load training data
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainData <- cbind(trainSubjects, trainY, trainX)

#Load test data
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testData <- cbind(testSubjects, testY, testX)

#Combine 'trainData' & 'testDatat' into 'Data' using 'rbind'
Data <- rbind(trainData, testData)


#2.Extracts only the measurements on the mean and standard deviation for each measurement. 

#Load features
features <- read.table("UCI HAR Dataset/features.txt")

#Create columns names based on features and add 'Subject' and 'Activity'
ColNames <- append(c("Subject", "Activity"), as.character(features[[2]]))

# Set the column names of 'Data'
colnames(Data) <- ColNames

#Use 'grep' to get column index of 'Subject', 'Activity' and
#measurements that contains the text 'mean()' and 'std()'
RequiredCols <- sort(c(grep("(Subject|Activity)", x = ColNames),
                  grep("mean()", x = ColNames, fixed=TRUE),
                  grep("std()", x = ColNames, fixed=TRUE)))

#Keep only the required columns
Data <- Data[,RequiredCols]


#3.Uses descriptive activity names to name the activities in the data set

#Load activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#Replace '_' with ' ' and set to lower case
activities[, 2] = gsub("_", " ", tolower(as.character(activities[, 2])))

#Match each activity integer in 'Data' with the corresponding activity labels 
Data$Activity <- activities[match(Data$Activity, activities[, 1]), 2]


#4.Appropriately labels the data set with descriptive variable names. 

#Extract the current variable names from 'Data'
colNames <- colnames(Data)

#Replace 'BodyBody' with 'Body'
colNames <- gsub(pattern = "BodyBody", "Body", colNames)

#Replace 't/f' with 'time/frequency' and add '_'
colNames <- gsub(pattern = "^t", "Time_", colNames)
colNames <- gsub(pattern = "^f", "Frequency_", colNames)

#Separate the description with '_'
colNames <- gsub(pattern = "Body", "Body_", colNames)
colNames <- gsub(pattern = "Gravity", "Gravity_", colNames)
colNames <- gsub(pattern = "Jerk", "Jerk_", colNames)

#Replace 'Acc' with 'Acceleration', 'Gyro' with 'AngularVelocity', 
#'Mag' with 'Magnitude' and add '_'
colNames <- gsub(pattern = "Acc", "Acceleration_", colNames)
colNames <- gsub(pattern = "Gyro", "AngularVelocity_", colNames)
colNames <- gsub(pattern = "Mag", "Magnitude_", colNames)

#Replace '-mean()' with 'Mean', '-std()' with 'Std'
colNames <- gsub(pattern = "-mean()", "Mean", colNames, fixed=TRUE)
colNames <- gsub(pattern = "-std()", "Std", colNames, fixed=TRUE)

#Update column names of 'Data'
colnames(Data)  <- colNames


#5.From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

#Use 'summarise_each' to group observations first by subject, then by activity
#and report the mean for other columns
Data2 <- group_by(Data, Subject, Activity) %>% 
  summarise_each(funs(mean))

#Check if folder 'tidy' exists, if not create folder
if(!file.exists("UCI HAR Dataset/tidy")){
  dir.create("UCI HAR Dataset/tidy/")
}

#Save the new data frame into 'tidy' folder using 'write.table' with 'row.names=FALSE'
write.table(Data2, file = "UCI HAR Dataset/tidy/tidy.txt",row.names=FALSE)