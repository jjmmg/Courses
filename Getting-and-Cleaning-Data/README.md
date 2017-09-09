Getting-and-Cleaning-Data
=========================

Getting and Cleaning Data Project.


After downloading and unzipping the file, the script run_analysis.R loads the training and test data, as well as the activity and subject codes.

Then, it follows the steps described in the project:

* Merges the training and the test sets to create one data set.  
The merged data, activities and subjects datasets are kept separated to be able to preprocess them as needed before joinning everything.

* Extracts only the measurements on the mean and standard deviation for each measurement.  
From the file features.txt, which contains a list of all available features, I get all the features related to any mean or standard deviation, and use this information to filter the data file and name the different columns. 

* Uses descriptive activity names to name the activities in the data set.  
The file activity_labels.txt contains a list of all the activity names. I join this names to the dataset.

* Appropriately labels the data set with descriptive activity names.  
I add everything (subjects, activities and data) to a single data set, and save it to a file.

* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
From the latter dataset, I get all the variables related to a mean, group by subject and activity, as requested, and perform the mean for each group. I finally save the new dataset to a new file.
