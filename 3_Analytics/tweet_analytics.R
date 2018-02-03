setwd("~/Documents/Sentiment/3_Analytics")
library("quanteda")
library("jsonlite")
library("wordcloud")
source("utils_part1.R")
source("utils_part2.R")
source("utils_part3.R")

dat <- fromJSON("../nltk_example/sampletweet.json")
head(dat)

##### Part 1: HASHTAG ANALYSIS ######
# 
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
head(dat)

# Do inner join to match filterout tweets with unnecessary hashtags
dat$hashtag_lower <- tolower(dat$hashtag)
dat <- merge(dat,absTFs, by="hashtag_lower")
head(dat)

# Plot wordcloud
if(require(RColorBrewer)){
  
  pal <- brewer.pal(6,"Dark2")
  pal <- pal[-(1)]
  # wordcloud(d$word,d$freq,c(8,.3),2,,TRUE,,.15,pal)
  
  #random colors
  # wordcloud(d$word,d$freq,c(8,.3),2,,TRUE,TRUE,.15,pal)
  wordcloud(absTFs$hashtag_lower,absTFs$TF_Abs,random.order = F,colors = pal)
} else {wordcloud(absTFs$hashtag_lower,absTFs$TF_Abs,random.order = F)}

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
library("igraph")
graphVars <- extract_graph_vars(dat)
toptweeters <- graphVars[[2]];  graphVars  <- graphVars[[1]][-4]
actors <- with(graphVars, c(User,Retweet_from))
actors <- actors[!duplicated(actors)]

## Network of top tweeters calculated above
names(graphVars) <- c("from","to","Count")
gr <- graph_from_data_frame(graphVars,T,actors)
plot(gr,edge.arrow.size=.5) # Someone please check whether the graph is correct!

##### Part 3: BASIC NLP ######
dat <- fromJSON("../nltk_example/sampletweet.json")
dat <- cleantweets(dat)
twCorpus <- corpus(dat,text_field = 'Tweet',docid_field = 'User')
summary(twCorpus)
# kwic(twCorpus, "vote")

tweetDFM <- dfm(twCorpus, remove = stopwords("english"), 
                stem = TRUE, remove_punct = TRUE,
                tolower=T)
summary(tweetDFM)
topfeatures(tweetDFM,20)

textplot_wordcloud(tweetDFM, min.freq = 10, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

tweetTFIDF <- tfidf(tweetDFM)
topfeat <- topfeatures(tweetTFIDF,ncol(tweetTFIDF))
topfeat <- topfeat[topfeat>quantile(topfeat,.9)]

tweetTFIDF <- as.data.frame(tweetTFIDF)
tweetTFIDF <- tweetTFIDF[colnames(tweetTFIDF)%in%names(topfeat)]

library(FactoMineR)
library(factoextra)

pca <- PCA(tweetTFIDF,graph = F)
fviz_eig(pca, addlabels = TRUE)

fviz_cos2(pca, choice = "var", axes = 1:2,top = 50)

fviz_pca_var(pca, col.var = "black")

fviz_pca_var(pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE # Avoid text overlapping
)

#### Explained variances w.r.t. dimensions
fviz_screeplot(pca, addlabels = TRUE)

#### Adding a threshold level for the plot
fviz_screeplot(ca) +
  geom_hline(yintercept=33.33, linetype=2, color="red")

#### Biplot that monitors the variances in both columns and rows
fviz_ca_biplot(ca, repel = TRUE)


#### Analysis for row variables
row <- get_ca_row(ca)
row$coord
row$contrib
row$cos2
