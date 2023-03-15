# this study organizes various pre-study files

library(tidyverse)
library(here)
library(tidylog)

# this code loads the master list of journals included in the Web of Science Core Collection and saves a list of only the psychology journals

wos_esci <- read_csv(here('data','primary','prepareSample','wos-core_ESCI 2023-February-22.csv')) # load list of all WOS journals
wos_scie <- read_csv(here('data','primary','prepareSample','wos-core_SCIE 2023-February-22.csv')) # load list of all WOS journals
wos_ssci <- read_csv(here('data','primary','prepareSample','wos-core_SSCI 2023-February-22.csv')) # load list of all WOS journals
wos_ahci <- read_csv(here('data','primary','prepareSample','wos-core_AHCI 2023-February-22.csv')) # load list of all WOS journals

wos_psych <- bind_rows(wos_esci,wos_scie,wos_ssci,wos_ahci) %>%
  filter(str_detect(`Web of Science Categories`, 'Psychology')) %>% # filter to obtain only WOS journals with at least one "psychology" classification
  distinct(`Journal title`, .keep_all = T)

wos_psych <- wos_psych %>% filter(str_detect(Languages, 'English')) # filter to obtain only journals with English language articles

wos_psych_jcr <- read_csv(here('data','primary','prepareSample','wos-jcr-psych-2023.csv'), skip = 2) # load list of athe top 600 ranked psychology journals in JCR

# some journals have multiple disciplinary classifications. Here we select only the first psychology classification:

wos_psych <- wos_psych %>%
  rowwise() %>%
  mutate(WOS_first_psych_category = str_extract(`Web of Science Categories`, "Psychology(\\W+\\w+){0,1}"))

table(wos_psych$WOS_first_psych_category)

write_csv(wos_psych,here('data','primary','prepareSample','d-wos-psych.csv')) # save file






# this code compiles all of the separate journal by impact factor files (one for each subfield) into one file

# load in journals for each subject area ranked by impact factor (top 10)
journals_by_IF <- rbind(
  read_csv(here('data','primary','prepareSample','d-jcr-experimental-psych.csv'), skip = 1) %>%
    mutate(field = 'experimental'),
  read_csv(here('data','primary','prepareSample','d-jcr-multidisciplinary-psych.csv'), skip = 1) %>%
    mutate(field = 'multidisciplinary'),
  read_csv(here('data','primary','prepareSample','d-jcr-clinical-psych.csv'), skip = 1) %>%
    mutate(field = 'clinical'),
  read_csv(here('data','primary','prepareSample','d-jcr-developmental-psych.csv'), skip = 1) %>%
    mutate(field = 'developmental'),
  read_csv(here('data','primary','prepareSample','d-jcr-social-psych.csv'), skip = 1) %>%
    mutate(field = 'social'),
  read_csv(here('data','primary','prepareSample','d-jcr-psychoanalysis-psych.csv'), skip = 1) %>%
    mutate(field = 'psychoanalysis'),
  read_csv(here('data','primary','prepareSample','d-jcr-applied-psych.csv'), skip = 1) %>%
    mutate(field = 'applied'),
  read_csv(here('data','primary','prepareSample','d-jcr-mathematical-psych.csv'), skip = 1) %>%
    mutate(field = 'mathematical'),
  read_csv(here('data','primary','prepareSample','d-jcr-educational-psych.csv'), skip = 1) %>%
    mutate(field = 'educational'),
  read_csv(here('data','primary','prepareSample','d-jcr-biological-psych.csv'), skip = 1) %>%
    mutate(field = 'biological')
)

# some data frame adjustments
journals_by_IF <- journals_by_IF %>%
  filter(!str_detect(`Journal name`,'Copyright')) %>% # remove some notes that are included in the data files
  filter(!str_detect(`Journal name`,'By exporting')) %>% # remove some notes that are included in the data files
  filter(`2021 JIF` != 'N/A') %>% # remove journals that don't have a journal impact factor
  mutate(JIF_2021 = as.numeric(`2021 JIF`), # make JIF column numeric
         journal = str_to_title(`Journal name`)) %>% # make journal names title case
  select(journal, JIF_2021, ISSN, eISSN, field)

# check for duplicates (journals appearing in multiple fields)
original_size <- nrow(journals_by_IF)
number_duplicated_before_removal <- sum(duplicated(journals_by_IF$journal))

# for each field, assign ranks by impact factor. Then identify and remove journals that appear in multiple groups, preserving the instance with a higher rank
journals_by_IF <- journals_by_IF %>% 
  group_by(field) %>%
  arrange(desc(JIF_2021)) %>%
  mutate(IF_rank = row_number()) %>% # assign ranks within groups
  ungroup() %>%
  group_by(journal) %>%
  arrange(journal, IF_rank) %>% # rows are ordered by journal name and rank, so higher ranked duplicates appear first
  distinct(journal, .keep_all = T) %>% # this removes duplicates, preserving the first instance (row), which as above is the highest ranked of the duplicates
  ungroup()

# two tests to see if duplicates have in fact been removed (both tests should be TRUE)
nrow(journals_by_IF) == original_size-number_duplicated_before_removal
sum(duplicated(journals_by_IF$journal)) == 0

# for each field reassign ranks within groups (to make up for removed duplicates) and select the top ten by IF rank journals in each group
journals_by_IF <-journals_by_IF %>%
  arrange(field, desc(JIF_2021)) %>%
  group_by(field) %>%
  mutate(IF_rank = row_number()) %>% # reassign ranks within groups
  slice_head(n=10) # select top 10 ranked journals in each group

write_csv(journals_by_IF, here('data','primary','prepareSample','journals_sample.csv'))