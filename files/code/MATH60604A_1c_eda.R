library(ggplot2)
library(poorman)
library(viridis)

theme_set(theme_minimal())
options(ggplot2.continuous.colour="viridis")
options(ggplot2.continuous.fill = "viridis")
scale_colour_discrete <- scale_colour_viridis_d
scale_fill_discrete <- scale_fill_viridis_d

data(renfe, package = "hecstatmod")
ggplot(data = renfe, 
       aes(x = forcats::fct_infreq(class))) + 
  geom_bar() +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5) +
  labs(x = "class", 
       y = "count")  +
  scale_y_continuous(expand = c(.125, 0)) + 
  theme(panel.grid.major.x = element_blank())


renfe %>% subset(fare == "Promo") %>%
  ggplot(aes(x = price)) + 
    geom_histogram(aes(y = ..density..), bins = 30) +
    geom_density() + 
    geom_rug(sides = "b") + 
    labs(x = "price of Promo tickets (in euros)", 
         y = "density") 


renfe %>% subset(fare == "Promo") %>%
    ggplot(aes(y = price, x = class, col = type)) + 
    geom_boxplot() + 
    labs(y = "price (en euros)", col = "train type") + 
    theme(legend.position = "bottom") +
    scale_colour_viridis_d()


renfe %>% subset(type != "REXPRESS") %>%
    ggplot(aes(x = duration, y = price, col = type)) + 
    geom_point() + 
    labs(y = "price (in euros)", 
         x = "travel duration (in minutes)",
         col = "train type") + 
    theme(legend.position = "bottom") +
    scale_colour_viridis_d()

         