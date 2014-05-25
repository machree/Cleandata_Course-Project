library(reshape2)

## Read the training data
train.x <- read.table("UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Bind training data to create training data set in columns
train.data <- cbind(train.subject, train.y, train.x)

## Repeat the same steps for the test data
test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.data <- cbind(test.subject, test.y, test.x)

## Bind training and test data sets to create one data set in rows
data.set <- rbind(train.data, test.data)

## Read the feature names
x.labels <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2

## Name the columns of the merged data set above
labels <- c("subject", "activity", x.labels)
names(data.set) <- labels

## Calculate the mean and the standard deviations for each measurement
data.extracted <- data.set[, grep(paste(c("subject", "activity", "^.*mean[(].*$","^.*std.*$"), collapse = "|"),names(data.set), ignore.case = TRUE)]

## Create tidy data set with the average of each variable for
## each activity and each subject (library reshape2 would be used here)

melteddata <- melt(data.extracted, id.vars = c("activity", "subject"))
tidydata <- dcast(melteddata, subject + activity ~ variable, mean)

## Read the activity names
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")$V2[1:6]

## Replace the activity ids with the activity names in both tidy and extracted data sets
data.extracted$activity <- unlist(lapply(data.extracted$activity, function(x) x <- activity.labels[x]))
tidydata$activity <- unlist(lapply(tidydata$activity, function(x) x <- activity.labels[x]))


write.table(tidydata, file ="tidydataforUCI.txt", sep="\t", row.names=FALSE)
