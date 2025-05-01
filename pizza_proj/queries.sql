SELECT *
FROM pizza_dataset_new

-- A. KPI’s

-- 1. Total Revenue from transactions
SELECT SUM(total_price) AS total_revenue
FROM pizza_dataset_new;

-- 2. Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT(order_id))) AS average_price
FROM pizza_dataset_new

-- 3. Total Pizzas Sold
SELECT SUM(quantity)) AS total_pizzas_sold
FROM pizza_dataset_new

-- 4. Total Orders
SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_dataset_new

-- 5. Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
FROM pizza_dataset_new

-- 6. Daily Trend for Total Orders
SELECT TO_CHAR(order_date, 'Day') AS order_day , COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_dataset_new
GROUP BY order_day
ORDER BY total_orders;

-- 7. Hourly Trend for Orders
SELECT TO_CHAR(order_time, 'HH24') AS order_time , COUNT(DISTINCT(order_id)) AS total_orders
FROM pizza_dataset_new
GROUP BY order_time
ORDER BY total_orders DESC;

-- 8. % of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10, 2)) AS total_revenue, CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_dataset_new) AS DECIMAL(10,2)) AS category_percentage
FROM pizza_dataset_new
GROUP BY pizza_category

-- 9. % of Sales by Pizza Size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10, 2)) AS total_revenue, CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_dataset_new) AS DECIMAL(10,2)) AS category_percentage
FROM pizza_dataset_new
GROUP BY pizza_size
ORDER BY pizza_size

-- 10. Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS total_quantity
FROM pizza_dataset_new
GROUP BY pizza_category
ORDER BY total_quantity DESC

-- 11. Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name, SUM(quantity) AS total_pizza_purchased
FROM pizza_dataset_new
GROUP BY pizza_name
ORDER BY total_pizza_purchased DESC
LIMIT 5

-- 12. Bottom 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name, SUM(quantity) AS total_pizza_purchased
FROM pizza_dataset_new
GROUP BY pizza_name
ORDER BY total_pizza_purchased ASC
LIMIT 5

