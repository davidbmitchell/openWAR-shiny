library(openWAR)
library(openWARData)
library(dplyr)
source("data/compileData.R")
################################################################
#       2013 Major League Baseball 
#       Opening Day: March 31st
#       Last Game: September 30th
################################################################

ds <- makeWAR(MLBAM2013) # MLBAM2013 loaded from openWARData
openWARPlays2013 <- ds$openWAR # select the plays from 2014
oWAR13 <- getWAR(openWARPlays2013)

oWAR13 <- compileData(oWAR13, 2013)

################################################################
#       2014 Major League Baseball 
#       Opening Day: March 22nd
#       Last Game: September 28th
################################################################

ds <- makeWAR(MLBAM2014) # MLBAM2014 loaded from openWARData
openWARPlays2014 <- ds$openWAR # select the plays from 2014
oWAR14 <- getWAR(openWARPlays2014) # tabulate the WAR for each player

oWAR14 <- compileData(oWAR14, 2014)
saveRDS(oWAR14, "data/oWAR_14.rds")

################################################################
#       2015 Major League Baseball 
#       Opening Day: April 5th
#       Last Game: October 4th
################################################################

# grab data from opening day to end of season
mlbam2015 <- getData(start = "2015-04-05", end = "2015-10-04")
# use makeWAR()
ds <- makeWAR(mlbam2015)
# select the plays from 2015
openWARPlays2015 <- ds$openWAR
# tabulate the WAR for each player
oWAR15 <- getWAR(openWARPlays2015)

oWAR15 <- compileData(oWAR15, 2015)

saveRDS(oWAR, "data/oWAR_15.rds")


