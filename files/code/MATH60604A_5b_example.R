library(ggplot2)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)

revenge[revenge$id %in% c(1:3),]
# id < 4 does not work because "id" is a factor...

# Summary statistics and linear correlation matrix
summary(revenge[revenge$time == 1,c("sex","age","vc","wom")])
cor(revenge[revenge$time == 1,c("sex","age","vc","wom")])

# Spaghetti plot
ggplot(data=revenge, 
       aes(x=t, y=revenge, group=id)) + 
  geom_line(alpha = 0.2) + 
  scale_x_continuous(expand = c(0,0), limits = c(1,5))
