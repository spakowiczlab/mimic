
tumor.volumes <- read.csv("2022-05-09_mean-tumor-volumes.csv", stringsAsFactors = F)

getPallete <- colorRampPalette(brewer.pal(8, "Dark2"))

plotDesiredGroups <- function(radselected){
  tmp.plot <- tumor.volumes %>%
    filter(treatment.group %in% radselected) %>%
    ggplot(aes(x = days.from.injection, y = mean.volume, group = treatment.group, color = treatment.group)) +
    geom_line(position = position_dodge(width = .5), lwd = 1.3)+
    geom_point(position = position_dodge(width = .5))+
    labs(title = "Tumor Volume vs. Time for Mimic", x = "Days from Tumor Injection", y = "Mean tumor volume") +
    theme_bw() +
    scale_color_manual(breaks = radselected, values = getPallete(length(radselected)),
                       name = "Treatment group") +
    geom_errorbar(aes(ymin = lwr, ymax = upr),
                  width = 0.3,
                  position = position_dodge(width = .5),
                  lwd = 1.3)
  return(tmp.plot)
}
