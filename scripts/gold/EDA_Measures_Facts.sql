
-- High level view of sales data
select 'Total $ Sales' as meausure_name, sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'Total Items Sold' as meausure_name, sum(quantity) as measure_value from gold.fact_sales
union all
select 'Average Price' as meausure_name, round(avg(sales_amount),2) as measure_value from gold.fact_sales
union all
select 'Total # Orders' as meausure_name, count(distinct order_number) as measure_value from gold.fact_sales
union all
select 'Total # Products' as meausure_name, count(distinct product_name) as measure_value from gold.dim_products
union all
select 'Total # Customers' as meausure_name, count(distinct customer_id) as measure_value from gold.dim_customers
union all
select 'Total # Customers w/ Orders' as meausure_name, count(distinct customer_key) as measure_value from gold.fact_sales
;
