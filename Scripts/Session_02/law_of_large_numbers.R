library(ggplot2)

set.seed(42)
number_of_examples <- round(10^seq(1, 6, length.out = 100))
number_of_examples <- unique(number_of_examples)
results <- numeric(length(number_of_examples))

for (i in seq_along(number_of_examples)) {
  n <- number_of_examples[i]
  samples <- rnorm(n, mean = 0, sd = 1)
  results[i] <- mean(samples > -1 & samples < 1)
}

df <- data.frame(n = number_of_examples, proportion = results)

p <- ggplot(df, aes(x = n, y = proportion)) +
  geom_hline(yintercept = 0.6827, color = "#D62728", linetype = "dashed", linewidth = 0.9) +
  geom_line(color = "#1F77B4", linewidth = 0.7) +
  geom_point(color = "#1F77B4", size = 2, alpha = 0.85) +
  scale_x_log10() +
  labs(
    title = "Law of Large Numbers: Convergence to 68.27%",
    x = "Number of Samples (log scale)",
    y = "Proportion within [-1, +1]"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    panel.grid.minor = element_blank()
  ) +
  annotate("text", x = max(df$n), y = 0.6827, label = "Theoretical: 68.27%",
           hjust = 1, vjust = -0.8, color = "#D62728", size = 4)

output_dir <- "./assets/images/"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

ggsave(paste0(output_dir, "law_of_large_numbers.png"), plot = p, 
       width = 10, height = 6, dpi = 300)

cat("Plot saved to:", paste0(output_dir, "law_of_large_numbers.png"), "\n")