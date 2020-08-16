#source general code
source("R/general.R")

#start firefox session
start_server()


#scrape individual store
scrape_jewel_store = function(n, zip){
  print(n)
  
  rD$navigate(paste0("https://local.jewelosco.com/search.html?q=",zip,"&storetype=5655&l=en"))
  Sys.sleep(4)
  links = rD$findElements(using = "css", ".Teaser-titleLink")
  Sys.sleep(4)
  links[[n]]$clickElement()
  Sys.sleep(4)
  
  Name = get_text(".ContentBanner-h1") %>%
    gsub("\n", " ", .)
    
  Address = get_text_class("c-AddressRow")[1:2] %>%
    paste(collapse = ", ")
  
  Phone = get_text(".Phone-link")
  Phone2 = get_text("#phone-main")
  
  Phone = ifelse(Phone == "", Phone2, Phone)
  
  out = c("Name" = Name, "Address" = Address, "Phone" = Phone)
  
  #rD$goBack()
  
  return(out)
}

#scrape by zip
scrape_jewel_zip = function(zip){
  print(zip)
  #go to web page
  start_server()
  
  rD$navigate(paste0("https://local.jewelosco.com/search.html?q=",zip,"&storetype=5655&l=en"))
  
  links = rD$findElements(using = "css", ".Teaser-titleLink")
  numLinks = length(links)
  
  stores = sapply(1:numLinks, scrape_jewel_store, zip = zip)%>%
    t() %>%
    as.data.frame()

  
  stop_server()
  
  return(stores) 
  
}


#jewels = lapply(cook_zipcodes_sample, scrape_jewel_zip) #keeps stalling out, do one by one


temp1 = scrape_jewel_zip("60625")
temp2 = scrape_jewel_zip("60804")
temp3 = scrape_jewel_zip("60620")
temp4 = scrape_jewel_zip("60601")
temp5 = scrape_jewel_zip("60026")
temp6 = scrape_jewel_zip("60004")
temp7 = scrape_jewel_zip("60546")
temp8 = scrape_jewel_zip("60426")
temp9 = scrape_jewel_zip("60465")
temp10 = scrape_jewel_zip("60173")
temp11 = scrape_jewel_zip("60656")
temp12 = scrape_jewel_zip("60120")
temp13 = scrape_jewel_zip("60467")

jewels = bind_rows(temp1, temp2, temp3, temp4, temp5,
                   temp6, temp7, temp8, temp9, temp10,
                   temp11, temp12, temp13) %>%
  unique()

#write to file
write_csv(jewels, paste0("data/jewel-osco/", Sys.Date(), "-jewel-osco.csv"), na = "")
