print("Hello, this is my version")
print(version)

yourdirectory<-"H:\\CasaUfficio\\R notes\\JH Coursera Data Science Toolbox\\Getting and Cleaning Data"
#create dir
setwd(yourdirectory)
if(!file.exists("data")) {
  dir.create("data")
}
#download data
setwd(".\\data")
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data.zip")) {
  download.file(url,destfile="data.zip")
  dateDownloaded<-date()
  print(dateDownloaded)
  }

#unzip data
mydir<-getwd()
if(!file.exists("UCI HAR Dataset")) {
  unzip("data.zip", exdir=mydir)  
}
fileslist<-list.files(path=mydir,pattern="*.txt", full.names=TRUE, recursive=TRUE)

traintest<-c("train","test")
#read triaxial data into a list "hte"
for (h in 1:2){
    for (i in 1:3){
    for (j in 1:3){
      a<-c("body_acc","body_gyro","total_acc")[i]
      b<-c("_x_","_y_","_z_")[j]
      c<-traintest[h]
      if (h==1 & i==1 & j==1) {
        hte<-list(read.table(fileslist[grepl(paste(a,b,c,".txt",sep=""),fileslist)],sep=""))
              }else {
          hte[[length(hte)+1]]<-read.table(fileslist[grepl(paste(a,b,c,".txt",sep=""),fileslist)],sep="")                }
      names(hte)[length(hte)]<-paste(a,b,c,sep="")
      print(names(hte)[length(hte)])
    }
  }  
}
#read train and test data into the same list "hte"
for (i in c("X_","/y_","subject_")) {
  for (j in traintest) {
    hte[[length(hte)+1]]<-read.table(fileslist[grepl(paste(i,j,sep=""),fileslist)],sep="")
    names(hte)[length(hte)]<-paste(i,j,sep="")
  }
}
names(hte)
#refine names
names(hte)[grepl("/y_",names(hte))]<-gsub("/y_","y_",names(hte)[grepl("/y_",names(hte))])
names(hte)
#create function to label if train or test sample
addtraintest<-function(x,z) {
  traintest<-rep(z,nrow(x))
  x1<-cbind(x,traintest)    
  return(x1)
  }

#apply function to "hte" list
for (i in traintest) {
    if (i=="train") {
    htetrain<-lapply(hte[grepl(i,names(hte))],addtraintest,z=i)
    names(htetrain)<-names(hte)[grepl(i,names(hte))]  
  }else {
    htetest<-lapply(hte[grepl(i,names(hte))],addtraintest,z=i)
    names(htetest)<-names(hte)[grepl(i,names(hte))]
    hte2<-c(htetest,htetrain)
  }
  }
rm(hte,htetest,htetrain)

#assign activity_labels to y_
activity_labels<-read.table(fileslist[grepl("activity_labels",fileslist)])
names(activity_labels)<-c("activity","activity_label")

for (i in c("train","test")) {
  names(hte2[[paste("y_",i,sep="")]])[1]<-"activity"  
  hte2[[paste("y_",i,sep="")]]<-merge.data.frame(hte2[[paste("y_",i,sep="")]],activity_labels,by="activity")
}

#assign features to X_
features<-read.table(fileslist[grepl("\\bfeatures\\b",fileslist)])
names(features)<-c("feature","featureslabel")
for (i in c("train","test")) {
  names(hte2[[paste("X_",i,sep="")]])[1:nrow(features)]<-as.character(features$featureslabel)
}
#column bind subjects id with activities and features in list hte3
hte3<-list()
for (i in traintest) {
  hte3[[which(traintest==i)]]<-cbind(read.table(fileslist[grepl(paste("subject_",i,sep=""),fileslist)]),hte2[[paste("X_",i,sep="")]],hte2[[paste("y_",i,sep="")]])  
  names(hte3)[which(traintest==i)]<-paste("subjectXy_",traintest[which(traintest==i)],sep="")
}
names(hte3[[paste("subjectXy_",i,sep="")]])[1]
#refine name of subjects column in subjects frames
for (i in traintest) {
  names(hte3[[paste("subjectXy_",i,sep="")]])[1]<-"subject"  
}
names(hte3[[paste("subjectXy_",i,sep="")]])[1]
#remove X_ y_ and subject_ unmerged and replace them with the ones merged in hte3
hte2[which(grepl("^X_|^y_|^subject",names(hte2)))]<-NULL
for (i in traintest) {
  hte2[[length(hte2)+1]]<-hte3[[which(traintest==i)]]
  names(hte2)[length(hte2)]<-names(hte3)[which(traintest==i)]
}

#rowbind train and test datasets
namesroots<-gsub("test","",names(hte2)[grepl("test",names(hte2))])
htetraintest<-list()
for (i in namesroots) {
  htetraintest[[which(namesroots==i)]]<-rbind(hte2[[paste(i,"test",sep="")]],hte2[[paste(i,"train",sep="")]])
  names(htetraintest)[which(namesroots==i)]<-namesroots[which(namesroots==i)]
}
#check
table(htetraintest[["subjectXy_"]][563]==htetraintest[["subjectXy_"]][565])
#remove excess traintest column
htetraintest[["subjectXy_"]][565]<-NULL
#select only those columns that are about mean and std
meanstd<-htetraintest[["subjectXy_"]][grepl("subject|traintest|activity|mean|std",names(htetraintest[["subjectXy_"]]))]
#further refining on names
library(dplyr)
names(meanstd)<-gsub("\\()","",names(meanstd))
meanstd<- meanstd %>% select(-c(traintest,activity)) %>% rename(activity=activity_label) 
#clean up the lists
rm(htetraintest,hte2,hte3)
head(meanstd)
#activity/subject tidy frame
meansby_activity_subject<-meanstd %>%  group_by(subject,activity) %>%  summarize_all(funs(mean))
#remove all the rest
rm(activity_labels,features)

#the requested data frame
meansby_activity_subject

write.table(meansby_activity_subject,file = "step5data.txt",row.name=FALSE)

