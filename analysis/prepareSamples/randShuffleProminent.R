# randomly shuffle prominent journal list to disrupt coder drift

library(tidyverse)
library(here)

d <- read_csv(here('data','tmp2.csv'))

d_coded <- d %>% filter(!is.na(primary_coder))
d_not_coded <- d %>% filter(is.na(primary_coder))

set.seed(42)
d_shuffle <- d_coded %>% slice_sample(n = nrow(d_coded))

d_out <- bind_rows(d_shuffle,d_not_coded)
  
write_csv(d_out, 'prom_journals_shuffled.csv')
