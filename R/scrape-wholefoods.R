
source("R/general.R")
stop_server()
start_server()
rD$navigate("https://www.wholefoodsmarket.com/stores")


scrape_WF_by_zip= function(zipcode){
  
  enter_text("#store-finder-search-bar",zipcode)
  click("#sf-search-icon")}
 
  
  store_info= get_text_class(".sb-location") 
  
}

  
 
  
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
  