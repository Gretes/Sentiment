library(quanteda)
summary(data_char_ukimmig2010)

myCorpus <- corpus(data_char_ukimmig2010)
summary(myCorpus)

metadoc(myCorpus, "language") <- "english"
metadoc(myCorpus, "docsource")  <- paste("data_char_ukimmig2010", 1:ndoc(myCorpus), sep = "_")

summary(myCorpus,showmeta=T)




mongo <- mongoDbConnect("heroku_wzpvdrhs","mongodb://veli:kamil7insan@ds237445.mlab.com", 37445)
mongo <- mongoDbReplicaSetConnect("heroku_wzpvdrhs", "mongodb://veli:kamil7insan@ds237445.mlab.com:37445")

