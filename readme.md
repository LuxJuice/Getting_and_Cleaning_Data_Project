# Getting and Cleaning Data
### Johns Hopkins Data Science Specialization
### Peer Reviewed Project

### run_analysis.R documentation

**Please reference the #commented documentation in `run_analysis.R` to correlate this description**

This script does not require preloaded data.
Lines 4-12 do the following: Check for a downloaded file, if there is no file, then it is downloaded. If the downloaded file exists, then unzip it. If it does not exist (ie download error) then stop the script with an error.

After successful unzipping, the data is read from the various text files:

Activity Labels are read ( 1-6 with correspoding activity)
Data Features are read

Since only data features that include the mean or standard deviation are needed, lines 22-23 use the `grep` function to determine which features are needed. These colun names are then captured.

Lines 27-29 clean up these features names by by changing -mean to Mean, -std to Std and removing the ()s.

In lines 34-40, the training and testing sets are read from text files, and they are each merged with their corresponding subjects and labels columns.

Lines 47 and 48 merge the training and testing data sets into a single data frame.

Lines 52-53 replace the numerid activityId's with descripting activity names.

Lines 58-59 create the second, ordered tidy data set with means for each unique subject/activity record.

Finally, the tidy dataset is written into a text file on line 61.