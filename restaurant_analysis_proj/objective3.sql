-- Objective 3: Analyze customer behavior

-- 1. Combine the menu_items and order_details tables into a single table

-- When combining tables, first, typically you want to list the transaction table when using a LEFT join. In this case, it would be details about what happened or in this case, every sales that happened.
-- Add the tranasaction table first --> Then add the lookup information/details
SELECT *
FROM restaurant_db.order_details od 
LEFT JOIN restaurant_db.menu_items mi
	ON restaurant_db.od.item_id = restaurant_db.mi.menu_item_id;

-- 2. What were the least and most ordered items? What were they categorized in?
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM restaurant_db.order_details od 
LEFT JOIN restaurant_db.menu_items mi
	ON restaurant_db.od.item_id = restaurant_db.mi.menu_item_id
GROUP BY item_name, category
ORDER BY num_purchases;

-- 3. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spent
FROM restaurant_db.order_details od 
LEFT JOIN restaurant_db.menu_items mi
	ON restaurant_db.od.item_id = restaurant_db.mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC
LIMIT 5;

-- 4. View the details of the highest spent order. What insights can you gather from the results?
SELECT category, COUNT(item_id) AS num_items
FROM restaurant_db.order_details od 
LEFT JOIN restaurant_db.menu_items mi
	ON restaurant_db.od.item_id = restaurant_db.mi.menu_item_id
WHERE order_id = 440
GROUP BY category;

-- 5. View the total details of the top 5 highest spent orders. What insights can you gather from the results?
SELECT order_id, category, COUNT(item_id) AS num_items
FROM restaurant_db.order_details od 
LEFT JOIN restaurant_db.menu_items mi
	ON restaurant_db.od.item_id = restaurant_db.mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category;

-- Insights gathered is that we should keep these expensive Italian dishes on the menu because people seem to be ordering them a lot. Especially our highest spending customers.
