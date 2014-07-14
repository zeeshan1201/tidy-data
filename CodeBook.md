### Introduction

This Codebook describes the data, the variables, and the workflow of the script run_analysis.R to clean up the data. The unzipped "UCI HAR Dataset" directory should be in the directory where the script "run_analysis.R" is present and it should be the working directory.

### Data Set Description and Source

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#### For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

#### Work flow

####Read features
```
features = read.table("./UCI HAR Dataset//features.txt")
```
####The dataframe obtained has features in the second column. So, convert dataframe feature variable into character vector
```
features = as.character(features[, 2])
```
####Read Training Set data and other training data
```
trainSet = read.table("./UCI HAR Dataset/train/X_train.txt"
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
activity_train = read.table("./UCI HAR Dataset/train/y_train.txt")
```
####Check if data contains NA values
```
any(is.na(trainSet)) 
```

####Read Test set data and other test data
```
testSet = read.table("./UCI HAR Dataset/test//X_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_test = read.table("./UCI HAR Dataset/test/y_test.txt")
```
####Check if data contains NA values
```
any(is.na(testSet)) 
```

###Objective 1
#####Merges the training and the test sets to create one data set
```
mergeData = rbind(trainSet, testSet)
mergeActivity = rbind(activity_train, activity_test)
mergeSubjectID = rbind(subject_train, subject_test)
```

###Objective 2

####Find index of the columns that contain the measurements on the mean and standard deviation for each measurement
```
index = grep("(mean|std)\\(\\)", features)
```
####Extracts only the measurements on the mean and standard deviation for each measurement
```
mergeRequired = mergeData[, index]
```
####Extract only required features
```
featuresRequired = features[index]
```
###Objective 3
####Label Activity
```
mergeActivity = mergeActivity[, 1]
mergeActivity = sub("1", "Walking",mergeActivity)
mergeActivity = sub("2", "Walking Upstairs",mergeActivity)
mergeActivity = sub("3", "Walking Downstairs",mergeActivity)
mergeActivity = sub("4", "Sitting",mergeActivity)
mergeActivity = sub("5", "Standing",mergeActivity)
mergeActivity = sub("6", "Laying",mergeActivity)

mergeActivity = as.data.frame(mergeActivity)
names(mergeActivity) = "Activity"
```

####Define variable name for Subject ID
names(mergeSubjectID) = "Subject"

###Objective 4
####Converting features to descriptive variable names
```
descFeatures = sub("^t", "Time of ", featuresRequired)

descFeatures = sub("^f", "Fast Fourier Transform of ", descFeatures)

descFeatures = sub("Acc", " Acceleration", descFeatures)

descFeatures = sub("BodyBody", "Body", descFeatures)

descFeatures = sub("Gyro", " Angular Velocity", descFeatures)

descFeatures = sub("[Jj]erk", " Jerk", descFeatures)

descFeatures = sub("Mag", " Magnitude", descFeatures)

#Remove special character "()"
descFeatures = sub("\\(\\)", "", descFeatures)

#Remove special character "-"
descFeatures = gsub("-", " ", descFeatures)
```

###Objective 4
####Label the merged data with descriptive variable names
```
colnames(mergeRequired) = descFeatures
```
####Generate tidy data 1
```
tidyData1 = cbind(mergeSubjectID, mergeActivity, mergeRequired)
```
##save the tidy data 1
```
write.table(tidyData1, file = "./tidydata1.txt", sep=" ")
```
####Melt data
####Define id and variables
```
id = names(c(mergeSubjectID, mergeActivity))
vars = descFeatures
```

####Reshape into long and skinny data
```
library(reshape2)
tidyMelt = melt(tidyData1, id = id, measure.vars = vars)
```

####Reformat the dataset average of each variable for each activity and each subject. 
```
tidyData2 = dcast(tidyMelt, Subject + Activity ~ variable, mean)
```
##save the tidy data 2
```
write.table(tidyData1, file = "./tidydata2.txt", sep=" ")
```