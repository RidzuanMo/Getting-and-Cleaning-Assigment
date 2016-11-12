# CodeBook : run_analysis.R

## 1) Process Flow
### Task 1 : Construct tidy dataset

step 1- Download dataset and uncompress zipped files.
```{R}
download.file(url, file.path(DATASET_FILENAME), method = "curl")
unzip(file.path(DATASET_FILENAME))
```  
step 2- Load list of activities and assign column name.  
```{R}
# Load activity into data table and assign column name
activities <- fread(file.path(DATASET_HOME,"activity_labels.txt"))
colnames(activities) <- c("activityId", "activity")
```
step 3- Load list of features and assign column name. Select on features which have a mean and standard deviation for each measurement only.  
```{r} 
# Load features into data table
features <- fread(file.path(DATASET_HOME, "features.txt"))

# Select only measurements on the mean and standard deviation for each measurement.
features <- subset(features, regexpr("mean|std", V2) > 0) %>%
   mutate(V2 = gsub("-mean", "Mean", features[,V2])) %>%
   mutate(V2 = gsub("-std", "Std", features[,V2])) %>%
   mutate(V2 = gsub("[()-]", "", features[,V2]))

# Assign column name
colnames(features) <- c("featureId", "feature")
```
step 4- Read a **training** data under folder *"./UCI HAR Dataset/train/"* and build a tidy dataset  
```{r}
# Load, read and construct training dataset.
# Assig descriptive column name.
train_measurement <- fread(file.path(DATASET_HOME, "train", "X_train.txt")) %>%
   select(features[,"featureId"])
colnames(train_measurement) <- features[,"feature"] 

train_activity <- fread(file.path(DATASET_HOME, "train", "y_train.txt"))
colnames(train_activity) <- c("activityId") 
train_activity <- merge(train_activity, activities, by="activityId")

train_subject <- fread(file.path(DATASET_HOME, "train", "subject_train.txt"))
colnames(train_subject) <- c("subjectId")
```
step 5- Combine the messy data for _measurement_, _activity_ and _subject_ using **cbind** to create tidy dataset for *training*
```{r}
train_dataset <- cbind(train_subject, select(train_activity, activity), train_data)
``` 
step 6- Repeat step 4 and 5 for **test** data under folder *"./UCI HAR Dataset/test/"* to build a tidy dataset. Store the tidy dataset for test into variable **test_dataset**

step 7- Merge both tidy dataset into final tidy dataset variable called **tidy_dataset**  
```{R} 
tidy_dataset <- rbind(train_dataset, test_dataset)
```
step 8- write to output file **tidy_dataset.text**  
```{R}
write.table(tidy_dataset, file.path("tidy_dataset.txt"), row.names=FALSE)
```

### Task 2 : Dataset with the average of each variable.

step 1- Firstly, the **tidy_dataset** is group by _subjectId_ and _activityId_

step 2- apply *summarize_each* which provided by package **dplyr**
```{r}
# summarize_each will apply the function mean() to get the average
# and the groups field is ignore in this process.
tidy_mean_dataset <- summarize_each(groups, c("mean"))
```

step 3- write to output file **tidy_mean_dataset.text**  
```{R}
write.table(tidy_mean_dataset, file.path("tidy_mean_dataset.txt"), row.names=FALSE)
```  

***

## 2) Data Dictionary  
 
#### ACTIVITIES
```
   activityId           activity
   ---------- ------------------
1:          1            WALKING
2:          2   WALKING_UPSTAIRS
3:          3 WALKING_DOWNSTAIRS
4:          4            SITTING
5:          5           STANDING
6:          6             LAYING
``` 

#### FEATURES
```
    featureId                      feature
    --------- ----------------------------
 1:         1                tBodyAccMeanX
 2:         2                tBodyAccMeanY
 3:         3                tBodyAccMeanZ
 4:         4                 tBodyAccStdX
 5:         5                 tBodyAccStdY
 6:         6                 tBodyAccStdZ
 7:        41             tGravityAccMeanX
 8:        42             tGravityAccMeanY
 9:        43             tGravityAccMeanZ
10:        44              tGravityAccStdX
11:        45              tGravityAccStdY
12:        46              tGravityAccStdZ
13:        81            tBodyAccJerkMeanX
14:        82            tBodyAccJerkMeanY
15:        83            tBodyAccJerkMeanZ
16:        84             tBodyAccJerkStdX
17:        85             tBodyAccJerkStdY
18:        86             tBodyAccJerkStdZ
19:       121               tBodyGyroMeanX
20:       122               tBodyGyroMeanY
21:       123               tBodyGyroMeanZ
22:       124                tBodyGyroStdX
23:       125                tBodyGyroStdY
24:       126                tBodyGyroStdZ
25:       161           tBodyGyroJerkMeanX
26:       162           tBodyGyroJerkMeanY
27:       163           tBodyGyroJerkMeanZ
28:       164            tBodyGyroJerkStdX
29:       165            tBodyGyroJerkStdY
30:       166            tBodyGyroJerkStdZ
31:       201              tBodyAccMagMean
32:       202               tBodyAccMagStd
33:       214           tGravityAccMagMean
34:       215            tGravityAccMagStd
35:       227          tBodyAccJerkMagMean
36:       228           tBodyAccJerkMagStd
37:       240             tBodyGyroMagMean
38:       241              tBodyGyroMagStd
39:       253         tBodyGyroJerkMagMean
40:       254          tBodyGyroJerkMagStd
41:       266                fBodyAccMeanX
42:       267                fBodyAccMeanY
43:       268                fBodyAccMeanZ
44:       269                 fBodyAccStdX
45:       270                 fBodyAccStdY
46:       271                 fBodyAccStdZ
47:       294            fBodyAccMeanFreqX
48:       295            fBodyAccMeanFreqY
49:       296            fBodyAccMeanFreqZ
50:       345            fBodyAccJerkMeanX
51:       346            fBodyAccJerkMeanY
52:       347            fBodyAccJerkMeanZ
53:       348             fBodyAccJerkStdX
54:       349             fBodyAccJerkStdY
55:       350             fBodyAccJerkStdZ
56:       373        fBodyAccJerkMeanFreqX
57:       374        fBodyAccJerkMeanFreqY
58:       375        fBodyAccJerkMeanFreqZ
59:       424               fBodyGyroMeanX
60:       425               fBodyGyroMeanY
61:       426               fBodyGyroMeanZ
62:       427                fBodyGyroStdX
63:       428                fBodyGyroStdY
64:       429                fBodyGyroStdZ
65:       452           fBodyGyroMeanFreqX
66:       453           fBodyGyroMeanFreqY
67:       454           fBodyGyroMeanFreqZ
68:       503              fBodyAccMagMean
69:       504               fBodyAccMagStd
70:       513          fBodyAccMagMeanFreq
71:       516      fBodyBodyAccJerkMagMean
72:       517       fBodyBodyAccJerkMagStd
73:       526  fBodyBodyAccJerkMagMeanFreq
74:       529         fBodyBodyGyroMagMean
75:       530          fBodyBodyGyroMagStd
76:       539     fBodyBodyGyroMagMeanFreq
77:       542     fBodyBodyGyroJerkMagMean
78:       543      fBodyBodyGyroJerkMagStd
79:       552 fBodyBodyGyroJerkMagMeanFreq
```
#### TIDY DATASET
Column | Remarks
----------|---------------------------------
subjectId | Test and Training subject
activity  | Type of activity
tBodyAccMeanX | Measurement data
tBodyAccMeanY | Measurement data
tBodyAccMeanZ | Measurement data
tBodyAccStdX | Measurement data
tBodyAccStdY | Measurement data
tBodyAccStdZ | Measurement data
tGravityAccMeanX | Measurement data
tGravityAccMeanY | Measurement data
tGravityAccMeanZ | Measurement data
tGravityAccStdX | Measurement data
tGravityAccStdY | Measurement data
tGravityAccStdZ | Measurement data
tBodyAccJerkMeanX | Measurement data
tBodyAccJerkMeanY | Measurement data
tBodyAccJerkMeanZ | Measurement data
tBodyAccJerkStdX | Measurement data
tBodyAccJerkStdY | Measurement data
tBodyAccJerkStdZ | Measurement data
tBodyGyroMeanX | Measurement data
tBodyGyroMeanY | Measurement data
tBodyGyroMeanZ | Measurement data
tBodyGyroStdX | Measurement data
tBodyGyroStdY | Measurement data
tBodyGyroStdZ | Measurement data
tBodyGyroJerkMeanX | Measurement data
tBodyGyroJerkMeanY | Measurement data
tBodyGyroJerkMeanZ | Measurement data
tBodyGyroJerkStdX | Measurement data
tBodyGyroJerkStdY | Measurement data
tBodyGyroJerkStdZ | Measurement data
tBodyAccMagMean | Measurement data
tBodyAccMagStd | Measurement data
tGravityAccMagMean | Measurement data
tGravityAccMagStd | Measurement data
tBodyAccJerkMagMean | Measurement data
tBodyAccJerkMagStd | Measurement data
tBodyGyroMagMean | Measurement data
tBodyGyroMagStd | Measurement data
tBodyGyroJerkMagMean | Measurement data
tBodyGyroJerkMagStd | Measurement data
fBodyAccMeanX | Measurement data
fBodyAccMeanY | Measurement data
fBodyAccMeanZ | Measurement data
fBodyAccStdX | Measurement data
fBodyAccStdY | Measurement data
fBodyAccStdZ | Measurement data
fBodyAccMeanFreqX | Measurement data
fBodyAccMeanFreqY | Measurement data
fBodyAccMeanFreqZ | Measurement data
fBodyAccJerkMeanX | Measurement data
fBodyAccJerkMeanY | Measurement data
fBodyAccJerkMeanZ | Measurement data
fBodyAccJerkStdX | Measurement data
fBodyAccJerkStdY | Measurement data
fBodyAccJerkStdZ | Measurement data
fBodyAccJerkMeanFreqX | Measurement data
fBodyAccJerkMeanFreqY | Measurement data
fBodyAccJerkMeanFreqZ | Measurement data
fBodyGyroMeanX | Measurement data
fBodyGyroMeanY | Measurement data
fBodyGyroMeanZ | Measurement data
fBodyGyroStdX | Measurement data
fBodyGyroStdY | Measurement data
fBodyGyroStdZ | Measurement data
fBodyGyroMeanFreqX | Measurement data
fBodyGyroMeanFreqY | Measurement data
fBodyGyroMeanFreqZ | Measurement data
fBodyAccMagMean | Measurement data
fBodyAccMagStd | Measurement data
fBodyAccMagMeanFreq | Measurement data
fBodyBodyAccJerkMagMean | Measurement data
fBodyBodyAccJerkMagStd | Measurement data
fBodyBodyAccJerkMagMeanFreq | Measurement data
fBodyBodyGyroMagMean | Measurement data
fBodyBodyGyroMagStd | Measurement data
fBodyBodyGyroMagMeanFreq | Measurement data
fBodyBodyGyroJerkMagMean | Measurement data
fBodyBodyGyroJerkMagStd | Measurement data
fBodyBodyGyroJerkMagMeanFreq | Measurement data

