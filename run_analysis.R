# checks if the file has been downloaded. if not -> download it
# if downloaded file exist, then unzip it

fileName <- "dataset.zip"

if (!file.exists(fileName)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, fileName, method="curl")
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(fileName) 
  } else { stop("Download failed!") }
}  

# activity labels and data features are input from txt files into data frames

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE)

# use grep to determine which features include the terms "mean" or "std" in any part of the feature name,
# then creates a list of the column names that were determined to meet the criteria above

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted, 2]

# ambigious terms are removed from the names of the desired features to accomplish objective #3

featuresWanted.names <- gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names <- gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# the data, labels, and subjects are input for both the training and testing datasets
# objective #2 is accomplished by only reading mean and std values by specifying read.table[featuresWanted]

trainingSet <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)[featuresWanted]
trainingLabels <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train <- cbind(trainingSubjects, trainingLabels, trainingSet)

testingSet <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)[featuresWanted]
testingLabels <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
testingSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test <- cbind(testingSubjects, testingLabels, testingSet)

# merge the training and tetsing data sets to accomplish obective #1
# descriptive names are added to accomplish obective #3

dataSet <- rbind(train, test)
colnames(dataSet) <- c("subject", "activity", featuresWanted.names)

# accomplish objective #4 by using the match function to create descriptive variable names for activities

colnames(activityLabels) <- c("activityId", "activity")
dataSet[["activity"]] <- activityLabels[match(dataSet[["activity"]], activityLabels[["activityId"]]), "activity"]

# use aggregate function to simplify the data to only the means for each unique subject/activity pair
# reorder tidy dataset to group subjects together, sorting first by group then activity

tidySet <- aggregate(. ~subject + activity, dataSet, mean)
tidySet <- tidySet[order(tidySet$subject, tidySet$activity),]

write.table(tidySet, "tidySet.txt", row.name = FALSE)

