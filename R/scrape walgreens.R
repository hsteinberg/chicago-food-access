library(tidyverse)
library(magrittr)
library(devtools)
library(RSelenium)

#source functions to make rselenium easier
source_url("https://github.com/hsteinberg/ccdph-functions/blob/master/general-use-rselenium-functions.R?raw=TRUE")

#start firefox session
start_server()

#navigate to locator site
rD$navigate("https://www.walgreens.com/storelocator/find.jsp?tab=store+locator&requestType=locator")

#find the 99 closest walgreens to given zipcode
get_walgreens_by_zip = function(zip){
  #put in zipcode
  click("#updateLocation")
  enter_text("#detailsPageTextFieldMob", c(zip, key = "enter"))
  click("#closesearchoverlay")
  
  #click load more 9 times
  for(i in 1:9){
    ifVisiblethenClick("#loadMoreBtn")
  }
  
  #get stores
  stores = rD$findElements(using = "css", ".card")
  
  #get store info
  walgreens = lapply(1:length(stores), function(i){
    element = stores[[i]]
    address = element$findChildElement(using = "css", ".address-row")$getElementText()
    phone = element$findChildElement(using = "css", ".phone")$getElementText()
    alert = try(element$findChildElement(using = "css", ".alert")$getElementText(), silent = T)
    out = c("address" = address,"phone" = phone, "alert" = alert)
    
    return(out)
  }) %>%
    bind_rows()
  
  walgreens_clean = walgreens %>%
    mutate(alert = gsub("Error .*$","", alert),
           closed = grepl("closed", alert),
           pharmacyOnly = grepl("Pharmacy only", alert),
           address = gsub("\\.", "", address),
           address = gsub("\\d{1,2} mi", "", address)
    ) 
  
  return(walgreens_clean)
}

#extract data for different areas of the Chicago
north = get_walgreens_by_zip("60625")
west = get_walgreens_by_zip("60804")
south = get_walgreens_by_zip("60620")

#Combine and deduplicate
walgreens = bind_rows(north, west, south) %>%
  unique()

#save csv
write_csv(walgreens, paste0("data/", Sys.Date(), "-walgreens.csv"))

#end server session
stop_server()
