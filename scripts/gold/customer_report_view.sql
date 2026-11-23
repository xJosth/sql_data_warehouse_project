--Gives a customer to customer overview with data about sales, orders, monthly spend, segmentation, and products
create or replace view gold.report_customers as
(
with customer_metrics as
         (select c.customer_key,
                 c.first_name || ' ' || c.last_name                            as customer_name,
                 c.gender,
                 c.country,
                 extract(year from age(max(s.order_date), min(s.order_date))) * 12 +
                 extract(month from age(max(s.order_date), min(s.order_date))) as lifespan_months,
                 case
                     when extract(year from age(max(s.order_date), min(s.order_date))) * 12 +
                          extract(month from age(max(s.order_date), min(s.order_date))) >= 12 and
                          sum(s.sales_amount) > 5000 then 'VIP'
                     when extract(year from age(max(s.order_date), min(s.order_date))) * 12 +
                          extract(month from age(max(s.order_date), min(s.order_date))) >= 12 and
                          sum(s.sales_amount) <= 5000 then 'Regular'
                     else 'New'
                     end                                                       as customer_segment,
                 sum(s.sales_amount)                                           as total_sales,
                 count(distinct s.order_number)                                as total_orders,
                 sum(s.quantity)                                               as total_quantity_purchased,
                 count(distinct s.product_key)                                 as total_products,
                 extract(year from age(now(), max(s.order_date))) * 12 +
                 extract(month from age(now(), max(s.order_date)))             as last_ordered_months_ago
          from gold.fact_sales as s
                   left join gold.dim_customers as c on s.customer_key = c.customer_key
          where s.order_date is not null
          group by c.customer_key, customer_name, c.gender, c.country)

select customer_key,
       customer_name,
       gender,
       country,
       lifespan_months,
       total_sales,
       case
           when total_orders = 0 then 0
           else total_sales / total_orders
           end as avg_order_value,
       case
           when lifespan_months = 0 then 0
           else round(total_sales / lifespan_months, 2)
           end as avg_monthly_spend,
       total_orders,
       total_quantity_purchased,
       total_products,
       last_ordered_months_ago
from customer_metrics
order by customer_key
    );
