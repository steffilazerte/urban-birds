#' ---
#' title: Download data
#' output: html_document
#' ---

# rmarkdown::render("./Scripts/02_get_data.R", output_dir = "./Results/")

#' # Setup
library(tidyverse)
library(here)
library(rnaturalearth)

#' Specify folders
raw <- here("./Data/Raw")
meta <- here("./Data/Metadata")

#' # Canadian Populations Spatial Data
#' 
#' ## Population counts
#' - [Population by federal electoral districts](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/hlt-fst/pd-pl/Table.cfm?Lang=Eng&T=501&S=46&O=A)
#' 

# pop <- read_csv(paste0("https://www12.statcan.gc.ca/census-recensement/2016/",
#                        "dp-pd/hlt-fst/pd-pl/Tables/File.cfm?T=501&SR=1&RPP=25",
#                        "&PR=0&CMA=0&CSD=0&S=46&O=A&Lang=Eng&OFT=CSV"))
# tail(pop)

#' ## Spatial regions
#' - [Federal electoral districts](https://open.canada.ca/data/en/dataset/737be5ea-27cf-48a3-91d6-e835f11834b0)
#' - [Documentation](http://ftp.maps.canada.ca/pub/elections_elections/Electoral-districts_Circonscription-electorale/federal_electoral_districts_boundaries_2015/doc/)

#' Download metadata
# download.file(url = paste0("http://ftp.maps.canada.ca/pub/elections_elections/",
#                            "Electoral-districts_Circonscription-electorale/",
#                            "federal_electoral_districts_boundaries_2015/doc/",
#                            "GeoBase_fed_en_Catalogue_2_2.pdf"),
#               destfile = file.path(meta, "federal_electoral_districts_meta.pdf"))

#' Download federal electoral districts
# download.file(
#   url = paste0("http://ftp.maps.canada.ca/pub/elections_elections/",
#                "Electoral-districts_Circonscription-electorale/",
#                "federal_electoral_districts_boundaries_2015/",
#                "federal_electoral_districts_boundaries_2015_shp_en.zip"),
#   destfile = file.path(raw, "federal_electoral_districts_boundaries_2015_shp_en.zip"))
# 
# unzip("../Data/Raw/federal_electoral_districts_boundaries_2015_shp_en.zip",
#       exdir = file.path(raw, "federal_electoral_districts"))
# file.remove(file.path(raw, "federal_electoral_districts_boundaries_2015_shp_en.zip"))

#' # US Population data
#' [US Census Bureau](https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-geodatabase-file.html)
# download.file(paste0("https://www2.census.gov/geo/tiger/TGRGDB18/",
#                      "tlgdb_2018_a_us_substategeo.gdb.zip"),
#               destfile = file.path(raw, "tlgdb_2018_a_us_substategeo.gdb.zip"))
# unzip(file.path(raw, "tlgdb_2018_a_us_substategeo.gdb.zip"),
#       junkpaths = TRUE,
#       exdir = file.path(raw, "us_census_districts"))

#' # Urban Areas
#' - [Modus](http://nelson.wisc.edu/sage/data-and-models/schneider-readme.php)
#' - [NaturalEarth Urban Areas](https://www.naturalearthdata.com/downloads/50m-cultural-vectors/50m-urban-areas/)
#' 
ne_download(scale = 50, "urban_areas", destdir = file.path(raw, "ne_urban/"))


#' # Bird Data
#' 
#' E-bird data can be requested at <https://ebird.org/data/download> and then accessed by using the `auk` package
#'
#' There are two types of data:
#'
#' 1. Basic Dataset: Most complete but lacking in extensive, extra, data
#' 2. Reference Dataset: Includes landscape variables, but only updated annually. Includes zero-filled data
#' 
#' For now we can play with the Sample datasets 
#' 
#' **Basic Dataset**
download.file(
  url = paste0("http://ebird.org/downloads/samples/",
               "ebd_US-AL-101_201801_201801_relMay-2018_SAMPLE.zip"), 
  destfile = file.path(raw, "ebd_US-AL-101_201801_201801_relMay-2018_SAMPLE.zip"))
unzip(file.path(raw, "ebd_US-AL-101_201801_201801_relMay-2018_SAMPLE.zip"), 
      exdir = file.path(raw, "ebird_basic/"))
file.remove(file.path(raw, "ebd_US-AL-101_201801_201801_relMay-2018_SAMPLE.zip"))

download.file(
  url = paste0("https://ebird.org/downloads/samples/",
               "ebird_reference_dataset_v2016_western_hemisphere_SAMPLE.zip"),
  destfile = file.path(raw, "ebird_reference_dataset_v2016_western_hemisphere_SAMPLE.zip"))
unzip(file.path(raw, "ebird_reference_dataset_v2016_western_hemisphere_SAMPLE.zip"),
      junkpaths = TRUE, exdir = file.path(raw, "ebird_reference"))
file.remove(file.path(raw, "ebird_reference_dataset_v2016_western_hemisphere_SAMPLE.zip"))