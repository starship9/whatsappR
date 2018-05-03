setwd("C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR")

whatsappRaw <-
  read.table(
    "WhatsApp Chat with CSE2018.txt",
    header = FALSE,
    fill = TRUE,
    stringsAsFactors = FALSE
  )
tail(whatsappRaw)
sample(whatsappRaw, 3)
head(whatsappRaw)
str(whatsappRaw)

class(whatsappRaw)
#whatsappRaw$V5 <- as.factor(whatsappRaw$V5)
#table(whatsappRaw$V5)

#basic cleaning
whatsappRaw <- whatsappRaw %>% filter(is.na(as.numeric(V5)))
whatsappRaw <- whatsappRaw %>% filter(V4 == "-")
whatsappRaw$V6[whatsappRaw$V6 == "added"] <- ""
whatsappRaw$V6[is.numeric(whatsappRaw$V6)] <- ""
whatsappRaw$V6[!is.na(as.numeric(whatsappRaw$V6))] <- ""
whatsappRaw$V6[whatsappRaw$V6 == "removed" |
                 whatsappRaw$V6 == "changed"] <- ""
whatsappRaw$V7[whatsappRaw$V7 == "added"] <- ""
whatsappRaw$V7[whatsappRaw$V7 == "removed" |
                 whatsappRaw$V7 == "changed"] <- ""
whatsappRaw$V7[!is.na(as.numeric(whatsappRaw$V7))] <- ""

library(tidyverse)
library(tidytext)

whatsappDF <- whatsappRaw %>% select(V5:V18)
View(whatsappDF)

#head(paste(whatsappDF$V7:whatsappDF$V18))

#whatsappChat <-
# readLines(
#    "WhatsApp Chat with CSE2018.txt"
#  )

#whatsappDFTidy <- data_frame(text = whatsappChat)
#whatsappDFTidy <- whatsappDFTidy %>% unnest_tokens(word,text) %>% anti_join(stop_words)

#sort(table(whatsappDF$V6)>10)
whatsappDF$V6[whatsappDF$V6 %in% c(
  "Mitra:",
  "Voruganti:",
  "Pathak:",
  "Miglani:",
  "Saini:",
  "Mukhopaddhay:",
  "Ananth:",
  "Manivanan:",
  "Jose:",
  "Gairola:",
  "C:"
)] <- ""

#whatsappDF$text <- paste(whatsappDF$(V6:V18))
#unite(whatsappDF, paste(colnames(whatsappDF)[-1], collapse=" "), colnames(whatsappDF)[-1])

#unite(whatsappDF,text,-1)
whatsappDFUnite <-
  unite(whatsappDF, text,-1, sep = " ", remove = TRUE)
head(whatsappDFUnite)
View(whatsappDFUnite)

colnames(whatsappDFUnite) <- c("Name", "text")
whatsappTidy <-
  whatsappDFUnite %>% unnest_tokens(word, text)  %>% anti_join(stop_words) %>% count(Name, word, sort = TRUE) %>% ungroup()

head(whatsappTidy)
tail(whatsappTidy)

totalWords <-
  whatsappTidy %>% group_by(Name) %>% summarize(total = sum(n))
whatsappTidy <- left_join(whatsappTidy, totalWords)
whatsappTidy

whatsappTidy <- whatsappTidy %>% bind_tf_idf(word, Name, n)
whatsappTidy <- whatsappTidy %>% filter(!word %in% c("happy","birthday","junaid","omitted","media"))

whatsappTidy %>% select(-total) %>% arrange(desc(tf_idf))

whatsappTidy %>% arrange(desc(tf_idf)) %>% mutate(word = factor(word, levels = rev(unique(word)))) %>% group_by(Name) %>% top_n(5) %>% ungroup %>% ggplot(aes(word, tf_idf, fill = Name)) +
  geom_col(show.legend = FALSE) + labs(x = NULL, y = "tf-idf") + facet_wrap( ~
                                                                               Name, ncol = 5, scales = "free") + coord_flip()
library(wordcloud)
library(RColorBrewer)
set.seed(100)
par(bg = "black")
wordcloud(
  whatsappTidy$word,
  max.words = 100,
  min.freq = 1000,
  random.order = FALSE,
  random.color = FALSE,
  scale = c(2, 0.25),
  colors = brewer.pal(9, "PuBuGn")
)

library(reshape2)
whatsappDFUnite %>% unnest_tokens(word,text) %>% anti_join(stop_words) %>%  filter(word!="happy") %>% inner_join(get_sentiments("bing")) %>% count(word, sentiment, sort = TRUE) %>% acast(word ~
                                                                                                        sentiment, value.var = "n", fill = 0) %>% comparison.cloud(
                                                                                                          colors = brewer.pal(8, "Dark2"),
                                                                                                          max.words = 100,
                                                                                                          scale = c(2.5, 0.5)
                                                                                                        )
par(bg="black")
wordcloud(
  whatsappTidy$Name,
  min.freq = 100,
  random.order = FALSE,
  random.color = FALSE,
  scale = c(3, 0.5),
  colors = brewer.pal(9, "PuBuGn")
)
