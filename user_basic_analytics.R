
user = read.csv("input/user.csv", stringsAsFactors=FALSE)

#install.packages("stringr")
library(dplyr)

result <- user %>%
    mutate(Month = as.Date(user$CREATETIME, "%m/%d/%Y %H:%M:%S")) %>%
    mutate(Month = substring(Month,1,7)) %>%
    group_by(Month) %>%
    summarise(MembersCount = n())

library(ggplot2)

ggplot(result, aes(x=Month, y=MembersCount)) +
    geom_bar(stat="identity", fill="skyblue")
