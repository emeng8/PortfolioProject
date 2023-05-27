--For this SQL project I will be answering 15 questions from this data set

--What is the total gross income per branch?

SELECT
	branch,
	SUM(gross_income) AS total_gross_income_by_branch
FROM supermarket_salesSheet2
GROUP BY branch;

--What branch has the highest number of sales?

SELECT TOP 1 
	branch,
	COUNT(invoice_id) AS total_sales
FROM supermarket_salesSheet2
GROUP BY branch
ORDER BY total_sales DESC;

--What is the average rating per branch? And how does it vary in between branches?

SELECT
	branch,
	AVG(rating) AS average_rating,
	STDEV(rating) AS rating_variation
FROM supermarket_salesSheet2
GROUP BY branch;

--Which product line has the highest sales?

SELECT
	product_line,
	COUNT(invoice_id) AS total_sales
FROM supermarket_salesSheet2
GROUP BY product_line
ORDER BY total_sales DESC;

--What is the total amount of sales and transactions for each payment method?

SELECT
	payment,
	COUNT(invoice_id) AS total_transactions,
	SUM(total) AS total_sales
FROM supermarket_salesSheet2
GROUP BY payment;

--What is the highest and lowest unit price for each product line?

SELECT
 	product_line,
 	MAX(unit_price) AS highest_unit_price,
	MIN(unit_price) AS lowest_unit_price
FROM supermarket_salesSheet2
GROUP BY product_line;

--What is the average quantity of products purchased by members vs non-members?

SELECT
	customer_type,
	AVG(quantity) AS average_quantity
FROM supermarket_salesSheet2
GROUP BY customer_type;

--What is the total tax collected per city?

SELECT
	city,
	SUM(tax_5%) AS total_tax
FROM supermarket_salesSheet2
GROUP BY city;

--Which product line has the highest gross income?

SELECT TOP 1
	product_line,
	SUM(gross_income) AS highest_gross_income
FROM supermarket_salesSheet2
GROUP BY product_line
ORDER BY highest_gross_income DESC;
   
--What are the top 5 selling products in each branch? In this case, top selling is referring to highest total quantity

WITH Product_Sales AS (
  SELECT
	  branch,
	  product_line,
	  SUM(quantity) AS total_quantity,
	  ROW_NUMBER() OVER (PARTITION BY branch ORDER BY SUM(quantity) DESC) AS rn
  FROM supermarket_salesSheet2
  GROUP BY branch, product_line
)
SELECT
	branch,
	product_line,
  	total_quantity
FROM Product_Sales
WHERE rn <= 5;

--On which date did the supermarket make the highest sales?

SELECT TOP 1
	date,
  	MAX(total_sales) AS highest_sales
FROM (
  SELECT
	date,
	SUM(total) AS total_sales
  FROM supermarket_salesSheet2
  GROUP BY date
) AS daily_sales
GROUP BY date;

--What is the peak shopping time (most sales occur) in the supermarket?

SELECT TOP 1 
	time,
  	MAX(number_of_sales)
 FROM (
   SELECT 
    	time, 
    	COUNT(invoice_id) AS number_of_sales
   FROM supermarket_salesSheet2
   GROUP BY time
   ) AS Shopping_Time
GROUP BY time;

--What is the gross margin percentage per product line?

SELECT
	product_line,
  	AVG((gross_income/total) * 100) AS gross_margin_percentage1
FROM supermarket_salesSheet2
GROUP BY product_line;
   
--How does the rating affect the total sales? For instance, do higher-rated branches have higher sales?

SELECT
	branch,
 	AVG(rating) AS average_rating,
  	SUM(total) AS total_revenue
FROM supermarket_salesSheet2
GROUP BY branch
ORDER BY average_rating DESC, total_revenue DESC;

--Which gender type has made the most purchases?

SELECT
	gender,
  	COUNT(invoice_id) AS purchases
FROM supermarket_salesSheet2
GROUP BY gender
ORDER BY purchases DESC; 
