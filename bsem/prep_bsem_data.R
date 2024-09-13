library(tidyverse)
setwd("~/Documents/Projects/Adolescent Psychosis Coreg/")
compiled_df = read_csv("processed_data/coreg_params_across_pipelines.csv")

omit_info = compiled_df %>% dplyr::select(Dyad_ID, cond) %>% distinct()
omit_info = mutate(omit_info, omit = case_when(Dyad_ID == 1005 & cond == "neg" ~ 1, # very low HRV in caregiver/poorly fit
                                               Dyad_ID == 1005 & cond == "neu" ~ 1, # very low HRV in caregiver/poorly fit (note that in pos interaction still low HRV in caregier, but model able to fit)
                                               Dyad_ID == 1007 & cond == "neg" ~ 1, # very low HRV in caregiver/poorly fit (note that in other interactions, also low HRV but model able to fit)
                                               Dyad_ID== 1010 & cond == "neu" ~ 1, # model couldn't fit (across every version)
                                               Dyad_ID == 2001 & cond == "neg" ~ 1, # model couldn't fit, by eye very low HRV in caregiver
                                               Dyad_ID == 2001 & cond == "pos" ~ 1, # model couldn't fit across the board, by eye very low HRV in caregiver
                                               Dyad_ID == 20212 & cond == "pos" ~ 1, # very high variability subject just not able to be fit well
                                               Dyad_ID == 2038 & cond  == "neg" ~ 1, # in general pretty low variability across both subjects
                                               Dyad_ID == 2001 & cond == "neu" ~ 1, # doens't fit well 
                                               # looked through medication log, and generally not enough information about medications taken to detmerine if that's what's going on. 
                                               TRUE ~ 0),
                   ld_sens = case_when(Dyad_ID == 1010 & cond == "neg" ~ 1,
                                       Dyad_ID == 1011 & cond == "neg" ~ 1,
                                       Dyad_ID == 1014 & cond == "pos" ~ 1, 
                                       Dyad_ID == 1018 & cond == "pos" ~ 1,
                                       Dyad_ID == 1018 & cond == "neg" ~ 1,
                                       Dyad_ID== 1031 & cond == "neu" ~ 1,
                                       Dyad_ID == 1031 & cond == "pos" ~ 1,
                                       Dyad_ID == 1041 & cond == "pos" ~1,
                                       Dyad_ID == 2011 & cond == "pos" ~ 1,
                                       Dyad_ID == 20172 & cond == "pos" ~ 1,
                                       Dyad_ID == 2021 & cond == "neg" ~ 1,
                                       Dyad_ID == 2029 & cond == "neu" ~ 1,
                                       Dyad_ID == 2039 & cond == "neu" ~ 1,
                                       Dyad_ID == 2040 & cond == "pos" ~ 1,
                                       
                                       TRUE ~ 0),
                   subj_sens = case_when(Dyad_ID == 2015 & cond == "neg" ~ 1,
                                         Dyad_ID == 2017 & cond == "pos" ~ 1,
                                         Dyad_ID == 2021 & cond == "neu" ~ 1,
                                         Dyad_ID == 2027 & cond == "neu"~ 1, 
                                         
                                         Dyad_ID == 1016 ~ 1, # subject listed as no longer pt on pdata df
                                         TRUE ~ 0),
                   isYout_sens = case_when(
                     
                     Dyad_ID == 1034 & cond == "neg" ~ 1,
                     Dyad_ID == 1034 & cond == "neu" ~ 1,
                     Dyad_ID == 2035 & cond == "neg" ~ 1,
                     Dyad_ID == 2047 & cond == "neu" ~ 1,
                     TRUE ~ 0
                   ))
compiled_df = left_join(compiled_df, omit_info)
compiled_df = mutate(compiled_df, Dyad_ID = if_else(Dyad_ID == 2029, 20291, Dyad_ID)) # rename
#pdata_df = read_csv("raw_data/pdata_df.csv")
pdata_df <- read_csv("raw_data/pdata_df_updated_w_latest_eia.csv")
# addition from trevor
risk_scores <- read_csv("~/Downloads/dyad_sharp_rc.csv") %>% dplyr::select(-`...1`)
risk_scores <- rename(risk_scores, Dyad_ID= `Dyad ID`) %>% mutate(Dyad_ID = gsub("_", "", Dyad_ID), Dyad_ID = as.numeric(Dyad_ID), Dyad_ID = if_else(Dyad_ID == 20291, 2029, Dyad_ID)) # 20291 -> 2029 in our data
risk_scores <- rename(risk_scores, risk = sharp_rc_score)
compiled_df = left_join(compiled_df, pdata_df)
compiled_df = left_join(compiled_df, risk_scores)

compiled_df = dplyr::filter(compiled_df, omit ==0)


compiled_df = mutate(compiled_df, CHR_fac = if_else(CHR == 1, "High", "Low"))
neg_df = compiled_df %>% dplyr::filter(isYout == "N", latest_data == 1, cond == "neg") %>% dplyr::mutate(child_sc = 100*child_sc, child_cc = child_cc*100, caregiver_sc = caregiver_sc*100, caregiver_cc = caregiver_cc*100)# N = 66
neu_df = compiled_df %>% dplyr::filter(isYout == "N", latest_data == 1, cond == "neu") %>% dplyr::mutate(child_sc = 100*child_sc, child_cc = child_cc*100, caregiver_sc = caregiver_sc*100, caregiver_cc = caregiver_cc*100)# N = 66
pos_df = compiled_df %>% dplyr::filter(isYout == "N", latest_data == 1, cond == "pos") %>% dplyr::mutate(child_sc = 100*child_sc, child_cc = child_cc*100, caregiver_sc = caregiver_sc*100, caregiver_cc = caregiver_cc*100)# N = 68



# ca_ for caregiver ch_ child


scale_this <- function(x){
  (x - mean(x, na.rm=TRUE)) / sd(x, na.rm=TRUE)
}
neg_int = mutate(neg_df, Y_SIPS_PosTotal = scale_this(Y_SIPS_PosTotal),
                        Y_SIPS_NegTotal = scale_this(Y_SIPS_NegTotal),
                        Y_SIPS_Dtotal = scale_this(Y_SIPS_Dtotal),
                        Y_BDI_total = scale_this(Y_BDI_total),
                        Y_BAI_total = scale_this(Y_BAI_total),
                        child_age = scale_this(child_age), 
                 risk = scale_this(risk),
                        CHR_x_Y_SIPS_PosTotal = CHR*Y_SIPS_PosTotal,
                        CHR_x_Y_SIPS_NegTotal = CHR*Y_SIPS_NegTotal,
                        CHR_x_Y_SIPS_Dtotal  = CHR*Y_SIPS_Dtotal,
                        CHR_x_Y_BDI_total = CHR*Y_BDI_total,
                        CHR_x_Y_BAI_total = CHR*Y_BAI_total)

pos_int = mutate(pos_df, Y_SIPS_PosTotal = scale_this(Y_SIPS_PosTotal),
                        Y_SIPS_NegTotal = scale_this(Y_SIPS_NegTotal),
                        Y_SIPS_Dtotal = scale_this(Y_SIPS_Dtotal),
                        Y_BDI_total = scale_this(Y_BDI_total),
                        Y_BAI_total = scale_this(Y_BAI_total),
                        child_age = scale_this(child_age),
                 risk = scale_this(risk),
                        CHR_x_Y_SIPS_PosTotal = CHR*Y_SIPS_PosTotal,
                        CHR_x_Y_SIPS_NegTotal = CHR*Y_SIPS_NegTotal,
                        CHR_x_Y_SIPS_Dtotal  = CHR*Y_SIPS_Dtotal,
                        CHR_x_Y_BDI_total = CHR*Y_BDI_total,
                        CHR_x_Y_BAI_total = CHR*Y_BAI_total)

neu_int = mutate(neu_df, Y_SIPS_PosTotal = scale_this(Y_SIPS_PosTotal),
                        Y_SIPS_NegTotal = scale_this(Y_SIPS_NegTotal),
                        Y_SIPS_Dtotal = scale_this(Y_SIPS_Dtotal),
                        Y_BDI_total = scale_this(Y_BDI_total),
                        Y_BAI_total = scale_this(Y_BAI_total),
                        child_age = scale_this(child_age),
                 risk = scale_this(risk),
                        CHR_x_Y_SIPS_PosTotal = CHR*Y_SIPS_PosTotal,
                        CHR_x_Y_SIPS_NegTotal = CHR*Y_SIPS_NegTotal,
                        CHR_x_Y_SIPS_Dtotal  = CHR*Y_SIPS_Dtotal,
                        CHR_x_Y_BDI_total = CHR*Y_BDI_total,
                        CHR_x_Y_BAI_total = CHR*Y_BAI_total)



neg_df = rename(neg_df, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac) %>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)
neu_df = rename(neu_df, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac)%>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)

pos_df = rename(pos_df, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac)%>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)



neg_int = rename(neg_int, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac,
                chrpos = CHR_x_Y_SIPS_PosTotal,
                chrneg = CHR_x_Y_SIPS_NegTotal,
                chrdis = CHR_x_Y_SIPS_Dtotal,
                chrbdi = CHR_x_Y_BDI_total,
                chrbai = CHR_x_Y_BAI_total) %>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)
neu_int = rename(neu_int, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac,
                chrpos = CHR_x_Y_SIPS_PosTotal,
                chrneg = CHR_x_Y_SIPS_NegTotal,
                chrdis = CHR_x_Y_SIPS_Dtotal,
                chrbdi = CHR_x_Y_BDI_total,
                chrbai = CHR_x_Y_BAI_total) %>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)

pos_int = rename(pos_int, id = Dyad_ID, chsc = child_sc, chcc = child_cc, casc = caregiver_sc, cacc =caregiver_cc, 
                chage = child_age, chwh = child_is_white, chfm = child_is_female, caage = caregiver_age,
                cawh = caregiver_is_white, cafm = caregiver_is_female, possx = Y_SIPS_PosTotal, negsx = Y_SIPS_NegTotal, 
                dissx = Y_SIPS_Dtotal, bai = Y_BAI_total, bdi = Y_BDI_total, CHRfc = CHR_fac,
                chrpos = CHR_x_Y_SIPS_PosTotal,
                chrneg = CHR_x_Y_SIPS_NegTotal,
                chrdis = CHR_x_Y_SIPS_Dtotal,
                chrbdi = CHR_x_Y_BDI_total,
                chrbai = CHR_x_Y_BAI_total) %>% 
  dplyr::select(-r2, -fname, -cond, -isYout, -omit, -ld_sens, -subj_sens, -isYout_sens)
#save(neg_df, neu_df, pos_df, neg_int, neu_int, pos_int, file = "processed_data/bsem_data.RData")
save(neg_df, neu_df, pos_df, neg_int, neu_int, pos_int, file = "processed_data/bsem_data_updated_w_latest_eia.RData")
