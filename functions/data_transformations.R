
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