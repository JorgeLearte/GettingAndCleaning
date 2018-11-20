# 1. Reading training and test tables:
subject_t <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

xtest <- read.table("./test/xtest.txt")
xtrain <- read.table("./train/xtrain.txt")
ytest <- read.table("./test/ytest.txt")
ytrain <- read.table("./train/ytrain.txt")
activityLabels = read.table("./activityLabels.txt")
feat <- read.table("./feat.txt")  

colnames(xtrain) <- feat[,2] 
colnames(ytrain) <-"aId"
colnames(subject_train) <- "sId"

colnames(xtest) <- feat[,2] 
colnames(ytest) <- "aId"
colnames(subject_test) <- "sId"

colnames(activityLabels) <- c('aId','activityType')

mergedTrain <- cbind(ytrain, subject_train, xtrain)
mergedTest <- cbind(ytest, subject_test, xtest)
mergedData <- rbind(mergedtrain, mergedTest)

# 2. Extracts mean and standard deviation for each measurement.
colNames <- colnames(mergedData)
meanstd <- (grepl("aId" , colNames) | 
                   grepl("sId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)
setMeanSt <- mergedData[ , meanstd == TRUE]
# 3. Set activity names
setWithActivityNames <- merge(setMeanSt, activityLabels,
                              by='aId',
                              all.x=TRUE)
# 5. Create tidy data set with the mean of each variable for each case
tidydata <- aggregate(. ~sId + aId, setWithActivityNames, mean)
tidydata <- tidydata[order(tidydata$sId, secTidySet$aId),]
write.table(tidydata, "tidydata.txt", row.name=FALSE)

