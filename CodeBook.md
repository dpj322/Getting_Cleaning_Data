# Codebook for run_analysis.R

This codebook explains the steps in downloading, processing, and saving wearable fitness device data for the peer-graded final project for the Coursera course Getting and Cleaning Data.

Import the library "dplyr".

Choose a filename for the data you will download.

Download the zipped data from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" using download.file, saving it as the filname chosen above, and using method = "curl"

Unzip the data.

Create the following tables by read.tables the .txt files from the data:

    - features = features.txt with columns "n", "functions"
    This is the names of the various measurements taken from the sensors.
    - activities = activity_lables.txt with columns "code", "activity"
    This is the code and name of the activities measured.
    - subject_test = test/subject_test.txt with column "subject"
    This is the numbers assigned to individual subjects for the test data.
    - x_test = test/X_test.txt with column features$functions
    This is the raw data measurements from the test data with column names as the types of measurments.
    - y_test = test/y_test.txt with column "code"
    This is the code associated with the activity from the test data.
    - subject_train = train/subject_train.txt with column "subject"
    This is the numbers assigned to individual subjects for the training data.
    - x_train = train/X_train.txt with colunm features$functions
    This is the raw data measurements from the train data with the column names as the types of measurements.
    - y_train = train/y_train.txt with column "code"
    This is the code associated with the activity from the train data.

Combine the train and test tables for x, y, and subject using rbind forming new tables x, y, and subject _all.

Perform a left_join for y_all and activities, then drop the "code" column, so that the "y_all" table is now activity names only.

Combine subject, y, and x _all tables using cbind, forming "all_data".

Form new table "tidy_data" by selecting subject, activity, and columns with "mean" or "std" from the "all_data" tables.

Use the "gsub" function to make the following replacements in the "tidy_data" names:

    - "Acc", "Accelerometer"
    - "Gyro", "Gyroscope"
    - "BodyBody", "Body"
    - "Mag", "Magnitude"
    - "^t", "Time"
    - "^f", "Frequency"
    - "tBody", "TimeBody"
    - "-mean()", "Mean"
    - "-std()", "STD"
    - "-freq()", "Frequency"
    - "angle", "Angle"
    - "gravity", "Gravity"

Create new table "averaged_data" by grouping tidy_data by subject and activity, and applying summarise_all(funs(mean)) to the table. This groups provides the mean of each column grouped by subject and activity.

Write each of the tables to a .csv by using write.table, and sep = ",".
