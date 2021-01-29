
library(dplyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(png)
library(RColorBrewer)

d15 <- read.csv("2015.csv", header = TRUE) %>% 
  slice_head(n = 15) %>%
  select(Country, Happiness.Rank, Happiness.Score) %>%
  mutate(Year = 2015)

d16 <- read.csv("2016.csv", header = TRUE) %>% 
  slice_head(n =15) %>%
  select(Country, Happiness.Rank, Happiness.Score) %>%
  mutate(Year = 2016)

d17 <- read.csv("2017.csv", header = TRUE) %>% 
  slice_head(n = 15) %>%
  select(Country, Happiness.Rank, Happiness.Score) %>%
  mutate(Year = 2017)

d18 <- read.csv("2018.csv", header = TRUE) %>% 
  slice_head(n = 15) %>%
  select(Country.or.region, Overall.rank, Score) %>%
  mutate(Year = 2018) %>%
  rename(Country = Country.or.region,
         Happiness.Rank = Overall.rank,
         Happiness.Score = Score)

d19 <- read.csv("2019.csv", header = TRUE) %>% 
  slice_head(n = 15) %>%
  select(Country.or.region, Overall.rank, Score) %>%
  mutate(Year = 2019) %>%
  rename(Country = Country.or.region,
         Happiness.Rank = Overall.rank,
         Happiness.Score = Score)

data <- rbind(d15, d16, d17, d18, d19) %>%
  mutate(Rank = as.factor(Happiness.Rank),
         Value_lbl = paste0(" ", round(Happiness.Score, 3)))


# Color palette
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(20)

anim = ggplot(data, 
              aes(Rank, group = Country, fill = Country))+
  geom_tile(aes(y = Happiness.Score/2,
                height = Happiness.Score,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Country, " ")), vjust = 0.2, hjust = 1, size = 8) + 
  geom_text(aes(y=Happiness.Score,label = Value_lbl, hjust=0), size = 5) +
  coord_flip(clip = "off", expand = TRUE) +
  scale_x_discrete(limits = rev) +
  theme_minimal() +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line(size=.1, color="grey" ),
        panel.grid.minor.x = element_line(size=.1, color="grey" ),
        plot.title=element_text(size=30, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.caption =element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(1,4, 1, 8, "cm")) +
  scale_fill_manual(values = mycolors) + 
  transition_states(Year, transition_length = 1, state_length = 1) +
  ease_aes('sine-in-out') +
  labs(title = 'The 15 Happiest Countries In the World: {closest_state}',
       caption = "Data Source: https://www.kaggle.com/unsdsn/world-happiness")

animate(anim, 
        nframes = 350,
        fps = 25, 
        width = 1200, 
        height = 1000, 
        renderer = gifski_renderer("gganim.gif"))













