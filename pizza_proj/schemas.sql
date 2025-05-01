DROP TABLE IF EXISTS pizza_dataset;
SET datestyle = 'ISO, MDY';

COPY pizza_dataset FROM '/path/to/file.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE pizza_dataset (
	pizza_id INT PRIMARY KEY,
	order_id INT, 
	pizza_name_id VARCHAR(50),
	quantity INT,
	order_date DATE,
	order_time TIME,
	unit_price FLOAT,
	total_price	FLOAT,
	pizza_size VARCHAR(5),
	pizza_category VARCHAR(20),
	pizza_ingredients VARCHAR(100),
	pizza_name VARCHAR(75)
); 
ALTER TABLE pizza_dataset
ALTER COLUMN order_date TYPE TEXT;


CREATE TABLE pizza_dataset_new AS
SELECT * FROM pizza_dataset;


