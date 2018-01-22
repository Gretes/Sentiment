# Extracts graph edges and vertices for popular tweeters I suppose
extract_graph_vars <- function(dat){
  
  # Graph Edge and Vertices
  retweeteds <- dat[!is.na(dat$Retweet_from),]
  retweeteds <- retweeteds[,names(retweeteds) %in% c('Time','Retweet_from','User')]
  graphVars <- aggregate(Time ~ Retweet_from + User, retweeteds, NROW)
  
  # Top Tweeters
  # Extracts Top Tweeters (that is the users who retweets popular tweets, I suppose)
  toptweeters <- dat[,names(dat) %in% c('Retweeted','User')]
  toptweeters <- aggregate(Retweeted ~ User, toptweeters,sum)
  toptweeters <- toptweeters[order(toptweeters$Retweeted,decreasing = T),]
  toptweeters <- toptweeters[1:40,] # Top 40 but WHY???
  
  graphVars   <- merge(graphVars,toptweeters,by="User")
  colnames(graphVars)[3] <- "Count"
  graphVars
}