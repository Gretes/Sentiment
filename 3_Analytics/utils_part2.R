extract_graph_vars <- function(dat){
  # Extracts graph edges and vertices for popular tweeters I suppose
  
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
  list(graphVars,toptweeters)
}


library(ggplot2)

plot_theme_river <- function(pivot){
  
  
  clean_theme = theme(panel.background = element_blank(),
                      plot.title = element_text(size=20, face="bold", colour = "black"),
                      panel.border = element_rect(color = "black", linetype = "solid", fill = "transparent"),
                      axis.title.x = element_blank(),
                      axis.title = element_text(size=14, face="italic", colour = "black"),
                      axis.text = element_text(size=12, face="italic", colour = "black"),
                      axis.text.y = element_blank(),
                      legend.text = element_text(size=12, face="italic", colour = "black"),
                      panel.grid = element_blank()
  )
  
  #fill = scale_fill_manual(values=palette)
  
  legend = guides( fill = guide_legend(reverse=TRUE), color = guide_legend(reverse=TRUE))
  
  #lines = scale_colour_manual(values=palette)
  
  ribbons = geom_ribbon(aes(Date, ymin=Min, ymax=Max, group = Hashtag, color = Hashtag, fill = Hashtag))
  
  
  labels = labs(y = "Tweet Volume")
  ggplot(data = pivot) + ribbons + legend + labels
  #fill + lines ++ clean_theme 
  
}