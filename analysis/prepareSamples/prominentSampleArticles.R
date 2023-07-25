# This script randomly shuffles the lists of journals and articles

library(tidyverse)
library(here)
library(readr)
`%notin%` <- Negate(`%in%`)

articles_prominent <- read_csv(here('data','prepareSample','articles','02 - modified','articles-all-prominent.csv')) # load list of all WOS psychology articles (2020)

set.seed(42) # set the seed for reproducibility of random sampling
articles_all_prominent <- slice_sample(articles_prominent, n = 600) # randomly select 600 rows (we're doing more than the target sample of 100 to allow for exclusions)

# apply formatting changes to standardize with the prominent journal sample
articles_all_prominent <- articles_all_prominent %>%
  select(link = DI,
         title = TI,
         authors = AU,
         journal = SO,
         publication_year = PY)

articles_all_prominent$id <- seq(1:600)

# publication year diagnostic
# articles_all_random %>% count(PY) # note that there's some articles that appear to be published outside of 2020, this is because WOS uses the 'early access' date when applying the publication year filter. All of these articles were published in 2020.

write_csv(articles_all_prominent, here('data','prepareSample','articles','03 - final','articles-prominent.csv')) # save the list of sampled articles
