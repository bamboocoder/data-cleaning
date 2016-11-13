source("run_analysis_methods.R")

# Load the data
LoadTheData()

# Unzip and load folder 
#LoadUnzipAndData()

# Read the file 
ReadTheFile()

# Merge records 
MergeRecords()

# Extract only the mean and standard deviation
ExtractMeanStandardDeviation()

# Use descriptive activity names
DescriptiveActivity()

# Label with descriptive activity names
LabelDescriptiveActivityNames()

# Create a tidy data set
CreateTidyDataSet()