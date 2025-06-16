# This script will run a precision analysis to help with sample size planning 
# when you wish to estimate a proportion with confidence intervals
# This code was written for personal use — reuse at your own risk!

# Load libraries ---------------------------------

library(tidyverse)

# Define functions ---------------------------------

# Define function for computing confidence interval width.
# If the population size is known a finite population correction can be applied.
# Otherwise, if the population size in unknown, no correction is applied (the default).
# A 95% confidence level is assumed.
calc_ci_width <- function(expectedProportion,sampleSize,confidenceLevel=.95,populationSize=Inf,report=T){
  n <- sampleSize
  N <- populationSize

  successCount <- n*expectedProportion
  CI <- prop.test(successCount, n, correct = F, conf.level = confidenceLevel)$conf.int # computes CI. Yate's continuity correction is off by default
  CI_width <- (CI[2] - CI[1]) # to get the CI width, subtract lowerbound of CI from upperbound of CI
  
  # NOT RUN — sanity check using hand written formula for Wilson CIs
  #P <- expectedProportion
  #Z <- qnorm(c( (1-confidenceLevel)/2, 1-(1-confidenceLevel)/2))[2]
  #CI <- (2 * n * P + Z^2 + c(-1, 1) * Z * sqrt(Z^2 + 4 * n * P * (1 - P))) /
  #   (2 * (n + Z^2)) 
  #CI_width <- (CI[2] - CI[1]) # to get the CI width, subtract lowerbound of CI from upperbound of CI
 
  if(N != Inf){ # if user has specified a population size
    FPC <- sqrt((N-n)/(N-1)) # calculate a finite population correction (FPC) factor
    CI_width <- CI_width*FPC # adjust the ci_width with the FPC
  }
  
  if(report){ # if user has asked for a report
    print(paste0(
      'The 95% Wilson confidence interval for an expected proportion of ',expectedProportion,
      ' and a sample size of ',sampleSize,' is ', round(CI_width,3)))
  }
  
  ci_object <- list(CI_width = CI_width, target_sample_size = sampleSize)
  
  return(ci_object)
}

# define function to plot a precision curve for given proportion and sample size (95% confidence interval assumed).
precisionCurve <- function(expectedProportion,sampleSize,confidenceLevel=.95,populationSize=Inf){
  
  sample_size_vector <- seq(1:(sampleSize*2)) # create a vector of sample sizes for X axis (by default we will show a curve for 2x the specified sample size)
  ci_width_vector <- NA # pre-load a variable to store ci_widths
  
  for(i in sample_size_vector){ # using a for loop as its more comprehensible 
    ci_object <- calc_ci_width(
      sampleSize = i,
      expectedProportion = expectedProportion,
      confidenceLevel = confidenceLevel,
      populationSize = populationSize,
      report = F # don't print a report
    )
    ci_width_vector <- c(ci_width_vector, ci_object$CI_width) # append new ci_width to ci_width vector
  }
  
  ci_vector <- ci_vector[!is.na(ci_vector)] # remove the NA value created when ci_width_vector was pre-loaded
  df <- data.frame(sampleSize = sample_size_vector,precision = ci_width_vector)
  
  # build plot
  plot <- ggplot(data = df, aes(x = sampleSize, y = precision)) +
    geom_line(colour = 'black', linewidth = .75) +
    theme_classic() +
    ylab('Precision (confidence interval width)') +
    xlab('Sample size') +
    scale_x_continuous(expand = c(0.0, 0), limits = c(0,max(sample_size_vector))) +
    scale_y_continuous(expand = c(0.0, 0), limits = c(0,round(max(ci_width_vector)+.1,1)), breaks = seq(0,round(max(ci_width_vector)+.1,1),0.1)) +
    theme(panel.grid.major = element_line(colour="grey97", size=0.5))
  
  return(plot)
}

# Run a precision analysis for Research Aim (1b)  ---------------------------------

# Run the code below to compute a ci width for given expected proportion and target sample size
ci_object1 <- calc_ci_width(
  expectedProportion = .67, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
  sampleSize = 100, # Specify the target sample size
  populationSize = 750, # If population size is known, we can apply a finite population correction, otherwise use Inf
  confidenceLevel = .95) # specify the level of the confidence interval


# Lets get a second ci width for a different target sample size (so we can display both on a precision curve)
ci_object2 <- calc_ci_width(
  expectedProportion = .67, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
  sampleSize = 50, # Specify the target sample size
  populationSize = 750, # If population size is known, we can apply a finite population correction, otherwise use Inf
  confidenceLevel = .95) # specify the level of the confidence interval

# Now plot a precision curve showing precision (confidence interval width) as a function of sample size.
# We'll annotate the plot with the parameters above

precisionCurve(expectedProportion =.67, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
               sampleSize = 100, # Specify the target sample size
               populationSize = 750, # If population size is known, we can apply a finite population correction, otherwise use Inf
               confidenceLevel = .95 # specify the level of the confidence interval
) +
  # this code annotates the precision curve with the ci widths computed above
  annotate("segment", x = ci_object1$target_sample_size, xend = ci_object1$target_sample_size, y = 0, yend = ci_object1$ci_width, colour = "purple", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend = ci_object1$target_sample_size, y = ci_object1$ci_width, yend = ci_object1$ci_width, colour = "purple", size=1, alpha=0.6) +
  annotate("label", x = 7, y = ci_object1$ci_width, colour = "purple", size=3, alpha=1, label = round(ci_object1$ci_width,3)) +
  annotate("label", x = ci_object1$target_sample_size, y = 0.02, colour = "purple", size=3, alpha=1, label = ci_object1$target_sample_size) + 
  
  annotate("segment", x = ci_object2$target_sample_size, xend = ci_object2$target_sample_size, y = 0, yend = ci_object2$ci_width, colour = "green", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend =  ci_object2$target_sample_size, y = ci_object2$ci_wdith, yend = ci_object2$ci_width, colour = "green", size=1, alpha=0.6) +
  annotate("label", x = 7, y = ci_object2$ci_width, colour = "green", size=3, alpha=1, label = round(ci_object2$ci_width,3)) +
  annotate("label", x = ci_object2$target_sample_size, y = 0.02, colour = "green", size=3, alpha=1, label = ci_object2$target_sample_size) 

# Run a precision analysis for Research Aim (2)  ---------------------------------

# Run the code below to compute a ci width for given expected proportion and target sample size
ci_object1 <- calc_ci_width(
  expectedProportion = .17, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
  sampleSize = 100, # Specify the target sample size
  populationSize = 61735, # If population size is known, we can apply a finite population correction, otherwise use Inf
  confidenceLevel = .95) # specify the level of the confidence interval


# Lets get a second ci width for a different target sample size (so we can display both on a precision curve)
ci_object2 <- calc_ci_width(
  expectedProportion = .17, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
  sampleSize = 50, # Specify the target sample size
  populationSize = 61735, # If population size is known, we can apply a finite population correction, otherwise use Inf
  confidenceLevel = .95) # specify the level of the confidence interval


# Now plot a precision curve showing precision (confidence interval width) as a function of sample size.
# We'll annotate the plot with the parameters above

precisionCurve(expectedProportion =.17, # Specify the anticipated proportion. Use 0.5 for the most conservative sample size estimate (see Gelman & Hill, 2006, p. 442).
               sampleSize = 100, # Specify the target sample size
               populationSize = 61735, # If population size is known, we can apply a finite population correction, otherwise use Inf
               confidenceLevel = .95 # specify the level of the confidence interval
) +
  # this code annotates the precision curve with the ci widths computed above
  annotate("segment", x = ci_object1$target_sample_size, xend = ci_object1$target_sample_size, y = 0, yend = ci_object1$ci_width, colour = "purple", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend = ci_object1$target_sample_size, y = ci_object1$ci_width, yend = ci_object1$ci_width, colour = "purple", size=1, alpha=0.6) +
  annotate("label", x = 7, y = ci_object1$ci_width, colour = "purple", size=3, alpha=1, label = round(ci_object1$ci_width,3)) +
  annotate("label", x = ci_object1$target_sample_size, y = 0.02, colour = "purple", size=3, alpha=1, label = ci_object1$target_sample_size) + 
  
  annotate("segment", x = ci_object2$target_sample_size, xend = ci_object2$target_sample_size, y = 0, yend = ci_object2$ci_width, colour = "green", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend =  ci_object2$target_sample_size, y = ci_object2$ci_width, yend = ci_object2$ci_width, colour = "green", size=1, alpha=0.6) +
  annotate("label", x = 7, y = ci_object2$ci_width, colour = "green", size=3, alpha=1, label = round(ci_object2$ci_width,3)) +
  annotate("label", x = ci_object2$target_sample_size, y = 0.02, colour = "green", size=3, alpha=1, label = ci_object2$target_sample_size) 


# References  ---------------------------------

# Gelman, A., & Hill, J. (2007). Data analysis using regression and multilevel/hierarchical models. Cambridge University Press.
# Newcombe R.G. (1998). Two-Sided Confidence Intervals for the Single Proportion: Comparison of Seven Methods. Statistics in Medicine, 17, 857–872. doi:10.1002/(SICI)1097-0258(19980430)17:8<857::AID-SIM777>3.0.CO;2-E.
# Rothman, K. J., & Greenland, S. (2018). Planning study size based on precision rather than power. Epidemiology, 29(5), 599–603. https://doi.org/10.1097/EDE.0000000000000876