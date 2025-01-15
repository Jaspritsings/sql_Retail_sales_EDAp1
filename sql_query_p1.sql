SELECT * FROM public.retail_sales
ORDER BY transactions_id ASC LIMIT 10

select count(*) from retail_sales;

--exploration data analysis
SELECT * FROM public.retail_sales
where transactions_id is null;

--DATA CLEANING
--checking for all different columns
SELECT * FROM retail_sales
where null in(transactions_id, sale_date, sale_time, customer_id, age, gender, category, quantiy, price_per_unit, cogs, total_sale)

alter table retail_sales
rename column quantiy to quantity ;

select * from retail_sales
where age is null
 or sale_date is null
 or sale_time is null
 or customer_id is null
 or category is null
 or quantity is null
 or price_per_unit is null
 or cogs is null
 or total_sale is null;

 --removing null values

  
 delete from retail_sales
where age is null
 or sale_date is null
 or sale_time is null
 or customer_id is null
 or category is null
 or quantity is null
 or price_per_unit is null
 or cogs is null
 or total_sale is null;

 --DATA EXPLORATION

--how many sales we have?
select count(*) as total_sale from retail_sales

 --how many unique customers do we have?
 select count(distinct customer_id) as total_sale from retail_sales

-- unique category
select distinct category from retail_sales

-- DATA ANALYSIS & business key problems
--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

select * from retail_sales
where sale_date = '2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

select *from retail_sales
where category= 'Clothing'
and --to char(___,___) used forn comparison
to_char(sale_date, 'YYYY-MM')= '2022-11'
and quantity >= 4

--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

select category, sum(total_sale) as total_sales,
count(*) as total_orders 
from retail_sales
group by 1; -- group by 1 means grouping by the 1 column in the output i.e the category column

--4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select category, round(avg(age),2) as avg_age from retail_sales
where category='Beauty'
group by category;

--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

select * from retail_sales
where total_sale>= 1000

--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select category, gender, count(*) as total_trans  from retail_sales 
group by category, gender
order by 1;

--7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
select  
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale
from retail_sales
group by 1,2 
order by 1,3 desc

-- using window function -Rank()

select 
year, month, avg_sale from 
(
select  
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)
as rank
from retail_sales
group by 1,2 
) as t1 --table alias t1
where rank=1

 --8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select 
customer_id, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
 select category,count(distinct customer_id) as unique_customer_count from retail_sales
 group by category

--10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

with Hourly_sale
as
(
select *,
case
when extract(hour from sale_time)<12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select 
shift, count(*) as total_orders
from Hourly_sale

--end of project

group by shift