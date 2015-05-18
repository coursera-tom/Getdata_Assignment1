##  GetData - Assignment 1
##  2015.05.17
##
##  Assignment Requirements -
##  Create one R script called run_analysis.R that does the following. 
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names. 
##  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)

## Step 0. Download, unzip and read files
filename <- "UCI-HAR-Dataset.zip"
if(!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,destfile=filename,method="curl",mode="wb")
  unzip(filename)
}

test_filename_x <- "UCI HAR Dataset/test/X_test.txt"
test_filename_y <- "UCI HAR Dataset/test/y_test.txt"
test_filename_subject <- "UCI HAR Dataset/test/subject_test.txt"
train_filename_x <- "UCI HAR Dataset/train/X_train.txt"
train_filename_y <- "UCI HAR Dataset/train/y_train.txt"
train_filename_subject <- "UCI HAR Dataset/train/subject_train.txt"
activity_labels_filename <- "UCI HAR Dataset/activity_labels.txt"
features_filename <- "UCI HAR Dataset/features.txt"

activities <- read.table(activity_labels_filename)
features <- read.table(features_filename)
names(activities) <- c("Activity_ID","Activity_Name")
names(features) <- c("Feature_ID", "Feature_Code")

X_train <- read.table(train_filename_x)
y_train <- read.table(train_filename_y)
subject_train <- read.table(train_filename_subject)
names(X_train) <- features$"Feature_Code"
names(y_train) <- "Activity_ID"
names(subject_train) <- "Subject_ID"

X_test <- read.table(test_filename_x)
y_test <- read.table(test_filename_y)
subject_test <- read.table(test_filename_subject)
names(X_test) <- features$"Feature_Code"
names(y_test) <- "Activity_ID"
names(subject_test) <- "Subject_ID"

## Step 1. Merges the training and the test sets to create one data set.
train_dat <- cbind(y_train, subject_train, X_train)
test_dat <- cbind(y_test, subject_test, X_test)
all_dat <- rbind(train_dat, test_dat)

## Step 2. Extracts only the measurements on the mean and standard deviation 
## for each measurement. 

ms_features <- features[grep('(mean|std)\\(\\)', features$"Feature_Code"),]
ms_cols <- ms_features[,1] + 2  ## shift +2 to accommandate activity and subject cols.
mean_std <- all_dat[,c(1,2,ms_cols)]

## Step 3. Uses descriptive activity names to name the activities in the data set
desc_activity <- merge(activities, mean_std, by="Activity_ID", all=T)

## Step 4. Appropriately labels the data set with descriptive variable names.
temp <- ms_features$"Feature_Code"
temp <- as.character(temp)
temp <- sub("^t","Time Domain",temp , perl=T)
temp <- sub("f","Frequency Domain",temp)
temp <- gsub("Body"," Body",temp) 
temp <- sub("Gravity"," Gravity",temp) 
temp <- sub("Acc"," Linear Acceleration",temp) 
temp <- sub("Gyro"," Angular Velocity",temp) 
temp <- sub("Jerk"," Jerk",temp) 
temp <- sub("Mag"," Magnitude",temp) 
temp <- sub("-mean\\(\\)"," Signal's Mean Value",temp) 
temp <- sub("-std\\(\\)"," Signal's Std Value",temp) 
temp <- sub("-X"," Along X Axis",temp) 
temp <- sub("-Y"," Along Y Axis",temp) 
temp <- sub("-Z"," Along Z Axis",temp) 

names(desc_activity)[4:69] <- temp

## Step 5. From the data set in step 4, creates a second, independent tidy data set with 
##         the average of each variable for each activity and each subject.
a <- desc_activity
splitted <- split(a, list(a$Activity_Name, a$Subject_ID)) ## split based on both Activity and Subject
means <- sapply(splitted, function(elt) colMeans(elt[,c(4:69)]))  ## apply column means for each group

# the following steps to add Activity and Subject columns back to the data set.
names <- colnames(means)
ap <- strsplit(names, "\\.")
ap.df <- as.data.frame(ap)
rownames(ap.df) <- c("Activity","Subject")
ap.df.t <- t(ap.df)
means.t <- t(means)
means.t.all <- cbind(as.data.frame(ap.df.t), as.data.frame(means.t))

# create tidy data set by building up a tall table, identified by Activity+Subject
tidy <- melt(means.t.all, id=c("Activity","Subject"), measure.vars=c(3:68))
names(tidy)[3:4] <- c("Measurement", "Value")

# write to a text file
write.table(tidy, "results.txt", sep=",", row.name=F)


