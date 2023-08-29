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
  d_articles_random %>% mutate(sampleID = "random"),
  d_articles_prominent %>% mutate(sampleID = "prominent")
)

# load journal data (random and prominent sample)
d_journals <- read_csv(here('data','raw','Data Extraction Form (policy) (Responses) - Form Responses 1.csv'), show_col_types = F)

# save as primary data
write_csv(d_journals, here('data','primary','journals.csv'))
write_csv(d_articles, here('data','primary','articles.csv'))