#source general code
source("R/general.R")

#start firefox session
start_server()

#scrape by zip
scrape_marianos = function(){
  Name = get_text_class(".VanityNameLinkContainer")
  Address = get_text_class(".StoreAddress-storeAddressGuts") %>% 
    setdiff("") %>%
    gsub("Get Directions", "", .)
  Phone = get_text_class(".PhoneNumber-phone")
  
  stores = tibble(Name, Address, Phone) 
  return(stores)
  
}

add_marianos = function(table){
  stores = scrape_marianos()
  
  rbind(table, stores)
  
}


# scrape_marianos_zip = function(zip, page){
#   rD$navigate("https://www.marianos.com/stores/search?searchText=60601&selectedPage=1")
#   
#   enter_text(".kds-SolitarySearch-input", zip)
#   click(".kds-SolitarySearch-button")
#   
#   all = lapply(1:13, function(x){
#     stores = scrape_marianos()
#     click(".kds-Pagination-next")
#     return(stores)
#   })
# 
# }

#have to click through manually or get kicked off site for scraping

marianos = scrape_marianos() #first page

#click through all and add to table
marianos = add_marianos(marianos) #other 12 pages (click this after clicking next)

write_csv(marianos, paste0("data/marianos/", Sys.Date(), "-marianos.csv"), na = "")


stop_server()
