# How do psychology journals handle post-publication critique? A cross-sectional study of policy and practice

This is a repository for the reproducible manuscript by Annie Whamond, Simine Vazire, Beth Clarke, Nicholas Moodie, Sarah Schiavone, Robert Thibault, and Tom Hardwicke.

The files have also been copied to the Open Science Framework ([https://doi.org/10.17605/OSF.IO/7WSHF](https://doi.org/10.17605/OSF.IO/7WSHF)), for long term preservation. The pre-registered protocol for this study is also available via the Open Science Framework ([https://osf.io/d6xf2](https://osf.io/d6xf2)). A Code Ocean capsule ([https://doi.org/10.24433/CO.3949618.v1](https://doi.org/10.24433/CO.3949618.v1)) has been published for computational reproducibility.

The folders contain the primary and processed data and analysis scripts. For copyright reasons, raw data has been withheld where institutional login or subscription is required for access. 

All preparation, processing, and analysis scripts can be found in the analysis/ folder:

**The prepareSamples/ folder contains R scripts for:**

  - *assignCoders.R*: randomly assigning data curators to journals and articles to be inspected
  
  - *masterScript.R*: loading and munging the lists of psychology journals and articles from the Web of Science Core Collection
  
  - *organizeJournals.R*: loads the master list of journals included in the Web of Science Core Collection and saves lists of (a) psychology journals and (b) top 600 (by journal impact factor) psycholgy journals
  
  - *prominentSampleArticles.R*: randomly shuffles and splices the list of articles published in prominent psychology journals
  
  - *randShuffleProminent.R*: shuffles prominent journal list to disrupt coder drift
  
  - *randomSampleArticles.R*: randomly shuffles the lists of all psychology articles 
  
  - *randomSampleJournals.R*: randomly shuffles the lists of psychology journals
  
**Other analysis scripts:**

  - *functions.R*: Defines functions for making the first letter of a string uppercase, creating a "not in" operator, and calculating 95% Wilson CIs
  
  - *precision_analysis.R*: runs analysis to help determine appropriate sample size and margin of error, creates plots to visualise for both journal and article samples
  
  - *preprocessing.Rmd*: cleans and harmonizes raw data, saves to /data/processed/ folder.
  
  - *raw_to_primary.R*: loads the raw data, filters out irrelevant rows, saves data to the /data/primary/ folder
  
  - *resultsAnalysis.Rmd*: analyses the data and produces the statistics and results presented in the final manuscript
 
All data (or instructions for obtaining data where subscriptions is required) can be found in the data/ folder:

- *prepareSample/*: instructions and search strings used to obtain raw data for the both prominent and random journal and article samples from Web of Science

- *primary/*: curated data (with irrelevant rows removed) for both journal and article samples (loaded in preprocessing.Rmd)

- *processed/*: saved files of journal and article data after being cleaned and harmonized via the preprocessing.Rmd script (loaded in resultsAnalysis.Rmd)

The renv/ folder contains information about the R packages used to run the analysis — it was created by the R package renv.
