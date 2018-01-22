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