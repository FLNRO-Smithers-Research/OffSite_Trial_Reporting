library(epitools)
library(ggplot2)
library(datetime)

#Input is a data frame, containing feilds "site", "date", and "temp", threshold is numeric of
#same unit as "temp" column.
#Returns Summary of all sites suitable for plotting.
temperature_summary <- function(climate, threshold){
  ClimateStationID <- unique(climate[,c("ClimateStationID")])
  site_stats = list()
  for(this_site in ClimateStationID){ #Calculate statistics for each site independantly
    active_climate = climate %>% filter(ClimateStationID == this_site & ClimateVar == "temp")
    events = find_events(active_climate, threshold)
    df = as.data.frame(t(matrix(unlist(events), nrow=length(unlist(events[1])))))
    colnames(df) <- c("date", "duration", "magnitude")
    site_stats[[this_site]] <- c(this_site, length(df[["magnitude"]]), max(as.numeric(df[["magnitude"]])), sum(as.numeric(df[["duration"]])))
  }
  event_df = as.data.frame(t(matrix(unlist(site_stats), nrow=length(unlist(site_stats[1])))))
  colnames(event_df) <- c("ClimateStationID", "num_events", "max_magnitude", "duration")
  return(event_df)
}

#Input is a data frame, containing feilds "site", "date", and "temp", threshold is numeric of
#same unit as "temp" column.
#Returns list of all events along with julian time, duration, and magnitude.
temperature_events <- function(climate, threshold){
  ClimateStationID <- unique(climate[,c("ClimateStationID")])
  all_events = list()
  for(this_site in ClimateStationID){ #Calculate statistics for each site independantly
    active_climate = climate %>% filter(ClimateStationID == this_site)
    events = find_events(active_climate, threshold)
    event_df = as.data.frame(t(matrix(unlist(events), nrow=length(unlist(events[1])))))
    colnames(event_df) <- c("Julean Date", "Duration", "Magnitude")
    all_events[[this_site]] <- event_df
  }
  return(all_events)
}

find_events <- function(active_climate, threshold){
  event_length = 0
  event_date = 0
  magnitude = threshold
  events = list()
  num_events = 0
  for (period in 1:nrow(active_climate)){ 
    if(is.na(active_climate[["Value"]][[period]])){ #Check for end of data
      if (event_length > 0){ #If an event was detected but, at end of data save event
        events[[num_events]] <- c(event_date, event_length, magnitude)
        event_length = 0
        magnitude = threshold
      }
    }
    else {
      #if loop is in an event, and temperature below threshold add to events duration, and check magnitude
      if (event_length > 0 && active_climate[["Value"]][[period]] < threshold){
        event_length = event_length + 1
        magnitude = min(magnitude, active_climate[["Value"]][[period]])
      }
      #if loop is not in an event, and temperature below threshold create event and set magnitude
      if (event_length == 0 && active_climate[["Value"]][[period]] < threshold){
        event_length = event_length + 1
        num_events = num_events + 1
        event_date = as.numeric(julian(as.Date(as.character(active_climate[["Date"]][[period]]))))
        magnitude = active_climate[["Value"]][[period]]
      }
      #if loop is in an event, and temperature above theshold write out event
      if (event_length > 0 && active_climate[["Value"]][[period]] >= threshold){
        events[[num_events]] <- c(event_date, event_length, (as.numeric(magnitude)*(-1)))
        event_length = 0
        magnitude = threshold
      }
    }
  }
  #Write any remaining data at end of loop
  if (event_length > 0){
    events[[num_events]] <- c(event_date, event_length, (as.numeric(magnitude)*(-1)))
  }
  return(events)
}
