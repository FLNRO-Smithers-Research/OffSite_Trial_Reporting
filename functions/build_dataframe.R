source("functions/tree_position.R")
load_all <- function(dir){
  
  all_data <- list("trees" = data.frame(), "plots" = data.frame(), "climate" = data.frame(), "meta" = data.frame())
  
  print("loading metadata...")
  all_data$meta = load_meta(dir)
  print("loading seedlots...")
  all_data$seedlots = load_seedlots(dir)
  print("loading plots...")
  all_data$plots = load_plots(dir)
  print("loading trees...")
  all_data$trees = load_trees(dir, all_data$plots)
  print("loading climate...")
  all_data$climate = load_climate(dir)
  print("finished!")

  save(all_data, file = "trial_data.Rdata")
}


load_trees <- function(folder, plots){
  file_list = list.files(folder)
  trees = data.frame()
  for(file in file_list){
    if(grepl("FID_", file)){
      trees = rbind(trees, read.csv(paste(folder, "/", file, sep = "")))
    }
  }
    
  trees[,"Lat"] <- numeric()
  trees[,"Lon"] <- numeric()
  for(tree in 1:nrow(trees)){
    #print(trees[tree,])
    result = tree_position(trees[tree,], plots)
    trees[tree, "Lat"] = result[["Lat"]]
    trees[tree, "Lon"] = result[["Lon"]]
  }
  return(trees)
}

load_plots <- function(folder){
  file_list = list.files(folder)
  plots = data.frame()
  for(file in file_list){
    if(grepl("_plot", file)){
      plots = rbind(plots, read.csv(paste(folder, "/", file, sep = "")))
    }
  }
  return(plots)
}

load_climate <- function(folder){
  file_list = list.files(folder)
  climate = data.frame()
  for(file in file_list){
    if(grepl("_climate", file)){
      climate = rbind(climate, read.csv(paste(folder, "/", file, sep = "")))
    }
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
    if(grepl("meta", file)){
      meta = rbind(meta, read.csv(paste(folder, "/", file, sep = "")))
    }
  }
  return(meta)
}

load_seedlots <- function(folder){
  file_list = list.files(folder)
  seedlots = data.frame()
  for(file in file_list){
    if(grepl("seedlots", file)){
      seedlots = rbind(seedlots, read.csv(paste(folder, "/", file, sep = "")))
    }
  }
  return(seedlots)
}


load_all("data")
load("trial_data.Rdata")






