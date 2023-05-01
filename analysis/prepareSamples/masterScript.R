# This master script prepares the study samples

library(tidyverse)
library(here)

# This script loads and mungs the master list of journals included in the Web of Science Core Collection and saves a list of only the psychology journals
# It also loads and mungs the list of the top 600 (ranked by Impact Factor) psychology journals in Journal Citation Reports
source(here('analysis','prepareSamples','organizeJournals.R'))

# This script obtains a random sample of psychology journals from among all psychology journals indexed by Web of Science (WOS) Core Collection
source(here('analysis','prepareSamples','randomSampleJournals.R'))

# This script obtains a random sample of psychology articles from among all psychology articles indexed by Web of Science (WOS) Core Collection in 2020
source(here('analysis','prepareSamples','randomSampleArticles.R'))


