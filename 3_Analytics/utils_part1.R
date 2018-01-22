library("stringr")

# Extracts hashtags and calculates TFs
# The code has too much lapply's that iterates unnecessarily
extract_hashtags <- function(tweet_list){
  hashtags <- lapply(tweet_list, function(tw) str_extract_all(tw,'#\\w+',simplify = T))
  TFs      <- lapply(hashtags, function(hts) sapply(hts, function(h) 1/length(hts)))
  names(TFs) <- 1:length(TFs)
  TFs      <- unlist(TFs)
  hashtags <- data.frame(TFs, t(sapply(strsplit(names(TFs),"[.]"), function(tf) tf)))
  
  names(hashtags) <- c("TF","tweet_key","hashtag")
  hashtags
}



calculateAbsTFs <- function(hashtag_list){
  fd <- table(sapply(hashtag_list, tolower))
  fd <- data.frame(fd)
  colnames(fd) <- c('hashtag_lower','TF_Abs')
  fd           <- fd[order(fd[,2],decreasing = T),]
  fd
}

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


