
#source general code
source("R/general.R")

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
    out = c("Address" = address,"Phone" = phone, "Alert" = alert)
    
    return(out)
  }) %>%
    bind_rows()
  
  walgreens_clean = walgreens %>%
    mutate(Alert = gsub("Error .*$","", Alert),
           Closed = grepl("closed", Alert),
           PharmacyOnly = grepl("Pharmacy only", Alert),
           StorePhotoOnly = grepl("Store & photo only", Alert),
           Name = gsub("\\d.*$", "", Address),
           Name = ifelse(Name == "", "Walgreens", Name),
           Address = gsub("\\.", "", Address),
           Address = gsub("\\d{1,2} mi", "", Address),
           Address = gsub("\\t", "", Address),
           Address = gsub("^\\D+(\\d)", "\\1", Address),
           
           
    ) 
  
  return(walgreens_clean)
}

#extract data for different areas of the Chicago
#Combine and deduplicate
walgreens = lapply(cook_zipcodes_sample, get_walgreens_by_zip) %>%
  bind_rows() %>%
  unique() 

#save csv
write_csv(walgreens, paste0("data/", Sys.Date(), "-walgreens.csv"))

#end server session
stop_server()
