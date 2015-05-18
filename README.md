# Getdata_Assignment1

## Introduction

A R script called **run_analysis.R** will perform the following: 

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement. 
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names. 
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
1. Finally write out the tidy data set as a text file, named as "results.txt".

## Tidy Data

The tidy dataset submitted is in a long form, where 

* each row represents an observation,
* the **value** of one **measurement** on one **person(subject)** performing one **activity**,
* each column is a variable.

Refer to the Cookbook for detailed descriptions of the variables.

## Files in this Directory
1. README.md & README.html  -- this file
2. Cookbook.md & Cookbook.html  -- descriptions of variables
3. run_script.R  --  R script to create the tidy data set
4. results.txt  -- the tidy datas set.