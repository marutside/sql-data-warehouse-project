# SQL Data Warehouse Project

## 📌 Overview

This project demonstrates the development of an **end-to-end SQL Data Warehouse using MySQL**.

The project focuses on loading raw data from **CRM and ERP source systems**, cleaning and transforming the data, and preparing it for further analysis.

The data warehouse follows a **Medallion-style architecture**, using **Bronze** and **Silver** layers to organize the data transformation process.

---

## 🎯 Project Objectives

* Build a data warehouse using MySQL
* Load raw CRM and ERP data into the Bronze layer
* Clean and transform raw data in the Silver layer
* Handle missing, duplicate, and invalid data
* Standardize inconsistent values
* Perform data quality checks
* Use SQL transformations to prepare clean analytical data
* Implement an automated stored procedure for loading the Silver layer

---

## 🏗️ Data Warehouse Architecture

The project uses the following architecture:

```text
                 SOURCE SYSTEMS
                      │
          ┌───────────┴───────────┐
          │                       │
         CRM                     ERP
          │                       │
          └───────────┬───────────┘
                      │
                      ▼
              ┌───────────────┐
              │ BRONZE LAYER  │
              │  Raw Data     │
              └───────┬───────┘
                      │
                ETL / Cleaning
                      │
                      ▼
              ┌───────────────┐
              │ SILVER LAYER  │
              │ Cleaned Data  │
              └───────────────┘
                      │
                      ▼
              Ready for Analysis
```

---

## 🥉 Bronze Layer

The Bronze layer stores the data in its **raw form**.

The main purpose of this layer is to preserve the original source data before applying transformations.

### CRM Tables

* `crm_cust_info`
* `crm_prd_info`
* `crm_sales_detail`

### ERP Tables

* `erp_cust_az12`
* `erp_loc_a101`
* `erp_px_cat_g1v2`

---

## 🥈 Silver Layer

The Silver layer contains **cleaned and transformed data**.

The following transformations were performed:

### Customer Data

* Removed duplicate customer records
* Kept the latest customer record using `ROW_NUMBER()`
* Removed unnecessary spaces using `TRIM()`
* Standardized marital status
* Standardized gender values

### Product Data

* Transformed product category IDs
* Extracted product keys
* Replaced missing product costs with `0`
* Standardized product line names
* Generated product end dates using `LEAD()`

### Sales Data

* Validated sales amounts
* Corrected invalid or missing sales values
* Corrected invalid prices
* Used `ABS()` to handle negative prices
* Used `NULLIF()` to avoid division-by-zero errors

### ERP Customer Data

* Removed the `NAS` prefix from customer IDs
* Validated birth dates
* Standardized gender values

### ERP Location Data

* Removed hyphens from customer IDs
* Standardized country codes
* Converted country codes such as `DE`, `US`, and `USA` into full country names

---

## 🔄 ETL Process

The project follows an ETL workflow:

```text
Extract
   ↓
Load raw CSV data
   ↓
Bronze Layer
   ↓
Transform
   ↓
Clean and validate data
   ↓
Silver Layer
   ↓
Ready for Analysis
```

---

## 🛠️ Technologies Used

* **MySQL 8.0**
* **MySQL Workbench**
* **SQL**
* **CSV**
* **ETL**
* **Window Functions**
* **Stored Procedures**

---

## 📚 SQL Concepts Used

This project helped practice several important SQL concepts:

* `SELECT`
* `INSERT INTO`
* `TRUNCATE TABLE`
* `CASE`
* `IFNULL()`
* `NULLIF()`
* `TRIM()`
* `UPPER()`
* `REPLACE()`
* `SUBSTRING()`
* `LENGTH()`
* `ABS()`
* `ROW_NUMBER()`
* `LEAD()`
* `PARTITION BY`
* `ORDER BY`
* `OVER()`
* `WHERE`
* `GROUP BY`
* `HAVING`
* Stored Procedures
* Variables
* Date functions
* Data validation

---

## ⚙️ Stored Procedure

A stored procedure was created to automate the Silver-layer loading process.

```sql
CALL silver.load_silver();
```

The procedure:

1. Clears the existing Silver table data
2. Reads data from the Bronze layer
3. Cleans and transforms the data
4. Inserts the transformed data into the Silver layer
5. Displays the resulting Silver tables

This allows the complete Silver-layer ETL process to be executed using a single command.

---

## 📂 Project Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   ├── crm_cust_info.csv
│   ├── crm_prd_info.csv
│   ├── crm_sales_detail.csv
│   ├── erp_cust_az12.csv
│   ├── erp_loc_a101.csv
│   └── erp_px_cat_g1v2.csv
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── procedures/
│
├── docs/
│
└── README.md
```

---

## 🔍 Data Quality Checks

Several data quality checks were performed during the transformation process:

* Duplicate records
* Missing values
* Invalid dates
* Invalid prices
* Invalid sales values
* Inconsistent gender values
* Inconsistent country codes
* Incorrect product categories
* Negative or zero prices
* Invalid customer IDs

---

## 💡 Key Learning Outcomes

Through this project, I gained practical experience in:

* Designing a basic data warehouse architecture
* Working with Bronze and Silver data layers
* Building ETL workflows using SQL
* Cleaning real-world datasets
* Using SQL window functions
* Writing stored procedures
* Handling missing and inconsistent data
* Performing data quality checks
* Transforming raw data into analysis-ready datasets

---

## 🚀 Future Improvements

The project can be extended by adding:

* A **Gold layer**
* Fact and dimension tables
* Data warehouse star schema
* Data quality monitoring
* Automated ETL scheduling
* Power BI dashboards
* Business intelligence reporting
* Advanced analytical queries

---

## 👨‍💻 Author

**Marut Shukla**

Aspiring Data Analyst | SQL | Power BI | Python | Data Analytics

---

## ⭐ Conclusion

This project demonstrates how raw CRM and ERP data can be transformed into clean, structured, and analysis-ready data using **MySQL and SQL-based ETL processes**.

It serves as a practical project for understanding **data warehousing, data cleaning, SQL transformations, and ETL development**.
