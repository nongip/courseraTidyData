# Cleaning and reshaping procedure
My script run_analysis.R runs with the data from the wearable computing experiment of Samsung
  ----
## Strategy
run_analysis.R:

* downloads the data directly from the link provided by the course
* applies meaningful labels to the data
* merges the training and test sets
* creates a 1st tidy frame with the means and standard deviations of all features measured
* creates a 2nd tidy frame with the means per subject and activity of the measures contained in the 1st data frame

  ----
## Download

* create dir "data"
  -download zipprd data file with name "data.zip" into folder "data", save time of download
  -unzip data and explore its contents

>the contents consist of a README, a features.txt on the features recoreded, a features_info.txt describing the features, an activity_labels.txt containing the labels of the activities' codes, a train set and a test set.Train set is used by the scientists to "train" the models, the test set to measure their predictive performance. 
>Each set contains inertial signals, for body acceleration, body gyro and total acceleration in the 3 dimensions, data on the subjects, a list of 569 syntetic measures derived from the preceding sets. Further info can be obtained at 
[experiment's details](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

* read triaxial data into a list "hte"
* read train and test data into the same list "hte"
  I construct loops here to exploit names' regularities

  ----
## Labels and names
* refine names of the elements of the list
* create function to label if train or test sample
  this function allows me to have a "check" column in each set before the merge
* apply function to "hte" list
  having a list here comes in handy because lapply can be used. A new list is now created called hte2
* assign activity_labels to y_ merging "y_" sets to actvity_labels for both train and test sets
* assign features to X_ using proper names contained in features.txt
* column bind subjects id with activities and features in list hte3
  subject code from "subject_" sets are binded by row for both sets. This subjectXy_ structure is *parked* in a new list hte3
* refine name of subjects column in subjects frames
* remove X_ y_ and subject_ unmerged from ht2 and replace them with the ones merged in hte3

  ----
## Merging
* rowbind train and test datasets
* check
  ----
## 1st data frame
* select only those columns that are about mean and std via grepl
* further refining on names
* clean up the lists

  ----
## 2nd data frame
* means by subject and activity with dplyr
  
  