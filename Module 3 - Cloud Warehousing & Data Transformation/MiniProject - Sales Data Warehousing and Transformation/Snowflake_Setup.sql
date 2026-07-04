USE ROLE accountadmin;


-- ==========================================
-- Create Warehouse
-- ==========================================

CREATE OR REPLACE WAREHOUSE COMPUTE_WH
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE COMPUTE_WH;

-- ==========================================
-- Create Database
-- ==========================================

CREATE OR REPLACE DATABASE RETAIL_DB;

USE DATABASE RETAIL_DB;

-- ==========================================
-- Create Schemas
-- ==========================================

CREATE OR REPLACE SCHEMA RAW;

CREATE OR REPLACE SCHEMA STAGING;

CREATE OR REPLACE SCHEMA INTERMEDIATE;

CREATE OR REPLACE SCHEMA MART;

SHOW SCHEMAS;




-- ==========================================
-- CSV File Format
-- ==========================================

USE SCHEMA RAW;

CREATE OR REPLACE FILE FORMAT FF_CSV
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = TRUE
EMPTY_FIELD_AS_NULL = TRUE
NULL_IF = ('NULL','null','');

SHOW FILE FORMATS;

-- ==========================================
-- Internal Stage
-- ==========================================

CREATE OR REPLACE STAGE STG_RETAIL
FILE_FORMAT = FF_CSV;

SHOW STAGES;


-- ==========================================
-- Create Tables
-- ==========================================

CREATE OR REPLACE TABLE CUSTOMERS
(
    CUSTOMER_ID INT,
    FIRST_NAME STRING,
    LAST_NAME STRING,
    EMAIL STRING,
    CITY STRING,
    COUNTRY STRING
);

CREATE OR REPLACE TABLE PRODUCTS
(
    PRODUCT_ID INT,
    PRODUCT_NAME STRING,
    CATEGORY STRING,
    PRICE NUMBER(10,2)
);

CREATE OR REPLACE TABLE ORDERS
(
    ORDER_ID INT,
    CUSTOMER_ID INT,
    ORDER_DATE DATE
);

CREATE OR REPLACE TABLE ORDER_ITEMS
(
    ORDER_ITEM_ID INT,
    ORDER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT
);

SHOW TABLES;



-- ==========================================
-- Load Data into Snowflake
-- ==========================================

COPY INTO CUSTOMERS
FROM @STG_RETAIL/customers.csv
FILE_FORMAT = (FORMAT_NAME = FF_CSV)
ON_ERROR = 'CONTINUE';

COPY INTO PRODUCTS
FROM @STG_RETAIL/products.csv
FILE_FORMAT = (FORMAT_NAME = FF_CSV)
ON_ERROR = 'CONTINUE';

COPY INTO ORDERS
FROM @STG_RETAIL/orders.csv
FILE_FORMAT = (FORMAT_NAME = FF_CSV)
ON_ERROR = 'CONTINUE';

COPY INTO ORDER_ITEMS
FROM @STG_RETAIL/order_items.csv
FILE_FORMAT = (FORMAT_NAME = FF_CSV)
ON_ERROR = 'CONTINUE';





-- ==========================================
-- Load Data into Snowflake
-- ==========================================

SELECT *
FROM CUSTOMERS
LIMIT 10;

SELECT *
FROM PRODUCTS
LIMIT 10;

SELECT *
FROM ORDERS
LIMIT 10;

SELECT *
FROM ORDER_ITEMS
LIMIT 10;

-- ==========================================
-- Validate Record Counts
-- ==========================================

SELECT COUNT(*) AS TOTAL_CUSTOMERS
FROM CUSTOMERS;

SELECT COUNT(*) AS TOTAL_PRODUCTS
FROM PRODUCTS;

SELECT COUNT(*) AS TOTAL_ORDERS
FROM ORDERS;

SELECT COUNT(*) AS TOTAL_ORDER_ITEMS
FROM ORDER_ITEMS;

-- ==========================================
-- Validate Record Counts
-- ==========================================

-- Check Duplicate Customers
SELECT
    CUSTOMER_ID,
    COUNT(*) AS TOTAL
FROM CUSTOMERS
GROUP BY CUSTOMER_ID
HAVING COUNT(*) > 1;

-- Check Duplicate Products
SELECT
    PRODUCT_ID,
    COUNT(*) AS TOTAL
FROM PRODUCTS
GROUP BY PRODUCT_ID
HAVING COUNT(*) > 1;

-- Check Duplicate Orders
SELECT
    ORDER_ID,
    COUNT(*) AS TOTAL
FROM ORDERS
GROUP BY ORDER_ID
HAVING COUNT(*) > 1;

-- Check Duplicate Order Items
SELECT
    ORDER_ITEM_ID,
    COUNT(*) AS TOTAL
FROM ORDER_ITEMS
GROUP BY ORDER_ITEM_ID
HAVING COUNT(*) > 1;

-- Check for NULL Customer IDs
SELECT *
FROM CUSTOMERS
WHERE CUSTOMER_ID IS NULL;

-- Check for NULL Product Prices
SELECT *
FROM PRODUCTS
WHERE PRICE IS NULL;

-- Check for NULL Order Dates
SELECT * 
FROM ORDERS
WHERE ORDER_DATE IS NULL;

-- Check for NULL Quantities
SELECT *
FROM ORDER_ITEMS
WHERE QUANTITY IS NULL;

-- ==========================================
-- Verify Relationships
-- ==========================================

-- Orders Without Customers
SELECT o.*
FROM ORDERS o
LEFT JOIN CUSTOMERS c
ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE c.CUSTOMER_ID IS NULL;

-- Order Items Without Orders
SELECT oi.*
FROM ORDER_ITEMS oi
LEFT JOIN ORDERS o
ON oi.ORDER_ID = o.ORDER_ID
WHERE o.ORDER_ID IS NULL;

-- Order Items Without Products
SELECT oi.*
FROM ORDER_ITEMS oi
LEFT JOIN PRODUCTS p
ON oi.PRODUCT_ID = p.PRODUCT_ID
WHERE p.PRODUCT_ID IS NULL;

-- ==========================================
-- Verify Relationships
-- ==========================================

-- Total Revenue
SELECT
    SUM(oi.QUANTITY * p.PRICE) AS TOTAL_REVENUE
FROM ORDER_ITEMS oi
JOIN PRODUCTS p
ON oi.PRODUCT_ID = p.PRODUCT_ID;

-- Top 10 Products by Revenue
SELECT
    p.PRODUCT_NAME,
    SUM(oi.QUANTITY * p.PRICE) AS REVENUE
FROM ORDER_ITEMS oi
JOIN PRODUCTS p
ON oi.PRODUCT_ID = p.PRODUCT_ID
GROUP BY p.PRODUCT_NAME
ORDER BY REVENUE DESC
LIMIT 10;

-- Orders by Month
SELECT
    DATE_TRUNC('MONTH', ORDER_DATE) AS ORDER_MONTH,
    COUNT(*) AS TOTAL_ORDERS
FROM ORDERS
GROUP BY ORDER_MONTH
ORDER BY ORDER_MONTH;

-- Orders by Country
SELECT
    c.COUNTRY,
    COUNT(o.ORDER_ID) AS TOTAL_ORDERS 
FROM ORDERS o
JOIN CUSTOMERS c
ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY c.COUNTRY
ORDER BY TOTAL_ORDERS DESC;