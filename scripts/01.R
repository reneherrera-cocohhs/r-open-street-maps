# Map Tucson restaurants 
# rené dario 
# 15 November 2022 
# rherrera@coconino.az.gov 


library(here)

install.packages("osmdata")

library(osmdata)

available_features()

available_tags(feature = "water")

available_tags(feature = "tunnel")

# resource: https://wiki.openstreetmap.org/wiki/Main_Page 

library(ggplot2)

# use the bounding box defined for tucson by OSM 
tucson_bb <- getbb("Tucson")

tucson_bb

available_tags(feature = "road")

# after checking wiki we learn it is actually highway, not road 
available_tags(feature = "highway")

# get major tucson road data
tucson_major <- getbb(place_name = "Tucson") %>%
  opq() %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "motorway",
      "primary",
      "secondary"
    )
  ) %>%
  osmdata_sf()

?osmdata_sf

# create the plot object use osm_lines of tucson major
street_plot <- ggplot() +
  geom_sf(
    data = tucson_major$osm_lines,
    inherit.aes = FALSE,
    color = "black",
    size = 0.2
  ) 

# print the street plot 
street_plot

# get minor road data 
tucson_minor <- getbb("Tucson") %>%
  opq() %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "tertiary",
      "residential"
    )
  ) %>%
  osmdata_sf()

# plot minor roads 
street_plot <- street_plot +
  geom_sf(
    data = tucson_minor$osm_lines,
    inherit.aes = FALSE,
    color = "grey",
    size = 0.1
  )

street_plot

# query for Tucson restaurants 
tucson_rest <- getbb(place_name = "Tucson") %>%
  opq() %>%
  add_osm_feature(
    key = "amenity",
    value = c(
      "restaurant"
    )
  ) %>% # mexican cuisine only
  add_osm_feature(
    key = "cuisine",
    value = c(
      "mexican"
    )
  ) %>%
  osmdata_sf()

tucson_rest

# create a new plot with restaurants and streets 
(rest_plot <- street_plot +
  geom_sf(
    data = tucson_rest$osm_points,
    inherit.aes = FALSE,
    color = "green",
    size = 1.5,
    alpha = 4/7
  ))

(rest_plot <- rest_plot +
  coord_sf(
    ylim = c(
      32.1,
      32.3
    ),
    expand = FALSE
  ) +
  theme_void()) +
  labs(
    title = "Mexican Restaurants in Tucson (2022)",
    caption = "Source: OSMData"
  )
