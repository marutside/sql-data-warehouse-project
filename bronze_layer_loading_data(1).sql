/* Now we extract the erp csv data USING the My SQL */

CREATE TABLE bronze.erp_cust_az12 (
	cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE bronze.erp_loc_a101 (
cid VARCHAR(50),
cntry VARCHAR(50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
	id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);

SHOW TABLES IN bronze;l