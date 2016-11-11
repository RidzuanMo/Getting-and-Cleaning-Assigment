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

train_data <- fread(file.path(DATASET_HOME, "train", "X_train.txt")) %>%
    select(features[,"featureId"])
colnames(train_data) <- features[,"feature"]

train_activity <- fread(file.path(DATASET_HOME, "train", "y_train.txt"))
colnames(train_activity) <- c("activityId")

train_subject <- fread(file.path(DATASET_HOME, "train", "subject_train.txt"))
colnames(train_subject) <- c("subjectId")




