Getting-and-Cleaning-Data-Course-Project
========================================

###Running the script file
Run the code to generate the tidy data set by sourcing the run_analysis.R file
```
source("run_analysis.R")
```

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

