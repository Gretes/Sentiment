setwd("~/Documents/Sentiment/analytics")
library("quanteda")
library("jsonlite")
dat <-jsonlite::fromJSON("nltk_example/sampletweet.json")

##### Part 1: HASHTAG ANALYSIS ######
# Extract hashtags and calculate their TFs
hashtags <- extract_hashtags(dat$Tweet)
head(hashtags)

# Calculate Absolute TFs for each hashtag
absTFs <- calculateAbsTFs(hashtags$hashtag)
absTFs <- absTFs[absTFs$`TF_Abs` >= quantile(absTFs$`TF_Abs`,.99),]

# remove outlier (FIND a better way to do this)
absTFs <- absTFs[-1,]

# Do inner join to match relative TFs of hashtags with the tweets
dat$tweet_key <- as.numeric(rownames(dat))
dat <- merge(dat,hashtags, by="tweet_key")

# Do inner join to match filterout tweets with unnecessary hashtags

dat$hashtag_lower <- tolower(dat$hashtag)
dat <- merge(dat,absTFs, by="hashtag_lower")

# Plot wordcloud
wordcloud::wordcloud(absTFs$hashtag_lower,absTFs$TF_Abs)

# Pivot tags to columns
pivot <- pivot_tags_to_columns(dat)

maxs  <- t(apply(pivot, 1, function(r) {r[is.na(r)] <- 0; cumsum(r)}))
mins  <- t(apply(maxs,  1, function(r) c(r[1], head(r,-1))))

library(reshape2)
mins <- melt(mins)
maxs <- melt(maxs)
pivot <- cbind(mins,maxs)
pivot <- pivot[,c(-4,-5)]
colnames(pivot) <- c("Date","Hashtag","Min","Max")

# Plot Theme River for hashtags 
# (THE CODE IS COPIED, WE NEED TO CHANGE DUE TO COPYRIGHT ISSUES!!!)
plot_theme_river(pivot)

##### Part 2: BASIC INFLUENCER ANALYSIS ######
graphVars <- extract_graph_vars(dat)[-4]
actors <- with(graphVars, c(User,Retweet_from))
actors <- actors[!duplicated(actors)]

names(graphVars) <- c("from","to","Count")
gr <- graph_from_data_frame(graphVars,T,actors)
plot(gr) # Someone please check whether the graph is correct!


