library(data.table)
library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DATASET_FILENAME <- "dataset.zip"
DATASET_HOME <- "UCI HAR Dataset"

if(!file.exists(file.path(DATASET_FILENAME))) {
    download.file(url, file.path(DATASET_FILENAME), method = "curl")
    unzip(file.path(DATASET_FILENAME))
}

# Load activity into data table and assign column name
activities <- fread(file.path(DATASET_HOME,"activity_labels.txt"))
colnames(activities) <- c("activityId", "activity")

# Load features into data table
features <- fread(file.path(DATASET_HOME, "features.txt"))

# Select only measurements on the mean and standard deviation for each measurement.
features <- subset(features, regexpr("mean|std", V2) > 0) %>%
    mutate(V2 = gsub("-mean", "Mean", features[,V2])) %>%
    mutate(V2 = gsub("-std", "Std", features[,V2])) %>%
    mutate(V2 = gsub("[()-]", "", features[,V2]))

# Assign column name
colnames(features) <- c("featureId", "feature")


##
## Load, read and construct training dataset.
## Assig descriptive column name
## Column binding all - subject, activity and measurement
##

train_measurement <- fread(file.path(DATASET_HOME, "train", "X_train.txt")) %>%
    select(features[,"featureId"])
colnames(train_measurement) <- features[,"feature"]

train_activity <- fread(file.path(DATASET_HOME, "train", "y_train.txt"))
colnames(train_activity) <- c("activityId")
train_activity <- merge(train_activity, activities, by="activityId")

train_subject <- fread(file.path(DATASET_HOME, "train", "subject_train.txt"))
colnames(train_subject) <- c("subjectId")

train_dataset <- cbind(train_subject, select(train_activity, activity), train_measurement)

##
## Load, read and construct test dataset.
## Assig descriptive column name
## Column binding all - subject, activity and measurement
##

test_data <- fread(file.path(DATASET_HOME, "test", "X_test.txt")) %>%
    select(features[,"featureId"])
colnames(test_data) <- features[,"feature"]

test_activity <- fread(file.path(DATASET_HOME, "test", "y_test.txt"))
colnames(test_activity) <- c("activityId")
test_activity <- merge(test_activity, activities, by="activityId")

test_subject <- fread(file.path(DATASET_HOME, "test", "subject_test.txt"))
colnames(test_subject) <- c("subjectId")

test_dataset <- cbind(test_subject, select(test_activity, activity), test_data)


##
## Merge both dataset as final tidy dataset
##
tidy_dataset <- rbind(train_dataset, test_dataset)

#
# write the tidy dataset into file "tidy_dataset.txt"
#
write.table(tidy_dataset, file.path("tidy_dataset.txt"), row.names=FALSE)


##
## Independent tidy data set with the average of each variable for each activity and each subject.
##

groups <- group_by(tidy_dataset, subjectId, activity)
tidy_mean_dataset <- summarize_each(groups, c("mean"))

#
# write the tidy dataset with average of each variable for each activity and each subject
# into file "tidy_mean_dataset.txt"
#
write.table(tidy_mean_dataset, file.path("tidy_mean_dataset.txt"), row.names=FALSE)
