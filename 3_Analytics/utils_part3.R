cleantweets <- function(dat){
  retweeteds <- dat[!is.na(dat$Retweet_from),]
  retweeteds <- retweeteds[!duplicated(retweeteds$Tweet),]
  retweeteds$Tweet <- gsub("#[^\\s]+","",gsub("^RT.*:+?|http[s]*.+$|http[s]*.+\\s"," ",retweeteds$Tweet))
  retweeteds$Tweet <- gsub("\\s\\S\\s|^\\S\\s|\\s\\S$"," ",gsub("\\s[0-9]+\\s"," ",retweeteds$Tweet))
  # hashtags <- lapply(tweet_list, function(tw) str_extract_all(tw,'#\\w+',simplify = T))
  retweeteds
}
