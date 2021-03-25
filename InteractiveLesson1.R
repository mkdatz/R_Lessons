library(tidyverse)

setwd("~/Desktop/R Lessons/")

df_1 <- read.csv("~/Desktop/R Lessons/DummyData.csv")


df_1 %>%
  group_by(Condition1, Condition2) %>%
  summarise(MeanDV1 = mean(DV1), 
            MeanDV2 = mean(DV2), 
            SdDV1 = sd(DV1), 
            SdDV2 = sd(DV2))

df_1 %>%
  group_by(Condition1, Condition2) %>%
  summarise(MeanDV = mean(DV1  +DV2),
            SdDV = sd(DV1 + DV2))

df_1 %>%
  group_by(Participant) %>%
  summarise(MeanDV = mean(DV1  +DV2),
            SdDV = sd(DV1 + DV2))

df_1 %>%
  group_by(Participant) %>%
  summarise(MeanDV1 = mean(DV1), 
            MeanDV2 = mean(DV2), 
            SdDV1 = sd(DV1), 
            SdDV2 = sd(DV2))

df_1$Participant <- as.factor(df_1$Participant)
ggplot(data = df_1, aes(x = Participant, y = DV1, group = Participant, color = Participant)) + geom_boxplot()
