library(openWAR)
library(openWARData)
library(dplyr)
################################################################
#       2014 Major League Baseball 
#       Opening Day: March 22nd
#       Last Game: September 28th
################################################################

data("MLBAM2014") # load data from 2014

ds <- makeWAR(MLBAM2014) # make 2014 WAR
openWARPlays2014 <- ds$openWAR # select the plays from 2015
oWAR14 <- getWAR(openWARPlays2014) # tabulate the WAR for each player

# melt oWAR to find main position
position <- reshape2::melt(oWAR14[,c(1,15,17,19,21,23,25,27,29,31)], id="playerId")
position <- filter(position, value != 0)
position <- position %>%
  group_by(playerId) %>%
  filter(value == max(value))

# read dh playerId csv
dh <- read.csv("data/dh_id.csv") %>%
  filter(year == 2014)
dh <- unlist(dh[1])

id <- read.csv("data/mlb_playerId.csv") # read playerIds 

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

oWAR14 <- merge(oWAR14, position[,1:2], by="playerId")

oWAR14 <- oWAR14[, c(1, 41, 2, 12:13, 33:36, 38:39)] # subset to columns we want
oWAR14 <- merge(id[,1:2], oWAR14, by = "playerId") # merge id and oWAR for player names

# round columns
oWAR14[, 6:12] <- round(oWAR14[, 6:12], 1)
colnames(oWAR14)[1:11] <- c("playerID", "Name", "Position", "PA", "BF", "Pitching", "Base Running", 
                          "Offense", "Defense", "RAA", "Replacement")

oWAR14 <- oWAR14[order(desc(oWAR14$WAR)),]

saveRDS(oWAR14, "data/oWAR_14.rds")
