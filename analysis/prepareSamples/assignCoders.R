library(tidyverse)
library(here)
d <- read_csv(here('data','journal_rand.csv'))
d <- d %>%
  filter(`eligible (T = publishes empirical, F = no empirical)` %in% c(T,F))

d_shuffle <- d %>%
  filter(`eligible (T = publishes empirical, F = no empirical)` == T) %>%
  slice_sample(n = 100) %>%
  mutate(coder = ifelse(row_number()<=40, "RT", "SV")) %>%
  mutate(coder = ifelse(row_number()>=81, "TEH", coder)) %>%
  select(journal_name, coder)

d <- d %>% left_join(d_shuffle, by = 'journal_name')

coders <- d %>% select(coder)

write_csv(coders, 'coders.csv')
