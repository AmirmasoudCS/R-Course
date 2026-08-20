# The Law of Large Numbers

## What It Means

The **Law of Large Numbers (LLN)** is a fundamental principle in probability and statistics. It states that as the number of trials (or samples) in a random experiment increases, the observed average of the results will converge toward the expected (theoretical) value.

In simple terms: **the more data you collect, the closer your results get to the "true" underlying probability.**

## The Experiment

In this simulation, we repeatedly drew random samples from a **standard normal distribution** (mean = 0, standard deviation = 1) and measured the proportion of values falling within **[-1, +1]**.

Theoretically, about **68.27%** of values in a standard normal distribution fall within one standard deviation of the mean. This is the well-known **68-95-99.7 empirical rule**.

## What the Graph Shows

- **X-axis (log scale):** Number of samples drawn, ranging from ~10 to 1,000,000.
- **Y-axis:** The proportion of samples that fell within [-1, +1].
- **Red dashed line:** The theoretical value (68.27%).

At small sample sizes (e.g., n = 10–50), the results are highly volatile, swinging between 45% and over 80%. This is pure randomness dominating the outcome.

As the sample size grows into the thousands and millions, the blue line stabilizes and hugs the red dashed line closely. The fluctuations shrink dramatically, visually confirming the Law of Large Numbers in action.

## Takeaway

Small samples can be misleading. random chance has a big influence. Large samples are far more reliable, as randomness "averages out" and the observed result converges to the true probability.