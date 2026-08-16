--SQL Retail Sales Analysis - P1
create database sql_project_p2;

--Create tables
create table retail_sales(
			transactions_id int primary key,
			sale_date date,
			sale_time time,
			customer_id	int,
			gender varchar(20),
			age int,
			category varchar(30),
			quantiy varchar(20),
			price_per_unit float,
			cogs float,
			total_sale float
);

select * from retail_sales limit 100;

select count(*) from retail_sales;

--data cleaning
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

--
delete from retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

select count(*) from retail_sales;

--data exploration

--how many sales we have

select count(*) as total_sales from retail_sales;

--how many cusyomer we have

select count(distinct customer_id) as total_sales from retail_sales;

select distinct category from retail_sales;

--data analysis & business key problems & answers

--1. write a sql query to retrive all column for sales made on '2022-11-05'

select * 
from retail_sales
where sale_date= '2022-11-05';

--2. write a sql query to retrieve all transaction where the category is 'clothing' and the quantity sold is more than 10 in the month of nov-2022

select *
from retail_sales
where 
	category = 'Clothing'
	and 
	to_char(sale_date,'YYYY-MM') = '2022-11'
	and
	quantity >= 4;

--3. write a sql query to calculate the total sales (total_sales) for each category

select 
	category,
	sum(total_sale) as net_sales,
	count(*) as total_orders
from retail_sales
group by 1;

--4. write a sql query to find the average age of customers who purchased items from the 'Beauty' category
select round(avg(age),2) as Avg_age
from retail_sales
where category='Beauty';

--5. write a sql query to find all transactions where the total_sales is greater than 1000.

select *
from retail_sales
where total_sale >=1000;

--6. write a sql query to find the total number of transactions (transaction_id) made by each gender in each category

select 
	gender,
	category,
	count(transactions_id) as total_id
from retail_sales
group by 1,2
order by 2;

--7. write a sql query to calculate the average sale for each month. find out best selling month in each year

select 
	year,
	month,
	avg_total_sales
from
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_total_sales,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
)as t1
where rank=1;
--order by 1,3 desc;

--8. write a sql query to find the top 5 custmers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--9. write a sql query to find the number of unique customers who purchased items from each category

select 
	category,
	count(distinct customer_id) as unique_customer
from retail_sales
group by 1;

--10. write a sql query to create each shifted and number of orders (Example morning <=12, afternoon between 12 & 17, evening > 17)

with hourly_sales
as
(
select *,
	case
		when extract(hour from sale_time) <12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Aftertoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sales
group by 1;



