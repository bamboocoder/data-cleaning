*Run Analysis Description to understand the code*

There will be two files, one is used to store all methods used in this calculation second one used to call it in sequence.  

1. Run_Analysis.R (Parent script file)
2. Run_Analysis_Method.R (Dependent script file)

#Steps

## Load the records

**Method**
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

