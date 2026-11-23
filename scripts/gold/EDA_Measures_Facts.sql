
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

--high level view of sales data by country
select
    c.country,
    count(distinct c.customer_number) as total_customers,
    sum(s.sales_amount) as total_sales,
    sum(s.quantity) as total_qualtity,
    count(distinct s.order_number) as total_orders
from gold.dim_customers as c
left join gold.fact_sales as s on c.customer_key = s.customer_key
group by country
order by total_sales desc
;

--# customers by gender
select
    gender,
    count(gender) as total_customers
from gold.dim_customers
group by gender
order by total_customers desc
;

--product info by category
select
    p.category,
    count(distinct p.product_number) as total_products,
    avg(p.cost)::money as avg_cost,
    sum(s.sales_amount)::numeric::money as total_sales
from gold.dim_products as p
left join gold.fact_sales as s on p.product_key = s.product_key
group by category
order by total_sales desc nulls last
;

--sales info by customer
select
    c.customer_number,
    sum(s.sales_amount)::numeric::money as total_revenue
from gold.dim_customers as c
left join gold.fact_sales as s on c.customer_key = s.customer_key
group by c.customer_number
order by total_revenue desc
;
