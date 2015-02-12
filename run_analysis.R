# 1. Merges the training and the test sets to create one data set.
subject_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

df_test  <- data.frame(subject_test, y_test, x_test)
df_train <- data.frame(subject_train, y_train, x_train)

df <- rbind(df_test, df_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI_HAR_Dataset/features.txt")
i_mean <- grep("[Mm]ean", features[[2]]) + 2
i_std <- grep("std", features[[2]]) + 2
i <- c(i_mean, i_std)
df1 <- df[c(1,2,i)]

# 3. Uses descriptive activity names to name the activities in the data set
activity.df <- read.table("UCI_HAR_Dataset/activity_labels.txt")
activity <- activity.df[[2]]
names(activity) <- activity.df[[1]]
df1[2] <- sapply(df1[[2]], function (x) activity[as.character(x)])

# 4. Appropriately labels the data set with descriptive variable names. 
i_mean_name <- grep("[Mm]ean", features[[2]], value=TRUE)
i_std_name <- grep("std", features[[2]], , value=TRUE)
names(df1) <- c("subject", "activity", i_mean_name, i_std_name)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

library(dplyr)
tbl <- tbl_df(df1)
tbl1 <- summarise_each(group_by(tbl, subject, activity), funs(mean))
write.table(tbl1, "out.txt", sep='\t', row.names=FALSE)