#Analysis of Adiel's Spotify "Liked Songs" Library 
library(tidyverse) 
library(broom)
liked_songs <- read_csv("Liked_Songs.csv", show_col_types = FALSE)
liked_songs <- liked_songs %>%
  mutate(
    added_date   = as.Date(str_sub(`Added At`, 1, 10)),
    release_date = suppressWarnings(as.Date(`Release Date`, format = "%Y-%m-%d")),
    release_date = if_else(
      is.na(release_date),
      as.Date(paste0(str_sub(`Release Date`, 1, 4), "-01-01")),
      release_date
    ),
    song_age_yrs = as.numeric(added_date - release_date) / 365.25,
    genre_primary = str_trim(map_chr(str_split(Genres, ","), 1)),
    genre_primary = if_else(genre_primary == "" | is.na(genre_primary), "Unlabeled", genre_primary),
    month = format(added_date, "%Y-%m")
  ) %>%
  filter(song_age_yrs >= 0, song_age_yrs < 70)

cat("Final N:", nrow(liked_songs), "\n")

# Figure 1 Liked Songs Growth per month 
monthly <- liked_songs %>% count(month)

fig1 <- ggplot(monthly, aes(x = month, y = n)) +
  geom_col(fill = "#1DB954") +
  labs(title = "Songs Liked per Month", x = NULL, y = "Songs added") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 6))

ggsave("fig1_timeline.png", fig1, width = 6.6, height = 3.6, dpi = 150)

#Figure 2 Top 10 Genres
top_genres <- liked_songs %>%
  filter(genre_primary != "Unlabeled") %>%
  count(genre_primary, sort = TRUE) %>%
  slice_head(n = 10)

fig2 <- ggplot(top_genres, aes(x = n, y = fct_reorder(genre_primary, n))) +
  geom_col(fill = "#1DB954") +
  labs(title = "Top 10 Genres (Liked Songs)", x = "Number of songs", y = NULL) +
  theme_minimal(base_size = 11)

ggsave("fig2_genres.png", fig2, width = 6.6, height = 3.6, dpi = 150)

#Diagnositc Model 

model <- lm(Popularity ~ song_age_yrs + Energy + Danceability + Valence + Acousticness, data = liked_songs)
print(summary(model))
tidy(model, conf.int = TRUE) %>% print()
glance(model) %>% print()


#Figure 3 

fig3 <- ggplot(liked_songs, aes(x = song_age_yrs, y = Popularity)) +
  geom_point(color = "#1DB954", alpha = 0.35) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Popularity vs. Song Age at Time of Liking",
       x = "Song age when liked (years)", y = "Spotify Popularity (0-100)") +
  theme_minimal(base_size = 11)

ggsave("fig3_scatter.png", fig3, width = 6.6, height = 4.3, dpi = 150)

cat("\n--- SUMMARY STATS ---\n")
cat("Median song age when liked (yrs):", round(median(liked_songs$song_age_yrs), 1), "\n")
cat("Mean popularity:", round(mean(liked_songs$Popularity), 1), "\n")
cat("Mean energy:", round(mean(liked_songs$Energy), 2),
    " Mean valence:", round(mean(liked_songs$Valence), 2),
    " Mean danceability:", round(mean(liked_songs$Danceability), 2), "\n")
cat("Top genre:", top_genres$genre_primary[1], "(", top_genres$n[1], "songs)\n")
cat("Busiest month:", monthly$month[which.max(monthly$n)], "(", max(monthly$n), "songs)\n")
