
# Function for transforming the list into a data-frame
transform_metadata_to_df <- function(metadata){
  df<- metadata[[1]] %>%  
    map(as_tibble) %>%  # Each row of the list as_tibble
    list_rbind() %>%  # Binding the rows
    
    # Transforming the nested list into a character value
    mutate(latestData = map_chr(latestData, 1, .default = NA_character_)) %>% 
    
    # Transforming the character version into a date value with the timezone UTC
    mutate(latestData = as_datetime(latestData, tz = "UTC"))  %>%  
    
    # Transforming the latitude and longitude into separate variables
    unnest_wider(location) %>%  
    unnest_wider(latLon)
  
  return(df)
}

# Function for converting dates to ISO with an offset
to_iso8601 <- function(datetime, offset){
  return_date <- iso8601( # Converting into iso format
    datetime + days(offset) # Adding the offset of days
    )
  return_date <- paste0(return_date,"Z") # Appending Z at the end of datetime
  return(return_date)
}

transform_volumes <- function(jsonOutput){
  df <- jsonOutput %>%
    pluck("trafficData", "volume", "byHour", "edges") %>%
    map_df(function(x) {
      data.frame(
        from = as_datetime(x$node$from),
        to = as_datetime(x$node$to),
        volume = x$node$total$volumeNumbers$volume
      )
    })
  return(df)
}