getLatLng <- function(address){
 
    urlData <- GET(paste0("https://maps.googleapis.com/maps/api/geocode/json?language=zh-TW&key=AIzaSyCwWPvfMJvZQU3HrKXIiQGPc55Xef_-nLc&address=", URLencode(address)))
    # urlData <- GET(paste0("https://maps.googleapis.com/maps/api/geocode/json?language=zh-TW&address=", URLencode(address)))
    
    jsonResult <- rjson::fromJSON(rawToChar(urlData$content))
    # Sys.sleep(1)
    if(jsonResult$status != "OK"){
        print(paste0("Google geocode API Error, Reason:", jsonResult$error_message))
        return("error")
    }
    print("LatLng Got")
    lat <<- jsonResult$results[[1]]$geometry$location$lat
    lng <<- jsonResult$results[[1]]$geometry$location$lng
    
    return(paste(lat, lng, sep=","))
}

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
