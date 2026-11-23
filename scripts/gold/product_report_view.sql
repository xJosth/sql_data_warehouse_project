create or replace view gold.report_products as
(
with base as
(
select
    p.product_name,
    p.category,
    p.subcategory,
    p.cost,
    sum(s.sales_amount) as total_sales,
    count(distinct s.order_number) as total_orders,
    sum(s.quantity) as total_quantity,
    count(distinct s.customer_key) as total_customers,
    extract(year from age(now(),max(p.start_date)))*12 + extract(month from age(now(),max(p.start_date))) as lifespan,
    max(s.order_date) as last_sale
from gold.fact_sales as s
left join  gold.dim_products as p on s.product_key = p.product_key
where order_date is not null
group by p.product_name, p.category, p.subcategory, p.cost
order by total_sales desc
)

select
    product_name,
    category,
    subcategory,
    cost,
    case
        when total_sales >= 360000 then 'High Performer'
        when total_sales <25000 then 'Low Performer'
        else 'Mid Range'
    end as product_segment,
    total_sales,
    total_orders,
    case when total_orders = 0  then 0
        else round(total_sales/total_orders,2)
    end as avg_order_revenue,
    case when lifespan = 0 then total_sales
        else  round(total_sales/lifespan,2)
    end as avg_monthly_revenue,
    total_quantity,
    total_customers,
    extract(year from age(now(),last_sale))*12 + extract(month from age(now(),last_sale)) as recency,
    lifespan
from base
);
