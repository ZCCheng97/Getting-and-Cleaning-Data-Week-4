library(stringr);library(dplyr)

#Read features and activity labels
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt") 


#Reading datasets, subject IDs and activity IDs for "test"
X_test<- read.table("X_test.txt")
subject_test<- read.table("subject_test.txt")
Y_test<- read.table("Y_test.txt")


#Reading datasets, subject IDs and activity IDs for "train"
X_train<- read.table("X_train.txt")
subject_train<- read.table("subject_train.txt")
Y_train<- read.table("Y_train.txt")


#labeling variables
names(X_test) <- features$V2 

#replace activity IDs with activity labels
Y_test$V1 <- factor(Y_test$V1,labels=activity_labels$V2)

#selecting means and std of variables
seltest <- X_test[ ,grep("mean[[:punct:]]+|std",names(X_test))]
test<- cbind(subject_test,Y_test,seltest)


#labeling variables
names(X_train) <- features$V2 

#replace activity IDs with activity labels
Y_train$V1 <- factor(Y_train$V1,labels=activity_labels$V2)

#selecting means and std of activity variables
seltrain <- X_train[ ,grep("mean[[:punct:]]+|std",names(X_train))]
train<- cbind(subject_train,Y_train,seltrain)


#naming subject and activity columns
joined <- rbind(test,train)
colnames(joined)[1]<- "Subject"
colnames(joined)[2]<- "Activity"


#tidy data of averaged variables by subject and activity
tidydata <- joined %>%
group_by(Subject, Activity) %>%
  summarise_all(funs(mean))

write.table(tidydata,"tidydata.txt",row.names = FALSE)
