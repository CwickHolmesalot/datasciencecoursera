#install.packages('jsonlite')
library(jsonlite)
#install.packages('httpuv')
library(httpuv)
#install.packages('httr')
library(httr)
install.packages('sqldf')
library(sqldf)

## go to working directory for course
setwd('C:/Users/chadwick/Desktop/DataScience-R/Getting_Data')

if(!file.exists("data"))
  dir.create("data")

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
gh <- oauth_endpoints("github")


# 2. To make your own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "b96400a49a93442b43a9",
                   secret = "08aab1567cd1296d80ca6eb4b5cee858e47a37a4")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(gh, myapp)


# 4. Use API
request <- GET("https://api.github.com/users/jtleek/repos",config(token = github_token))
stop_for_status(request)
rp_val <- content(request)

for (i in 1:length(rp_val)) {
  if(rp_val[[i]]$name == "datasharing")
  {
    print(rp_val[[i]]$created_at)
  }
}
## ANSWER 1: "2013-11-07T13:25:07Z"

## Question 2

## download file
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(fileURL, destfile = 'data/ACS_community.csv', method='curl')

## note download date
dateDownloaded <- date()
dateDownloaded

## load data
acs <- read.table("data/communities.csv", sep = ",", header = TRUE)
str(acs)

## ANSWER 2: 
nrow(sqldf("select wgtp1 from acs where AGS < 50"))

## Question 3

## ANSWER 3:
sqldf("select distinct AGS from acs")

## Question 4
htmlconnection = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlcode = readLines(htmlconnection)
close(htmlconnection)
print(nchar(htmlcode[10]))
print(nchar(htmlcode[20]))
print(nchar(htmlcode[30]))
print(nchar(htmlcode[100]))

## ANSWER 4:
# 45 31 7 25

## Question 5
fileURL <- url("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
download.file(fileURL, destfile = 'data/wksst8110.for', method='curl')

# column sequence: 5x empty space, SST column, SSTA column
col_seq <- c(-5, 4, 4)

df <- read.fwf(fileURL, 
               widths = c(-1, 9, col_seq, col_seq, col_seq, col_seq),
               skip = 4)
sum(df[, 4])