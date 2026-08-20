# The Law of Large Numbers

## What It Means

The **Law of Large Numbers (LLN)** is a fundamental principle in probability and statistics. It states that as the number of trials (or samples) in a random experiment increases, the observed average of the results will converge toward the expected (theoretical) value.

In simple terms: **the more data you collect, the closer your results get to the "true" underlying probability.**

## The Experiment

In this simulation, we repeatedly drew random samples from a **standard normal distribution** (mean = 0, standard deviation = 1) and measured the proportion of values falling within **[-1, +1]**.

Theoretically, about **68.27%** of values in a standard normal distribution fall within one standard deviation of the mean. This is the well-known **68-95-99.7 empirical rule**.

![Standard normal distribution with probabilities for each region](../assets/images/normal_distribution_probabilities.png)

*The standard normal distribution, showing the proportion of values falling within 1, 2, and 3 standard deviations of the mean.*

## What the Graph Shows

![Law of Large Numbers convergence plot](../assets/images/law_of_large_numbers.png)

*Simulated proportion of samples within [-1, +1] as the number of samples increases, converging toward the theoretical 68.27%.*

- **X-axis (log scale):** Number of samples drawn, ranging from ~10 to 1,000,000.
- **Y-axis:** The proportion of samples that fell within [-1, +1].
- **Red dashed line:** The theoretical value (68.27%).

At small sample sizes (e.g., n = 10–50), the results are highly volatile, swinging between 45% and over 80%. This is pure randomness dominating the outcome.

As the sample size grows into the thousands and millions, the blue line stabilizes and hugs the red dashed line closely. The fluctuations shrink dramatically, visually confirming the Law of Large Numbers in action.

## Takeaway

Small samples can be misleading. Random chance has a big influence. Large samples are far more reliable, as randomness "averages out" and the observed result converges to the true probability.