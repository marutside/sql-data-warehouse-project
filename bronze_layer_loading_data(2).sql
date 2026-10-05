/* We have to create the another table so that we can store the
data using this table
the table we have created using the bronze. it is like a table
in the schema and this table hold the actual data */

CREATE TABLE erp_cust_az12 (
	cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE erp_loc_a101 (
cid VARCHAR(50),
cntry VARCHAR(50)
);

CREATE TABLE erp_px_cat_g1v2 (
	id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
); 

S