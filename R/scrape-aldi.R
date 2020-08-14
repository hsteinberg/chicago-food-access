#source general code
source("R/general.R")

#start firefox session
start_server()

#scrape by zip function
scrape_aldi_zip = function(zip){
  rD$navigate(paste0("https://www.aldi.us/stores/en-us/Search?SingleSlotGeo=",zip,"&Mode=None"))
  
  address1 = get_text_class(".resultItem-Street")
  address2 = get_text_class(".resultItem-City")
  addresses = paste0(address1, ", ", address2)
  
  phones = get_text_class(".resultItem") %>%
    str_extract("\\d{3}\\-\\d{3}\\-\\d{4}")
  
  names = rep("ALDI", length(addresses))
  
  stores = bind_cols(names, addresses, phones) %>%
    set_colnames(c("Name", "Address", "Phone"))
  
  return(stores)
}


aldis = lapply(cook_zipcodes_sample, scrape_aldi_zip) %>%
  bind_rows() %>%
  unique()

write_csv(aldis, paste0("data/aldi/", Sys.Date(), "-aldi.csv"), na = "")

stop_server()
