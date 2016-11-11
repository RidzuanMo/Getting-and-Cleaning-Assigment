library(data.table)
library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DATASET_FILENAME <- "dataset.zip"
DATASET_HOME <- "UCI HAR Dataset"

if(!file.exists(file.path(DATASET_FILENAME))) {
    download.file(url, file.path(DATASET_FILENAME), method = "curl")
    unzip(file.path(DATASET_FILENAME))
}

activities <- fread(file.path(DATASET_HOME,"activity_labels.txt"))

colnames(activities) <- c("activityId", "activity")

features <- fread(file.path(DATASET_HOME, "features.txt")) %>%
    subset(regexpr("mean|std", V2) > 0) %>%
    mutate(V2 = gsub("-mean", "Mean", features[,V2])) %>%
    mutate(V2 = gsub("-std", "Std", features[,V2])) %>%
    mutate(V2 = gsub("[()-]", "", features[,V2]))

colnames(features) <- c("featureId", "feature")


#
# Load, read and construct train dataset
#

train_data <- fread(file.path(DATASET_HOME, "train", "X_train.txt")) %>%
    select(features[,"featureId"])
colnames(train_data) <- features[,"feature"]

train_activity <- fread(file.path(DATASET_HOME, "train", "y_train.txt"))
colnames(train_activity) <- c("activityId")

train_subject <- fread(file.path(DATASET_HOME, "train", "subject_train.txt"))
colnames(train_subject) <- c("subjectId")

train_dataset <- cbind(train_subject, train_activity, train_data)

#
# Load, read and construct test dataset
#

test_data <- fread(file.path(DATASET_HOME, "test", "X_test.txt")) %>%
    select(features[,"featureId"])
colnames(test_data) <- features[,"feature"]

test_activity <- fread(file.path(DATASET_HOME, "test", "y_test.txt"))
colnames(test_activity) <- c("activityId")

test_subject <- fread(file.path(DATASET_HOME, "test", "subject_test.txt"))
colnames(test_subject) <- c("subjectId")

test_dataset <- cbind(test_subject, test_activity, test_data)


#
# Merge both dataset as final tidy dataset
#
tidy_dataset <- rbind(train_dataset, test_dataset)

#
# write the tidy dataset into file "tidy_dataset.txt"
#
write.table(tidy_dataset, file.path("tidy_dataset.txt"), row.names=FALSE)

