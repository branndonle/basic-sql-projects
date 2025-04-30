-- SQL Retail Sales Project Analysis - P1
CREATE DATABASE sql_project_p2;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender varchar(15),
	age INT,
	category varchar(15),
	quantity INT, 
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR
	age IS NULL
	OR 
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration


-- Total Sales
SELECT COUNT(*) as total_sales
FROM retail_sales;


-- Total # of customers
SELECT COUNT(customer_id) AS total_customers
FROM retail_sales;

-- # of Unique customers
SELECT COUNT(DISTINCT(customer_id)) AS unique_customers
FROM retail_sales;

-- What are the Categories?
SELECT DISTINCT(category) AS categories
FROM retail_sales;

-- Data Analysis

-- Retrieve all columns for sales made on '2022-11-05':
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
AND quantity >= 4 
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

-- Calculate the total sales (total_sale) for each category:
SELECT category, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY category;

-- Find the average age of customers who purchased items from the 'Beauty' category:
SELECT ROUND(AVG(age), -1) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Find all transactions where the total_sale is greater than 1000:
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Calculate the average sale for each month. Find out best selling month in each year:
SELECT 
	year,
	month,
	avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year, month
) AS table1
WHERE rank = 1

-- Find the top 5 customers based on the highest total sales **:
SELECT customer_id, SUM(total_sale) AS highest_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY highest_sales DESC
LIMIT 5;

-- Find the number of unique customers who purchased items from each category:
SELECT category, COUNT(DISTINCT(customer_id)) AS unique_customers
FROM retail_sales
GROUP BY category

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH shift_maker
	AS(
		SELECT *, CASE 
						WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
						WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
						ELSE 'Evening'
					END AS shift
					FROM retail_sales
	)
	SELECT shift, COUNT(*) as num_orders
	FROM shift_maker
	GROUP BY shift

-- 
