url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "Dataset.zip"
datasetHome <- "UCI HAR Dataset"

if(!file.exists(filename)) {
    download.file(url, filename, method = "curl")
}

if(!file.exists(datasetHome)) {
    unzip(filename)
}