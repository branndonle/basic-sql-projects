USE restaurant_db;
-- Objective 1:

-- 1. View the menu_items table
SELECT * 
FROM restaurant_db.menu_items;

-- 2. Find the number of items on the menu.
SELECT COUNT(*)
FROM restaurant_db.menu_items;

-- 3. What are the least and most expensive items on the menu?
SELECT *
FROM restaurant_db.menu_items
ORDER BY price ASC;

SELECT *
FROM restaurant_db.menu_items
ORDER BY price DESC;

-- 4. How many Italian dishes are on the menu?
SELECT COUNT(*)
FROM restaurant_db.menu_items
WHERE category LIKE 'Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?
SELECT *
FROM restaurant_db.menu_items
WHERE category LIKE 'Italian'
ORDER BY price;

SELECT *
FROM restaurant_db.menu_items
WHERE category LIKE 'Italian'
ORDER BY price DESC;

-- 6. How many dishes are in each category?
SELECT category, COUNT(menu_item_id) AS num_dishes
FROM restaurant_db.menu_items
GROUP BY category;

-- 7. What is the average dish price within each category?
SELECT category, AVG(price) as avg_price
FROM restaurant_db.menu_items
GROUP BY category;

