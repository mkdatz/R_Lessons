# Factors allow us to categorize data into easy-to-understand categories.
# You can use factors as a way to describe levels in your dataset.

# Create a factor
music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"))

# Print the factor
music_genre 

levels(music_genre) 

length(music_genre) 

# You can also change the value of items in the factor.

music_genre[3] <- "Pop"

music_genre[3]