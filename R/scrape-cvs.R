#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Dollar General website
rD$navigate("https://www.cvs.com/store-locator/landing")

#scrape by zipcode
scrape_cvs_by_zip = function(zipcode){
  rD$navigate("https://www.cvs.com/store-locator/landing")
  Sys.sleep(2)
  
  enter_text("#search", c(paste0(zipcode, ", IL"), key = "enter"))
  Sys.sleep(2)
  #click(".suggestions > ul:nth-child(1) > li:nth-child(1) > a:nth-child(1)")
  click("#srchstorebtn")
  Sys.sleep(10)
  
  stores = rD$findElements(using = "css", ".searchResult")
  
  cvs = sapply(1:length(stores), function(i){
    store = stores[[i]]
    text = store$getElementText()[[1]]
    split = strsplit(text, "\n")[[1]]
    
    Closed = "STORE CLOSED" %in% split
    PharmacyClosed = "PHARMACY CLOSED" %in% split
    
    split = setdiff(split, c("Nearest Open Store","myCVS®Store"))
    split = split[!grepl("STORE|PHARMACY", split)]
    
    Name = split[6]
    Phone = split[5]
    Address = paste0(split[3], ", ", split[4])
    
    out = c("Name" = Name, "Address" = Address, "Phone" = Phone,
            "Closed" = Closed, "PharmacyClosed" = PharmacyClosed)
  }) %>%
    t() %>%
    as.tibble()
  
  return(cvs)
  
}


cvss = lapply(cook_zipcodes_sample[-2], scrape_cvs_by_zip) %>% #60804 giving error on 6/8- run on cook_zipcodes_sample[-2] if error
  bind_rows() %>%
  unique() %>%
  rowwise() %>%
  mutate(Name = paste("CVS", Name))

write_csv(cvss, paste0("data/cvs/", Sys.Date(), "-cvs.csv"))

stop_server()
