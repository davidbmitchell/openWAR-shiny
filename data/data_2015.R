library(openWAR)
library(dplyr)
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
oWAR <- getWAR(openWARPlays2015)

# melt oWAR to find main position
position <- reshape2::melt(oWAR[,c(1,15,17,19,21,23,25,27,29,31)], id="playerId")
position <- filter(position, value != 0)
position <- position %>%
  group_by(playerId) %>%
  filter(value == max(value))

# read the mlb_playerId_15 csv into a data frame
id <- read.csv("data/mlb_playerId_15.csv", stringsAsFactors = FALSE)

# single out DH
dh <- unlist(filter(id, position == "DH")[1])

# change variables to position
position$variable <- as.character(position$variable)
position$variable <- with(position, ifelse(variable == "PA.P", "P", variable))
position$variable <- with(position, ifelse(variable == "PA.C", "C", variable))
position$variable <- with(position, ifelse(variable == "PA.1B", "1B", variable))
position$variable <- with(position, ifelse(variable == "PA.2B", "2B", variable))
position$variable <- with(position, ifelse(variable == "PA.SS", "SS", variable))
position$variable <- with(position, ifelse(variable == "PA.3B", "3B", variable))
position$variable <- with(position, ifelse(variable == "PA.LF", "LF", variable))
position$variable <- with(position, ifelse(variable == "PA.CF", "CF", variable))
position$variable <- with(position, ifelse(variable == "PA.RF", "RF", variable))
position$variable <- with(position, ifelse(playerId %in% dh, "DH", variable))

oWAR <- merge(oWAR, position[,1:2], by="playerId")

# subset oWAR to columns we want
oWAR <- oWAR[, c(1, 41, 2, 12:13, 33:36, 38:39)]

# merge id and oWAR for player names
oWAR <- merge(id[,1:2], oWAR, by = "playerId")

# round columns
oWAR[, 6:12] <- round(oWAR[, 6:12], 1)
colnames(oWAR)[1:11] <- c("playerID", "Name", "Position", "PA", "BF", "Pitching", "Base Running", 
                           "Offense", "Defense", "RAA", "Replacement")

# seperate by position players and pitchers
oWAR.pitcher <- subset(oWAR, oWAR$Position == "P")
oWAR.position <- subset(oWAR, oWAR$Position != "P")

saveRDS(oWAR, "data/oWAR_15.rds")
