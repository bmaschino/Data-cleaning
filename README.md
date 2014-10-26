#Data-cleaning
=============

# Importing Data

run_analysis.R will import unzipped data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and stored in a "data" directory.

On import, run_analysis will merge three files from the /test directory, x_test.txt (actual measurements), y_test.txt (activity types (integer)), and subject_test.txt (integer referring to the original test subject).

On import, data fromm the training set will also be imported by similar means. The mesurement data in /training are different, but subject numbers and activities are the same.

x_text.txt and x_train.txt are merged first, then subject numbers and activity numbers are appended to the beginning of the data frame. All data frames have the same number of rows.

# Naming Variables

The first tidying step is to replace the activity number with a variale that is human-readible. This is done by looping through the Activity column and assigning the number value its string equivalent from the activity_labels.txt file.

Second is cleaning up the column names. "-" and "()" are illegal variable names in R, so they are removed with the gsub [[:punct:]] command. Also,  various varible names are expanded to aid in legibility. This is all done through a series of gsub commands.

# Organizing data

The data subset is melted with Subject and Activity as the id. This allows the data to be recast into a new shape. With dcast, the melted data is arranged by Subject and Activity, leading to a 180x81 matrix that lists the mean for every value, based on each subject's activity type.
