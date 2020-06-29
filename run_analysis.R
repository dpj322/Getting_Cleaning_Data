library(dplyr)
filename <- "source_data.zip"

## Import data for processing.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}

## Unzip the data just imported
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

## Import names of activities with their codes, subjects, and raw data;
## build tables of raw data with activities as column names.
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Replace y activity code with activity name, and combine the training and testing data
## for the raw data (x), activities (y), and subjects.
x_all <- rbind(x_train, x_test)
y_all <- rbind(y_train, y_test)
y_all <- y_all %>% left_join(activities, by = "code")
y_all <- y_all[2]
subject_all <- rbind(subject_train, subject_test)

## Combine all the data into one table.
all_data <- cbind(subject_all, y_all, x_all)

## keep only the data mean and standard deviation from table.
tidy_data <- all_data %>% select(subject, activity, contains("mean"), contains("std"))

## Rename columns to remove abbreviations.
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

## Create new table with data grouped by subjects and activities, taking the 
## mean of all of the activities.
averaged_data <- tidy_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

## Write the data to columns.
write.table(tidy_data, "data_set.csv", append = FALSE, row.names = FALSE, sep = ",")
write.table(averaged_data, "data_set_2.csv", append = FALSE, row.names = FALSE, sep = ",")