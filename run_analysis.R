# Reading training and test tables:

subject_t <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

X_test <- read.table("./test/X_test.txt")
X_train <- read.table("./train/X_train.txt")
y_test <- read.table("./test/y_test.txt")
y_train <- read.table("./train/y_train.txt")
activity_labels = read.table("./activity_labels.txt")
features <- read.table("./features.txt")  

colnames(X_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(X_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

mergedtrain <- cbind(y_train, subject_train, X_train)
mergedtest <- cbind(y_test, subject_test, X_test)
mergeddata <- rbind(mergedtrain, mergedtest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- colnames(mergeddata)

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)


setForMeanAndStd <- mergeddata[ , mean_and_std == TRUE]


# 3. Uses descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activity_labels,
                              by='activityId',
                              all.x=TRUE)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydata <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
tidydata <- tidydata[order(tidydata$subjectId, secTidySet$activityId),]
write.table(tidydata, "tidydata.txt", row.name=FALSE)


