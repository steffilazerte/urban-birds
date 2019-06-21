#' ---
#' title: Explore Bird Data
#' output: html_document
#' ---
#' 
#+ eval = FALSE
# rmarkdown::render("./Scripts/03_explore_urban.R", output_file = "./Results")

#' # Setup
library(here)
library(tidyverse)
library(sf)
library(rnaturalearth)
library(fasterize)
library(raster)
library(gridExtra)
library(mapview)

#' # Birds
# birds <- auk_ebd("../Data/Raw/ebird_reference/extended-covariates-sample.csv") %>%
#   auk_species(species = "Black-capped Chickadee") %>%
#   auk_country(country = "Canada") %>%
#   auk_filter(file = "../Data/Datasets/bcch.txt") %>%
#   read_ebd()

birds <- read_tsv("./Data/Raw/ebird_basic/ebd_US-AL-101_201801_201801_relMay-2018.txt") %>%
  filter(`COMMON NAME` == "American Robin") %>%
  select(common_name = `COMMON NAME`, n = `OBSERVATION COUNT`, loc = `LOCALITY`,
         loc_id = `LOCALITY ID`, loc_type = `LOCALITY TYPE`, lat = LATITUDE,
         lon = LONGITUDE, date = `OBSERVATION DATE`, sampling_event = `SAMPLING EVENT IDENTIFIER`)

covar <- read_csv("./Data/Raw/ebird_reference/extended-covariates-sample.csv") %>%
  rename_all(tolower) %>%
  select(sampling_event_id, umd_landcover, umd_watercover, year)

birds <- read_csv("./Data/Raw/ebird_reference/checklists-sample.csv") %>%
  rename_all(tolower) %>%
  select(sampling_event_id, loc_id, latitude, longitude, year, month, day, time, 
         country, state_province, country, count_type, n = turdus_migratorius)

birds_sf <- birds%>%
  filter(country %in% c("Canada", "United States")) %>%
  left_join(covar, by = c("sampling_event_id", "year")) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
  st_transform(crs = st_crs(dist))

ggplot() +
  geom_sf(data = na) +
  geom_sf(data = dist) +
  geom_sf(data = birds_sf)

ggplot() +
  geom_sf(data = na, fill = "white") +
  geom_sf(data = urban, fill = "orange", colour = NA) 

urban_birds <- urban %>%
  st_transform(crs = 3347) %>%
  st_join(st_transform(birds_sf, crs = 3347), ., left = FALSE)

zoom <- data.frame(lon = c(-70, -50, -70, -50),
                   lat = c(43, 43, 50, 50)) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  st_transform(3347) %>%
  st_bbox()

ggplot() +
  geom_sf(data = na, fill = "white") +
  geom_sf(data = birds_sf, colour = "green") +
  geom_sf(data = urban, fill = "orange", colour = NA) +
  geom_sf(data = urban_birds, colour = "red")
coord_sf(xlim = zoom[c(1,3)], ylim = zoom[c(2,4)])

