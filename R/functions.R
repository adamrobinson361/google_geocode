library(dplyr)
library(sf)

# Function to round to decimal place
specify_decimal <- function(x, k) trimws(format(round(x, k), nsmall = k))

# Function to convert comma sepetated lng lat to easting northing
lnglat_to_eastnorth <- function(x){
  
  df <- tibble(x) %>%
    separate(x, into = c("lng", "lat"),
             sep = ",", convert = TRUE)
  
  pt <- st_as_sf(df, coords = c("lng", "lat"),
                 crs = st_crs(4326)) %>%
    st_transform(crs = st_crs(27700))
  
  coords <- st_coordinates(pt)
  
  paste0(specify_decimal(coords[1], 0), ",", specify_decimal(coords[2],0))
  
}