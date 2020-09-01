#packages needed
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
#navigate to Whole Foods Website
start_server()

rD$navigate("https://www.wholefoodsmarket.com/stores")

#search by zip

scrape_WF_by_zip= function(zipcode){
  
  enter_text("#store-finder-search-bar",zipcode)
  click("#sf-search-icon")}
  #get all of store info at once
  storeinfo = get_text_class("w-store-finder-core-info") 
 
#Clean up store info by separating into columns, naming columns, and selecting relevant info
WF= storeinfo %>%
  gsub("Closed", "Closed\\\nNA", .) %>% #adding in a line that says NA where hours would be if open
    strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble() %>%
set_colnames(c("StoreName", "Miles", "Extra", "Status", "Hours", "Address1", "Address2", "Location2"))%>%
     mutate(Address3 = paste(Address1, Address2),
          Address = gsub("Opens 8:00 am tomorrow 832 W 63rd St", "832 W 63rd St Chicago, IL 60621", Address3),
          Store_Name= paste0("Whole Foods ",StoreName)  
  ) %>%
    select(Store_Name, Address, Status)

#save completed table
write_csv(WF, paste0("data/whole-foods/", Sys.Date(), "-wholefoods.csv"), na = "")

stop_server() 


