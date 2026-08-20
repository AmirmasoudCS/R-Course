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
  
  png("revenue_expenses_profit.png", width = 900, height = 500)
  plot(1:12, revenue, type = "o", col = "forestgreen", lwd = 2, pch = 16,
       ylim = range(c(revenue, expenses, taxxed_profit)),
       xaxt = "n", xlab = "Month", ylab = "Amount ($)",
       main = "Revenue vs Expenses vs Profit")
  lines(1:12, expenses, type = "o", col = "firebrick", lwd = 2, pch = 16)
  lines(1:12, taxxed_profit, type = "o", col = "steelblue", lwd = 2, pch = 16)
  axis(1, at = 1:12, labels = months)
  legend("topleft", legend = c("Revenue", "Expenses", "Taxed Profit"),
         col = c("forestgreen", "firebrick", "steelblue"), lwd = 2, pch = 16)
  dev.off()
  
  # show in plot window too
  plot(1:12, revenue, type = "o", col = "forestgreen", lwd = 2, pch = 16,
       ylim = range(c(revenue, expenses, taxxed_profit)),
       xaxt = "n", xlab = "Month", ylab = "Amount ($)",
       main = "Revenue vs Expenses vs Profit")
  lines(1:12, expenses, type = "o", col = "firebrick", lwd = 2, pch = 16)
  lines(1:12, taxxed_profit, type = "o", col = "steelblue", lwd = 2, pch = 16)
  axis(1, at = 1:12, labels = months)
  legend("topleft", legend = c("Revenue", "Expenses", "Taxed Profit"),
         col = c("forestgreen", "firebrick", "steelblue"), lwd = 2, pch = 16)
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
}

main <- function(){
  display()
}

main()
