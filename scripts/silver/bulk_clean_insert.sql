--//-----------------------------------
--//Cleans raw data from each table and inserts into silver schema
--//-----------------------------------

--Inserts the corrected data and removes the bad data from the raw table to a new silver crm_cust_info table
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


--Inserts the corrected data and removes the bad data from the raw table to a new silver crm_prd_info table
insert into silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
select
    prd_id,
    replace(substring(prd_key,1,5) ,'-','_') as cat_id,
    substring(prd_key,7,length(prd_key)-6) as prd_key,
    prd_nm,
    coalesce(prd_cost,0) as prd_cost,
    case upper(trim(prd_line))
        when 'M'then 'Mountain'
        when 'R' then 'Road'
        when 'S' then 'Other Sales'
        when 'T' then 'Touring'
        else 'N/A'
    end as prd_line,
    prd_start_dt,
    lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) -1 as prd_end_dt
from bronze.crm_prd_info;


