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


