tidy-data
=========

Getting and cleaning data project

There is only one script run_analysis.R, which performs the data tidying and saves the files. It reads data from the current directory which should have the unzipped "UCI HAR Dataset" folder.

The program reads and performs the follwing actions:

 *   Merges the training and the test sets to create one data set.
 *   Extracts only the measurements on the mean and standard deviation for each measurement. 
 *   Uses descriptive activity names to name the activities in the data set
 *   Appropriately labels the data set with descriptive variable names. 
 *   Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

And finally saves two files, one after step 4 and second after step 5.

The workflow and variable descriptions are present in the CodeBook.md.

The run_analysis.R script also has indented lines to explain the steps performed.