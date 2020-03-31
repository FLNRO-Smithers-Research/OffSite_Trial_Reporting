require(dplyr)

load_trees <- function(folder){
  file_list = read.csv(paste(folder, "FID.csv", sep = ""))
  trees = data.frame()
  for(file in file_list[[1]]){
    fid = read.csv(paste(folder, "FID_", file[[1]], ".csv", sep = ""))
    trees = rbind(trees, fid)
  }
  return(trees)
}

plot_summary <- function(tree_list){
  summary <- data.frame(fid=character(), plot=character(), condition=character(), count=numeric())
  fid <- tree_list %>% distinct(FID)
  for (f in 1:nrow(fid)){
    plots <- filter(tree_list, FID == fid$FID[[f]]) %>% distinct(Plot)
    for (p in 1:nrow(plots)){
      summary <- rbind(summary, data.frame(fid=as.character(fid$FID[[f]]), plot=as.character(plots$Plot[[p]]), condition="Good", 
                                           count=filter(tree_list, FID == fid$FID[[f]] & Plot == plots$Plot[[p]] & Condition == "Good") %>% count()))
      summary <- rbind(summary, data.frame(fid=as.character(fid$FID[[f]]), plot=as.character(plots$Plot[[p]]), condition="Fair", 
                                           count=filter(tree_list, FID == fid$FID[[f]] & Plot == plots$Plot[[p]] & Condition == "Fair") %>% count()))
      summary <- rbind(summary, data.frame(fid=as.character(fid$FID[[f]]), plot=as.character(plots$Plot[[p]]), condition="Poor", 
                                           count=filter(tree_list, FID == fid$FID[[f]] & Plot == plots$Plot[[p]] & Condition == "Poor") %>% count()))
      summary <- rbind(summary, data.frame(fid=as.character(fid$FID[[f]]), plot=as.character(plots$Plot[[p]]), condition="Moribund", 
                                           count=filter(tree_list, FID == fid$FID[[f]] & Plot == plots$Plot[[p]] & Condition == "Moribund") %>% count()))
      summary <- rbind(summary, data.frame(fid=as.character(fid$FID[[f]]), plot=as.character(plots$Plot[[p]]), condition="Missing", 
                                           count=filter(tree_list, FID == fid$FID[[f]] & Plot == plots$Plot[[p]] & Condition == "Missing") %>% count()))
    }
  }
  return(summary)
}

treatment_summary <- function(tree_list){
  summary <- data.frame(species=character(), plot=character(), condition=character(), count=numeric())
  species <- tree_list %>% distinct(Species)
  for (f in 1:nrow(species)){
    plots <- filter(tree_list, Species == species$Species[[f]]) %>% distinct(Seedlot)
    for (p in 1:nrow(plots)){
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), plot=as.character(plots$Seedlot[[p]]), condition="Good", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Seedlot == plots$Seedlot[[p]] & Condition == "Good") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), plot=as.character(plots$Seedlot[[p]]), condition="Fair", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Seedlot == plots$Seedlot[[p]] & Condition == "Fair") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), plot=as.character(plots$Seedlot[[p]]), condition="Poor", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Seedlot == plots$Seedlot[[p]] & Condition == "Poor") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), plot=as.character(plots$Seedlot[[p]]), condition="Moribund", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Seedlot == plots$Seedlot[[p]] & Condition == "Moribund") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), plot=as.character(plots$Seedlot[[p]]), condition="Missing", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Seedlot == plots$Seedlot[[p]] & Condition == "Missing") %>% count()))
    }
  }
  return(summary)
}

species_summary <- function(tree_list){
  summary <- data.frame(species=character(), condition=character(), count=numeric())
  species <- tree_list %>% distinct(Species)
  for (f in 1:nrow(species)){
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), condition="Good", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Condition == "Good") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), condition="Fair", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Condition == "Fair") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), condition="Poor", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Condition == "Poor") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), condition="Moribund", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Condition == "Moribund") %>% count()))
      summary <- rbind(summary, data.frame(species=as.character(species$Species[[f]]), condition="Missing", 
                                           count=filter(tree_list, Species == species$Species[[f]] & Condition == "Missing") %>% count()))
  }
  return(summary)
}

seedlot_summary <- function(tree_list){
  summary <- data.frame(seedlot=character(), condition=character(), count=numeric())
  seedlot <- tree_list %>% distinct(Seedlot)
  for (f in 1:nrow(seedlot)){
    summary <- rbind(summary, data.frame(seedlot=as.character(seedlot$Seedlot[[f]]), condition="Good", 
                                         count=filter(tree_list, Seedlot == seedlot$Seedlot[[f]] & Condition == "Good") %>% count()))
    summary <- rbind(summary, data.frame(seedlot=as.character(seedlot$Seedlot[[f]]), condition="Fair", 
                                         count=filter(tree_list, Seedlot == seedlot$Seedlot[[f]] & Condition == "Fair") %>% count()))
    summary <- rbind(summary, data.frame(seedlot=as.character(seedlot$Seedlot[[f]]), condition="Poor", 
                                         count=filter(tree_list, Seedlot == seedlot$Seedlot[[f]] & Condition == "Poor") %>% count()))
    summary <- rbind(summary, data.frame(seedlot=as.character(seedlot$Seedlot[[f]]), condition="Moribund", 
                                         count=filter(tree_list, Seedlot == seedlot$Seedlot[[f]] & Condition == "Moribund") %>% count()))
    summary <- rbind(summary, data.frame(seedlot=as.character(seedlot$Seedlot[[f]]), condition="Missing", 
                                         count=filter(tree_list, Seedlot == seedlot$Seedlot[[f]] & Condition == "Missing") %>% count()))
  }
  return(summary)
}
