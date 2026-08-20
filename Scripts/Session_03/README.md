## Scenario
You are a data scientist working for a consulting firm. One of your colleagues from the Auditing department has asked you to help them assess the
financial statement of organization X.

You have been supplied with two vectors of data: monthly revenue and monthly expenses for the financial year in question.
Your task is to calculate the following financial metrics:

* Profit for each month
* Profit after tax for each month
* Profit margin for each month - equals to profit after tax divided by the revenue
* Good months - where the profit after tax was greater than the mean of the year
* Bad months - where the profit after tax was lesser than the mean of the year
* The best month - where the profit after tax was max for the year
* The worst month - where the profit after tax was the min for the year

All results need to be presented as vectors.

Results for the profit margin ratio needs to be presented in units of % with no decimal points.

Results for dollar values need to be calculated with \$0.01 precision, but need to be presented in Units of \$1000 (i.e. 1k) with no decimal points.

> Note: Your colleague has warned you that it is okay for tax for any given month to be negative (in accounting terms, negative
 tax translates into a deferred tax asset).
 
 