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
    summarise(Income = sum(PRICE)) %>%
    spread(Category, Income, fill=0)

category_sum = colSums(result[,-1])
highest_category_index = which(category_sum==max(category_sum))
print(paste0("Income最高的商品:",colnames(result[,-1])[highest_category_index]
))

## Day6 ###

write.table(result, file="output/category_income_by_month.csv", sep = ",", row.names=FALSE, col.names = TRUE)

category_income <- read.csv("output/category_income_by_month.csv", stringsAsFactors=FALSE)

result <- category_income %>%
    gather(Category, Income, 2:73, na.rm=FALSE) %>%
    group_by(Category) %>%
    summarise(Category_Income = sum(Income)) %>%
    arrange(desc(Category_Income))

ggplot(result, aes(x="", y=Category_Income, fill=Category)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start=0) +
    theme(text=element_text(family="黑體-繁 中黑", size=12)) 

### day7 ###

result <- orders %>%
    mutate(Month = as.Date(orders$CREATETIME, "%Y-%m-%d %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    group_by(Month) %>%
    summarise(Income = sum(PRICE)) %>%
    arrange(desc(Income))
    
result <- orders %>%
    mutate(Month = as.Date(orders$CREATETIME, "%Y-%m-%d %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    filter(Month=="2017-05"| Month=="2017-08"|Month=="2017-11",
           PAYMENTTYPE=="信用卡") %>%
    separate(NAME, c("Category", "Brand"), sep="\\(") %>%
    group_by(Category) %>%
    summarise(Category_Income = sum(PRICE)) %>%
    arrange(desc(Category_Income))
    
### day8 ###

result <- orders %>%
    mutate(Month = as.Date(orders$CREATETIME, "%Y-%m-%d %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    separate(NAME, c("Category", "Brand"), sep="\\(") %>%
    filter(Month=="2017-05", Category=="生活家電", 450<PRICE) %>%
    merge(user, by.x="BUYERID", by.y="ID") %>%
    select(ID, PRICE, PAYMENTTYPE, ACCOUNT, MOBILE)
