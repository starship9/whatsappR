setwd("C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR")

whatsappRaw <- read.table("WhatsApp Chat with CSE.txt", header=FALSE,fill = TRUE, stringsAsFactors = FALSE)
View(whatsappRaw)
str(whatsappRaw)
library(tm)
library(RColorBrewer)
library(tidyverse)
library(tidytext)

#docs <- VCorpus(DirSource(getwd()))
#summary(docs)

#inspect(docs[6])
whatsappRaw <- whatsappRaw[,6:18]
View(whatsappRaw)
docs <- Corpus(VectorSource(whatsappRaw))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs,tolower)
docs <- tm_map(docs,removeNumbers)
docs <- tm_map(docs,removeWords,stopwords("english"))
docs <- tm_map(docs,removeWords,as.vector(as.matrix(stop_words)))
docs <- tm_map(docs,removeWords,c("happy","birthday","saini","mitra","jose","voruganti","mukhopaddhay","gairola","miglani"))


library(wordcloud)
wordcloud(docs, random.order = FALSE,max.words = 100,random.color = FALSE, colors = brewer.pal(9,"Accent"))


library(dplyr)
whatsappDF <- tbl_df(whatsappRaw)
head(whatsappDF) 
select(whatsappDF,V5)
whatsappDF$V5<-gsub('\\d+', '', whatsappDF$V5)
whatsappDF$V5<-gsub('\\You+', '', whatsappDF$V5)
library(wordcloud)
wordcloud(whatsappDF$V5, random.order = FALSE, max.words = 100, col = brewer.pal(7,"Accent"))
whatsappDF$V6<-gsub('\\Saini+', '', whatsappDF$V6)
whatsappDF$V6<-gsub('\\Jose+', '', whatsappDF$V6)
whatsappDF$V6<-gsub('\\Mitra+', '', whatsappDF$V6)
whatsappDF$V6<-gsub('\\Miglani+', '', whatsappDF$V6)
whatsappDF$V6<-gsub('\\d+', '', whatsappDF$V6)
#newData$combineData<-gsub('\\Saini+', '', newData$combineData)
#newData$combineData<-gsub('\\Jose+', '', newData$combineData)
newData<-select(whatsappDF,V6:V20)

newData<-unite(newData, combineData, V6:V20,sep = " ", remove = TRUE)
newData$combineData<-gsub('\\d+', '', newData$combineData)
wordcloud(newData$combineData, random.order = FALSE, max.words = 100, col = brewer.pal(10,"Set3"))


