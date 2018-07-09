#Housekeeping ####
rm(list=ls())
require(dplyr)
require(ggplot2)
require(tidyr)
library(wordcloud)
library(tm)
library(SnowballC)
require(lubridate)
theme_set(theme_bw())


entries <- read.csv("./freshwater_telegraph.csv", as.is=T)

entries$date <- dmy(entries$date)

entries <- entries[!grepl("travel|best|hotel|review",entries$title, ignore.case=T),]

title_corpus <- Corpus(VectorSource(entries$title))

# title_corpus <- tm_map(title_corpus, PlainTextDocument)
title_corpus <- tm_map(title_corpus, removePunctuation)
title_corpus <- tm_map(title_corpus, stripWhitespace)
title_corpus <- tm_map(title_corpus, content_transformer(tolower))
title_corpus <- tm_map(title_corpus, removeWords, stopwords('english'))
title_corpus <- tm_map(title_corpus, removeWords, c("telegraph"))
title_corpus <- tm_map(title_corpus, stemDocument)
wordcloud(title_corpus, max.words = 100, random.order = FALSE)

p <- qplot(data=entries,
           x=date)


p
