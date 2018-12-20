*Cleaning and reshaping procedure
My script run_analysis.R runs with the data from the wearable computing experiment of Samsung
**Strategy
run_analysis.R 
  -downloads the data directly from the link provided by the course
  -applies meaningful labels to the data
  -merges the training and test sets
  -creates a 1st tidy frame with the means and standard deviations of all features measured
  -creates a 2nd tidy frame with the means per subject and activity of the measures contained in the 1st   data frame
**Download
  -create dir
  -unzip data
  -read triaxial data into a list "hte"
  -read train and test data into the same list "hte"
**Labels and names
  -refine names of the elements of the list
  -create function to label if train or test sample
  -apply function to "hte" list
  -assign activity_labels to y_
  -assign features to X_
  -column bind subjects id with activities and features in list hte3
  -refine name of subjects column in subjects frames
  -remove X_ y_ and subject_ unmerged and replace them with the ones merged in hte3
**Merging
  -rowbind train and test datasets
  -check
**1st data frame
  -select only those columns that are about mean and std
  -further refining on names
  -clean up the lists
**2ns data frame
  -means by subject and activity with dplyr