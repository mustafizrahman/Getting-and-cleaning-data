# read train data
x_train <- read.table(".//data//UCI HAR Dataset//train/X_train.txt")
y_train <- read.table(".//data//UCI HAR Dataset//train/y_train.txt")
subject_train <- read.table(".//data//UCI HAR Dataset//train/subject_train.txt")
# read test data
x_test <- read.table(".//data//UCI HAR Dataset//test/X_test.txt")
y_test <- read.table(".//data//UCI HAR Dataset//test/y_test.txt")
subject_test <- read.table(".//data//UCI HAR Dataset//test/subject_test.txt")
# merge train and test data
x_merged_data <- rbind(x_train, x_test)
y_merged_data <- rbind(y_train, y_test)
subject_merged_data <- rbind(subject_train, subject_test)

# extract only the mean and standard deviation
features <- read.table(".//data//UCI HAR Dataset//features.txt")
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])
x_merged_data <- x_merged_data[, mean_std]
names(x_merged_data) <- features[mean_std, 2]

# update name the activities with the descriptive activity names in the text file
activities <- read.table(".//data//UCI HAR Dataset//activity_labels.txt")
y_merged_data[, 1] <- activities[y_merged_data[, 1], 2]
names(y_merged_data) <- "activity"

# create single dataset
names(subject_merged_data) <- "subject"
single_dataset <- cbind(x_merged_data, y_merged_data, subject_merged_data)

# create tidy data set with the average of each variable for each activity and each subject
averages_data <- ddply(single_dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
tidy_data <- ddply(single_dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy_data, ".//data//tidy_data.txt", row.name=FALSE)