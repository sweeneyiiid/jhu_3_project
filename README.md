#JHU Getting and Cleaning Data Project

This document describes the process used to complete the class project for the JHU Coursera course Getting and Cleaning Data.  The project requires us to process a dataset as specified by the instructors.

###Downloading the Data

The first step is to download the data from the URL listed below.

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Once downloaded unzip the files into a directory named: UCI HAR Dataset

Note I completed the project in MS Windows 8, which allows space characters in directory names.  If your system does not allow this you may need to change the directory name.

###Processing the Data

Once downloaded, we need to process the data according to the instructions provided for the project:

>You should create one R script called run_analysis.R that does the following.
>
>1. Merges the training and the test sets to create one data set.
>
>2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>
>3. Uses descriptive activity names to name the activities in the data set
>
>4. Appropriately labels the data set with descriptive variable names. 
>
>5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

A description of the data was provided by the instructors and can be found at the link below.

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

A revised data description based on the original but modified to account for our processing is listed a the end of this document. 

The processing will be completed by the R script run_analysis.R in this repository.

###R Script

The R script completes the steps listed below and depends on the presence of the directory descibed in the Downloading the Data section in the working directory of R.

The R script loads the plyr library to complete the summarization required in the last step.

- Read in required data
  - data frames for the subjects, labels, and measurements for the train and test sets
  - data frame for activity labels
  - character lines for feature names
- Identify mean and standard deviation features
  - extract the names, indices, and axis of features for mean and standard deviation based on the structure of the feature names
    - the line always starts with the index followed by a space
    - the feature name follows the space and ends directly before the first '-' character
    - for all mean and standard deviation variables, if the last character in the feature string is not ')' then it is the axis for the measurement
  - rename mean and standard deviation variables (see code book below for more details) 
  - create a vector of column indices containing the mean standard deviation measurements
- Setup main dataset
  - Stack train and test data, subjects, and labels
  - keep only mean and standard deviation fields in the stacked data set
  - join the subjects and labels to the mean and standard deviation data
  - apply the standardized field names
- Setup summarized dataset
  - summarize measurements but subject and activity label
  - write summary dataset to file

###Code Book

The except below descibes how the raw data was collected.

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
>
>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
>
>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 


The variables in the processed datasets are descibed below:

After processing the main data set and summarized dataset have the same variables, the difference is the main dataset contains multiple observations per subject and activity, while the summarized dataset contains the mean of each measurement per subject and activity.

- subject.id: integer identifying a unique subject
- activity.name: the english name of the activity label
- measurement variables
  - each measurement variable is constructed as the base variable name, metric (mean or std), and axis (X, Y, or Z) if applicable separated by periods.
  - For example: tBodyAcc.mean.X

Below is the list of measurements in the dataset.  If the name is followed by XYZ, it is actually three separate measurements, one for each axis.

- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag
