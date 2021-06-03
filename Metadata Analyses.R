library(tidyverse)
library(dplyr)

member %>%
  group_by(freshman) %>%
  summarize(count = n())

member %>%
  group_by(female) %>%
  summarize(count = n())

member %>%
  group_by(dem) %>%
  summarize(count = n())

speech_ns %>%
  group_by(freshman) %>%
  summarize(count = n())

speech_ns %>%
  group_by(female) %>%
  summarize(count = n())

speech_ns %>%
  group_by(dem) %>%
  summarize(count = n())
