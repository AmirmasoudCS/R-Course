set.seed(42) # random seed for reproducibility
number_of_examples = c(100, 1000, 10000, 100000) # number of examples we are going to test on

for (n in number_of_examples) {
  samples <- rnorm(n, mean = 0, sd = 1)      # Generate n random normal values with mean = 0 and standard deviation = 1
  within_range <- samples > -1 & samples < 1 # Logical vector: True if between -1 and +1
  proportion <- mean(within_range)           # Proportion of TRUEs = Proportion in range
  
  cat("n =", n, "-> Proportion within [-1, +1]:", round(proportion * 100, 2), "%\n")
}