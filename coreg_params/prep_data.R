dir = "~/Documents/Projects/Adolescent Psychosis Coreg/"
setwd(dir)

# Set up fx ---------------------------------------------------------------


library(tidyverse)


interpolateIBI <- function(ibi_couple, freqHz=10) {
  #figure min and max times for ibi and behavior to create common time grid
  l_ibi <- dplyr::select(ibi_couple, Dyad_ID, Child_ID, CHR, Segment, Child_IBI, Second) %>% rename(ibi = Child_IBI, time = Second) %>% mutate(time = time*1000) #l = child
  r_ibi <- dplyr::select(ibi_couple, Dyad_ID, Caregiver_ID, CHR, Segment, Caregiver_IBI, Second) %>% rename(ibi = Caregiver_IBI, time = Second) %>% mutate(time = time*1000)#r = parent
  
  xoutmin <- max(min(l_ibi$time), min(r_ibi$time))
  xoutmax <- min(max(l_ibi$time), max(r_ibi$time))
  
  gridstep <- 1/freqHz *  1000
  interp_time_grid <- seq(xoutmin, xoutmax, by=gridstep) #100ms increment
  
  #have 6 time series to resample onto grid (could probably functionalize this, but happy just to repeat...)
  l_ibi_interp <- spline(x=l_ibi$time, y=l_ibi$ibi, xout=interp_time_grid, method="fmm")$y
  r_ibi_interp <- spline(x=r_ibi$time, y=r_ibi$ibi, xout=interp_time_grid, method="fmm")$y
  
  interpdf <- data.frame(Dyad_ID=ibi_couple$Dyad_ID[1], ms=interp_time_grid, l_ibi_interp, r_ibi_interp)
  
  #linear detrend of all time series
  detrend <- as.data.frame(lapply(interpdf[,grep("interp", names(interpdf), value=TRUE)], function(x) {
    lin <- 1:length(x)
    residuals(lm(x ~ 1 + lin))
  } ))
  names(detrend) <- paste(names(detrend), "detrend", sep="_")
  interpdf <- cbind(interpdf, detrend)
  return(interpdf)
}

# Load in data ------------------------------------------------------------



raw_data <- read_csv("raw_data/IBI_Linkage_Windows5TO50_Leads1To4.csv")
raw_data <- dplyr::select(raw_data, -`...1`, -X)

sample_dyad_neg_int <- dplyr::filter(raw_data, Dyad_ID == 1002, Segment ==8)

sample_dyad_neg_int_interp_detrend <- interpolateIBI(sample_dyad_neg_int)

## Scale up and graph all interpolated and detrended dyads



wrapper <- function(Dyad_ID, Segment, freqHz = 10) {
  tmp_df <- dplyr::filter(raw_data, Dyad_ID == !!Dyad_ID, Segment == !!Segment)
  
  out_df <- interpolateIBI(tmp_df)
  out_df <- rename(out_df, child_ibi_interp = l_ibi_interp,
                   caregiver_ibi_interp = r_ibi_interp,
                   child_ibi_interp_detrend = l_ibi_interp_detrend,
                   caregiver_ibi_interp_detrend = r_ibi_interp_detrend)
  print(paste0(Dyad_ID))
  return(out_df)
}

dyad_IDs <- unique(raw_data$Dyad_ID)
segment = 8

torun = expand.grid(Dyad_ID = dyad_IDs, Segment = segment)
# Don't include 1030 or 2004 or 2037 or 10252 due to missing data

torun <- dplyr::filter(torun, !Dyad_ID %in% c(1030 , 2004, 2037, 10252))
combined_interp_df <- plyr::mdply(torun, wrapper)
write_csv(combined_interp_df, "processed_data/negint_ibis_interp_19Dec2023.csv")
for_graphing <- combined_interp_df %>% dplyr::select(Dyad_ID, ms, child_ibi_interp_detrend, caregiver_ibi_interp_detrend) %>% gather(key = "key", value = "value", child_ibi_interp_detrend, caregiver_ibi_interp_detrend)
ids = unique(for_graphing$Dyad_ID)
pdf("figures/descriptive/Overplotted negint ibi time series by dyad 19Dec2023.pdf", width = 7, height = 5)
for(i in ids) {
  for_graphing_tmp <- dplyr::filter(for_graphing, Dyad_ID == !!i) %>% mutate(role = if_else(key == "child_ibi_interp_detrend", "Child", "Caregiver"),time = ms/1000)
  plot(ggplot(for_graphing_tmp, aes(x = time, y = value, color = role)) + geom_line(size = .8) + xlab("Time (s)") + ylab("IBI") + ggtitle(paste0("Negint: ",i)) + theme_bw() + theme(legend.position = "bottom"))
  
}
dev.off()

# 1009 candidate for coreg analyses

library(dplyr)
basedir <- "~/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/negint_ibis/"
interp_df_1009 <- dplyr::filter(combined_interp_df, Dyad_ID == 1009)
export_ibis <- function(couple) {
  couple$time <- couple$ms / 1000
  write.table(file=file.path(basedir, paste0(couple$Dyad_ID[1], "_ibis.txt")), couple[,c("Dyad_ID", "ms", "child_ibi_interp_detrend", "caregiver_ibi_interp_detrend")],
              row.names=FALSE, col.names=FALSE)
}

##export_ibis(interp_df_1009)

## Get rid of people who need to be further cleaned
## 1034 still looks bad

#bad_ids <- c(1034)
setwd(basedir)
#torun_ids = dplyr::filter(torun, !Dyad_ID %in% bad_ids)
torun_ids = torun

torun_ids_vec <- as.vector(torun_ids$Dyad_ID)
export_ibi_wrapper <- function(id) {
  tmp_df <- dplyr::filter(combined_interp_df, Dyad_ID == !!id)
  export_ibis(tmp_df)
}
lapply(torun_ids_vec, export_ibi_wrapper)


# Posint  -----------------------------------------------------------------
setwd(dir)
dyad_IDs <- unique(raw_data$Dyad_ID)
segment = 12

torun = expand.grid(Dyad_ID = dyad_IDs, Segment = segment)

## 1030, 2004, 2037, 10252 missing
torun <- dplyr::filter(torun, !Dyad_ID %in% c(1030 , 2004, 2037, 10252))
combined_posint_interp_df <- plyr::mdply(torun, wrapper)
write_csv(combined_posint_interp_df, "processed_data/posint_ibis_interp_19Dec2023.csv")

for_graphing <- combined_posint_interp_df %>% dplyr::select(Dyad_ID, ms, child_ibi_interp_detrend, caregiver_ibi_interp_detrend) %>% gather(key = "key", value = "value", child_ibi_interp_detrend, caregiver_ibi_interp_detrend)
ids = unique(for_graphing$Dyad_ID)
pdf("figures/descriptive/Overplotted posint ibi time series by dyad 19Dec2023.pdf", width = 7, height = 5)
for(i in ids) {
  for_graphing_tmp <- dplyr::filter(for_graphing, Dyad_ID == !!i) %>% mutate(role = if_else(key == "child_ibi_interp_detrend", "Child", "Caregiver"),time = ms/1000)
  plot(ggplot(for_graphing_tmp, aes(x = time, y = value, color = role)) + geom_line(size = .8) + xlab("Time (s)") + ylab("IBI") + ggtitle(paste0("Pos Int:", i)) + theme_bw() + theme(legend.position = "bottom"))
  
}
dev.off()

# For coreg analyses, omit 1004 (very large IBIs) 
# Keep an eye out on 1007 (very low variability in caregiver), 1034 as there are some extremes
basedir <- "~/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/posint_ibis/"
#bad_ids <- c(1004)

#torun_ids = dplyr::filter(torun, !Dyad_ID %in% bad_ids)
## 1034 in pos and neg still looks bad -- see how fares in coreg analysees
setwd(basedir)
torun_ids = torun
torun_ids_vec <- as.vector(torun_ids$Dyad_ID)
export_ibi_wrapper <- function(id) {
  tmp_df <- dplyr::filter(combined_posint_interp_df, Dyad_ID == !!id)
  export_ibis(tmp_df)
}
lapply(torun_ids_vec, export_ibi_wrapper)


# Neutral interaction -----------------------------------------------------
setwd(dir)

dyad_IDs <- unique(raw_data$Dyad_ID)
segment = 4

torun = expand.grid(Dyad_ID = dyad_IDs, Segment = segment)

## 1030, 2004, 2037, 10252 missing
torun <- dplyr::filter(torun, !Dyad_ID %in% c(1030, 2019, 2037, 10252))
combined_neuint_interp_df <- plyr::mdply(torun, wrapper)
write_csv(combined_neuint_interp_df, "processed_data/neuint_ibis_interp 19Dec2023.csv")

for_graphing <- combined_neuint_interp_df %>% dplyr::select(Dyad_ID, ms, child_ibi_interp_detrend, caregiver_ibi_interp_detrend) %>% gather(key = "key", value = "value", child_ibi_interp_detrend, caregiver_ibi_interp_detrend)
ids = unique(for_graphing$Dyad_ID)
pdf("figures/descriptive/Overplotted neu ibi time series by dyad 19Dec2023.pdf", width = 7, height = 5)
for(i in ids) {
  for_graphing_tmp <- dplyr::filter(for_graphing, Dyad_ID == !!i) %>% mutate(role = if_else(key == "child_ibi_interp_detrend", "Child", "Caregiver"),time = ms/1000)
  plot(ggplot(for_graphing_tmp, aes(x = time, y = value, color = role)) + geom_line(size = .8) + xlab("Time (s)") + ylab("IBI") + ggtitle(paste0("Neu Int: ", i)) + theme_bw() + theme(legend.position = "bottom"))
  
}
dev.off()

basedir <- "~/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/neuint_ibis/"
setwd(basedir)

# 1034 still has issues
## 1035 must be excluded
bad_ids <- c(1035) ##, 1002, 1013, 2020, 2023, 2027)

torun_ids = dplyr::filter(torun, !Dyad_ID %in% bad_ids)
torun_ids_vec <- as.vector(torun_ids$Dyad_ID)
export_ibi_wrapper <- function(id) {
  tmp_df <- dplyr::filter(combined_neuint_interp_df, Dyad_ID == !!id)
  export_ibis(tmp_df)
}
lapply(torun_ids_vec, export_ibi_wrapper)


