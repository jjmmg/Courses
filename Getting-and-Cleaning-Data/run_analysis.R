#setwd("J:\\Competencias\\learning\\coursera\\Johns Hopkins University\\Getting and Cleaning Data\\Project")

print <- function(...) {
  cat(format(Sys.time(), "%X"), "[run_analysis]", ..., "\n")
}

print("getting file ...")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileLocal <- "data.zip"
if (!file.exists(fileLocal)) {
  download.file(fileUrl, destfile=fileLocal, mode="wb")
}
print("unzipping file ...")
unzip(fileLocal)

print("loading data ...")
library(data.table)
trainingData    <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
trainingLabel   <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
trainingSubject <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
testData        <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
testLabel       <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
testSubject     <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")


# Merges the training and the test sets to create one data set.
print("merging data ...")
data <- rbind(trainingData, testData)
label <- rbind(trainingLabel, testLabel)
subject <- rbind(trainingSubject, testSubject)


# Extracts only the measurements on the mean and standard deviation for each measurement. 
print("extracting mean and standard deviation ...")
features <- read.table(".\\UCI HAR Dataset\\features.txt")
dataMeanStd <- data[,grep("mean\\(\\)|std\\(\\)", features[, 2])]
names(dataMeanStd) <- features[meanStdIndices, 2]


# Uses descriptive activity names to name the activities in the data set
print("adding activities ...")
activity <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
label <- activity[unlist(label), 2]


# Appropriately labels the data set with descriptive activity names. 
print("generating complete dataset with mean and std ...")
completeDataMeanStd <- cbind(subject, label, dataMeanStd)
names(completeDataMeanStd)[c(1,2)] <- c("subject", "activity")


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
print("generating result file submission_file.txt ...")
onlyMeans <- data.table(completeDataMeanStd[,c(1,2,grep("mean\\(\\)", names(completeDataMeanStd)))])
completeDataMean <- onlyMeans[, lapply(.SD, mean), by=list(subject, activity)]
write.table(completeDataMean, "submission_file.txt")

print("DONE !!!")

