-- sql retail sales analysis - p1
CREATE DATABASE sql_project_p1;

-- CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
               transactions_id	INT,
               sale_date DATE,	
               sale_time TIME,	
               customer_id	INT,
               gender VARCHAR(15),	
               age	INT,
               category	VARCHAR(15),
               quantiy	INT,
               price_per_unit	FLOAT,
               cogs	FLOAT,
               total_sale FLOAT
);
SELECT*FROM retail_sales
LIMIT 100;

SELECT COUNT(*)
FROM retail_sales;

-- DATA CLEANING

SELECT*FROM retail_sales
WHERE transactions_id IS NULL;

SELECT*FROM retail_sales
WHERE sale_date IS NULL;

SELECT*FROM retail_sales
WHERE sale_time IS NULL;

SELECT*FROM retail_sales
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
    age IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
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
    age IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- DATA EXPLORATION

-- How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- How many customers we have?
SELECT COUNT( DISTINCT customer_id) AS total_sales FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS & BUSINESS KEY & ANSWERS
-- My analysis&findings
-- Q.1 Write a sql query to retrive all columns for sales made on '2022-11-05
-- Q.2 Write a sql query to retrive all transactions where the category is 'clothing' and the quantiy sold is more than 4 in the month of NOV-2022
-- Q.3 Write a sql query to calculate the total sales (total_sales) for each category
-- Q.4 Write a sql query to find the average age of customers who purchased items from the 'Beauty' category
-- Q.5 Write a sql query to find all transactions where the total_sale is greater than 1000
-- Q.6 Write a sql query to find the total number of transactions (transaction_id) made by each gender in each category
-- Q.7 Write a sql query to calculate the average sale for each month.Find out best selling onth month in each year
-- Q.8 Write a sql query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a sql query to find the number of unique customers who purchased items for each category
-- Q.10 Write a sql query to create each shift and number of orders (Example Morning<=12, Afternoon between 12&17, Evening>17)


 -- Q.1 Write a sql query to retrive all columns for sales made on '2022-11-05  
 SELECT*
 FROM retail_sales
 WHERE sale_date = '2022-11-05';
 
--  Q.2 Write a sql query to retrive all transactions where the category is 'clothing' and the quantiy sold is more than 4 in the month of NOV-2022
SELECT*
FROM retail_sales
WHERE 
   category='clothing' 
   AND
   DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
   AND 
   quantiy>=4;


-- Q.3 Write a sql query to calculate the total sales (total_sales) for each category
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;


-- Q.4 Write a sql query to find the average age of customers who purchased items from the 'Beauty' category
SELECT
    ROUND(AVG(age),2) AS avg_age
FROM retail_sales
    WHERE category='Beauty';


--  Q.5 Write a sql query to find all transactions where the total_sale is greater than 1000

SELECT*FROM retail_sales
WHERE total_sale > 1000;


-- Q.6 Write a sql query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
    category,
    gender
ORDER BY 1;


-- Q.7 Write a sql query to calculate the average sale for each month.Find out best selling onth month in each year
SELECT
    year,
    month,
    avg_sale
FROM(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY (YEAR (sale_date)) ORDER BY AVG(total_sale) DESC) AS sale_rank
FROM retail_sales
GROUP BY 1,2
)AS t1
WHERE sale_rank=1;
-- ORDER BY 1,3 DESC;


-- Q.8 Write a sql query to find the top 5 customers based on the highest total sales 
SELECT
    customer_id,
    SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Write a sql query to find the number of unique customers who purchased items for each category
SELECT
   category,
   COUNT(DISTINCT customer_id) AS cun_unq_id
FROM retail_sales
GROUP BY category;


-- Q.10 Write a sql query to create each shift and number of orders (Example Morning<=12, Afternoon between 12&17, Evening>17)
WITH hourly_sale 
AS
(
SELECT*,
   CASE
      WHEN HOUR(sale_time) <12 THEN 'morning'
      WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'evening'
	END AS shift
FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

