#Work in Progress

shift_x <- c(-5,-5,-5,-5,-5,-5,-3,-3,-3,-3,-3,-3,-1,-1,-1,-1,-1,-1,1,1,1,1,1,1,3,3,3,3,3,3,5,5,5,5,5,5)
shift_y <- c(5,3,1,-1,-3,-5,-5,-3,-1,1,3,5,5,3,1,-1,-3,-5,-5,-3,-1,1,3,5,5,3,1,-1,-3,-5,-5,-3,-1,1,3,5)

deg2rad <- function(deg) {(deg * pi) / (180)}

tree_position <-function(tree, plots) {
  plot = filter(plots, FID == as.character(tree$FID) & Plot == tree$Plot)

  x = plot$E + 
    (shift_x[tree$Tree] * cos(deg2rad(plot$Orintation))) + # x cos(deg)
    (shift_y[tree$Tree] * sin(deg2rad(plot$Orintation)))   # y sin(deg)
  y = plot$N + 
    (-1 * shift_x[tree$Tree] * sin(deg2rad(plot$Orintation))) + # -x cos(deg)
    (shift_y[tree$Tree] * cos(deg2rad(plot$Orintation)))
  
  return(c(N = as.numeric(y), E = as.numeric(x), Zone = as.character(plot$Zone)))
}
