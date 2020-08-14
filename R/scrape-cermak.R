#source general code
source("R/general.R")

#start firefox session
start_server()

#go to website
rD$navigate("https://www.cermakfreshmarket.com/our-stores")

cermaks = get_text_class(".col-md-3") %>%
  gsub("Cermak BT Wearhouse", "Cermak\nBT Wearhouse", .) %>%
  strsplit("\\\n") %>%
  do.call("rbind", .) %>%
  as.tibble() %>%
  set_colnames(c("Name1", "Name2", "Address1", "Address2", "Phone", "Hours")) %>%
  mutate(Name = paste(Name1, Name2),
         Address = paste0(Address1, ", ", Address2),
         Phone = gsub("Phone: ", "", Phone)
         ) %>%
  select(Name, Address, Phone, Hours)


write_csv(cermaks, paste0("data/cermak/", Sys.Date(), "-cermak.csv"))

stop_server()  
