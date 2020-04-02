load_all <- function(dir){
  tree_dir = paste(dir, "/trees", sep = "")
  plot_dir = paste(dir, "/plots", sep = "")
  meta_dir = paste(dir, "/meta", sep = "")
  climate_dir = paste(dir, "/climate", sep = "")
  all_data <- list("trees" = data.frame(), "plots" = data.frame(), "climate" = data.frame(), "meta" = data.frame())
  all_data$trees = load_trees(tree_dir)
  all_data$plots = load_plots(plot_dir)
  all_data$climate = load_climate(climate_dir)
  all_data$meta = load_meta(meta_dir)
  save(all_data, file = "trial_data.Rdata")
}

load_trees <- function(folder){
  file_list = list.files(folder)
  trees = data.frame()
  for(file in file_list){
    trees = rbind(trees, read.csv(paste(folder, "/", file, sep = "")))
  }
  return(trees)
}

load_plots <- function(folder){
  file_list = list.files(folder)
  plots = data.frame()
  for(file in file_list){
    plots = rbind(plots, read.csv(paste(folder, "/", file, sep = "")))
  }
  return(plots)
}

load_climate <- function(folder){
  file_list = list.files(folder)
  climate = data.frame()
  for(file in file_list){
    climate = rbind(climate, read.csv(paste(folder, "/", file, sep = "")))
  }
  expand_climate = data.frame(ClimateSationID = character(), Date = character(), ClimateVar = character(), Value = character())
  for(var in 3:ncol(climate)){
    expand_climate = rbind(expand_climate, data.frame(ClimateStationID = climate[[1]], Date = climate[[2]], 
                                                      ClimateVar = rep(as.character(colnames(climate[var])), 
                                                      Value = nrow(climate)), Value = climate[[var]]))
  }
  return(expand_climate)
}

load_meta <- function(folder){
  file_list = list.files(folder)
  meta = data.frame()
  for(file in file_list){
    meta = rbind(meta, read.csv(paste(folder, "/", file, sep = "")))
  }
  return(meta)
}


load_all("data")
load("trial_data.Rdata")



