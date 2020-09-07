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
#startserver and navigate to savealot store locator website
source("R/general.R")
stop_server()
start_server()
rD$navigate("https://savealot.com/grocery-stores/locationfinder/")

#scrape by zipcode

scrape_savealot_by_zip= function(zipcode){
  
  enter_text("#inputaddress", zipcode)}
  
 store_info= get_text_class(".sb-location") 



#Clean data so only relevant info and columns remain
store_info1= store_info %>%
strsplit("\\\n") %>%
do.call("rbind", .) %>%
  as_tibble() %>%
set_colnames(c("Miles", "StoreName", "Address1", "Address2", "Hours", "Phone", "b", "c", "v")) %>%
  mutate(Address = paste(Address1, Address2),
         Store_Name = gsub("Chicago", "Chicago SaveaLot", StoreName)
  ) %>%
  select(Store_Name, Address, Phone)
#remove out of state
savealot <- store_info1[-c(9, 10, 13, 14, 15, 16, 17, 18, 19, 20), ]
#save completed table
write_csv(savealot, paste0("data/savealot/", Sys.Date(), "-savealot.csv"), na = "")

stop_server()  

