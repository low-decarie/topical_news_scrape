library(XML)
library(RCurl)
#https://stackoverflow.com/questions/32889136/how-to-get-google-search-results


getGoogleURL <- function(search.term, domain = '.co.uk', quotes=TRUE) 
{
  search.term <- gsub(' ', '%20', search.term)
  if(quotes) search.term <- paste('%22', search.term, '%22', sep='') 
  getGoogleURL <- paste('http://www.google', domain, '/search?q=',
                        search.term, sep='')
}

getGoogleLinks <- function(google.url) {
  doc <- getURL(google.url, httpheader = c("User-Agent" = "R
                                           (2.10.0)"))
  html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function
                        (...){})
  nodes <- getNodeSet(html, "//h3[@class='r']//a")
  return(sapply(nodes, function(x) x <- xmlAttrs(x)[["href"]]))
}

getGoogleLinks <- function(google.url) {
  doc <- getURL(google.url, httpheader = c("User-Agent" = "R
                                           (2.10.0)"))
  html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function
                        (...){})
  nodes <- getNodeSet(html, "//h3[@class='r']//a")
  
  url <- sapply(nodes, function(x) x <- xmlAttrs(x)[["href"]])
  
  title <- 
  
  return()
}

search.term <- "site:www.telegraph.co.uk freshwater"
quotes <- "FALSE"
search.url <- getGoogleURL(search.term=search.term, quotes=quotes)

links <- getGoogleLinks(search.url)
