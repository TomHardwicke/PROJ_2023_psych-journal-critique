# precision analysis for proportions

# NB For proportions, using 0.5 as the expected proportion is appropriate in situations where you do not know what to expect - this is the most conservative approach because it leads to a maximal sample size estimate. See Gelman & Hill (2006, p. 442).
# in this case, we case base our expected proportion on Hardwicke et al.'s post-publication critique prevalence estimate - 1.9%

library(tidyverse)

# Formula to plot a precision curve for given proportion and sample size (95% confidence interval assumed).
precisionCurve <- function(P, Z = 1.96, N){
  vector <- NA # pre-load vector variable
  for(N in seq(1:N)){
    vector <- c(vector, Z*sqrt(P*(1-P)/N)) # add new value to vector
  }
  
  vector <- vector[!is.na(vector)] # remove the NA value added when variable was pre-loaded
  
  # build plot
  plot <- ggplot(data = data.frame(sampleSize = seq(1:N), precision = vector), aes(x = sampleSize, y = precision)) +
    geom_line(colour = 'darkblue', size = 1) +
    theme_classic() +
    ylab('Margin of error') +
    xlab('Sample size') +
    scale_x_continuous(expand = c(0.01, 0), limits = c(0,N)) +
    scale_y_continuous(expand = c(0.01, 0), limits = c(0,1))
  
  return(plot)
}

# formula for margin of error (MOE) calculation (95% confidence interval assumed)
marginOfError <- function(P, Z = 1.96, N){
  MOE <- Z*sqrt(P*(1-P)/N)
  return(MOE)
}

# first let's plot a precision curve to see how precision varies as a function of sample size
precisionCurve(P = .019, N = 300)

# looks like dimnishing returns after N = 100, maybe even N = 50 is fine

# an MOE for a given proportion and sample size
marginOfError(P = .019, N = 50)

# an MOE for a given proportion and sample size
marginOfError(P = .019, N = 100)

