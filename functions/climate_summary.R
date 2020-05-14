library(epitools)
library(ggplot2)
library(datetime)

#Input is a data frame, containing feilds "site", "date", and "temp", threshold is numeric of
#same unit as "temp" column.
#Returns Summary of all sites suitable for plotting.
temperature_summary <- function(climate, threshold, threshold_2=NULL, start=NULL, end=NULL){
  if(is.null(start)){
    start = "1970-01-01" #Easy beginning date range 
  }
  if(is.null(end)){
    end = "2970-01-01" #Arbitrary end date, presumably code will no longer be in use by 2970
  }
  ClimateStationID <- unique(climate[,c("ClimateStationID")])
  site_stats = list()
  for(this_site in ClimateStationID){ #Calculate statistics for each site independantly
    active_climate = climate %>% filter(ClimateStationID == this_site & ClimateVar == "temp" & as.Date(Date) >= as.Date(start) & as.Date(Date) <= as.Date(end) )
    events = find_events(active_climate, threshold)
    if(length(events) > 0){ #Make sure events exist for site
      df = as.data.frame(t(matrix(unlist(events), nrow=length(unlist(events[1])))))
      colnames(df) <- c("date", "frost_duration", "frost_magnitude")
      if(!is.null(threshold_2)){
        events2 = find_events(active_climate, threshold_2)
        if(length(events2) > 0){ #Confim that there is data to read
          df2 = as.data.frame(t(matrix(unlist(events2), nrow=length(unlist(events2[1])))))
          colnames(df2) <- c("date", "hard_frost_duration", "hard_frost_magnitude")
          site_stats[[this_site]] <- c(this_site, length(df[["frost_magnitude"]]), max(as.numeric(df[["frost_magnitude"]])), sum(as.numeric(df[["frost_duration"]])), 
                                       length(df2[["hard_frost_magnitude"]]), sum(as.numeric(df2[["hard_frost_duration"]])))
        }
        else{ #If no hard frost event fill with 0
          site_stats[[this_site]] <- c(this_site, length(df[["frost_magnitude"]]), max(as.numeric(df[["frost_magnitude"]])), sum(as.numeric(df[["frost_duration"]])), 
                                       0, 0)
        }
      }
      else{
        site_stats[[this_site]] <- c(this_site, length(df[["frost_magnitude"]]), max(as.numeric(df[["frost_magnitude"]])), sum(as.numeric(df[["frost_duration"]])))
      }
    }
    else{ #If no events present fill with 0's, inner if makes sure that dimensions are maintained
      if(!is.null(threshold_2)){
        site_stats[[this_site]] <- t(c(this_site, 0, 0, 0, 0, 0))
      }
      else{
        site_stats[[this_site]] <- t(c(this_site, 0, 0, 0))
      }
    }
    
  }
  event_df = as.data.frame(t(matrix(unlist(site_stats), nrow=length(unlist(site_stats[1])))))
  if(!is.null(threshold_2)){
    colnames(event_df) <- c("ClimateStationID", "num_frost_events", "max_magnitude", "frost_duration", "num_hard_frost_events", "hard_frost_duration")
  }
  else{
    colnames(event_df) <- c("ClimateStationID", "num_events", "max_magnitude", "duration")
  }
  return(event_df)
}

#Input is a data frame, containing feilds "site", "date", and "temp", threshold is numeric of
#same unit as "temp" column.
#Returns list of all events along with date, duration, and magnitude.
temperature_events <- function(climate, threshold, start=NULL, end=NULL){
  if(is.null(start)){
    start = "1970-01-01" #Easy beginning date range 
  }
  if(is.null(end)){
    end = "2970-01-01" #Arbitrary end date, presumably code will no longer be in use by 2970
  }
  ClimateStationID <- unique(climate[,c("ClimateStationID")])
  all_events = list()
  for(this_site in ClimateStationID){ #Calculate statistics for each site independantly
    active_climate = climate %>% filter(ClimateStationID == this_site & as.Date(Date) >= as.Date(start) & as.Date(Date) <= as.Date(end))
    events = find_events(active_climate, threshold)
    if(length(events) > 0){ #Check that data frame is not empty
      event_df = as.data.frame(t(matrix(unlist(events), nrow=length(unlist(events[1])))))
    }
    else{ #If the dataframe is empty fill with 0's to prevent null errors
      event_df = as.data.frame(t(c(0,0,0,0)))
    }
    colnames(event_df) <- c("Date", "Day_of_Year", "Duration", "Magnitude")
    all_events[[this_site]] <- event_df
  }
  return(all_events)
}

find_events <- function(active_climate, threshold){
  event_length = 0
  event_date = 0
  day_of_year = 0
  magnitude = threshold
  events = list()
  num_events = 0
  if(nrow(active_climate) > 0){
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
          event_date = as.character(active_climate[["Date"]][[period]])
          day_of_year = lubridate::yday(event_date)
          magnitude = active_climate[["Value"]][[period]]
        }
        #if loop is in an event, and temperature above theshold write out event
        if (event_length > 0 && active_climate[["Value"]][[period]] >= threshold){
          events[[num_events]] <- c(event_date, day_of_year, event_length, (as.numeric(magnitude)*(-1)))
          event_length = 0
          magnitude = threshold
        }
      }
    }
  }
  #Write any remaining data at end of loop
  if (event_length > 0){
    #event_date is cast to string as date objects do not survive unlisting
    events[[num_events]] <- c(as.character(event_date), day_of_year, event_length, (as.numeric(magnitude)*(-1)))
  }
  return(events)
}

