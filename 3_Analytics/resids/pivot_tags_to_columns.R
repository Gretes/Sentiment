pivot_tags_to_columns <- function(dat){
  dat$Date <- as.Date(substr(dat$Time,1,10))
  htags    <- dat$hashtag_lower[!duplicated(dat$hashtag_lower)] 
  counts   <- lapply(htags, function(ht) aggregate(hashtag_lower ~ Date, subset(dat, hashtag_lower == ht), NROW))
  dates    <- unlist(lapply(counts, function(c) as.character(c$Date)))
  dates    <- sort(as.Date(dates[!duplicated(dates)]))
  
  counts   <- sapply(counts, function(c) c$hashtag_lower[match(dates,c$Date)])
  rownames(counts) <- as.character(dates)
  colnames(counts) <- htags
  counts
}
