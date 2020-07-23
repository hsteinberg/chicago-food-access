#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Dollar General website
rD$navigate("https://storelocations.familydollar.com/index.test.html?callerURL=www.familydollar.com&loggedin=false")


scrape_family_dollar_by_zip = function(zipcode){
  
  #Enter zipcode and search
  enter_text("#inputaddress", zipcode)
  click("#search_button")
  
  #scrape store names
  names = rD$findElements(using = "css", ".store-name")
  names_text = sapply(names, function(x){
    return(x$getElementText())
    
  }) %>% unlist() %>%
    setdiff("")
  
  #scrape addresses
  addresses = rD$findElements(using = "css", ".address-wrapper")
  address_text = sapply(addresses, function(x){
    return(x$getElementText())
  }) %>%
    unlist() %>%
    gsub("\n", " ", .)
  
  #scrape phone numbers
  phones = rD$findElements(using = "css", ".phone")
  phone_text = sapply(phones, function(x){
    x$getElementText()
    
  }) %>%
    unlist()
  
  #make into dataframe
  df = cbind("Name" = names_text, "Address" = address_text, "Phone" = phone_text) %>%
    as_tibble() 
  
  return(df)
  
}

#extract data for different areas of the Chicago
#Combine and deduplicate
family_dollars = lapply(cook_zipcodes_sample, scrape_family_dollar_by_zip) %>%
  bind_rows() %>%
  unique() 


#save csv
write_csv(family_dollars, paste0("data/family-dollar/", Sys.Date(), "-family-dollar.csv"))

#end server session
stop_server()
