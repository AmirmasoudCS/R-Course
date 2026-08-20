
read_revenue <- function(){
  return(c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50))
}

read_expenses <- function(){
  return(c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96))
}

raw_profit <- function(revenue, expenses){
  return(revenue - expenses)
}

taxxed_profit <- function(revenue, expenses, tax_rate=0.3){
  raw_profit <- raw_profit(revenue, expenses)
  after_tax <- (1-tax_rate)*raw_profit
  return(after_tax)
}

profit_margin <- function(taxxed_profit, revenue){
  return(taxxed_profit/revenue)
}

yeaer_mean_after_tax(taxxed_profit){
  sum <- 0
  for(i in 1:12){
    sum <- sum + taxxed_profit[i]
  }
  return(sum/12)
}

good_months(taxxed_profit){
  mean <- year_mean_after_tax(taxxed_profit)
  good <- taxxed_profit > mean
  return(good)
}

