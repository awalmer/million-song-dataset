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

data$geohash <- gh_encode(data$artist_latitude, data$artist_longitude, precision = 8)
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(data$geohash, popup="The birthplace of R")
m  # Print the map


timeseries <- ggplot(data, aes(x = `year`, y = `segments_loudness_max`, color = time_signature,
                                                   text = paste('Song Title:', `title`,
                                                                '<br>Artist Name:', `artist_name`,
                                                                )
                                        )) + 
  geom_point(alpha = 0.85, shape=16) +
  theme(legend.key.height = unit(1,"cm"), legend.key.width = unit(.2, "cm"))
  #xlab("Retention Time") + ylab("Injection Date") +
  #labs(title = "Heparin Retention Time: Time Series, Color by Project",
  #     caption = "Heparin data, historical and new, with and without project info.") +
  #scale_x_continuous(breaks = seq(0,26,2), limits = c(0,10)) +
  #scale_y_date(labels = date_format("%e %b %Y"), breaks = date_breaks("6 weeks"))
saveWidget(ggplotly(timeseries, tooltip = "text"), file = "time series test.html")

