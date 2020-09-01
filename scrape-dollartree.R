#necessary packages
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

rD$navigate("https://hosted.where2getit.com/dollartree/change-store.test.html?callerURL=www.dollartree.com&loggedin=false")

#search by zip

scrape_DT_by_zip= function(zipcode){
  
  enter_text("main-input-cont",zipcode)
  click("#searchbutton")}

#get all of store info at once
storeinfo = get_text_class("poi_address") 
#clean store info and select relevant info
DT= storeinfo %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as_tibble()%>%
  set_colnames(c("StoreName1", "StoreName2","Store_Number","Address1", "Address2","Phone", "Hours"))%>%
  mutate(Address = paste(Address1, Address2),
         StoreName= paste(StoreName1,StoreName2)
  ) %>%
  select(StoreName,Store_Number, Address, Hours, Phone)

#save data table as csv file
write_csv(DT, paste0("data/dollartree/", Sys.Date(), "-dollartree.csv"), na = "")

stop_server() 





