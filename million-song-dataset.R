#------------------------------#
# Million Song Dataset
# Data Exploration
# Auralee Walmer // Sep. 2020
#------------------------------#

#-----------#
# SET UP
#-----------#

library(utils)
library(geohashTools)
library(leaflet)
library(ggplot2)
library(htmlwidgets)
library(plotly)
library(stringr)


#-------------#
# DATA FRAMES
#-------------#

data <- read.csv("msd-cleaned-subset.csv")

#-------------#
# CLEANING
#-------------#

subset <- data[data$year>= 1990 & data$year <= 2010 & data$segments_loudness_max<6000,]


#----------------#
# VISUALIZATIONS
#----------------#

timeseries <- ggplot(data, aes(x = `year`, y = `segments_loudness_max`, color = time_signature)) + 
  geom_point(alpha = 0.85, shape=16) +
  geom_smooth(method = 'lm', aes(x = `year`, y = `segments_loudness_max`)) + 
  theme(legend.key.height = unit(1,"cm"), legend.key.width = unit(.2, "cm")) +
  xlab("Year") + ylab("Maximum dB Reached in Song") +
  labs(title = "Are Songs Getting Louder Over Time?",
       caption = "Million Song Dataset: Subset of 10,000") +
  scale_x_continuous(breaks = seq(1960,2010,5), limits = c(1960,2010)) +
  stat_smooth(method = "lm", col = "red")

saveWidget(ggplotly(timeseries, tooltip = "text"), file = "time series test.html")

## doesn't seem like songs are getting longer over time or louder over time. :-/
ggplot(subset, aes(x = `year`, y = `segments_loudness_max`, color = time_signature)) + geom_point() + stat_smooth(method = 'lm')
ggplot(subset, aes(x = `year`, y = `duration`, color = segments_loudness_max)) + geom_point() + stat_smooth(method = 'lm', color="red")

# linear regression:
linearMod <- lm(`segments_loudness_max` ~ `year`, data=data)


## would it be interesting to look at all the individual words in song titles, then rank the most common ones?
str_split(data$release[1], " ", simplify = TRUE)
vect <- c()
for (n in 1:nrow(data)) {
  vals <- as.vector(str_split(data$release[n], " ", simplify = TRUE))
  vect <- append(vals, vect)
}
# vect = individual words



