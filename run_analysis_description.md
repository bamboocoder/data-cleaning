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

