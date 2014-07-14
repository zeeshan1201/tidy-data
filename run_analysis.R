#Read features
features = read.table("./UCI HAR Dataset//features.txt")
#The dataframe obtained has features in the second column
#Convert dataframe feature variable into character vector
features = as.character(features[, 2])

#Read Training Set data and other training data
trainSet = read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt")
activity_train = read.table("./UCI HAR Dataset/train/y_train.txt")

#Check if data contains NA values
any(is.na(trainSet)) 

#Read Test set data and other test data
testSet = read.table("./UCI HAR Dataset/test//X_test.txt")
subject_test = read.table("./UCI HAR Dataset/test/subject_test.txt")
activity_test = read.table("./UCI HAR Dataset/test/y_test.txt")

#Check if data contains NA values
any(is.na(testSet)) 

#Objective 1
#Merges the training and the test sets to create one data set
mergeData = rbind(trainSet, testSet)
mergeActivity = rbind(activity_train, activity_test)
mergeSubjectID = rbind(subject_train, subject_test)

#Objective 2

#Find index of the columns that contain the measurements on 
#the mean and standard deviation for each measurement
index = grep("(mean|std)\\(\\)", features)

#Extracts only the measurements on the mean and standard deviation for each measurement
mergeRequired = mergeData[, index]

#Extract only required features
featuresRequired = features[index]

#Objective 3
#Label Activity
mergeActivity = mergeActivity[, 1]
mergeActivity = sub("1", "Walking",mergeActivity)
mergeActivity = sub("2", "Walking Upstairs",mergeActivity)
mergeActivity = sub("3", "Walking Downstairs",mergeActivity)
mergeActivity = sub("4", "Sitting",mergeActivity)
mergeActivity = sub("5", "Standing",mergeActivity)
mergeActivity = sub("6", "Laying",mergeActivity)

mergeActivity = as.data.frame(mergeActivity)
names(mergeActivity) = "Activity"

#Define variable name for Subject ID
names(mergeSubjectID) = "Subject"

#Objective 4
#Converting features to descriptive variable names
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

#Objective 4
#Label the merged data with descriptive variable names
colnames(mergeRequired) = descFeatures

#Generate tidy data 1
tidyData1 = cbind(mergeSubjectID, mergeActivity, mergeRequired)

#save the tidy data 1
write.table(tidyData1, file = "./tidydata1.txt", sep=" ")

#Melt data
#Define id and variables
id = names(c(mergeSubjectID, mergeActivity))
vars = descFeatures
#vars = c("Activity", descFeatures)


#Reshape into long and skinny data
library(reshape2)
tidyMelt = melt(tidyData1, id = id, measure.vars = vars)

#Reformat the dataset average of each variable for each activity and each subject. 
tidyData2 = dcast(tidyMelt, Subject + Activity ~ variable, mean)

#save the tidy data 2
write.table(tidyData1, file = "./tidydata2.txt", sep=" ")

