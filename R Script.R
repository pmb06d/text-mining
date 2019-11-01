
######### Combining data for vectorizing and topic modeling #########

HBONOW_IOS <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HBONOW-full-IOS.csv",stringsAsFactors = FALSE)
HBONOW_IOS$OS <- "IOS"

HBOGO_IOS <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HBOGO-full-IOS.csv",stringsAsFactors = FALSE)
HBOGO_IOS$OS <- "IOS"

PRIME_Play <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/AMAZONPRIME-full-PlayStore.csv",stringsAsFactors = FALSE)
PRIME_Play$OS <- "Android"

PRIME_IOS <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/AMAZONPRIME-full-IOS.csv",stringsAsFactors = FALSE)
PRIME_IOS$OS <- "IOS"

HULU_Play <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HULU-full-PlayStore.csv",stringsAsFactors = FALSE)
HULU_Play$OS <- "Android"

HULU_IOS <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HULU-full-IOS.csv",stringsAsFactors = FALSE)
HULU_IOS$OS <- "IOS"

Netflix_Play <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/NETFLIX-full-PlayStore.csv",stringsAsFactors = FALSE)
Netflix_Play$OS <- "Android"

Netflix_IOS <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/NETFLIX-full-IOS.csv",stringsAsFactors = FALSE)
Netflix_IOS$OS <- "IOS"

HBONOW_Play <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HBONOW-full-PlayStore.csv",stringsAsFactors = FALSE)
HBONOW_Play$OS <- "Android"

HBOGO_Play <- read.csv("C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/HBOGO-full-PlayStore.csv",stringsAsFactors = FALSE)
HBOGO_Play$OS <- "Android"

# Combining

FullData <- rbind(HBONOW_IOS,HBOGO_IOS,PRIME_Play,PRIME_IOS,HULU_Play,HULU_IOS,Netflix_Play,Netflix_IOS,HBONOW_Play,HBOGO_Play)

######### Cleaning platform labels #########

#"HBO NOW" --> "HBONOW"
#"HBO GO: Stream with TV Package" --> "HBOGO"
#"Amazon Prime Video" --> "PRIME"
#"Hulu: Stream TV, Movies & more" --> "HULU"
#"Hulu: Watch TV Shows & Movies" --> "HULU"
#"Netflix"
#"HBO NOW: Stream TV & Movies" --> "HBONOW"

FullData$Platform <- FullData$Source

FullData$Platform <- gsub("HBO NOW","HBONOW",FullData$Platform)
FullData$Platform <- gsub("HBO GO: Stream with TV Package","HBOGO",FullData$Platform)
FullData$Platform <- gsub("Amazon Prime Video","PRIME",FullData$Platform)
FullData$Platform <- gsub("Hulu: Stream TV, Movies & more","HULU",FullData$Platform)
FullData$Platform <- gsub("Hulu: Watch TV Shows & Movies","HULU",FullData$Platform)
FullData$Platform <- gsub("HBONOW: Stream TV & Movies","HBONOW",FullData$Platform)

#Combine HBOGO into HBONOW to boost presence
FullData$Platform <- gsub("HBOGO","HBONOW",FullData$Platform)

FullData$DiscRating <- cut(FullData$Rating, breaks = c(-Inf,1,4,Inf), labels = c("low","average","high"))
FullData$MContent <- paste(FullData$Title,FullData$Content,sep=" ")

FullData[,c("Title")] <- iconv(FullData[,c("Title")], from = 'UTF-8', to = 'ASCII//TRANSLIT')
FullData[,c("Content")] <- iconv(FullData[,c("Content")], from = 'UTF-8', to = 'ASCII//TRANSLIT')
FullData[,c("Name")] <- iconv(FullData[,c("Name")], from = 'UTF-8', to = 'ASCII//TRANSLIT')
FullData[,c("MContent")] <- iconv(FullData[,c("MContent")], from = 'UTF-8', to = 'ASCII//TRANSLIT')

# Dropping post conversion NA's and useless variables (name, version)
FullDataClean <- FullData[!is.na(FullData$MContent)&!is.na(FullData$Content)&!is.na(FullData$Title),]
FullDataClean <- FullDataClean[,-c(1,5,7)]
FullDataClean$Content <- gsub("\n","",FullDataClean$Content)
FullDataClean$MContent <- gsub("\n","",FullDataClean$MContent)

#Second dataframe/different discretization
FullData2 <- FullData
FullData2$DiscRating <- cut(FullData2$Rating, breaks = c(-Inf,2,3,Inf), labels = c("low2","average","high2"))

sklearnData <- FullDataClean[,c(7,8)]

sklearnData2 <- FullDataClean[FullDataClean$DiscRating!="average",c(7,8)]

sklearnHBO <- FullDataClean[FullDataClean$DiscRating!="average"&FullDataClean$Platform=="HBONOW",c(7,8)]
sklearnNetflix <- FullDataClean[FullDataClean$DiscRating!="average"&FullDataClean$Platform=="Netflix",c(7,8)]
sklearnHulu <- FullDataClean[FullDataClean$DiscRating!="average"&FullDataClean$Platform=="HULU",c(7,8)]
sklearnPrime <- FullDataClean[FullDataClean$DiscRating!="average"&FullDataClean$Platform=="PRIME",c(7,8)]

######### Saving CSV's #########

#full dataset csv
write.table(FullData,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/FullReviewData2.tsv",quote=FALSE, sep='\t', col.names = NA)

write.table(FullDataClean,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewData.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)

write.table(sklearnData,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewData2.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)

# no avg reviews
write.table(sklearnData2,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewData3.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)

# no avg reviews, tsv by platform
write.table(sklearnHBO,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewDataHBO.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)
write.table(sklearnNetflix,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewDataNetflix.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)
write.table(sklearnHulu,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewDataHulu.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)
write.table(sklearnPrime,"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/CleanReviewDataPrime.tsv",quote=FALSE, sep='\t', na = "", row.names = FALSE)


#text files for topic modeling

#by platform
write.table(FullData[FullData$Platform=="Netflix",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HBONOW",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HULU",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="PRIME",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/primeReviews.txt",col.names = F, row.names = F, quote=F)

#by score
write.table(FullData[FullData$DiscRating=="low",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/lowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$DiscRating=="average",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/avgReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$DiscRating=="high",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/highReviews.txt",col.names = F, row.names = F, quote=F)

#by score and platform

#high
write.table(FullData[FullData$Platform=="Netflix"&FullData$DiscRating=="high",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high_netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HBONOW"&FullData$DiscRating=="high",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high_hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HULU"&FullData$DiscRating=="high",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high_huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="PRIME"&FullData$DiscRating=="high",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high_primeReviews.txt",col.names = F, row.names = F, quote=F)

#average
write.table(FullData[FullData$Platform=="Netflix"&FullData$DiscRating=="average",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/avg_netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HBONOW"&FullData$DiscRating=="average",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/avg_hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HULU"&FullData$DiscRating=="average",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/avg_huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="PRIME"&FullData$DiscRating=="average",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/avg_primeReviews.txt",col.names = F, row.names = F, quote=F)

#low
write.table(FullData[FullData$Platform=="Netflix"&FullData$DiscRating=="low",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low_netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HBONOW"&FullData$DiscRating=="low",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low_hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="HULU"&FullData$DiscRating=="low",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low_huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData[FullData$Platform=="PRIME"&FullData$DiscRating=="low",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low_primeReviews.txt",col.names = F, row.names = F, quote=F)

#by score and platform, alternate

#high2
write.table(FullData2[FullData2$Platform=="Netflix"&FullData2$DiscRating=="high2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high2_netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="HBONOW"&FullData2$DiscRating=="high2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high2_hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="HULU"&FullData2$DiscRating=="high2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high2_huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="PRIME"&FullData2$DiscRating=="high2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/high2_primeReviews.txt",col.names = F, row.names = F, quote=F)

#low2
write.table(FullData2[FullData2$Platform=="Netflix"&FullData2$DiscRating=="low2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low2_netflixReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="HBONOW"&FullData2$DiscRating=="low2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low2_hbonowReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="HULU"&FullData2$DiscRating=="low2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low2_huluReviews.txt",col.names = F, row.names = F, quote=F)
write.table(FullData2[FullData2$Platform=="PRIME"&FullData2$DiscRating=="low2",c("Content")],"C:/Users/pbonnin/Desktop/Local DataScience@Syracuse/IST736 Project/low2_primeReviews.txt",col.names = F, row.names = F, quote=F)


######### Mallet commands #########
# bin\mallet import-dir --input sample-data\TextMiningProject\by_review_platform --output TopicsByPlatformReview.mallet  --keep-sequence --remove-stopwords --extra-stopwords my-stoplist.txt
# bin\mallet train-topics --input TopicsByPlatformReview.mallet --num-topics 10 --optimize-interval 20 --output-state TopicsByPlatformReview-topic-state.gz --output-topic-keys TopicsByPlatformReview_keys.txt --output-doc-topics TopicsByPlatformReview_compostion.txt


# Testing ASCII conversion
# testVector <- iconv(FullData$MContent[1:150], from = 'UTF-8', to = 'ASCII//TRANSLIT')

# Exploring reviews
View(FullDataClean[grep("sense8",FullDataClean$MContent),c("Platform","DiscRating","Title","Content")])

table(FullDataClean[grep("sense8",FullDataClean$MContent),c("DiscRating")])

View(FullDataClean[grep("complaints",FullDataClean$MContent),c("Platform","DiscRating","Title","Content")])

table(FullDataClean[grep("complaints",FullDataClean$MContent),c("DiscRating")])
