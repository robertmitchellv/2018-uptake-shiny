library(tidyverse)
library(sf)
`%<>%` <- magrittr::`%<>%`

load_data <- function() {
  
  housing_read <- readr::read_csv(
    file = "data/raw/Affordable_Rental_Housing_Developments.csv",
    progress = FALSE) %>% janitor::clean_names()
  
  readr::stop_for_problems(housing_read)
  
  geo_data <- read_sf(
    dsn = "data/geo/chicago_boundaries_community_areas.geojson",
    layer = "chicago_boundaries_community_areas")
  
  # We'll use these list with dplyr to assign a new variable
  artist <- c(
    "Artist Housing", "Artist Live/Work Space"
  )
  
  disabled <- c(
    "People with Disabilities" 
  )
  
  family <- c(
    "Multfamily", "Multifamily", "Multifamily/Artists", "Multigfamily",
    "Mutifamily", "Inter-generational" 
  )
  
  senior <- c(
    "Senior", "Senior HUD 202", "Senior LGBTQ", "Seniors"
  )
  
  supportive <- c(
    "65+/Supportive", "Disabled/Homeless", "Supportive", "Supportive Housing",
    "Supportive/HIV/AIDS", "Supportive/Kinship Families", "Supportive/Males 18-24yrs.",
    "Supportive/Teenage Moms", "Supportive/Veterans", "Supportive/Youth/Kinship Families"
  )
  
  housing_read %<>%
    mutate(property_category = case_when(
      property_type %in% artist ~ "Artist",
      property_type %in% disabled ~ "Disabled",
      property_type %in% family ~ "Family",
      property_type %in% senior ~ "Senior",
      property_type %in% supportive ~ "Supportive",
      property_type == "ARO" ~ "Chicago ARO", # Affordable Requirements Ordiance
      TRUE ~ "error"
    ))
  
  housing_read %<>%
    group_by(property_category) %>%
    mutate(n_by_property_category = n())
  
  housing_read %<>% 
    group_by(management_company, community_area_name) %>% 
    mutate(n_by_management_company = n()) %>%
    arrange(community_area_name) %>%
    dplyr::ungroup() %>%
    group_by(community_area_name) %>%
    mutate(n_affordable_housing = n()) %>%
    dplyr::ungroup()
  
  geo_data %<>%
    mutate(community = str_to_title(community))
  
  housing_read %<>%
    rename(community = community_area_name)
  
  housing <- left_join(geo_data, housing_read, by = "community")
  stopifnot("sf" %in% class(housing))
  return(housing)
}
