#source general code
source("R/general.R")

#start firefox session
start_server()

#go to Dollar General website
rD$navigate("https://www.costco.com/warehouse-locations")

#get data
#put in zipcode
enter_text("#search-warehouse", "60601")
click("#warehouse-locator-search-form > div:nth-child(1) > span:nth-child(2) > button:nth-child(1)") #find
click(".tertiary") #load more
click(".tertiary") #load more
  

text = get_text("#warehouse-list")
stores = strsplit(text, "\\\n\\d{1,2}\\\n")[[1]] %>%
  gsub("1\\\n", "", .) %>%
  gsub("Get Directions Store Details", "", .) %>%
  strsplit("\\\n|\\(") 

costcos = lapply(stores, function(x){setdiff(x, "")}) %>%
  do.call("rbind", .) %>%
  as.tibble() %>%
  set_colnames(c("Name", "Miles", "Address1", "Address2", "Phone")) %>%
  mutate(Address = paste0(Address1, ", ", Address2),
         Phone = paste0("(", Phone),
         Name = paste("Costco", Name)
         ) %>%
  select(Name, Address, Phone) %>%
  filter(grepl(" IL ", Address))

write_csv(costcos, paste0("data/costco/", Sys.Date(), "-costco.csv"))

stop_server()

  