# this study organizes various pre-study files

library(tidyverse)
library(here)
library(tidylog)

# this code loads the master list of journals included in the Web of Science Core Collection and saves a list of only the psychology journals

wos_esci <- read_csv(here('data','primary','prepareSample','journals','01 - fromWOS','wos-core-ESCI-2023-February-22.csv')) # load list of WOS journals
wos_scie <- read_csv(here('data','primary','prepareSample','journals','01 - fromWOS','wos-core-SCIE-2023-February-22.csv')) # load list of WOS journals
wos_ssci <- read_csv(here('data','primary','prepareSample','journals','01 - fromWOS','wos-core-SSCI-2023-February-22.csv')) # load list of WOS journals
wos_ahci <- read_csv(here('data','primary','prepareSample','journals','01 - fromWOS','wos-core-AHCI-2023-February-22.csv')) # load list of WOS journals

wos_psych <- bind_rows(wos_esci,wos_scie,wos_ssci,wos_ahci) %>%
  filter(str_detect(`Web of Science Categories`, 'Psychology')) %>% # filter to obtain only WOS journals with at least one "psychology" classification
  distinct(`Journal title`, .keep_all = T)

# some journals have multiple disciplinary classifications. Here we select only the first psychology classification:

wos_psych <- wos_psych %>%
  rowwise() %>%
  mutate(WOS_first_psych_category = str_extract(`Web of Science Categories`, "Psychology(\\W+\\w+){0,1}"))

write_csv(wos_psych,here('data','primary','prepareSample','journals','02 - modified','wos-psych.csv')) # save file

# this code loads the list of (the top 600) psychology journals included in Journal Citation Reports
wos_psych_jcr <- read_csv(here('data','primary','prepareSample','journals','01 - fromWOS','wos-jcr-psych-2022.csv')) # load list of the top 600 ranked psychology journals in JCR

# some journals have multiple disciplinary classifications. Here we select only the first psychology classification. Also make journal names uppercase
wos_psych_jcr <- wos_psych_jcr %>%
  rowwise() %>%
  mutate(WOS_first_psych_category = str_extract(`Category`, "PSYCHOLOGY(\\W+\\w+){0,1}"),
         `Journal name` = str_to_upper(`Journal name`))

write_csv(wos_psych_jcr,here('data','primary','prepareSample','journals','02 - modified','jcr-psych.csv')) # save file