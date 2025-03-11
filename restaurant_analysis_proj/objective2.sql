-- Objective 2:

-- 1. View the order_details table. 
SELECT * 
FROM restaurant_db.order_details;

-- 2.What is the date range of the table?
SELECT MIN(order_date), MAX(order_date)
FROM restaurant_db.order_details;

-- 3. How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id)
FROM restaurant_db.order_details;

-- 4. How many items were made within this date range?
SELECT COUNT(*)
FROM restaurant_db.order_details;

-- 5. Which orders had the most number of items?
SELECT order_id, COUNT(item_id) AS num_items
FROM restaurant_db.order_details
GROUP BY order_id
ORDER BY num_items DESC;

-- 6. How many orders had more than 12 items? 
SELECT COUNT(*) 
FROM (SELECT order_id, COUNT(item_id) AS num_items
FROM restaurant_db.order_details
GROUP BY order_id
HAVING num_items > 12) AS num_orders;

-- The query below creates a table that show cases the orders that have more than 12 items. But we want the total number of all orders that have more than 12 items in their order, which is what this query does ^^.
-- SELECT order_id, COUNT(item_id) AS num_items
-- FROM restaurant_db.order_details
-- GROUP BY order_id
-- HAVING num_items > 12) AS num_orders;



