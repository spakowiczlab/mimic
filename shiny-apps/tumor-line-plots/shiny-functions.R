
tumor.volumes <- read.csv("mean-tumor-volumes.csv", stringsAsFactors = F)

getPallete <- colorRampPalette(brewer.pal(8, "Dark2"))

plotDesiredGroups <- function(radselected){
  tmp.plot <- tumor.volumes %>%
    filter(treatment.group %in% radselected) %>%
    ggplot(aes(x = time.point, y = mean.volume, group = treatment.group, color = treatment.group)) +
    geom_line(position = position_dodge(width = .5))+
    geom_point(position = position_dodge(width = .5))+
    labs(title = "Tumor Volume vs. Time for Mimic", x = "Time point", y = "Mean tumor volume") +
    theme_bw() +
    scale_color_manual(breaks = radselected, values = getPallete(length(radselected)),
                       name = "Treatment group") +
    geom_errorbar(aes(ymin = lwr, ymax = upr),
                  width = 1,
                  position = position_dodge(width = .5))
  return(tmp.plot)
}
