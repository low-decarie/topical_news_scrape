library(URLencode)
library(rvest)
require(RCurl)

#options("HTTPUserAgent")

options(HTTPUserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4")

#&num=100

search_collect <- function(news_site= "www.telegraph.co.uk",
                           search_words = "freshwater",
                           period = "y"){ #y year, month month, d day
  
  
  search_words <- gsub(" ", "+", search_words)
  
google_url <- paste0("https://www.google.com/search?q=site:",
                     news_site,"+",
                     search_words,"&tbs=qdr:",
                     period, "&oe=UTF-8&num=100&pws=0")

  url = URLencode(google_url)
  
  page <- read_html(url)
  
  # page <- browseURL(url)
  
  # page <- readLines(url)
  # write_xml(page, "test.xml")
  # sink("test.txt");page;sink()
  
  titles <- page %>% 
    html_nodes("h3") %>% 
    html_text()
  
  urls <- page %>% 
    html_nodes("h3") %>% 
    html_nodes("a") %>% 
    html_attr("href")
  
  dates <- page %>%
    html_nodes("span span") %>%
    html_text()
  
  text <- page %>%
    html_nodes("span") %>%
    html_text()
  
  dates <- dates[!dates %in% c("Google", "", "Next", "   Help    Send feedback    Privacy Terms Use Google.com   ")]


  # text <- gsub(".* \\.\\.\\. ","",more_info)
  
  results <- data.frame(news_site=news_site,
                         date=dates,
                        # text=text,
                        title=titles)
  
  return(results)
}


# freshwater_telegraph <- search_collect()
# 
# write.csv(freshwater_telegraph, file="freshwater_telegraph.csv")

newspapers <- read.csv("./newspapers.csv", as.is=T)
newspapers_url <- newspapers$URL
newspapers_url <- newspapers_url[newspapers_url!=""]

keywords <- read.csv("./keywords for search.csv", as.is = T)
habitats <- keywords$habitat[keywords$habitat!=""]
organism <- keywords$region[keywords$organism!=""]

search_results <- NULL

for(newspaper in newspapers_url){
  for(habitat in habitats){
    for(organism in organism){
      temp <- search_collect(news_site= newspaper,
                             search_words = paste(habitat, organism),
                             period = "y")
      temp$organism <- organism
      temp$habitat <- habitat
      search_results <- rbind_all(search_results, temp)
      Sys.sleep(60+rnorm(n = 1, mean = 60) )
    }
  }
}
