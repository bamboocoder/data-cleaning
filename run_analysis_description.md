*Run Analysis Description to understand the code*

There will be two files, one is used to store all methods used in this calculation second one used to call it in sequence.  

1. Run_Analysis.R (Parent script file)
2. Run_Analysis_Method.R (Dependent script file)

#Steps

## 1. Load the records

LoadTheData()

```r
LoadTheData <- function(){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  datasetFile <- "DatasetFile.zip";
  filePath <- getwd();
  
  if (!file.exists(paste(filePath,'/',datasetFile,sep = "")))
  {
    # download the file from InterNet 
    download.file(url, file.path(filePath, datasetFile))
  }
}
```
## 2. Unzip and create folder 

LoadUnzipAndData()

```r
LoadUnzipAndData <- function(){
  executable <- file.path("C:", "Program Files (x86)", "7-Zip", "7z.exe")
  parameters <- "x"
  cmd <- paste(paste0("\"", executable, "\""), parameters, paste0("\"",
          file.path(filePath, datasetFile), "\""))
  system(cmd)
  
  pathIn <- file.path(path, "UCI HAR Dataset")
  list.files(pathIn, recursive = TRUE)
}
```
**output**

 [1] "activity_labels.txt"                         
 [2] "features.txt"                                
 [3] "features_info.txt"                           
 [4] "README.txt"                                  
 [5] "test/Inertial Signals/body_acc_x_test.txt"   
 [6] "test/Inertial Signals/body_acc_y_test.txt"   
 [7] "test/Inertial Signals/body_acc_z_test.txt"   
 [8] "test/Inertial Signals/body_gyro_x_test.txt"  
 [9] "test/Inertial Signals/body_gyro_y_test.txt"  
[10] "test/Inertial Signals/body_gyro_z_test.txt"  
[11] "test/Inertial Signals/total_acc_x_test.txt"  
[12] "test/Inertial Signals/total_acc_y_test.txt"  
[13] "test/Inertial Signals/total_acc_z_test.txt"  
[14] "test/subject_test.txt"                       
[15] "test/X_test.txt"                             
[16] "test/y_test.txt"                             
[17] "train/Inertial Signals/body_acc_x_train.txt" 
[18] "train/Inertial Signals/body_acc_y_train.txt" 
[19] "train/Inertial Signals/body_acc_z_train.txt" 
[20] "train/Inertial Signals/body_gyro_x_train.txt"
[21] "train/Inertial Signals/body_gyro_y_train.txt"
[22] "train/Inertial Signals/body_gyro_z_train.txt"
[23] "train/Inertial Signals/total_acc_x_train.txt"
[24] "train/Inertial Signals/total_acc_y_train.txt"
[25] "train/Inertial Signals/total_acc_z_train.txt"
[26] "train/subject_train.txt"                     
[27] "train/X_train.txt"                           
[28] "train/y_train.txt"          

## 3. Merge Record

MergeRecords()

```r
MergeRecords <- function(){
  dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
  setnames(dtSubject, "V1", "subject")
  dtActivity <- rbind(dtActivityTrain, dtActivityTest)
  setnames(dtActivity, "V1", "activityNum")
  dt <- rbind(dtTrain, dtTest)
  dtSubject <- cbind(dtSubject, dtActivity)
  dt <- cbind(dtSubject, dt)
  setkey(dt, subject, activityNum)
}
```
4. Extract only the mean and standard deviation

ExtractMeanStandardDeviation()

```r
ExtractMeanStandardDeviation() <- function(){
  dtFeatures <- fread(file.path(pathIn, "features.txt"))
  setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))
  dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]
  dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]
  select <- c(key(dt), dtFeatures$featureCode)
  dt <- dt[, select, with = FALSE]
}
```
**Output**

head(dtFeatures)
```r
##    featureNum       featureName featureCode
## 1:          1 tBodyAcc-mean()-X          V1
## 2:          2 tBodyAcc-mean()-Y          V2
## 3:          3 tBodyAcc-mean()-Z          V3
## 4:          4  tBodyAcc-std()-X          V4
## 5:          5  tBodyAcc-std()-Y          V5
## 6:          6  tBodyAcc-std()-Z          V6
```
dtFeatures$featureCode
```r
##  [1] "V1"   "V2"   "V3"   "V4"   "V5"   "V6"   "V41"  "V42"  "V43"  "V44" 
## [11] "V45"  "V46"  "V81"  "V82"  "V83"  "V84"  "V85"  "V86"  "V121" "V122"
## [21] "V123" "V124" "V125" "V126" "V161" "V162" "V163" "V164" "V165" "V166"
## [31] "V201" "V202" "V214" "V215" "V227" "V228" "V240" "V241" "V253" "V254"
## [41] "V266" "V267" "V268" "V269" "V270" "V271" "V345" "V346" "V347" "V348"
## [51] "V349" "V350" "V424" "V425" "V426" "V427" "V428" "V429" "V503" "V504"
## [61] "V516" "V517" "V529" "V530" "V542" "V543"
```
5.  Use descriptive activity names

DescriptiveActivity()

```r
DescriptiveActivity <- function(){
  dtActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
  setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))
}
```

6.  Label with descriptive activity names

LabelDescriptiveActivityNames()

```r
LabelDescriptiveActivityNames() <- function(){
  dt <- merge(dt, dtActivityNames, by = "activityNum", all.x = TRUE)
  setkey(dt, subject, activityNum, activityName)
  dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))
  dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by = "featureCode", 
              all.x = TRUE)
  dt$activity <- factor(dt$activityName)
  dt$feature <- factor(dt$featureName)
  
  ## Features with 2 categories
  n <- 2
  y <- matrix(seq(1, n), nrow = n)
  x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
  dt$featDomain <- factor(x %*% y, labels = c("Time", "Freq"))
  x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
  dt$featInstrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
  x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol = nrow(y))
  dt$featAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
  x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol = nrow(y))
  dt$featVariable <- factor(x %*% y, labels = c("Mean", "SD"))
  ## Features with 1 category
  dt$featJerk <- factor(grepthis("Jerk"), labels = c(NA, "Jerk"))
  dt$featMagnitude <- factor(grepthis("Mag"), labels = c(NA, "Magnitude"))
  ## Features with 3 categories
  n <- 3
  y <- matrix(seq(1, n), nrow = n)
  x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol = nrow(y))
  dt$featAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))
  
  r1 <- nrow(dt[, .N, by = c("feature")])
  r2 <- nrow(dt[, .N, by = c("featDomain", "featAcceleration", "featInstrument", 
                             "featJerk", "featMagnitude", "featVariable", "featAxis")])
  r1 == r2
}

grepthis <- function(regex) {
  grepl(regex, dt$feature)
}
```
