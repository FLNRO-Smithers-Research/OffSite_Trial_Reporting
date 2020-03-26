library(epitools)
library(ggplot2)

temperature_event <- function(active_climate, threshold){
  event_length = 0
  event_date = 0
  magnitude = threshold
  events = list()
  num_events = 0

  for (hour in 1:nrow(active_climate)){
    
    if(is.na(active_climate[[3]][[hour]])){
      if (event_length > 0){
        events[[num_events]] <- c(event_date, event_length, magnitude)
        event_length = 0
        magnitude = threshold
      }
    }
    else {
      if (event_length > 0 && active_climate[[3]][[hour]] < threshold){
        event_length = event_length + 1
        magnitude = min(magnitude, active_climate[[3]][[hour]])
      }
      if (event_length == 0 && active_climate[[3]][[hour]] < threshold){
        event_length = event_length + 1
        num_events = num_events + 1
        event_date = as.numeric(julian(active_climate[[2]][[hour]]))
        magnitude = min(magnitude, active_climate[[3]][[hour]])
      }
      
      if (event_length > 0 && active_climate[[3]][[hour]] >= threshold){
        events[[num_events]] <- c(event_date, event_length, (as.numeric(magnitude)*(-1)))
        event_length = 0
        magnitude = threshold
      }
    }
  }
  if (event_length > 0){
    events[[num_events]] <- c(event_date, event_length, (as.numeric(magnitude)*(-1)))
    event_length = 0
    magnitude = threshold
  }
  df = as.data.frame(t(matrix(unlist(events), nrow=length(unlist(events[1])))))
  colnames(df) <- c("date", "duration", "magnitude")
  print(cat("   \n Number of Events: ", length(events), "  \n"))
  print(ggplot(data = df, aes(date)) + geom_line(aes(y=duration, color="Duration hours")) + geom_line(aes(y=magnitude, color="Magnitude: Degrees below threshold")))
  return()
}

