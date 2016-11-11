# Getting-and-Cleaning-Assigment
To demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

## Task 1 : Construct tidy dataset

1. Load list of activities and assign column name.  
```{R}
activities <- fread(file.path(DATASET_HOME,"activity_labels.txt"))
## give column a descriptive name
colnames(activities) <- c("activityId", "activity")
``` 
2. Load list of features and assign column name. Select on features which have a mean and standard deviation for each measurement only.  
```{r}
features <- fread(file.path(DATASET_HOME, "features.txt")) %>%
   subset(regexpr("mean|std", V2) > 0) %>%
## give column a descriptive name
colnames(features) <- c("featureId", "feature")
``` 
3. Read a **train** data under folder *"./UCI HAR Dataset/train/"* and build a tidy dataset  
```{r}
train_data <- fread(file.path(DATASET_HOME, "train", "X_train.txt")) %>%
   select(features[,"featureId"])
train_activity <- fread(file.path(DATASET_HOME, "train", "y_train.txt"))
train_subject <- fread(file.path(DATASET_HOME, "train", "subject_train.txt"))
``` 
4. Combine the messy data for _reading_, _activity_ and _subject_ using **cbind** to create tidy dataset for *train*
```{r}
train_dataset <- cbind(train_subject, train_activity, train_data)
``` 
5. Repeat step 3 and 4 for **test** data under folder *"./UCI HAR Dataset/test/"* to build a tidy dataset. Store the tidy dataset for test into variable **test_dataset**
6. Merge both tidy dataset into final tidy dataset variable called **tidy_dataset**  
```{R} 
tidy_dataset <- rbind(train_dataset, test_dataset)
```
7. write to output file **tidy_dataset.text**  
```{R}
write.table(tidy_dataset, file.path("tidy_dataset.txt"), row.names=FALSE)
```

## Task 3 : Dataset with the average of each variable.

1. Firstly, the **tidy_dataset** is group by _subjectId_ and _activityId_
2. apply *summarize_each* which provided by package **dplyr**
```{r}
# summarize_each will apply the function mean() to get the average
# and the groups field is ignore in this process.
tidy_mean_dataset <- summarize_each(groups, c("mean"))
```
3. write to output file **tidy_mean_dataset.text**  
```{R}
write.table(tidy_mean_dataset, file.path("tidy_mean_dataset.txt"), row.names=FALSE)
```

