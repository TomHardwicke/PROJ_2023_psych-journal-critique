## This script will run a precision analysis to help with sample size planning

library(ggplot2)

# define function for computing margin of error (MOE) assuming a 95% confidence interval assumed
marginOfError <- function(P, Z = 1.96, N){
  MOE <- Z*sqrt(P*(1-P)/N)
  return(MOE)
}

# define function to plot a precision curve for given proportion and sample size (95% confidence interval assumed).
precisionCurve <- function(P, Z = 1.96, N){
  vector <- NA # pre-load vector variable
  for(N in seq(1:N)){
    vector <- c(vector, Z*sqrt(P*(1-P)/N)) # add new value to vector
  }
  
  vector <- vector[!is.na(vector)] # remove the NA value added when variable was pre-loaded
  
  # build plot
  plot <- ggplot(data = data.frame(sampleSize = seq(1:N), precision = vector), aes(x = sampleSize, y = precision)) +
    geom_line(colour = 'black', size = .75) +
    theme_classic() +
    ylab('Margin of error') +
    xlab('Sample size') +
    scale_x_continuous(expand = c(0.0, 0), limits = c(0,N)) +
    scale_y_continuous(expand = c(0.0, 0), limits = c(0,0.5), breaks = seq(0,0.5,0.1)) +
    theme(panel.grid.major = element_line(colour="grey97", size=0.5))
  
  return(plot)
}

# compute the moe for a sample size of 100 using 0.019 as the expected proportion 
# NB using 0.5 is appropriate in situations where you do not know what to expect - this is the most conservative approach because it leads to a maximal sample size estimate. See Gelman & Hill (2006, p. 442).
# but we're going to use 0.019 based on the results of Hardwicke et al. (2022)

expectedProportion <- 0.019
sampleSize1 <- 100
sampleSize2 <- 50

moe1 <- marginOfError(P = expectedProportion, N = sampleSize1)
moe1

moe2 <- marginOfError(P = expectedProportion, N = sampleSize2)
moe2

# plot a precision curve showing margin of error for a 95% confidence interval as a function of sample size assuming a proportion of 0.5. 
precisionCurve(P = expectedProportion, N = 300) +
  annotate("segment", x = sampleSize1, xend = sampleSize1, y = 0, yend = moe1, colour = "purple", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend =  sampleSize1, y = moe1, yend = moe1, colour = "purple", size=1, alpha=0.6) +
  annotate("label", x = 7.5, y = moe1, colour = "purple", size=3, alpha=1, label = round(moe1,2)) +
  annotate("label", x = sampleSize1, y = 0.05, colour = "purple", size=3, alpha=1, label = sampleSize1) + 
  
  annotate("segment", x = sampleSize2, xend = sampleSize2, y = 0, yend = moe2, colour = "green", size=1, alpha=0.6) +
  annotate("segment", x = 0, xend =  sampleSize2, y = moe2, yend = moe2, colour = "green", size=1, alpha=0.6) +
  annotate("label", x = 7.5, y = moe2, colour = "green", size=3, alpha=1, label = round(moe2,2)) +
  annotate("label", x = sampleSize2, y = 0.05, colour = "green", size=3, alpha=1, label = sampleSize2)