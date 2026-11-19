//-------------------
//INSERTING CLEANED DATA INTO SILVER TABLE
//-------------------

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

//-------------------
//DUPLICATE AND NULL CHECKS FOR KEY COLUMN
//-------------------

-- find nulls and duplicate cst_id (customer ids) in the raw table
select
    count(*),
    cst_id
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- displays the rows with duplicate cst_id or null id
select
   *
from bronze.crm_cust_info
where cst_id in (select
    cst_id
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null) OR cst_id is null
;

-- displays all rows that are not null and most recent version of the cst_id
-- USE FROM SUBQUERY WHEN INSERTING
select
   *
from (select
          *,
    row_number() over (partition by cst_id order by cst_create_date desc) as dup
from bronze.crm_cust_info) as rn --ranks the cst_id by recent date; 1 is most recent, used to filter
where dup = 1 AND cst_id is not null
;

-- checks to see if the cleaned up data is actually rid of dups and nulls; should return nothing if true.
-- just combines the first query with the last
select
    count(*),
    cst_id
from (select
           *
        from (select
                  *,
            row_number() over (partition by cst_id order by cst_create_date desc) as dup
     from bronze.crm_cust_info) as rn
where dup = 1 AND cst_id is not null) as chec
group by cst_id
having count(*) > 1 or cst_id is null;

//-------------------
//TEXT ROW VALUE CHECKS; SPACES & RENAMING
//-------------------
--Checking if there are extra spaces in each column, should return nothing if true
select
    *
from bronze.crm_cust_info
where   cst_key != replace(cst_key, ' ', '') or
        cst_firstname != replace(cst_firstname, ' ', '') or
        cst_lastname != replace(cst_lastname, ' ', '');

--Checking cst_marital_status and cst_gender to see if the values are consistent, should return nothing if true
select distinct
    cst_marital_status,
    cst_gndr
from bronze.crm_cust_info;
-- where cst_marital_status not in('M','S') OR cst_gndr not in ('M', 'F');

--Corrected full table without any extra spaces, with full word labeling for low cardinality columns
--USE SELECT STATEMENT WHEN INSERTING
select cst_id,
        replace(cst_key, ' ', '') as cst_key,
        replace(cst_firstname, ' ', '') as cst_firstname,
        replace(cst_lastname, ' ', '') as cst_lastname,
        case when upper(trim(cst_marital_status)) = 'M' then 'Married' when upper(cst_marital_status) = 'S' then 'Single' else 'N/A' end as cst_marital_status,
        case when upper(trim(cst_gndr)) = 'M' then 'Male' when upper(cst_gndr) = 'F' then 'Female' else 'N/A' end as cst_gndr,
       cst_create_date
from bronze.crm_cust_info;
