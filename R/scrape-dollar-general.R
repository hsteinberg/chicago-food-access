#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Dollar General website
rD$navigate("https://hosted.where2getit.com/dollargeneral/index.html")
Sys.sleep(2)

#Get data by zip code search
get_dollar_gen_by_zip = function(zipcode){
  
  #enter zipcode
  click("#address")
  enter_text("#address", c(zipcode, key = "enter"))
  
  #sleep to wait for load
  Sys.sleep(2)
  
  #get text for all stores
  stores = rD$findElement(using = "css", "#poiblock")$getElementText()[[1]]
  stores = gsub("^.*STORES NEAR YOU\n", "", stores)
  stores = strsplit(stores,"\n\\d\\.\\d\\d miles")[[1]]
  
  #get info for each store
  df = sapply(1:length(stores), function(i){
    x = stores[i]
    split = strsplit(x, "\n")[[1]]
    
    Name = str_extract(x, "Dollar General # \\d+")
    Address = paste0(split[4], ", ", split[5])
    Phone = str_extract(x, "\\(\\d{3}\\) \\d{3}-\\d{4}")
    Closed = grepl("Temporarily Closed", x)
    out = c("Name" = Name, "Address" = Address, "Phone" = Phone, "Closed"=Closed)
    return(out)
  }) %>%
    t() %>%
    as_tibble()
  
  return(df)
  
}

dollar_gens = lapply(cook_zipcodes_sample, get_dollar_gen_by_zip) %>%
  bind_rows() %>%
  unique()

write_csv(dollar_gens, paste0("data/dollar-general/", Sys.Date(), "-dollar-general.csv"))

stop_server()
