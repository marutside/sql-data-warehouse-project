/* Create Stored Procedure */

DROP PROCEDURE IF EXISTS silver.load_silver;

DELIMITER $$

CREATE PROCEDURE silver.load_silver()
 
BEGIN

/* Describing the variable we are going to use
to get the time difference */
DECLARE start_time DATETIME;
DECLARE end_time DATETIME;
DECLARE batch_start_time DATETIME;
DECLARE batch_end_time DATETIME;
DECLARE duration DATETIME;
/* =====================================================
   TABLE 1: CRM_CUST_INFO
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info (
    crm_cust_id,
    crm_cust_key,
    crm_cust_firstname,
    crm_cust_lastname,
    crm_cust_marital_status,
    crm_cust_gndr,
    crm_cust_create_date
)
SELECT
    crm_cust_id,
    crm_cust_key,
    TRIM(crm_cust_firstname),
    TRIM(crm_cust_lastname),
    CASE
        WHEN UPPER(TRIM(crm_cust_marital_status)) = 'M' THEN 'MARRIED'
        WHEN UPPER(TRIM(crm_cust_marital_status)) = 'S' THEN 'SINGLE'
        ELSE 'n/a'
    END,
    CASE
        WHEN UPPER(TRIM(crm_cust_gndr)) = 'F' THEN 'FEMALE'
        WHEN UPPER(TRIM(crm_cust_gndr)) = 'M' THEN 'MALE'
        ELSE 'n/a'
    END,
    crm_cust_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY crm_cust_id
               ORDER BY crm_cust_create_date DESC
           ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE crm_cust_id IS NOT NULL
) t
WHERE flag_last = 1;
SET end_time = NOW();

SET duration =  TIMEDIFF(end_time , start_time);

SELECT duration AS crm_cust_info_load_time;
/* =====================================================
   TABLE 2: CRM_SALES_DETAIL
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.crm_sales_detail;

INSERT INTO silver.crm_sales_detail (
    crm_sls_num,
    crm_sls_key,
    crm_sls_cust_id,
    crm_sls_order_dt,
    crm_sls_shiping_dt,
    crm_sls_date,
    crm_sls_sales,
    crm_sls_quantity,
    crm_sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_shiping_dt,
    sls_due_date,

    CASE
        WHEN sls_sales IS NULL
             OR sls_sales <= 0
             OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END,

    sls_quantity,

    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END

FROM bronze.crm_sales_detail;
SET end_time = NOW();
SET duration =  TIMEDIFF(end_time , start_time);
SELECT duration AS crm_sales_detail_load_time;
/* =====================================================
   TABLE 3: CRM_PRD_INFO
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_name,
    prd_cost,
    prd_line,
    prd_startdate,
    prd_enddate
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_name,
    IFNULL(prd_cost, 0) AS prd_cost,

    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'MOUNTAIN'
        WHEN 'R' THEN 'ROAD'
        WHEN 'S' THEN 'OTHER SALES'
        WHEN 'T' THEN 'TOURING'
        ELSE 'n/a'
    END AS prd_line,

    prd_startdate,

    LEAD(prd_startdate) OVER (
        PARTITION BY prd_key
        ORDER BY prd_startdate
    ) - INTERVAL 1 DAY AS prd_enddate

FROM bronze.crm_prd_info;
SET end_time = NOW();
SET duration =  TIMEDIFF(end_time , start_time);
SELECT duration AS crm_prd_info_load_time;
/* =====================================================
   TABLE 4: ERP_CUST_AZ12
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT

    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
        ELSE cid
    END AS cid,

    CASE
        WHEN bdate > NOW() THEN NULL
        ELSE bdate
    END AS bdate,

    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'FEMALE'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'MALE'
        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12;
SET end_time = NOW();
SET duration =  TIMEDIFF(end_time , start_time);
SELECT duration AS erp_cust_az12_load_time;
/* =====================================================
   TABLE 5: ERP_LOC_A101
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT

    REPLACE(cid, '-', '') AS cid,

    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry

FROM bronze.erp_loc_a101;
SET end_time = NOW();
SET duration =  TIMEDIFF(end_time , start_time);
SELECT duration AS erp_loc_a101_load_time;
/* =====================================================
   TABLE 6: ERP_PX_CAT_G1V2
   ===================================================== */
SET start_time = NOW();
TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;
SET end_time = NOW();
SET duration =  TIMEDIFF(end_time , start_time);
SELECT duration AS erp_px_cat_g1v2_load_time;
/* show all six tables */


SELECT * FROM silver.crm_cust_info;
SELECT * FROM silver.crm_sales_detail;
SELECT * FROM silver.crm_prd_info;
SELECT * FROM silver.erp_cust_az12;
SELECT * FROM silver.erp_loc_a101;
SELECT * FROM silver.erp_px_cat_g1v2;


END $$

DELIMITER ;