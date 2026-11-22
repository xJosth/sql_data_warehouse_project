--//-------------------------------------
--//Creates the various views to group and analyze the silver layer data
--//-------------------------------------

--//-------------------------------------
--//Creates the dimension views for the customers, products and sales data
--//-------------------------------------

--//Creates the dimension views for the customers data via the silver crm_cust_info, erp_loc_a101, and erp_cust_az12 tables
create or replace view gold.dim_customers as
(
select row_number() over (order by c.cst_id) as customer_key,
       c.cst_id                              as customer_id,
       c.cst_key                             as customer_number,
       c.cst_firstname                       as first_name,
       c.cst_lastname                        as last_name,
       c1.cntry                              as country,
       c.cst_marital_status                  as marital_status,
       case
           when c.cst_gndr = 'N/A' and c2.gen is not null then c2.gen
           when c.cst_gndr != c2.gen or c.cst_gndr = c2.gen then cst_gndr
           else 'N/A'
           end                               as gender,
       c2.bdate                              as birthdate,
       c.cst_create_date                     as create_date
from silver.crm_cust_info as c
         left join silver.erp_loc_a101 as c1 on c.cst_key = c1.cid
         left join silver.erp_cust_az12 as c2 on c.cst_key = c2.cid
    );


--//Creates the dimension views for the product data via the silver crm_prd_info and erp_px_cat_g1v2
create or replace view gold.dim_products as
    (
select
    row_number() over (order by prd_start_dt,p.prd_id) as product_key,
    p.prd_id as product_id,
    p.prd_key as product_number,
    p.prd_nm as product_name,
    p.cat_id as category_id,
    p1.cat as category,
    p1.subcat as subcategory,
    p.prd_line as product_line,
    p.prd_cost as cost,
    p1.maintenance as maintenance,
    p.prd_start_dt as start_date
from silver.crm_prd_info p
left join silver.erp_px_cat_g1v2 as p1 on p.cat_id = p1.id
    where p.prd_end_dt is null --Filters out old data
);
--//-------------------------------------
--//Creates the fact views for the customers, products and sales data
--//-------------------------------------
