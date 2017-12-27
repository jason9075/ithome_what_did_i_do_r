### Day 11 ###

url <- "http://data.coa.gov.tw/Service/OpenData/FromM/FarmTransData.aspx?FOTT=CSV"
download.file(url, destfile = "downloaded/result.csv" , method = "curl")
                     


