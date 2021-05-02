# Dependencies
library(tidyverse)
library(igraph)
load("data/data_full_program.rda")
load("data/data_1st_season.rda")
load("data/data_2nd_season.rda")

# Create vector with name of the brothers
brothers <- data_full_program %>% select(Sender) %>%
  unique() %>% as.data.frame() %>%
  pull(Sender) %>% c(., "Carla")


#### Full-program Graph ----
# Create dataset with senders and recievers based on the score
d_full <- data_full_program %>% filter(scores_days > 0.6) %>%
  select(Sender, Reciever)

# Create igraph object
g <- graph_from_data_frame(d_full,
                      directed = FALSE,
                      vertices = brothers)


# Centrality measures
df_centralidade <- data.frame(
  "Participantes" = V(g)$name,
  degree = degree(g, norm = TRUE),
  closeness = closeness(g, norm = TRUE),
  betweenness = betweenness(g, norm = TRUE)
)

# write_csv2(df_centralidade, "data/centralidade_full_program.csv")

# Plot the igraph
# png("figs/full_program.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
plot(g, vertex.color = "#ff617b", label.cex = 1000,
     vertex.label.color = "Black")
# dev.off()

# Plot the igraph with clusters
# png("figs/full_program_clusters.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
cluster_leading_eigen(g) %>% plot(g, edge.arrow.size = 0.1,
                                  vertex.label.color = "black",
                                  main = "Clusters")
# dev.off()

#### 1st season Graph ----
# Create dataset with senders and recievers based on the score
d_1st <- data_1st_season %>% filter(scores_days > 0.75) %>%
  select(Sender, Reciever)

# Create igraph object
g <- graph_from_data_frame(d_1st,
                           directed = FALSE,
                           vertices = brothers)


# Centrality measures
df_centralidade <- data.frame(
  "Participantes" = V(g)$name,
  degree = degree(g, norm = TRUE),
  closeness = closeness(g, norm = TRUE),
  betweenness = betweenness(g, norm = TRUE)
)

# write_csv2(df_centralidade, "data/centralidade_1st_season.csv")

# Plot the igraph
# png("figs/1st_season.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
plot(g, vertex.color = "#ff617b", label.cex = 1000,
     vertex.label.color = "Black")
# dev.off()

# Plot the igraph with clusters
# png("figs/1st_season_cluster.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
cluster_louvain(g) %>% plot(g, edge.arrow.size = 0.1,
                            vertex.label.color = "black",
                            main = "Clusters")
# dev.off()

#### 2nd season Graph ----
# Brothers
brothers <- data_2nd_season %>% select(Sender) %>%
  unique() %>% as.data.frame() %>%
  pull(Sender)

# Create dataset with senders and recievers based on the score
d_2nd <- data_2nd_season %>% filter(scores_days > 0.85) %>% # era 0.85
  select(Sender, Reciever)

# Create igraph object
g <- graph_from_data_frame(d_2nd,
                           directed = FALSE,
                           vertices = brothers)


# Centrality measures
df_centralidade <- data.frame(
  "Participantes" = V(g)$name,
  degree = degree(g, norm = TRUE),
  closeness = closeness(g, norm = TRUE),
  betweenness = betweenness(g, norm = TRUE)
)

# write_csv2(df_centralidade, "data/centralidade_2nd_season.csv")

# Plot the igraph
# png("figs/2nd_season.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
plot(g, vertex.color = "#ff617b", label.cex = 1000,
     vertex.label.color = "Black")
# dev.off()


# Plot the igraph with clusters
# png("figs/2nd_season_clusters.png", width = 1167*5, height = 550*5, res = 300)
set.seed(1)
cluster_leading_eigen(g) %>% plot(g, edge.arrow.size = 0.1,
                                  vertex.label.color = "black",
                                  main = "Clusters")
# dev.off()
