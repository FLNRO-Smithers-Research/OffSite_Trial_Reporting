library(dplyr)
require(rgdal)
#Work in Progress

deg2rad <- function(deg) {(deg * pi) / (180)}

#This function assumes that Coordinates in plots are based on tree 1
#Orientation is the degrees clockwise plot is from having tree one in North-West Corner
tree_position <-function(tree, plots) {
  plot = filter(plots, FID == as.character(tree$FID) & Plot == tree$Plot)
  if(is.null(plot)){
    return(c(Lat = 0, Lon = 0))
  }
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
  
  cord = SpatialPoints(cbind(plot$Lon, plot$Lat), proj4string = CRS("+proj=longlat"))
  UTM = spTransform(cord, CRS("+init=epsg:32610"))
 
  rot_x = as.numeric(UTM[1,]$coords.x1) + x * cos(rad) + y * sin(rad)
  rot_y = as.numeric(UTM[1,]$coords.x2) + -1 * x * sin(rad) + y * cos(rad)
  tree_coord = SpatialPoints(cbind(rot_x, rot_y), proj4string = CRS("+proj=utm +zone=10 +north +datum=WGS84 +units=m +no_defs"))
  print(tree_coord)
  tree_degrees = spTransform(tree_coord, CRS("+init=epsg:4326"))
  return(c(Lat = as.numeric(tree_degrees[1,]$rot_x), Lon = as.numeric(tree_degrees[1,]$rot_y)))
}




