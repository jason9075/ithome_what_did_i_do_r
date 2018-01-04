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
### Day 17 ###

set.seed(20180103)
kmeans_3 = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 3)
set.seed(20180103)
kmeans_7 = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 7)
set.seed(20180103)
kmeans_10 = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 10)
set.seed(20180103)
kmeans_20 = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 20)

result <- address_LatLng_data %>%
    ungroup() %>%
    mutate(category3 = kmeans_3$cluster,
           category7 = kmeans_7$cluster,
           category10 = kmeans_10$cluster,
           category20 = kmeans_20$cluster)

ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=result,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category3)))
ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=result,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category7)))
ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=result,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category10)))
ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=result,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category20)))

### Day 18 ###

rad = function(x) {
    return (x * pi / 180)
}

getDistance = function(p1, p2) { #計算兩點經緯度距離 
    R = 6378137; # 地球平均的半徑
    dLat = rad(p2[1] - p1[1])
    dLong = rad(p2[2] - p1[2])
    a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rad(p1[1])) * cos(rad(p2[1])) *
        sin(dLong / 2) * sin(dLong / 2);
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    d = R * c
    return (d) # 回傳公尺
}

isCenterDistanceOverThreshold <- function(center, df, threshold){ # threshold 單位是公尺
    for (i in 1:nrow(df)) {
        if(threshold < getDistance(center, c(df$Lat[i], df$Lng[i]))){
            return(TRUE)
        }
    }
    return(FALSE)
}

unclassifiedAddress <- address_LatLng_data %>% ungroup()
classifiedAddresses <- address_LatLng_data[0,]

SEED <- 20180103
iterDistance <- c(300, 400, 500, 600, 700, 800, 1000)
category = 1 #分類編號

for(iter in 1:length(iterDistance)){
    n = nrow(unclassifiedAddress) #未分類資料筆數
    
    if(n <= 5){
        print("地址過少 無法分類")
        break
    }
    
    centersCount = as.integer(1 + 0.23*n) #預計產生的中心數
    set.seed(SEED)
    kmeans = kmeans(x = unclassifiedAddress[, c('Lat','Lng')], centers = centersCount)
    y_kmeans = kmeans$cluster
    y_centers = kmeans$centers
    for(i in 1:centersCount){
        subAddress <- unclassifiedAddress %>%
            filter(y_kmeans==i)
        
        if(!isCenterDistanceOverThreshold(y_centers[i,], subAddress, iterDistance[iter])){
            
            subAddress$category <- category
            category <- category + 1
            
            classifiedAddresses <- rbind(classifiedAddresses, subAddress)
            next
        }
    }
    unclassifiedAddress <- unclassifiedAddress %>% 
        filter(!(V1 %in% classifiedAddresses$V1))
    # ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    #     geom_point(data=addresses, aes(x=Lng, y=Lat, colour=factor(y_kmeans)))
    print(paste0("iter-", iter," complete! remain:", nrow(unclassifiedAddress), " addresses"))
}

### Day 19 ###

  # 一次K-means
kmeans = kmeans(x = address_LatLng_data[, c('Lat','Lng')], centers = 24)
y_kmeans = kmeans$cluster

single_kmeans <- address_LatLng_data %>%
    ungroup() %>%
    mutate(category = y_kmeans)

ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=single_kmeans,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category)))

  # 多次K-means 
ggmap(get_googlemap(center=c(121.52311,25.04126), zoom=12, maptype='satellite'), extent='device') +
    geom_point(data=classifiedAddresses,
               size=1.8,
               aes(x=Lng, y=Lat, colour=factor(category)))
