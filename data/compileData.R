compileData <- function(oWAR, yr) {
  # melt oWAR data frame
  position <- reshape2::melt(oWAR[, c(1,15,17,19,21,23,25,27,29,31)], id="playerId")
  # filter out zeros
  position <- filter(position, value != 0)
  # group by playerId and find the poaition with most appearances
  position <- position %>%
    group_by(playerId) %>%
    filter(value == max(value))
  
  # account for players who main position is designated hitter
  dh <- read.csv("data/dh_id.csv") %>%
    filter(year == yr)
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
  
  oWAR <- merge(oWAR, position[,1:2], by="playerId")
  
  oWAR <- oWAR[, c(1, 41, 2, 12:13, 33:36, 38:39)] # subset to columns we want
  oWAR <- merge(id[,1:2], oWAR, by = "playerId") # merge id and oWAR for player names
  
  # round columns
  oWAR[, 6:12] <- round(oWAR[, 6:12], 1)
  colnames(oWAR)[1:11] <- c("playerID", "Name", "Position", "PA", "BF", "Pitching", "Base Running", 
                            "Offense", "Defense", "RAA", "Replacement")
  
  oWAR <- oWAR[order(desc(oWAR$WAR)),]
}