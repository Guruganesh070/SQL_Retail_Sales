-- SQL Retail Sales Analysis

Create database SQL_project1;

-- Creating the Table

Drop table if exists retail_sales;
create table retail_sales
				(
				
				transactions_id int Primary key,
				sale_date date,
				sale_time time,
				customer_id int,
				gender varchar(15),
				age int,
				category varchar(15),
				quantiy int,
				price_per_unit float,
				cogs float,
				total_sale float
				);

select * from retail_sales;


select 
	count(*) 
from retail_sales;

-- Data Cleaning 


alter table retail_sales
rename column quantiy to quantity;

select * from retail_sales
where age is null;

--( Deleting NULL Rows )

delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or 
	cogs is null
	or
	total_sale is null;

-- Exploratory Data Analysis

-- How many Sales we have?

select count(*) as total_sale from retail_sales;

-- How many unique customers we have?

select count(distinct(customer_id)) as Customers from retail_sales;

-- How many categories we have?

select distinct(category) from retail_sales;

select count(distinct(category)) from retail_sales;


-- Data Analysis & Business Problems / Answers


-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

select * from retail_sales
where sale_date = '2022-11-05';


-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

SELECT * 
FROM retail_sales
where category = 'Clothing'
and
to_char (sale_date, 'YYYY-MM') = '2022-11'
and
quantity >= 4;


-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

select 
		category, 
		count(*) as total_orders,
		sum(total_sale) as total_Sales
from retail_sales
group by 1
order by 3 desc;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:


select 
		round(avg(age),2) as Avg_Age
from retail_sales
where category = 'Beauty';


-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

SELECT
		*
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale;


-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

SELECT
		gender,
		category,
		COUNT(transactions_id) as Total_Transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY 2;


-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

select 
		year,
		month,
		avg_sale
from 
(
select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,			
		avg(total_sale) as avg_sale,
		RANK() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = 1;


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT
		customer_id,
		sum(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

SELECT 
		category,
		COUNT(distinct(customer_id))
FROM retail_sales
GROUP BY category
ORDER BY 2 DESC;


-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

WITH hourly_sale as
(
SELECT 
	*,
	CASE
		WHEN EXTRACT ( HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT ( HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift_Time
FROM retail_sales
)

SELECT 
		Shift_Time,
		count(transactions_id) as No_of_Orders
FROM hourly_sale
GROUP BY Shift_Time;

-- End of Project



