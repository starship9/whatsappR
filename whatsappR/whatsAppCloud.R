setwd("C:/Users/Nishank/Desktop/SNU/RStuff/whatsappR/whatsappR")

whatsappRaw <-
  read.table(
    "WhatsApp Chat with CSE2018.txt",
    header = FALSE,
    fill = TRUE,
    stringsAsFactors = FALSE
  )
tail(whatsappRaw)
sample(whatsappRaw,3)
head(whatsappRaw)
str(whatsappRaw)

class(whatsappRaw)
#whatsappRaw$V5 <- as.factor(whatsappRaw$V5)
#table(whatsappRaw$V5)

#basic cleaning
whatsappRaw$V6[whatsappRaw$V6=="added"] <- ""
whatsappRaw$V6[is.numeric(whatsappRaw$V6)] <- ""
whatsappRaw$V6[!is.na(as.numeric(whatsappRaw$V6))] <- ""
whatsappRaw$V6[whatsappRaw$V6=="removed" | whatsappRaw$V6=="changed"] <- ""
whatsappRaw$V7[whatsappRaw$V7=="added"] <- ""
whatsappRaw$V7[whatsappRaw$V7=="removed" | whatsappRaw$V7=="changed"] <- ""
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
whatsappDF$V6[whatsappDF$V6 %in% c("Mitra:","Voruganti:","Pathak:","Miglani:","Saini:","Mukhopaddhay:","Ananth:","Manivanan:","Jose:","Gairola:","C:")] <- ""

#whatsappDF$text <- paste(whatsappDF$(V6:V18))
#unite(whatsappDF, paste(colnames(whatsappDF)[-1], collapse=" "), colnames(whatsappDF)[-1])

#unite(whatsappDF,text,-1)
whatsappDFUnite <- unite(whatsappDF,text,-1,sep = " ", remove = TRUE)
head(whatsappDFUnite)
View(whatsappDFUnite)

colnames(whatsappDFUnite) <- c("Name","text")
whatsappTidy <- whatsappDFUnite %>% unnest_tokens(word,text) %>% group_by(Name) %>% anti_join(stop_words) %>% summarise(sum = n)%>% ungroup()

whatsappTidy %>% count(word)
