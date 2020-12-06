longest_between_observations <- function(df, vessel){
  
  full_obs <- df %>% 
    filter(SHIPNAME == vessel) %>% 
    mutate(last_lat = lag(LAT, 1),
           last_lon = lag(LON, 1)) %>% 
    mutate(distance = distHaversine(cbind(LON, LAT), cbind(last_lon, last_lat))/1000) %>% 
    filter(!is.na(distance)) %>% 
    filter(distance == max(distance)) %>% 
    filter(DATETIME == max(DATETIME))
  
  long <- full_obs %>% 
    select(LAT = last_lat,
           LON = last_lon,
           DATETIME) %>% 
    bind_rows(full_obs %>% select(LAT, LON, DATETIME))
  
  return(list(full = full_obs, long = long))
}
