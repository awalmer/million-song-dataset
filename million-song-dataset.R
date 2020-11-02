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


#-------------#
# DATA FRAMES
#-------------#

data <- read.csv("msd-cleaned-subset.csv")

#-------------#
# CLEANING
#-------------#


#----------------#
# VISUALIZATIONS
#----------------#

data$geohash <- gh_encode(data$artist_latitude, data$artist_longitude, precision = 8)
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(data$geohash, popup="The birthplace of R")
m  # Print the map


timeseries <- ggplot(data, aes(x = `year`, y = `segments_loudness_max`, color = time_signature,
                                                   text = paste('Song Title:', `title`,
                                                                '<br>Artist Name:', `artist_name`
                                                                )
                                        )) + 
  geom_point(alpha = 0.85, shape=16) +
  stat_smooth(method='lm', formula= y~x) + 
  theme(legend.key.height = unit(1,"cm"), legend.key.width = unit(.2, "cm")) +
  xlab("Year") + ylab("Maximum dB Reached in Song") +
  labs(title = "Are Songs Getting Louder Over Time?",
       caption = "Million Song Dataset: Subset of 10,000") +
  scale_x_continuous(breaks = seq(1960,2010,5), limits = c(1960,2010))
  #scale_y_date(labels = date_format("%e %b %Y"), breaks = date_breaks("6 weeks"))
saveWidget(ggplotly(timeseries, tooltip = "text"), file = "time series test.html")



# most popular time signature by year?
# 

