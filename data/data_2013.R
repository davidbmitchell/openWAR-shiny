library(openWAR)
library(openWARData)
library(dplyr)
################################################################
#       2014 Major League Baseball 
#       Opening Day: March 31st
#       Last Game: September 30th
################################################################

ds <- makeWAR(MLBAM2013) # make 2014 WAR
openWARPlays2013 <- ds$openWAR # select the plays from 2015
oWAR13 <- getWAR(openWARPlays2013) # tabulate the WAR for each player

position <- reshape2::melt(oWAR13[,c(1,15,17,19,21,23,25,27,29,31)], id="playerId")
position <- filter(position, value != 0)
position <- position %>%
  group_by(playerId) %>%
  filter(value == max(value))

# read dh playerId csv
dh <- read.csv("data/dh_id.csv") %>%
  filter(year == 2013)
dh <- unlist(dh[1])

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

oWAR13 <- merge(oWAR13, position[,1:2], by="playerId")
oWAR13 <- oWAR13[, c(1, 41, 2, 12:13, 33:36, 38:39)] # subset to columns we want
oWAR13 <- merge(id[,1:2], oWAR13, by = "playerId") # merge id and oWAR for player names

# round columns
oWAR13[, 6:12] <- round(oWAR13[, 6:12], 1)
colnames(oWAR13)[1:11] <- c("playerID", "Name", "Position", "PA", "BF", "Pitching", "Base Running", 
                            "Offense", "Defense", "RAA", "Replacement")

oWAR13 <- oWAR13[order(desc(oWAR13$WAR)),]

saveRDS(oWAR13, "data/oWAR_13.rds")
