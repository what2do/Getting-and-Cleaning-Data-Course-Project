Getting-and-Cleaning-Data-Course-Project
========================================

###Running the script file
Run the code to generate the tidy data set by sourcing the run_analysis.R file
```
source("run_analysis.R")
```

###Analysis Steps
1. Check if dplyr library loaded, if not install and load
2. If data file don't exists, download Raw Dataset
3. If data directory don't exists, uzip Raw Dataset
4. Read "X_train.txt" into trainX
5. Read "y_train.txt" into trainY
6. Read "subject_train.txt" into trainSubjects
7. cbind (trainSubjects, trainY, trainX) into trainData
8. Read "X_test.txt" into testX
9. Read "y_test.txt" into testY
10. Read "subject_test.txt" into testSubjects
11. cbind (trainSubjects, trainY, trainX) into testData
12. rbind(trainData, testData) into Data
13. Read "features.txt" into features
14. Create columns names based on features and add 'Subject' and 'Activity'
15. Set the column names
16. Use 'grep' to get column index of 'Subject', 'Activity' and measurements that contains the text 'mean()' and 'std()'
17. Keep only the required columns
18. Read "activity_labels.txt" into activities
19. Replace '_' with ' ' and set to lower case
20. Match each activity integer in 'Data' with the corresponding activity labels 
21. Extract the current variable names from 'Data'
22. Replace 'BodyBody' with 'Body'
23. Replace 't/f' with 'time/frequency' and add '_'
24. Separate the description with '_'
25. Replace 'Acc' with 'Acceleration', 'Gyro' with 'AngularVelocity', 'Mag' with 'Magnitude' and add '_'
26. Replace '-mean()' with 'Mean', '-std()' with 'Std'
27. Update column names of 'Data'
28. Use 'summarise_each' to group observations first by subject, then by activity and report the mean for other columns
29. Check if folder 'tidy' exists, if not create folder
30. Save the new data frame into 'tidy' folder using 'write.table' with 'row.names=FALSE'

###Output file
After the code executed, the output file "tidy.txt" will be generated in the folder below
```
"UCI HAR Dataset/tidy"
```

###Reading the output file
To read the output file, you can use the following commands
```
data <- read.table("UCI HAR Dataset/tidy/tidy.txt", header = TRUE)
View(data)
```

