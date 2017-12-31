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


