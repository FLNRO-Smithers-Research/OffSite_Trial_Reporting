library(dplyr)
#Work in Progress

deg2rad <- function(deg) {(deg * pi) / (180)}

#This function assumes that Coordinates in plots are based on tree 1
#Orientation is the degrees clockwise plot is from having tree one in North-West Corner
tree_position <-function(tree, plots) {
  plot = filter(plots, FID == as.character(tree$FID) & Plot == tree$Plot)
  t = tree$Tree
  w = plot$Width
  h = plot$Height
  s = plot$Spacing
  rev = ((t-1) %/% h) %% 2
  x = ((t-1) %/% w) * s
  pre_y = ((t-1) %% h) * s# Y before reversal for bee-line
  y = pre_y + rev * ((h-(2* pre_y)) + s^2)
  deg = plot$Orientation
  rad = deg2rad(deg)
  
  rot_x = plot$E + x * cos(rad) + y * sin(rad)
  rot_y = plot$N + -1 * x * sin(rad) + y * cos(rad)
  return(c(N = as.numeric(rot_y), E = as.numeric(rot_x), Zone = as.character(plot$Zone)))
}




