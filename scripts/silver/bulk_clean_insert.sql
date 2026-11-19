--//-----------------------------------
--//Cleans raw data from each table and inserts into silver schema
--//-----------------------------------
--Inserts the corrected data and removes the bad data from the raw table to a new silver table
insert into silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
select cst_id,
        replace(cst_key, ' ', '') as cst_key,
        replace(cst_firstname, ' ', '') as cst_firstname,
        replace(cst_lastname, ' ', '') as cst_lastname,
        case when upper(trim(cst_marital_status)) = 'M' then 'Married' when upper(cst_marital_status) = 'S' then 'Single' else 'N/A' end as cst_marital_status,
        case when upper(trim(cst_gndr)) = 'M' then 'Male' when upper(cst_gndr) = 'F' then 'Female' else 'N/A' end as cst_gndr,
       cst_create_date
from (select
          *,
    row_number() over (partition by cst_id order by cst_create_date desc) as dup
from bronze.crm_cust_info) as rn --ranks the cst_id by recent date; 1 is most recent, used to filter
where dup = 1 AND cst_id is not null;
