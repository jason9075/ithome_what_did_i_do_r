### Day 2 ###
user = read.csv("input/user.csv", stringsAsFactors=FALSE)

#install.packages("dplyr")
library(dplyr)

result <- user %>%
    mutate(Month = as.Date(user$CREATETIME, "%m/%d/%Y %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    group_by(Month) %>%
    summarise(MembersCount = n())

library(ggplot2)

ggplot(result, aes(x=Month, y=MembersCount)) +
    geom_bar(stat="identity", fill="skyblue")

### Day 3 ###

orders = read.csv("input/orders.csv", stringsAsFactors=FALSE, fileEncoding="big5")

buyer_list <- orders %>%
    distinct(BUYERID)
buyer_list <- buyer_list$BUYERID

result <- user %>%
    mutate(Month = as.Date(user$CREATETIME, "%m/%d/%Y %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    mutate(HasBought = ID %in% buyer_list) %>%
    group_by(Month, HasBought) %>%
    summarise(MembersCount = n())

ggplot(result, aes(x=Month, y=MembersCount, fill=HasBought)) +
    geom_bar(stat="identity")

### Day 4 ###

result <- orders %>%
    mutate(Month = as.Date(orders$CREATETIME, "%Y-%m-%d %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    group_by(Month) %>%
    summarise(Income = sum(PRICE))

ggplot(result, aes(x=Month, y=Income)) +
    geom_bar(stat="identity", fill="gold1")

### Day 5 ###

#install.packages("tidyr")
library(tidyr)

result <- orders %>%
    mutate(Month = as.Date(orders$CREATETIME, "%Y-%m-%d %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    separate(NAME, c("Category", "Brand"), sep="\\(") %>%
    group_by(Month, Category) %>%
    summarise(Income = sum(PRICE))
    
    

