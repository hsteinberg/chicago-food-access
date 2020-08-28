library(tidyverse)
library(magrittr)
library(devtools)
library(RSelenium)

#source functions to make rselenium easier
source_url("https://github.com/hsteinberg/ccdph-functions/blob/master/general-use-rselenium-functions.R?raw=TRUE")

#zip codes spread out through the county since most store locator websites only show a certain number of stores,
#have to search by many zip codes
cook_zipcodes_sample = c(north="60625", west="60804",south="60620",
                         central="60601",northsub="60026",northwestsub="60004",
                         westsub="60546",southsub="60426",southwestsub="60465")
source("R/general.R")
stop_server()
start_server()

rD$navigate("https://www.wholefoodsmarket.com/stores")

#search by zip

scrape_WF_by_zip= function(zipcode){
  
  enter_text("#store-finder-search-bar",zipcode)
  click("#sf-search-icon")
  
  storeinfo= get_text_class("wfm-store-details")
}

WFinfo= storeinfo
WF= WFinfo %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()  


#ignore everything below this line; was stuff I was trying out 



storeinfo = rD$findElements(using = "css", "wfm-store-details")
store_text = sapply(names, function(x){
  return(x$getElementText())
  
})

WF= strsplit(storeinfo, "\n")
WF= storeinfo %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()  

store_info1= store_info %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble() 

data = rD$findElement(using = "css", "wfm-store-details")$getElementText()[[1]] 
WF= str_split(store_text, "\n")


wfm-store-list.hydrated > ul:nth-child(1) > li:nth-child(1) > wfm-store-details:nth-child(1) > div:nth-child(1) > div:nth-child(1) > a:nth-child(1)
data = rD$findElement(using = "css", "wfm-store-list.hydrated")$getElementText()[[1]] 
stores = strsplit(data, "\n")[[1]]

  
 
  store_info= stores %>%
    strsplit("\\\n") %>%
    do.call("rbind", .) %>%
    as_tibble()


  


  
 
  
  #scrape store names
  names = rD$findElements(using = "css", ".store-name")
  names_text = sapply(names, function(x){
    return(x$getElementText())
    
  })
store_info1= store_info %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble() %>%
  set_colnames(c("Miles", "StoreName", "Address1", "Address2", "Hours", "Phone", "b", "c", "v")) %>%
  