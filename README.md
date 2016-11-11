# Getting-and-Cleaning-Assigment
To demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## This assigment is performs the following steps, as per the project instructions:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each
subject. 

## How to run:

```{R}
source("run_analysis.R")
```
This will download the Dataset in form https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and save it as **_dataset.zip_** in the same folder.  

The download zipped file will be automatically uncompressed into folder **UCI HAR Dataset**. The script will read the data files from this folders to load data regarding activities, features, subject, training and test.  

The script only read the measurements on the mean and standard deviation for each measurement.

The constructed tidy dataset will be assigned with descriptive column name for better understanding and useful for future analysis.

The detail process, please refer **CodeBook.md**

## Output

Filename              | Description
----------------------| -------------------------------------------------------------------------
tidy_dataset.txt      | Tidy dataset consist of subjectId, activityId and measurement variables.
tidy_mean_dataset.txt | Tidy dataset constructed based on *tidy_dataset* where the data is grouped by subjectId and activityId and average for all measurement variables

