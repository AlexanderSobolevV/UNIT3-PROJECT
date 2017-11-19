filename <- filename <- "project_dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) }

# Load activity labels + featuresactivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
actLabels[,2] <- as.character(actLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract data on mean and standard deviation
featuresWant <- grep(".*mean.*|.*std.*", features[,2])
featuresWant.names <- features[featuresWant,2]
featuresWant.names = gsub('-mean', 'Mean', featuresWant.names)
featuresWant.names = gsub('-std', 'Std', featuresWant.names)
featuresWant.names <- gsub('[-()]', '', featuresWant.names)

#Extract dataframes
training <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
training <- cbind(trainingSubjects, trainingAct, training)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merging
MData <- rbind(training, test)
MData_names <- c("subject", "activity", featuresWant.names)
colnames(MData) <- MData_names

# changing data type for activities
MData$activity <- factor(MData$activity, levels = actLabels[,1], labels = actLabels[,2])
MData$subject <- as.factor(MData$subject)

#forming tidy dataset
MData.melted <- melt(MData, id = c("subject", "activity"))
MData.mean <- dcast(MData.melted, subject + activity ~ variable, mean)
write.table(MData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


