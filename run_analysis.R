#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#===============================================================================
# JHU Getting and Cleaning Data: Course Project
#   - Before running code need to download and unzip data
#      -- see README for more details
#===============================================================================

library(plyr)

setwd('C:/Users/dan/Desktop/coursera/jhu_ds3/project')

#===============================================================================
#STEP 1: Read in Raw Data
#===============================================================================

#set file paths ----------------------------------------------------------------

feature_path = './UCI HAR Dataset/features.txt'

tr_x_path = './UCI HAR Dataset/train/X_train.txt'
tr_y_path = './UCI HAR Dataset/train/y_train.txt'
tr_s_path = './UCI HAR Dataset/train/subject_train.txt'

ts_x_path = './UCI HAR Dataset/test/X_test.txt'
ts_y_path = './UCI HAR Dataset/test/y_test.txt'
ts_s_path = './UCI HAR Dataset/test/subject_test.txt'

act_lbl_path = './UCI HAR Dataset/activity_labels.txt'

#output data
out_path = './summary_data.txt'

#read in data ------------------------------------------------------------------

#define line reader function
lines_reader = function(file_path){
    ctcn = srcfile(file_path)
    con = open(ctcn,1)
    data_lines = readLines(con)
    close(con)
    data_lines
}

#features
feat = lines_reader(feature_path)

#train
tr_x = read.table(tr_x_path)
tr_y = read.table(tr_y_path)
tr_s = read.table(tr_s_path)

#test
ts_x = read.table(ts_x_path)
ts_y = read.table(ts_y_path)
ts_s = read.table(ts_s_path)

#activity labels
act_lbl = read.table(act_lbl_path)

#===============================================================================
#STEP 2: Setup main dataset
#===============================================================================

#Identify columns to keep ------------------------------------------------------

#get column numbers
space = regexpr(' ',feat)
nums = as.integer(substr(feat,1,space-1))

#get column names
dash = regexpr('-',feat)
var_names = substr(feat,space+1,dash-1)

#flag mean and std columns
is_mean = regexpr('mean[(][)]',feat) > 0
is_std = regexpr('std[(][)]',feat) > 0

suffix = rep("",561)

for(i in 1:561){
    if(is_mean[i]) suffix[i] = ".mean."
    if(is_std[i]) suffix[i] = ".std."
}

suffix2 = substr(feat,nchar(feat),nchar(feat))

#now get columns numbers and column names to keep
keepers = is_mean | is_std
keep_nums = nums[keepers]
keep_names = var_names[keepers]
keep_suffix = suffix[keepers]
keep_suffix2 = suffix2[keepers]

fnl_names = paste(keep_names, keep_suffix, keep_suffix2, sep="")

#replace last chars of names that arent on an axis
drop2char = substr(fnl_names,nchar(fnl_names),nchar(fnl_names)) == ")"
new_names = fnl_names[drop2char]
new_names = substr(new_names,1,nchar(new_names)-2)

fnl_names[drop2char] = new_names


#Trim down data to mean and std columns ----------------------------------------

#stack train and test sets for x, y, and labels
all_x = rbind(tr_x, ts_x)
all_y = rbind(tr_y, ts_y)
all_s = rbind(tr_s, ts_s)


#keep desired variables from x
trim_x = all_x[,keep_nums]

#setup final dataset
main_data = cbind(all_s,trim_x,all_y)

names(main_data) = c("subject.id",fnl_names,"activity.id")


#get activity names
names(act_lbl) = c("activity.id","activity.name")
main_data = merge(main_data,act_lbl,by="activity.id")
main_data$activity.id = NULL
main_data = main_data[order(main_data$subject.id),]

#===============================================================================
#STEP 3: Setup data summarized by subject
#===============================================================================


#setup function for use in ddply
sumry_calc = function(df){
    colMeans(df[,fnl_names])
}

sumry_data = ddply(main_data, c("subject.id","activity.name"), sumry_calc)

names(sumry_data) = c("subject.id","activity.name",fnl_names)

#write summary to file
write.table(sumry_data,out_path,row.names = F)





