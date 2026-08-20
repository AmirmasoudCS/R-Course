set.seed(42) # random seed for reproducibility

# Generate 20 log-spaced points between 10 and 1,000,000
number_of_examples <- round(10^seq(1, 6, length.out = 100))
number_of_examples <- unique(number_of_examples)  # remove duplicates from rounding

results <- numeric(length(number_of_examples))    # to store proportions

for (i in seq_along(number_of_examples)) {
  n <- number_of_examples[i]
  samples <- rnorm(n, mean = 0, sd = 1)          # Generate n random normal values
  within_range <- samples > -1 & samples < 1     # Logical vector: True if between -1 and +1
  proportion <- mean(within_range)               # Proportion of TRUEs = Proportion in range
  results[i] <- proportion
  
  cat("n =", n, "-> Proportion within [-1, +1]:", round(proportion * 100, 2), "%\n")
}

# Create output directory if it doesn't exist
output_dir <- "./assets/images/"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Open PNG device to save the plot
png(filename = paste0(output_dir, "law_of_large_numbers.png"), width = 800, height = 600)

# Plot the results
plot(number_of_examples, results, 
     log = "x",                                  # log scale on x-axis (since n spans orders of magnitude)
     type = "b",                                 # "b" = both points and lines
     pch = 19,                                    # solid circle points
     cex = 0.7,                                   # smaller points since there are more of them
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

# Close the device to finalize/save the file
dev.off()

cat("Plot saved to:", paste0(output_dir, "law_of_large_numbers.png"), "\n")