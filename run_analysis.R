## 1. Merge two datasets(training, test) into one data set
#1-1. Read six text files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#1-2. merge train and test
x_merged <- rbind(x_train, x_test)
y_merged <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

## 2. Extracts the mean and standard deviation of each measurements
#2-1. Read Features.txt
features <- read.table("./data/UCI HAR Dataset/features.txt")

#2-2. Extract Mean & Std of each measurements
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

#2-3. Subset the desired columns
x_subset <- x_merged[, mean_and_std]

#2-4. Add the column names from features.txt
names(x_subset) <- features[mean_and_std, 2]

##3. Name the activities from the labels.txt
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
y_merged[, 1] <- activities[y_merged[, 1], 2]
names(y_merged) <- "activity"

##4. Use the variable names to label the data
names(subject) <- "subject"

##5. Merge all into a single set (subject-y-x order is more intuitive)
#5-1. Make a single set
single_set <- cbind(subject, y_merged, x_subset)
#5-2. Make a tiny set (with library plyr)
library(plyr)
tiny_set <- ddply(single_set, .(subject, activity), function(x) colMeans(x[,3:68]))
#5-3. Create a txt file
write.table(tiny_set, "tiny_set.txt", row.name=FALSE)
############### End of the script ###############