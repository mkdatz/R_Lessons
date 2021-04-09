library(dplyr)

#Example adapted from https://www.guru99.com/r-dplyr-tutorial.html
df_primary <- tribble(
  ~ID, ~y,
  "A", 1,
  "B", 3,
  "C", 8,
  "D", 0,
  "F", 7)

df_secondary <- tribble(
  ~ID, ~y,
  "A", 22,
  "B", 21,
  "C", 28,
  "D", 25,
  "E", 23)

# Examine the output of these statements. How do they differ?

left_join(df_primary, df_secondary, by ='ID')

right_join(df_primary, df_secondary, by = 'ID')

inner_join(df_primary, df_secondary, by ='ID')

full_join(df_primary, df_secondary, by = 'ID')