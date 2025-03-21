CREATE DATABASE sql_project_p2;


-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender	VARCHAR(15),
		age INT,
		category VARCHAR(15),	
		quantity INT,
		price_per_unit	FLOAT,
		cogs FLOAT,	
		total_sale FLOAT
	);

SELECT * FROM retail_sales
LIMIT 10


SELECT 
	COUNT(*) 
FROM retail_sales


-- Data Cleaning 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL

--

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	category IS NULL
	OR 
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR 
	cogs IS NULL 
	OR 
	total_sale IS NULL

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale from retail_sales

-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_customer from retail_sales

-- How many categories we have?
SELECT DISTINCT category from retail_sales

-- Data analysis & Business Key Problems and Answers?


-- 1. write a sql query to retrieve all columns for sales made on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of nov-2022 
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND 
	quantity >= 4

-- 3. write a sql query to  calculate the total sales (total_sale) for each category.
Select 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

-- 4. write a sql query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) as ave_age
from retail_sales 
WHERE category = 'Beauty'

-- 5. write a sql query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales 
where total_sale > 1000

-- 6. write a sql query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, 
	   gender,
	   COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY 1

-- 7. write a sql query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	from retail_sales
	GROUP BY 1, 2
)
WHERE rank = 1
--ORDER BY 1, 3 DESC

-- 8. write a sql query to find the top 5 customers based on the highest total sale
SELECT 
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9. write a sql query to find the number of unique customers who purchased itms from each category.
SELECT 
	category,
	COUNT(DISTINCT(customer_id)) as unique_customers
FROM retail_sales
GROUP BY category


-- 10. write a sql query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening > 17)
WITH hourly_sale
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift


-- END OF PROJECT