
#source general code
source("R/general.R")

#start firefox session
start_server()

get_target_by_zipcode = function(zipcode){
  #navigate to locator site
  rD$navigate(paste0("https://www.target.com/store-locator/find-stores/",zipcode))
  Sys.sleep(2)
  
  #Get table data
  data = rD$findElement(using = "css", "div.Row-uds8za-0:nth-child(2)")$getElementText()[[1]] %>%
    gsub("\nthird party advertisement|\nsponsored", "", .)
  
  stores = strsplit(data, "\n")[[1]]
  target = as.data.frame(matrix(stores, ncol = 5,  byrow = TRUE), stringsAsFactors = FALSE)[,1:4] %>%
    set_colnames(c("Name", "Address", "Hours", "Phone")) %>%
    mutate(Closed = grepl("closed today", Hours),
           Name = paste("Target", Name)
    )
  
  return(target)
}

targets = lapply(cook_zipcodes_sample, get_target_by_zipcode) %>%
  bind_rows() %>%
  unique()

write_csv(targets, paste0("data/", Sys.Date(), "-target.csv"))

stop_server()

