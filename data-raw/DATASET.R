# dependencies
library(tidyverse)
source("R/c_sort_collapse.R")
source("R/not_in.R")

# Function to create a variable to use distinct after



# Load data from xlsx
# Read sheet names
sheets <- readxl::excel_sheets("data-raw/queridometro2021.xlsx")

# Load eliminations date
eliminations <- readxl::read_excel("data-raw/queridometro2021.xlsx",
                                   sheet = sheets[2])

# Load votes
votes <- readxl::read_excel("data-raw/queridometro2021.xlsx",
                            sheet = sheets[1])

# Delete NAs in the votes
votes <- votes %>% na.omit()

# Give score based on emoji
votes <- votes %>%
  mutate(score = case_when(Emoji == "Coração" ~ 1,
                           Emoji == "Sorriso" ~ 0,
                           TRUE ~ -1
  ))

#### Data full-program ----

# Calculate votes by participants
df <- votes %>% group_by(Sender, Reciever) %>%
  summarise(scores = sum(score)) %>% arrange(desc(scores))

# Create df with days that participants remained in the show
# Create vector with the starting date of the shot
data_inicio <- votes %>%
  as.data.frame() %>% .[1,2] %>%
  as.character()

# Create vector with name of participants that were not eliminated
participantes <- c("Gilberto", "Juliette", "Camilla", "Fiuk")
brothers <- votes %>% filter(Sender %in% participantes) %>%
  group_by(Sender) %>% summarise(Data = max(Data)) %>%
  relocate(Data, Participante = Sender)

# bind dfs and calcualte days in the show
part <- eliminations %>% rename(Participante = Eliminado) %>%
  bind_rows(brothers) %>%
  mutate(first_day = as.Date(data_inicio),
         Data = as.Date(Data),
         between = Data - first_day) %>%
  select(Participante, between)

# Add days in the show
df <- df %>%
  left_join(part, by = c("Sender" = "Participante")) %>%
  left_join(part, by = c("Reciever" = "Participante")) %>%
  mutate(between = if_else(between.x > between.y, between.y, between.x)) %>%
  select(-between.x, -between.y)

# Create two df to add in same line scores from both participants
df1 <- df %>% ungroup() %>%
  mutate(connection = paste0(Sender, Reciever))
df2 <- df %>% ungroup() %>%
  mutate(connection = paste0(Reciever, Sender)) %>%
  select(scores, connection)

# Unite dfs and remove duplicates
d <- full_join(df1, df2, by = c("connection" = "connection")) %>%
  mutate(x_y = map2_chr(Sender, Reciever, c_sort_collapse)) %>%
  distinct(x_y, .keep_all = TRUE) %>%
  select(-x_y)

# Equalize scores by days in the show
data_full_program <- d %>%
  mutate(scores = (scores.x + scores.y)/2,
         scores_days = scores/as.numeric(between)) %>%
  select(-scores.x, -scores.y, -connection)

# Save
usethis::use_data(data_full_program, overwrite = TRUE)

#### Data Primeira Temporada ----
# Filter data until the day that Karol was eliminated
# Day that Karol was eliminated
end_1st_season <- eliminations %>%
  as.data.frame() %>% .[5,1] %>%
  as.character()

votes_1st_season <- votes %>% filter(Data <= end_1st_season)

# Calculate votes by participants
df <- votes_1st_season %>% group_by(Sender, Reciever) %>%
  summarise(scores = sum(score)) %>% arrange(desc(scores))

# Create df with days that participants remained in the show
# Create vector with the starting date of the shot
data_inicio <- votes_1st_season %>%
  as.data.frame() %>% .[1,2] %>%
  as.character()

# Create vector with name of participants that were not eliminated
participantes <- c("Kerline", "Arcrebiano", "Lucas", "Nego Di", "Karol")
brothers <- votes_1st_season %>% filter(Sender %!in% participantes) %>%
  group_by(Sender) %>% summarise(Data = max(Data)) %>%
  relocate(Data, Participante = Sender)

# bind dfs and calcualte days in the show
part <- eliminations %>% arrange(Data) %>% .[1:5,] %>%
  rename(Participante = Eliminado) %>%
  bind_rows(brothers) %>%
  mutate(first_day = as.Date(data_inicio),
         Data = as.Date(Data),
         between = Data - first_day) %>%
  select(Participante, between)

# Add days in the show
df <- df %>%
  left_join(part, by = c("Sender" = "Participante")) %>%
  left_join(part, by = c("Reciever" = "Participante")) %>%
  mutate(between = if_else(between.x > between.y, between.y, between.x)) %>%
  select(-between.x, -between.y)

# Create two df to add in same line scores from both participants
df1 <- df %>% ungroup() %>%
  mutate(connection = paste0(Sender, Reciever))
df2 <- df %>% ungroup() %>%
  mutate(connection = paste0(Reciever, Sender)) %>%
  select(scores, connection)

# Unite dfs and remove duplicates
d <- full_join(df1, df2, by = c("connection" = "connection")) %>%
  mutate(x_y = map2_chr(Sender, Reciever, c_sort_collapse)) %>%
  distinct(x_y, .keep_all = TRUE) %>%
  select(-x_y)

# Equalize scores by days in the show
data_1st_season <- d %>%
  mutate(scores = (scores.x + scores.y)/2,
         scores_days = scores/as.numeric(between)) %>%
  select(-scores.x, -scores.y, -connection)

# Save
usethis::use_data(data_1st_season, overwrite = TRUE)

#### Data Segunda Temporada ----
# Filter data between the day that Karol was eliminated and the day that
# Rodolffo was eliminated
# Day that Lumena was eliminated
end_1st_season <- eliminations %>%
  as.data.frame() %>% .[5,1] %>%
  as.character()

# Day that Rodolffo was eliminated
end_2nd_season <- eliminations %>%
  as.data.frame() %>% .[10,1] %>%
  as.character()

votes_2nd_season <- votes %>% filter(Data > end_1st_season & Data <= end_2nd_season)

# Calculate votes by participants
df <- votes_2nd_season %>% group_by(Sender, Reciever) %>%
  summarise(scores = sum(score)) %>% arrange(desc(scores))

# Create df with days that participants remained in the show
# Create vector with the starting date of the 2nd season
data_inicio <- votes_2nd_season %>%
  as.data.frame() %>% .[1,2] %>%
  as.character()

# Create vector with name of participants that were not eliminated
participantes <- c("Kerline", "Arcrebiano", "Lucas", "Nego Di", "Karol",
                   "Projota", "Carla", "Sarah", "Rodolffo")
brothers <- votes_2nd_season %>% filter(Sender %!in% participantes) %>%
  group_by(Sender) %>% summarise(Data = max(Data)) %>%
  relocate(Data, Participante = Sender)

# bind dfs and calcualte days in the show
part <- eliminations %>% arrange(Data) %>% .[1:10,] %>%
  rename(Participante = Eliminado) %>%
  bind_rows(brothers) %>%
  mutate(first_day = as.Date(data_inicio),
         Data = as.Date(Data),
         between = Data - first_day) %>%
  select(Participante, between)

# Add days in the show
df <- df %>%
  left_join(part, by = c("Sender" = "Participante")) %>%
  left_join(part, by = c("Reciever" = "Participante")) %>%
  mutate(between = if_else(between.x > between.y, between.y, between.x)) %>%
  select(-between.x, -between.y)

# Create two df to add in same line scores from both participants
df1 <- df %>% ungroup() %>%
  mutate(connection = paste0(Sender, Reciever))
df2 <- df %>% ungroup() %>%
  mutate(connection = paste0(Reciever, Sender)) %>%
  select(scores, connection)

# Unite dfs and remove duplicates
d <- full_join(df1, df2, by = c("connection" = "connection")) %>%
  mutate(x_y = map2_chr(Sender, Reciever, c_sort_collapse)) %>%
  distinct(x_y, .keep_all = TRUE) %>%
  select(-x_y)



# Equalize scores by days in the show
data_2nd_season <- d %>%
  mutate(scores = (scores.x + scores.y)/2,
         scores_days = scores/as.numeric(between)) %>%
  select(-scores.x, -scores.y, -connection)

# Save
usethis::use_data(data_2nd_season, overwrite = TRUE)

