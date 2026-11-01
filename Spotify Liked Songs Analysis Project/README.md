# What My Liked Songs Say About My Music Taste

An R analysis of my full Spotify Liked Songs library (1,814 tracks): what I listen to, and whether a song's sound or age predicts how mainstream it is.

## Question
Do I gravitate toward songs because they sound like hits, or is my taste driven by something audio features can't capture?

## Data
My Spotify Liked Songs export: audio features (energy, valence, danceability, acousticness), Spotify popularity score (0–100), genre tags, release date, and the date I liked each song. Downloaded csv through spotify. The raw file is not included because it is my personal listening history.

## Methods
- Descriptive analysis of liking activity by month and top genres
- OLS regression of popularity on song age at the time I liked it and four audio features
- Excluded tracks with a negative age or an age of 70+ years at the time liked
- Robustness check re-running the model without songs that have a popularity of 0

## Key findings
- My liking activity is bursty: 38% of the library (684 of 1,814 songs) was added in four months (Nov 2024 – Feb 2025).
- The library is anchored in dream pop and rap variants, with reggaetón and retro soul in the top 10.
- Song age is the only significant predictor of popularity: each extra year between release and liking is associated with a 0.135-point higher score (p < 0.001). This estimate is sensitive to 82 songs with a popularity of 0; excluding them roughly halves it to 0.066 (p = 0.023).
- The model's R² is 0.009, so audio features and age explain under 1% of the variation in popularity. My taste isn't well explained by surface-level audio traits or by chasing mainstream sound.

## Limitations
- 82 songs (4.5%) have a Spotify popularity of 0, mostly newer tracks. This may reflect missing data rather than true unpopularity. Results are directionally the same without them, but the age effect shrinks by about half.
- 27.8% of songs had no genre tag and were left out of the genre chart.
- The explanation for the age effect is a hypothesis; the regression doesn't test it.
- The data covers one person's library, so the results describe my taste only.

## Files
- [`Spotify_Analysis.R`](): full analysis code (cleaning, charts, regression, robustness check)
- [`Spotify_Analysis.pdf`](): written report

## Tools
R · tidyverse · ggplot2 · broom
