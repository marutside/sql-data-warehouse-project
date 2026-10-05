/* I'm going to start working on a project called SQL DATAWAREHOUSE project*/

CREATE DATABASE datawarehouse;
use datawarehouse;

/* Now creating schema so that i can organize the datasets and work
smoothly without getting confused */

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

/* First I'have to make a table that store the data constraints */

CREATE TABLE bronze.crm_cust_info (
	crm_cust_id INT,
    crm_cust_key VARCHAR(50),
    crm_cust_firstname VARCHAR(50),
    crm_cust_lastname VARCHAR(50),
    crm_cust_marital_status VARCHAR(50),
    crm_cust_gndr VARCHAR(50),
    crm_cust_create_date DATE 
);
 
/* Now we are going to write the second table constraints */

CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key VARCHAR(50),
    prd_name VARCHAR(50),
    prd_cost INT,
	prd_line VARCHAR(50),
    prd_startdate DATE,
    prd_enddate DATE  
);


/* to view the column of the table use this */
DESCRIBE bronze.crm_cust_info;

/* check which folder has been alloted to import or export the data*/
SHOW VARIABLES LIKE 'secure_file_priv';

/* Now we are going to add the csv file to the crm_cust_info */

/* @ this is used to specify that we are going to work on this variable
and NULLIF is used if there are two same value then value will be the null
----field are terminated by comma and the desination of the csv file is
crm_cust_info */

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_INFO.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@crm_cust_id, crm_cust_key, crm_cust_firstname, crm_cust_lastname, crm_cust_marital_status, crm_cust_gndr, @crm_cust_create_date)
SET
    crm_cust_id = NULLIF(@crm_cust_id, ''),
    crm_cust_create_date = NULLIF(@crm_cust_create_date, '');

/* creating the table before loading the data in the dataset*/


CREATE TABLE crm_prd_info (
	prd_id INT,
	prd_key VARCHAR(50),
    prd_name VARCHAR(50),
    prd_cost INT,
	prd_line VARCHAR(50),
    prd_startdate DATE,
    prd_enddate DATE  
);

/* Now loading the data of product into the Schema Bronze */
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS

(prd_id, prd_key, prd_name,  @prd_cost, prd_line, prd_startdate, @prd_enddate)
SET 
	prd_cost = NULLIF(@prd_cost , ''),
    prd_enddate = NULLIF(@prd_enddate, '');
    
/* Now we are going to get the data of the third csv Sales Details */

/* first create the table using bronze so that store the raw data */
DROP TABLE bronze.crm_sales_detail;
CREATE TABLE bronze.crm_sales_detail (
	sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_shiping_dt DATE,
    sls_due_date DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT 
);


/* This table is created to store the data from the */
DROP TABLE crm_sales_detail;

CREATE TABLE crm_sales_detail (
	sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_shiping_dt DATE,
    sls_due_date DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT 
);


/* Now loading the csv file into the and extracting the 
data and saving to the destination at crm_sales_deatils*/

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_detail
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS


(sls_ord_num, sls_prd_key, @sls_cust_id, @sls_order_dt, sls_shiping_dt,
sls_due_date, @sls_sales, sls_quantity, @sls_price)

SET 
	sls_cust_id =NULLIF(@sls_cust_id , ''),
    sls_order_dt = 
    CASE WHEN LENGTH(@sls_order_dt) < 8 THEN NULL
        ELSE @sls_order_dt
	END ,
	sls_sales = NULLIF(@sls_sales , ''),
    sls_price = NULLIF(@sls_price , '');
    
describe bronze.crm_sales_detail;

SELECT * FROM bronze.crm_sales_detail;



