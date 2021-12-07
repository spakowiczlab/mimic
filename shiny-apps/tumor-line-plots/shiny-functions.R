
key.caro <- read.csv("key_redcap-to-nutrient_curated.csv")
key.radio <- read.csv("key_radio-to-serv.csv")

longandjoin <- function(redout){
  red.tmp <- redout %>%
    gather(-subject_number, key = "redcap.label", value = "Selection") %>%
    mutate(Duration = ifelse(grepl("30d", redcap.label), "30d", "7d"),
           redcap.label = gsub("_.*", "", redcap.label),
           Selection = as.numeric(Selection)) %>%
    left_join(key.radio) %>%
    left_join(key.caro) %>%
    filter(!is.na(Selection))
    
    return(red.tmp)
}

calcCaroteneRaw <- function(red.long){
  caro.tmp <- red.long %>%
    mutate(g.serving = as.numeric(as.factor(g.serving)),
           Servings = ifelse(is.na(Servings), 0, Servings),
           ug.time = amount*Servings*g.serving/100)
  
  return(caro.tmp)
}

calcCaroteneSub <- function(redout){
  red.long.tmp <- longandjoin(redout)
  caro.raw <- calcCaroteneRaw(red.long.tmp)
  subvals.tmp <- caro.raw %>%
    group_by(subject_number, name, Duration) %>%
    summarise(ug.time = sum(ug.time, na.rm = TRUE)) %>%
    mutate(nuttime = paste0(name, "/", Duration)) %>%
    ungroup() %>%
    select(subject_number, nuttime, ug.time) %>%
    spread(key = "nuttime", value = "ug.time")
  
  return(subvals.tmp)
}


displayCaroSource <- function(redout){
  red.long.tmp <- longandjoin(redout)
  caro.raw <- calcCaroteneRaw(red.long.tmp) %>%
    filter(Duration == "30d" & Servings > 0) %>%
    group_by(name) %>%
    summarise(total = sum(ug.time)) %>%
    left_join(calcCaroteneRaw(red.long.tmp)) %>%
    filter(Duration == "30d" & Servings > 0) %>%
    mutate(ug.month.percent = ug.time/total)
  tmp.plot <- caro.raw %>%
    ggplot(aes(x = "", y = ug.month.percent, fill = Food)) +
    geom_bar(width = 1, stat = "identity", show.legend = FALSE) +
    facet_wrap(vars(name)) +
    coord_polar("y", start=0) +
    labs(x = "", y = "", title = "Food source of the carotenoids") +
    theme_bw() +
    theme(axis.text = element_blank(), axis.ticks = element_blank())
  return(tmp.plot)
}
