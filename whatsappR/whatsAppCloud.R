setwd("C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR")

whatsappRaw <-
  read.table(
    "WhatsApp Chat with Shambhavi V.txt",
    header = FALSE,
    fill = TRUE,
    stringsAsFactors = FALSE
  )
View(whatsappRaw)
#str(whatsappRaw)
library(tm)
library(RColorBrewer)
library(tidyverse)
library(tidytext)
#head(whatsappRaw,1)
#docs <- VCorpus(DirSource(getwd()))
#summary(docs)
#inspect(docs[6])
whatsappRaw <- whatsappRaw[, 7:20]
#View(whatsappRaw)
docs <- Corpus(VectorSource(whatsappRaw))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, as.vector(as.matrix(stop_words)))
docs <-
  tm_map(
    docs,
    removeWords,
    c(
      "happy",
      "birthday",
      "saini",
      "mitra",
      "jose",
      "voruganti",
      "mukhopaddhay",
      "gairola",
      "miglani",
      "??~"
    )
  )


library(wordcloud)

#pdf("shreyCloud.pdf")
wordcloud(
  docs,
  random.order = FALSE,
  max.words = 100,
  random.color = FALSE,
  colors = brewer.pal(9, "Dark2"),
  scale = c(3, 0.5)
)
#dev.off()

tdm <- TermDocumentMatrix(docs)
m <- as.matrix(tdm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
head(d, 10)

wordcloud(
  words = d$word,
  freq = d$freq,
  min.freq = 1,
  max.words = 100,
  random.order = FALSE,
  rot.per = 0.35,
  colors = brewer.pal(9, "Dark2"),
  scale = c(3, 0.5)
)


library(dplyr)
whatsappDF <- tbl_df(whatsappRaw)
head(whatsappDF)
select(whatsappDF, V5)
whatsappDF$V5 <- gsub('\\d+', '', whatsappDF$V5)
whatsappDF$V5 <- gsub('\\You+', '', whatsappDF$V5)
library(wordcloud)
wordcloud(
  whatsappDF$V5,
  random.order = FALSE,
  max.words = 100,
  col = brewer.pal(7, "Accent")
)
whatsappDF$V6 <- gsub('\\Saini+', '', whatsappDF$V6)
whatsappDF$V6 <- gsub('\\Jose+', '', whatsappDF$V6)
whatsappDF$V6 <- gsub('\\Mitra+', '', whatsappDF$V6)
whatsappDF$V6 <- gsub('\\Miglani+', '', whatsappDF$V6)
whatsappDF$V6 <- gsub('\\d+', '', whatsappDF$V6)
#newData$combineData<-gsub('\\Saini+', '', newData$combineData)
#newData$combineData<-gsub('\\Jose+', '', newData$combineData)
newData <- select(whatsappDF, V6:V20)

newData <-
  unite(newData,
        combineData,
        V6:V20,
        sep = " ",
        remove = TRUE)
newData$combineData <- gsub('\\d+', '', newData$combineData)
wordcloud(
  newData$combineData,
  random.order = FALSE,
  max.words = 100,
  col = brewer.pal(10, "Set3")
)

text <-
  readLines(
    "C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR/WhatsApp Chat with Shambhavi V.txt"
  )
head(text)
tail(text)
textDF <- as.data.frame(text)
library(tidyverse)
library(tidytext)
names(textDF)
textDF %>% unnest_tokens(tokens, text)
textChat <-
  readLines(
    "C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR/WhatsApp Chat with Shambhavi V.txt"
  )
textDF <- data.frame(text = textChat)
textDF %>% unnest_tokens(tokens, text)
textDF$text
textDF %>% unnest_tokens(tokens, text)
textDF %>% unnest_tokens(text, token)
?unnest_tokens
textDF <- data_frame(text = textChat)
textDF
textDF %>% unnest_tokens(word, text)
textDF %>% unnest_tokens(word, text) %>% anti_join(stop_words)
tidyWA <- textDF %>% count(word, sort = TRUE)
tidyWA <-
  textDF %>% unnest_tokens(word, text) %>% anti_join(stop_words)
tidyWA %>% count(word, sort = TRUE)
tidyWA %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                  sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                    colors = c("#F8766D", "#00BFC4"),
                                                                                                    max.words = 100,
                                                                                                    scale = c(3, 0.5)
                                                                                                  )
library(wordcloud)
library(reshape2)
tidyWA %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                  sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                    colors = c("#F8766D", "#00BFC4"),
                                                                                                    max.words = 100,
                                                                                                    scale = c(3, 0.5)
                                                                                                  )
tidyWA %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                  sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                    colors = c("#F8766D", "#00BFC4"),
                                                                                                    max.words = 100,
                                                                                                    scale = c(2, 0.25)
                                                                                                  )
tidyWA %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                  sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                    colors = c("#F8766D", "#00BFC4"),
                                                                                                    max.words = 100,
                                                                                                    scale = c(2, 0.5)
                                                                                                  )
pdf("comparisonSV.pdf")
print(
  tidyWA %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                    sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                      colors = c("#F8766D", "#00BFC4"),
                                                                                                      max.words = 100,
                                                                                                      scale = c(2, 0.5)
                                                                                                    )
)
dev.off()
