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

### Day 13 ###

fruit_price_data <- list.files(path="downloaded/", pattern="*.csv", full.names=TRUE) %>% 
    map_df(~read_csv(.))
result <- fruit_price_data %>%
    filter_at(1, any_vars(is.na(.))) %>%
    select_at(-1) %>%
    group_by(作物代號, 作物名稱) %>%
    summarise(上價平均=mean(上價, na.rm = TRUE) ,
                  中價平均=mean(中價, na.rm = TRUE) ,
                  下價平均=mean(下價, na.rm = TRUE) ,
                  總交易量=sum(交易量, na.rm = TRUE)) %>%
    filter(200 < 上價平均) %>%
    arrange(desc(總交易量))


