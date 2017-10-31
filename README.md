# Generating a wordcloud based on the data generated from your Whatsapp chats.

### Prerequisites:
- R (preferably version 3.2.3 or higher)
- A WhatsApp chat in plain text format

### Here's how to get the text data:

- Export your Whatsapp chat history: http://www.whatsapp.com/faq/general/23753886
- Download the attachment. 
- Replace the path given here with your desired path.

``` R
whatsappRaw <- read.table("WhatsApp Chat with CSE Junior Year.txt", header=FALSE,fill = TRUE)
```


``` R
library(dplyr)
whatsappDF <- tbl_df(whatsappRaw)
head(whatsappDF) 
```

Selecting only the names of the recipients (the data frame is loaded in the form of columns from V1:V20):
``` R
select(whatsappDF,V5)
```

The cloud was generated in the following way:
``` R
library(wordcloud)
wordcloud(whatsappDF$V5, random.order = FALSE, max.words = 100, col = brewer.pal(7,"Accent"))
```
![Wordcloud](https://github.com/starship9/whatsappR/blob/master/whatsappR/senderCloud.png)
![Sentiment Cloud](https://github.com/starship9/whatsappR/blob/master/whatsappR/comparisonCloud.PNG)

### TODO:

- Create a shiny web app
