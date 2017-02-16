whatsappRaw <- read.table("WhatsApp Chat with CSE Junior Year.txt", header=FALSE,fill = TRUE)
library(dplyr)
whatsappDF <- tbl_df(whatsappRaw)
head(whatsappDF) 
select(whatsappDF,V5)

library(wordcloud)
wordcloud(whatsappDF$V5, random.order = FALSE, max.words = 100)

