/* Now we are going to load the data of the CSV file */

DESCRIBE erp_cust_az12;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(@cid, @bdate, @gen)

SET
    cid = NULLIF(@cid, ''),
    bdate = NULLIF(@bdate, ''),
    gen = NULLIF(@gen, '');
    
    
/* Now adding the second table in the erp format we are going to
load that csv into the branch */

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM ERP_LOC_A101;


/* Now loading the last dataset into the database using the 
bronze Schema */

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

