library(xlsx)
library(XML)
library(data.table)
library(rbenchmark)

## go to working directory for course
setwd('C:/Users/chadwick/Desktop/DataScience-R/Getting_Data')

if(!file.exists("data"))
  dir.create("data")

## download file
fileURL<- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(fileURL, destfile = 'data/communities.csv', method='curl')

## note download date
dateDownloaded <- date()
dateDownloaded

## load data
communityData <- read.table("data/communities.csv", sep = ",", header = TRUE)
str(communityData)

## QUESTION 1
## count number of properties worth > $1,000,0000
## field == VAL, value == 24
sum(communityData$VAL >= 24, na.rm = TRUE)

## 53 is the answer

## QUESTION 2
## check values of FES variable.  What tidy data principle does it violate
## based on Code Book?

# Family type and employment status
# b .N/A (GQ/vacant/not a family)
# 1 .Married-couple family: Husband and wife in LF
# 2 .Married-couple family: Husband in labor force, wife
# .not in LF
# 3 .Married-couple family: Husband not in LF,
# .wife in LF
# 4 .Married-couple family: Neither husband nor wife in
# .LF
# 5 .Other family: Male householder, no wife present, in
# .LF
# 6 .Other family: Male householder, no wife present,
# .not in LF
# 7 .Other family: Female householder, no husband
# .present, in LF
# 8 .Other family: Female householder, no husband
# .present, not in LF

# More than one variable per column - i.e. this is a combination field

## QUESTION 3

# download Excel spreadsheet on Natural Gas Aquisition Program
fileURL<- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(fileURL, destfile = 'data/NGAP.xlsx', method='curl')

## note download date
dateDownloaded <- date()
dateDownloaded

## load data
rowIndex = 18:23
colIndex = 7:15
dat <- read.xlsx("data/NGAP.xlsx", sheetIndex = 1, colIndex=colIndex, rowIndex=rowIndex)

# detemine value of sum indicated below
sum(dat$Zip*dat$Ext,na.rm=T)

# 36534720

## QUESTION 4

# access XML data
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileURL, useInternal = TRUE)
rootNode <- xmlRoot(doc)

zipcodes <- xpathSApply(rootNode,"//zipcode", xmlValue)
sum(zipcodes == "21231")

## QUESTION 5

# down 2006 microdata survey
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = 'data/ACS2006.csv', method='curl')
DT <- fread("data/ACS2006.csv")
file.info("data/ACS2006.csv")$size

# test time to calculate average of pwgtp15 by gender
bm <- benchmark(
  "sapply" = {
    sapply(split(DT$pwgtp15,DT$SEX),mean)
    },
  "mean1" = {
    mean(DT[DT$SEX==1,]$pwgtp15)
    mean(DT[DT$SEX==2,]$pwgtp15)
    },
  "DT" = {
    DT[,mean(pwgtp15),by=SEX]
    },
  "tapply" = {
    tapply(DT$pwgtp15,DT$SEX,mean)
    },
  "mean2" = {
    mean(DT$pwgtp15,by=DT$SEX)
    },
  # "rowmeans" = {
  #   rowMeans(DT)[DT$SEX==1];
  #   rowMeans(DT)[DT$SEX==2]
  # },
  replications = 1000,
  columns = c("test", "replications", "elapsed", "relative", "user.self", "sys.self")
)
