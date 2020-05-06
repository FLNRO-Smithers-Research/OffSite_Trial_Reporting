# OffSite_Trial_Reporting
Scripts to show statistical and graphical output for species trial data

## Loading Data
All data is contained within the all_data data frame, data can be added to this directly, or alternatively can be done using the build data frame fuction.

The build data frame function will load all the csv files in the data directory, thies files have the following structure

### Seedlots
There is one file named seedlots.csv, additionall seedlots can be added by appending rows to this table.

### Metadata
The meta.csv file has a list of all the study site fid's date collected and the person who collected the data.

### Field Cards
For every fid in Metadata there should be a CSV with a corresponding name FID_<FID>.csv with the following attributes
FID, Tree, Plot, Species, Seedlot, Condition, Comment

### Plot
For every fid there should also be a file <FID>_plot.csv, plot files contain the geographic location of the site the contain the following feilds
FID: Site where plot is located
Plot: Plot number
Orientation: Rotation of the plot in degress relative to true north.
Lat, Lon: The position of tree 1 in the plot
Spacing: Distance in meters between trees planted
Height, Width: This determins the number of trees in the plot and makes the assumption that when planting rows go top-bottom, then bottom-top alternating while moving each row the distance of spacing to the right. 

### Climate Date
For every site there is a file <site>_climate.csv containing the following information
ClimateStationID,date,temp

## Functions
All functions are available within the Functions folder

### tree_position
This function is used by the data loader, and calculates tree position based on plot information

### plot_summary

plot_summary, this function takes in a list of trees and returns the survival rate for each plot, grouped by FID

treatment_summary, this function takes in a list of trees and returns the survival rate for each seedlot, grouped by species

treatment_summary, this function takes in a list of trees and returns the survival rate for each seedlot

species_summary, this function takes in a list of trees and returns the survival rate for each species across all trials

condition_by_trial, this function takes a list of trees and returns the survival rate for each site FID

### Temperature

#### temperature_summary
This function returns a summary table including how many times the threshold was crossed, for how long, and the magnitude (maximum degrees below threshold), resutls are grouped by climate station_id
Arguments:
climate (mandatory): list of climate data
threshold (mandatory): degree C of threshold. *Most likely you want 0
threshold2 (optional): if set function will calculate 2 thresholds (ie for hard frost), note that adding this variable function returns a larger data frame
start (optional): used to filter start time to search for events, if left blank defaults to unix epoch (Jan 1, 1970), if you have older data do not leave blank!
end (optional): used to filter end time for summary produces, if left black defaults to unix epoch +1000 years (Jan 1, 2970)

#### temperature_event
This function returns a list of events below threshold the date they happend, and for how long
Arguments:
climate (mandatory): list of climate data
threshold (mandatory): degree C of threshold. *Most likely you want 0
start (optional): used to filter start time to search for events, if left blank defaults to unix epoch (Jan 1, 1970), if you have older data do not leave blank!
end (optional): used to filter end time for summary produces, if left black defaults to unix epoch +1000 years (Jan 1, 2970)

### find_events
This is a helper function, and should not be called directly