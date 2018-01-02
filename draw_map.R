### Day 14 ###

#install.packages("ggmap")
library(ggplot2)
library(ggmap)

LatLngData <- data.frame(
    Lat = runif(20, 24.96, 25.11),
    Lng = runif(20, 121.44, 121.60))

google_map <- get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite')
ggmap(google_map) +
    geom_point(data=LatLngData, aes(x=Lng, y=Lat), colour='red')

### Day 15 ###

#install.packages("httr")
#install.packages("rjson")
library(httr)
library(rjson)

getLatLng <- function(address){
 
    urlData <- GET(paste0("https://maps.googleapis.com/maps/api/geocode/json?language=zh-TW&address=", URLencode(address)))
    jsonResult <- rjson::fromJSON(rawToChar(urlData$content))
    Sys.sleep(1)
    if(jsonResult$status != "OK"){
        print(paste0("Google geocode API Error, Reason:", jsonResult$error_message))
        return("error")
    }
    print("LatLng Got")
    lat <<- jsonResult$results[[1]]$geometry$location$lat
    lng <<- jsonResult$results[[1]]$geometry$location$lng
    
    return(paste(lat, lng, sep=","))
}

address_data = read.csv("input/address.csv", stringsAsFactors=FALSE, header=FALSE)

result <- address_data %>%
    rowwise() %>%
    mutate(LatLng = getLatLng(V1)) %>%
    filter(LatLng!="error") %>%
    separate(LatLng, c("Lat", "Lng"), sep=",") %>%
    mutate(Lat=as.numeric(Lat), Lng=as.numeric(Lng))

ggmap(google_map) +
    geom_point(data=result, aes(x=Lng, y=Lat), colour='red')

### Day 16 ###

address_LatLng_data <- result #將前一天的資料存到address_LatLng_data

set.seed(20180102)
kmeans = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 10)
y_kmeans = kmeans$cluster

result <- address_LatLng_data %>%
    ungroup() %>%
    mutate(category = y_kmeans)

ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=result,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category)))
