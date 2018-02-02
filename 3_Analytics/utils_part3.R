cleandat <- function(dat){
  retweeteds <- dat[!is.na(dat$Retweet_from),]
  retweeteds$Tweet <- gsub("^RT.*:+?|http[s]*.+$|http[s]*.+\\s"," ",retweeteds$Tweet)
  retweeteds
}