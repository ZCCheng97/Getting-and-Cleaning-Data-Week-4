### Files in this Repo

-   README.md: Description of data set and data cleaning steps.
-   CodeBook.md: Description of variables in tidydata.txt
-   run\_analysis.R: Script to produce tidydata.txt

### Data Summary

#### Introduction

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by
applying noise filters and then sampled in fixed-width sliding windows
of 2.56 sec and 50% overlap (128 readings/window). The sensor
acceleration signal, which has gravitational and body motion components,
was separated using a Butterworth low-pass filter into body acceleration
and gravity. The gravitational force is assumed to have only low
frequency components, therefore a filter with 0.3 Hz cutoff frequency
was used. From each window, a vector of features was obtained by
calculating variables from the time and frequency domain.

#### Data Collected

-   Triaxial acceleration from the accelerometer (total acceleration)
    and the estimated body acceleration.
-   Triaxial Angular velocity from the gyroscope.
-   A 561-feature vector with time and frequency domain variables.
-   Its activity label.
-   An identifier of the subject who carried out the experiment.

#### Variable Selection

The features selected for this database come from the accelerometer and
gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain
signals (prefix ‘t’ to denote time) were captured at a constant rate of
50 Hz. Then they were filtered using a median filter and a 3rd order low
pass Butterworth filter with a corner frequency of 20 Hz to remove
noise. Similarly, the acceleration signal was then separated into body
and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ)
using another low pass Butterworth filter with a corner frequency of 0.3
Hz.

Subsequently, the body linear acceleration and angular velocity were
derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and
tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional
signals were calculated using the Euclidean norm (tBodyAccMag,
tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these
signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ,
fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the ‘f’ to
indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for
each pattern:  
‘-XYZ’ is used to denote 3-axial signals in the X, Y and Z directions.

The set of variables that were estimated from these signals are:

mean(): Mean value std(): Standard deviation

### Data Cleaning (Explanation for run\_analysis.R)

We started off by reading the .txt files into R as data frames.

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
    Y_train<- read.table("Y_train.txt")}

There are two groups of data, one for “test” and other for “train”.

The following procedure extracts the means and standard deviations of
each variable, subject number and activity for the “test” group. The
column names are labelled with the test variables (561 total).

    #labeling variables
    names(X_test) <- features$V2 

The activity IDs of numerals 1 to 6 were rewritten as the appropriate
activity.

    #replace activity IDs with activity labels
    Y_test$V1 <- factor(Y_test$V1,labels=activity_labels$V2)

Only the means and std are needed as per the requirement for the
tidydata set compilation. A subset of the dataframe is then taken
containing the variables which were means or std.

    #selecting means and std of variables
    seltest <- X_test[ ,grep("mean[[:punct:]]+|std",names(X_test))]
    test<- cbind(subject_test,Y_test,seltest)

The process is repeated to create the data frame for “train”.

    #labeling variables
    names(X_train) <- features$V2 

    #replace activity IDs with activity labels
    Y_train$V1 <- factor(Y_train$V1,labels=activity_labels$V2)

    #selecting means and std of activity variables
    seltrain <- X_train[ ,grep("mean[[:punct:]]+|std",names(X_train))]
    train<- cbind(subject_train,Y_train,seltrain)

The “test” and “train” groups are merged by rows and the subject and
activity columns are labelled.

    #naming subject and activity columns
    joined <- rbind(test,train)
    colnames(joined)[1]<- "Subject"
    colnames(joined)[2]<- "Activity"

This step produces the independent tidy data set with the average of
each variable for each activity and each subject.

    #tidy data of averaged variables by subject and activity
    tidydata <- joined %>%
    group_by(Subject, Activity) %>%
      summarise_all(funs(mean))

### Source of Data

\[1\] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a
Multiclass Hardware-Friendly Support Vector Machine. International
Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz,
Spain. Dec 2012
