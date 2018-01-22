
calculateAbsTFs <- function(hashtag_list){
  fd <- table(sapply(hashtag_list, tolower))
  fd <- data.frame(fd)
  colnames(fd) <- c('hashtag_lower','TF_Abs')
  fd           <- fd[order(fd[,2],decreasing = T),]
  fd
}