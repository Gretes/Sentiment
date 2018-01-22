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





