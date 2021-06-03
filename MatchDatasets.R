# this separates the names according a delimiter, posts them into two new columns
separated_df <- separate(member, col = thomas_name, into = c("Last Name", "First Name"), convert = TRUE)

FullmTurk <- read.csv("~/Desktop/annotation_results.csv")

combinedForDoc2 <- speech %>% inner_join(df, by = c("speech" = "Input.doc2"))
