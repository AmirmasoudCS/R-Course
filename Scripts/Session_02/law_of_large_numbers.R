set.seed(42) # random seed for reproducibility
number_of_examples <- c(100, 1000, 10000, 100000) # number of examples we are going to test on
results <- numeric(length(number_of_examples))    # to store proportions

for (i in seq_along(number_of_examples)) {
  n <- number_of_examples[i]
  samples <- rnorm(n, mean = 0, sd = 1)          # Generate n random normal values
  within_range <- samples > -1 & samples < 1     # Logical vector: True if between -1 and +1
  proportion <- mean(within_range)               # Proportion of TRUEs = Proportion in range
  results[i] <- proportion
  
  cat("n =", n, "-> Proportion within [-1, +1]:", round(proportion * 100, 2), "%\n")
}

# Plot the results
plot(number_of_examples, results, 
     log = "x",                                  # log scale on x-axis (since n spans orders of magnitude)
     type = "b",                                 # "b" = both points and lines
     pch = 19,                                    # solid circle points
     col = "blue",
     xlab = "Number of Samples (log scale)",
     ylab = "Proportion within [-1, +1]",
     main = "Law of Large Numbers: Convergence to 68.27%",
     ylim = c(min(results, 0.6827) - 0.02, max(results, 0.6827) + 0.02))

# Add horizontal reference line at the theoretical value
abline(h = 0.6827, col = "red", lty = 2, lwd = 2)

# Add a legend
legend("bottomright", 
       legend = c("Simulated proportion", "Theoretical (68.27%)"),
       col = c("blue", "red"), 
       lty = c(1, 2), 
       pch = c(19, NA),
       lwd = c(1, 2))