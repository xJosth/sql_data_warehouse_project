                                    create or replace procedure bronze.load_bronze()
                                         language plpgsql
                                     as
                                     $$
                                     begin
                                         raise notice '=====================';
                                         raise notice 'Loading Bronze Layer';
                                         raise notice '=====================';
                                     
                                         raise notice '=====================';
                                         raise notice 'Loading CRM Tables';
                                         raise notice '=====================';
                                     
                                     
                                         raise notice '>>>Truncating Table bronze.crm_cust_info';
                                         truncate table bronze.crm_cust_info;
                                     
                                         raise notice '>>>Copying Data To Table bronze.crm_cust_info';
                                         copy bronze.crm_cust_info
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_crm\cust_info.csv'
                                         with (format csv, header true);
                                     
                                         raise notice '>>>Truncating Table bronze.crm_prd_info';
                                         truncate table bronze.crm_prd_info;
                                     
                                         raise notice '>>>Copying Data To Table bronze.crm_prd_info';
                                         copy bronze.crm_prd_info
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_crm\prd_info.csv'
                                         with (format csv, header true);
                                     
                                         raise notice '>>>Truncating Table bronze.crm_sales_details';
                                         truncate table bronze.crm_sales_details;
                                     
                                         raise notice 'Copying Data To Table bronze.crm_sales_details';
                                         copy bronze.crm_sales_details
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_crm\sales_details.csv'
                                         with (format csv, header true);
                                     
                                         raise notice '=====================';
                                         raise notice 'Loading ERP Tables';
                                         raise notice '=====================';
                                     
                                         raise notice '>>>Truncating Table bronze.erp_cust_az12';
                                         truncate table bronze.erp_cust_az12;
                                     
                                         raise notice 'Copying Data To Table bronze.erp_cust_az12';
                                         copy bronze.erp_cust_az12
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_erp\CUST_AZ12.csv'
                                         with (format csv, header true);
                                     
                                         raise notice '>>>Truncating Table bronze.erp_loc_a101';
                                         truncate table bronze.erp_loc_a101;
                                     
                                         raise notice 'Copying Data To Table bronze.erp_loc_a101';
                                         copy bronze.erp_loc_a101
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_erp\LOC_A101.csv'
                                         with (format csv, header true);
                                     
                                         raise notice '>>>Truncating Table bronze.erp_px_cat_g1v2';
                                         truncate table bronze.erp_px_cat_g1v2;
                                     
                                         raise notice 'Copying Data To Table bronze.erp_px_cat_g1v2';
                                         copy bronze.erp_px_cat_g1v2
                                         from 'C:\Users\Public\sql-data-warehouse-project-main\01_datasets\source_erp\PX_CAT_G1V2.csv'
                                         with (format csv, header true);
                                     end;
                                     $$
