#' ---
#' title: Explore Urban Data
#' output: html_document
#' ---
#' 
#+ eval = FALSE
# rmarkdown::render("./Scripts/03_explore_urban.R", output_dir = "./Results/")
  
#' # Setup
library(here)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(fasterize)
library(raster)
library(gridExtra)
library(mapview)

#' # Zoomed location
zoom <- data.frame(lon = c(-80, -75, -80, -75),
                   lat = c(35, 35, 40, 40)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(3347) %>%
  st_bbox()

#' # General Maps
na <- ne_countries(continent = "North America", returnclass = "sf") %>%
  st_transform(3347) %>%
  st_crop(zoom)

urban <- ne_load(scale = 50, "urban_areas", destdir = here("./Data/Raw/ne_urban/"), returnclass = "sf")  %>%
  st_transform(3347) %>%
  st_crop(zoom) %>%
  st_cast("MULTIPOLYGON")

ggplot(na) +
  geom_sf() +
  geom_sf(data = urban, colour = "orange", fill = "grey")

r <- fasterize::raster(urban, res = 500)
urban_raster <- fasterize(urban, r, fun = "max")

urban_plot <- as.data.frame(urban_raster, xy = TRUE) %>%
  filter(!is.na(layer))

ggplot(na) + 
  geom_sf() +
  geom_tile(data = urban_plot, aes(x = x, y = y), colour = "orange")

zoom <- data.frame(lon = c(-79.75, -79.5, -79.75, -79.5),
                   lat = c(43.75, 43.75, 44, 44)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(3347) %>%
  st_bbox()

#' Not too bad a rasterization job!
ggplot(na) + 
  geom_sf() +
  geom_sf(data = urban, colour = "red", fill = "grey") +
  geom_tile(data = urban_plot, aes(x = x, y = y), colour = "orange", alpha = 0.8) +
  coord_sf(xlim = zoom[c(1,3)], ylim = zoom[c(2,4)])

#' Is this 500m resolution? Hmm, approximately (may depend on where around the world)
mapview(urban_raster, maxpixels = 1393639)

#' Perhaps worth requesting original?