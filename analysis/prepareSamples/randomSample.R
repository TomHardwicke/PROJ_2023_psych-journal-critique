# This script randomly shuffles the lists of journals and articles

library(tidyverse)
library(here)
`%notin%` <- Negate(`%in%`)

journals_all <- read_csv(here('data','prepareSample','journals','02 - modified','journals-all.csv')) # load list of all WOS psychology journals
journals_all_eng <- journals_all %>% filter(str_detect(Languages, 'English')) # filter to obtain only journals with English language articles

set.seed(42) # set the seed for reproducibility of random sampling
journals_all_eng_random <- slice_sample(journals_all_eng, n = 600) # randomly select 600 rows (we're doing more than the target sample of 100 to allow for exclusions)

# apply formatting changes to standardize with the prominent journal sample
journals_all_eng_random <- journals_all_eng_random %>%
  select(everything(), 
         'Journal' = `Journal title`,
         -Languages,
         -`Publisher name`,
         -`Publisher address`)

write_csv(journals_all_eng_random, here('data','prepareSample','journals','03 - final','journals-random.csv')) # save the list of sampled journals
