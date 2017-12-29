### Day 11 ###

url <- "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx?FOTT=CSV"
download.file(url, destfile = "downloaded/result.csv" , method = "curl")
                     
### Day 12 ###

start <- as.Date("2017-01-01")
end   <- as.Date("2017-01-31")

theDate <- start
while (theDate <= end){
    year <- as.integer(format(theDate,"%Y")) - 1911
    month_date <- format(theDate,".%m.%d") 
    chineseDate <- paste0(year, month_date)
    download.file(paste0(url, "&StartDate=", chineseDate, "&EndDate=", chineseDate), 
                  destfile = paste0("downloaded/file", chineseDate, ".csv"), method = "curl")
    theDate <- theDate + 1                    
}

