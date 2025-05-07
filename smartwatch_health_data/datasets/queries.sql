SELECT * 
FROM smartwatch_data;

ALTER 
--------------------------------------------------------Descriptive Questions--------------------------------------------------------

-- How many unique users are there in this dataset?
SELECT COUNT(DISTINCT(user_id))
FROM smartwatch_data;

-- What’s the average heart rate across all records?
SELECT ROUND(CAST(AVG(heart_rate) AS DECIMAL(10,2)), 2) AS avg_heartrate
FROM smartwatch_data;

-- What is the average stress level?
SELECT ROUND(AVG(stress_level), 0) AS stress_level
FROM smartwatch_data;

-- What are the minimum and maximum stress levels recorded?
SELECT MIN(stress_level) AS min_stress, MAX(stress_level) AS max_stress
FROM smartwatch_data;

-- How many total records are there in the dataset?
SELECT COUNT(*)
FROM smartwatch_data;

-- What’s the most common activity level?
SELECT activity_level
FROM smartwatch_data
GROUP BY activity_level
HAVING COUNT(activity_level) > 5

-- How many unique activity levels are there?
SELECT COUNT(DISTINCT(activity_level))
FROM smartwatch_data;

---------------------------------------------------End of Descriptive Questions-----------------------------------------------------



-------------------------------------------------- Aggregate Analysis ----------------------------------------------------------


-- What is the average sleep duration grouped by activity level?
SELECT activity_level, ROUND(CAST(AVG(sleep_duration) AS DECIMAL (10, 2)), 2) AS avg_sleep 
FROM smartwatch_data
GROUP BY activity_level;

-- How do stress levels vary with sleep duration?
SELECT sleep_duration,  ROUND(AVG(stress_level)) AS avg_stress
FROM smartwatch_data
GROUP BY sleep_duration, stress_level
ORDER BY sleep_duration ASC;

-- Which users are most physically active based on step count totals?
SELECT user_id, ROUND(CAST(SUM(step_count) AS DECIMAL (10,2)))AS total_steps
FROM smartwatch_data
GROUP BY user_id
ORDER BY total_steps DESC;

-- What is the distribution of heart rates across different activity levels?
SELECT activity_level, AVG(heart_rate) AS avg_hr
FROM smartwatch_data
GROUP BY activity_level;

-- How does blood oxygen level vary among users?
SELECT user_id, AVG(blood_oxygen_level) AS avg_blood_oxygen_levels
FROM smartwatch_data
GROUP BY user_id
ORDER BY avg_blood_oxygen_levels DESC;

SELECT MIN(blood_oxygen_level) AS min_oxygen, MAX(blood_oxygen_level) AS max_oxygen,  AVG(blood_oxygen_level) AS avg_oxygen
FROM smartwatch_data;


---------------------------------------------------End of Aggregate Analysis------------------------------------------------------



---------------------------------------------------Comparative/Behavioral Questions-----------------------------------------------

-- Do highly active users sleep more or less than sedentary users?
SELECT activity_level, AVG(sleep_duration) as avg_sleep
FROM smartwatch_data
GROUP BY activity_level; 

-- Is there a trend between low sleep and high stress?
SELECT
	FLOOR(sleep_duration) AS sleep_bucket, 
	ROUND(CAST(AVG(stress_level) AS DECIMAL (10,2))) AS avg_stress,  
	ROUND(CAST(AVG(heart_rate) AS DECIMAL (10,2))) AS avg_hr,
	ROUND(CAST(AVG(blood_oxygen_level) AS DECIMAL (10,2))) AS avg_bol
FROM smartwatch_data
GROUP BY sleep_bucket
ORDER BY sleep_bucket;

-- Which users show consistently high or low heart rate values?
SELECT user_id, ROUND(CAST(AVG(heart_rate) AS DECIMAL (10, 2)), 2) AS avg_hr
FROM smartwatch_data
GROUP BY user_id
HAVING AVG(heart_rate) > 100
	OR AVG(heart_rate) < 80
ORDER BY avg_hr

-- Do users with low blood oxygen levels also have higher stress? N/A
SELECT
	user_id,
	CASE
		WHEN blood_oxygen_level < 90 THEN 'Low'
		WHEN blood_oxygen_level  BETWEEN 90 AND 95 THEN 'Moderate'
		WHEN blood_oxygen_level > 95 THEN 'High'
	END AS oxygen_category, 
	ROUND(CAST(AVG(stress_level) AS DECIMAL (10,2))) AS avg_stress
FROM smartwatch_data
WHERE blood_oxygen_level < 90
GROUP BY user_id, oxygen_category
ORDER BY avg_stress DESC;

---------------------------------------------------End of Comparative/Behavioral Questions----------------------------------------


