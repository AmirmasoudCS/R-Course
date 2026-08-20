library(ggplot2)

sep <- function(){
  cat(strrep("=", 25), "\n")
}

month_names <- function(){
  return(c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
}

read_revenue <- function(){
  return(c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50))
}

read_expenses <- function(){
  return(c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96))
}

raw_profit <- function(revenue, expenses){
  return(revenue - expenses)
}

taxxed_profit <- function(revenue, expenses, tax_rate = 0.3){
  raw_p <- raw_profit(revenue, expenses)
  after_tax <- (1 - tax_rate) * raw_p
  return(after_tax)
}

profit_margin <- function(taxxed_profit, revenue){
  return(taxxed_profit / revenue)
}

year_mean_after_tax <- function(taxxed_profit){
  sum <- 0
  for(i in 1:12){
    sum <- sum + taxxed_profit[i]
  }
  return(sum / 12)
}

good_months <- function(taxxed_profit){
  mean_val <- year_mean_after_tax(taxxed_profit)
  good <- taxxed_profit > mean_val
  return(good)
}

bad_months <- function(taxxed_profit){
  mean_val <- year_mean_after_tax(taxxed_profit)
  bad <- taxxed_profit < mean_val
  return(bad)
}

best_month <- function(taxxed_profit){
  max_index <- 1
  max_value <- taxxed_profit[1]
  for(i in 2:12){
    if(taxxed_profit[i] > max_value){
      max_index <- i
      max_value <- taxxed_profit[i]
    }
  }
  return(list(index = max_index, value = max_value))
}

worst_month <- function(taxxed_profit){
  min_index <- 1
  min_value <- taxxed_profit[1]
  for(i in 2:12){
    if(taxxed_profit[i] < min_value){
      min_index <- i
      min_value <- taxxed_profit[i]
    }
  }
  return(list(index = min_index, value = min_value))
}

plot_revenue_expenses_profit <- function(revenue, expenses, taxxed_profit){
  months <- month_names()
  
  df <- data.frame(
    month = factor(rep(months, 3), levels = months),
    value = c(revenue, expenses, taxxed_profit),
    series = rep(c("Revenue", "Expenses", "Taxed Profit"), each = 12)
  )
  
  p <- ggplot(df, aes(x = month, y = value, color = series, group = series)) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    scale_color_manual(values = c("Revenue" = "forestgreen",
                                  "Expenses" = "firebrick",
                                  "Taxed Profit" = "steelblue")) +
    labs(title = "Revenue vs Expenses vs Profit",
         x = "Month", y = "Amount ($)", color = NULL) +
    theme_minimal()
  
  ggsave("./assets/images/revenue_expenses_profit.png", plot = p, width = 9, height = 5)
  print(p)
}

plot_monthly_profit_bar <- function(taxxed_profit){
  months <- month_names()
  mean_val <- year_mean_after_tax(taxxed_profit)
  
  df <- data.frame(
    month = factor(months, levels = months),
    profit = taxxed_profit,
    status = ifelse(taxxed_profit >= mean_val, "Above Mean", "Below Mean")
  )
  
  p <- ggplot(df, aes(x = month, y = profit, fill = status)) +
    geom_col() +
    geom_hline(yintercept = mean_val, linetype = "dashed", linewidth = 1) +
    scale_fill_manual(values = c("Above Mean" = "seagreen", "Below Mean" = "tomato")) +
    labs(title = "Monthly Taxed Profit",
         subtitle = paste("Mean:", round(mean_val, 2)),
         x = "Month", y = "Taxed Profit ($)", fill = NULL) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("./assets/images/monthly_profit_bar.png", plot = p, width = 9, height = 5)
  print(p)
}

plot_profit_margin <- function(margin){
  months <- month_names()
  mean_margin <- mean(margin)
  
  df <- data.frame(
    month = factor(months, levels = months),
    margin = margin
  )
  
  p <- ggplot(df, aes(x = month, y = margin)) +
    geom_col(fill = "steelblue") +
    geom_hline(yintercept = mean_margin, linetype = "dashed", color = "darkorange", linewidth = 1) +
    labs(title = "Profit Margin by Month",
         subtitle = paste("Mean margin:", round(mean_margin, 3)),
         x = "Month", y = "Margin (proportion)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("./assets/images/profit_margin.png", plot = p, width = 9, height = 5)
  print(p)
}

plot_cumulative_profit <- function(taxxed_profit){
  months <- month_names()
  cumulative <- cumsum(taxxed_profit)
  
  df <- data.frame(
    month = factor(months, levels = months),
    cumulative = cumulative
  )
  
  p <- ggplot(df, aes(x = month, y = cumulative, group = 1)) +
    geom_line(color = "purple", linewidth = 1) +
    geom_point(color = "purple", size = 2) +
    geom_hline(yintercept = 0, linetype = "dotted", color = "gray40") +
    labs(title = "Cumulative Taxed Profit Over the Year",
         x = "Month", y = "Cumulative Profit ($)") +
    theme_minimal()
  
  ggsave("./assets/images/cumulative_profit.png", plot = p, width = 9, height = 5)
  print(p)
}

display <- function(){
  revenue <- read_revenue()
  expenses <- read_expenses()
  sep()
  
  cat("\nRevenues:\n")
  print(revenue)
  sep()
  
  cat("\nExpenses:\n")
  print(expenses)
  sep()
  
  cat("\nProfit of each month without the impact of tax:\n")
  raw_p <- raw_profit(revenue, expenses)
  print(raw_p)
  sep()
  
  cat("\nProfit of each month after the impact of tax (30%):\n")
  taxxed <- taxxed_profit(revenue, expenses)
  print(taxxed)
  sep()
  
  cat("\nProfit margin:\n")
  margin <- profit_margin(taxxed, revenue)
  print(margin)
  sep()
  
  cat("\nMean of the year after tax:\n")
  year_mean <- year_mean_after_tax(taxxed)
  print(year_mean)
  sep()
  
  cat("\nGood months:\n")
  goods <- good_months(taxxed)
  print(goods)
  sep()
  
  cat("\nBad months:\n")
  bads <- bad_months(taxxed)
  print(bads)
  sep()
  
  cat("\nBest month:\n")
  best <- best_month(taxxed)
  cat("Month index:", best$index, "- Value:", best$value, "\n")
  sep()
  
  cat("\nWorst month:\n")
  worst <- worst_month(taxxed)
  cat("Month index:", worst$index, "- Value:", worst$value, "\n")
  sep()
  
  cat("\nGenerating visualizations...\n")
  plot_revenue_expenses_profit(revenue, expenses, taxxed)
  plot_monthly_profit_bar(taxxed)
  plot_profit_margin(margin)
  plot_cumulative_profit(taxxed)
  cat("Plots saved as PNG files in your working directory.\n")
  
  
  
}

main <- function(){
  display()
}

main()
