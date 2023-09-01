# loads the raw data, filters out irrelevant rows, saves data to the primary folder

library(tidyverse) # for various tasks including munging and plotting
library(here) # for easier file path access

# load article data (random)
d_articles_random <- read_csv(here('data','raw','articles (random) - Sheet1.csv'), show_col_types = F) %>%
  filter(!is.na(`primary coder initials`) & !is.na(`secondary coder initials`)) # we only need articles that were coded by someone

# load article data (prominent)
d_articles_prominent <- read_csv(here('data','raw','articles (prominent) - Sheet1.csv'), show_col_types = F)  %>%
  filter(!is.na(`primary coder initials`) & !is.na(`secondary coder initials`)) # we only need articles that were coded by someone

# join the prominent and random articles together (with a new column identifying which sample they are in) to streamline some testing.

d_articles <- bind_rows(
  d_articles_random %>% mutate(sample_id = "random"),
  d_articles_prominent %>% mutate(sample_id = "prominent")
)

# load journal data (random and prominent sample)
d_journals <- read_csv(here('data','raw','Data Extraction Form (policy) (Responses) - Form Responses 1.csv'), show_col_types = F) %>%
  filter(`Are you piloting?` == "No") %>% # remove pilot journals
  select(-`Are you piloting?`)

# Some journal names were entered in the extraction form with incorrect formatting. Correct this below.
d_journals <- d_journals %>% 
  mutate(`Journal Name` = fct_recode(`Journal Name`,
                              "MEMORY & COGNITION" = "Memory & Cognition","JOURNAL OF COUPLE & RELATIONSHIP THERAPY-INNOVATIONS IN CLINICAL AND EDUCATIONAL INTERVENTIONS" = "Journal of Couple & Relationship Therapy"))

# Attach sample information to extracted data

# There is some information about the sample that isn't included in the extracted data files (sample_id, JIFs, Web of Science subject category, COPE status), so we need to load some of that information from the original sample files and attached it to the extracted data

# load journal information
d_journals_prominent_info <- read_csv(here('data','raw','journal_prominent_information.csv')) 

d_journals_prominent_info_sample <- d_journals_prominent_info %>%
  filter(!is.na(journal_website)) # select only journals included in the sample

d_journals_random_info <- read_csv(here('data','raw','journal_random_information.csv')) 

d_journals_random_info_sample <- d_journals_random_info %>%
  filter(!is.na(journal_website)) # select only journals included in the sample

# Identify sample for journals

# The `d_journals` dataset does not identify whether journals were in the prominent sample, random sample, or both. So we need to get the sample ID retroactively using the files containing all journals included in the sample.

# Create sample ID column(s) to indicate whether in prominent, random, or both samples

d_journals <- d_journals %>%
  mutate(
    sample_journal_prominent = `Journal Name` %in% d_journals_prominent_info_sample$journal_name,
    sample_journal_random = `Journal Name` %in% d_journals_random_info_sample$journal_name,
    sample_journal_both = sample_journal_prominent & sample_journal_random,
    sample_journal_error = !sample_journal_prominent & !sample_journal_random
  )



#Creates sample_id column denoting; prominent, random, or both to replace the 4 specified columns above
d_journals <- d_journals %>% 
  mutate(sample_journal_prominent = ifelse(sample_journal_prominent, "prominent", "random")) %>%
  mutate(sample_journal_both = ifelse(sample_journal_both, "both", "na")) %>%
  mutate(sample_id = case_when(
    sample_journal_both == "both" ~ "both",
    sample_journal_both == "na" ~ sample_journal_prominent,
    TRUE ~ sample_journal_both
  )) %>%
  select(-c(sample_journal_prominent, sample_journal_random, sample_journal_both, sample_journal_error))

## Identify JIFs for journals

# For the random journals we can find the JIFs in the prominent journal sample. 
# Some journals do not have a JIF because they haven't been indexed long enough. We manually checked all of these journals on Journal Citation Reports to see if they had been assigned JIFs. One JIF needs to be added manually for the journal "Journal of Psychology and Theology". The 2021 JIF for this journal is .80.

# first split d_journals into two data frames based on sample ID
d_journals_prominent <- d_journals %>%
  filter(sample_id %in% c('prominent', 'both'))

d_journals_random <- d_journals %>%
  filter(sample_id == 'random')

# get COPE, JIF and WOS subject category for prominent journals

d_journals_prominent_info <- d_journals_prominent_info %>%
  select(`Journal Name` = journal_name, jif = `2021 JIF`, field = WOS_first_psych_category, cope = `COPE (T = member; F = not a member)`) # identify the columns we need from the sample data

d_journals_prominent <- left_join(d_journals_prominent, d_journals_prominent_info, by = 'Journal Name') # attach info to extracted data

# get COPE and WOS subject category for random journals
d_journals_random_info <- d_journals_random_info %>%
  select(`Journal Name` = journal_name, cope = `COPE (T = member; F = not a member)`, field = WOS_first_psych_category) # identify the columns we need from the sample data

d_journals_random <- left_join(d_journals_random, d_journals_random_info , by = 'Journal Name') # attach info to extracted data

# get JIFs for randomly selected journals by extracting them from the list of prominent journals (in the original download, not the sample)
d_jifs <- d_journals_prominent_info %>%
  select(`Journal Name`, jif) # we only need these columns

d_journals_random <- left_join(d_journals_random, d_jifs, by = 'Journal Name') # attach info to extracted data

d_journals_random <- d_journals_random %>%
  mutate(jif = ifelse(
    `Journal Name` == "JOURNAL OF PSYCHOLOGY AND THEOLOGY", # for one journal,
    .80, # manually add its JIF
    jif)) # otherwise keep whatever is already in the JIF column

# reunite d_journals_random and d_journals_prominent
d_journals <- bind_rows(d_journals_random,d_journals_prominent)

# save as primary data
write_csv(d_journals, here('data','primary','journals.csv'))
write_csv(d_articles, here('data','primary','articles.csv'))

rm(list = ls())