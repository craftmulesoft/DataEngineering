# 🚀 Mini Project: SQL for Data Engineers (PostgreSQL)

# Retail Sales Data Warehouse Implementation

# /*

# PROJECT OBJECTIVE

Build a Retail Sales Data Warehouse using PostgreSQL.

This project demonstrates:

✅ Data Modeling
✅ Star Schema Design
✅ ETL Development
✅ Data Warehousing Concepts
✅ Data Quality Validation
✅ Business Reporting
✅ Advanced SQL Analytics

*/

---

## -- STEP 1: CREATE SOURCE TABLES (OLTP DATABASE)

-- Customer master data

CREATE TABLE customers (
customer_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
city VARCHAR(50),
country VARCHAR(50)
);

-- Product master data

CREATE TABLE products (
product_id SERIAL PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
price NUMERIC(10,2)
);

-- Store master data

CREATE TABLE stores (
store_id SERIAL PRIMARY KEY,
store_name VARCHAR(100),
city VARCHAR(50)
);

-- Order header table

CREATE TABLE orders (
order_id SERIAL PRIMARY KEY,
customer_id INT,
store_id INT,
order_date DATE
);

-- Order transaction details

CREATE TABLE order_details (
order_detail_id SERIAL PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
unit_price NUMERIC(10,2)
);

---

## -- STEP 2: INSERT SAMPLE DATA

-- Customers

INSERT INTO customers
(first_name,last_name,email,city,country)
VALUES
('John','Smith','[john@email.com](mailto:john@email.com)','New York','USA'),
('Sara','Johnson','[sara@email.com](mailto:sara@email.com)','Chicago','USA'),
('Mike','Brown','[mike@email.com](mailto:mike@email.com)','Dallas','USA');

-- Products

INSERT INTO products
(product_name,category,price)
VALUES
('Laptop','Electronics',1200),
('Headphones','Electronics',150),
('T-Shirt','Clothing',30),
('Coffee Maker','Home Appliances',80);

-- Stores

INSERT INTO stores
(store_name,city)
VALUES
('Downtown Store','New York'),
('Mall Branch','Chicago');

-- Orders

INSERT INTO orders
(customer_id,store_id,order_date)
VALUES
(1,1,'2025-01-15'),
(2,2,'2025-01-20'),
(3,1,'2025-02-10');

-- Order Details

INSERT INTO order_details
(order_id,product_id,quantity,unit_price)
VALUES
(1,1,1,1200),
(1,2,2,150),
(2,3,5,30),
(3,4,2,80);

---

## -- STEP 3: CREATE STAR SCHEMA

/*
Star Schema Structure

```
            Dim_Date
                |
                |
```

Dim_Customer -- Fact_Sales -- Dim_Product
|
|
Dim_Store
*/

---

## -- DATE DIMENSION

CREATE TABLE dim_date (
date_key INT PRIMARY KEY,
full_date DATE,
day INT,
month INT,
month_name VARCHAR(20),
quarter INT,
year INT
);

---

## -- CUSTOMER DIMENSION

CREATE TABLE dim_customer (
customer_key SERIAL PRIMARY KEY,
customer_id INT,
customer_name VARCHAR(100),
city VARCHAR(50),
country VARCHAR(50)
);

---

## -- PRODUCT DIMENSION

CREATE TABLE dim_product (
product_key SERIAL PRIMARY KEY,
product_id INT,
product_name VARCHAR(100),
category VARCHAR(50)
);

---

## -- STORE DIMENSION

CREATE TABLE dim_store (
store_key SERIAL PRIMARY KEY,
store_id INT,
store_name VARCHAR(100),
city VARCHAR(50)
);

---

## -- FACT TABLE

CREATE TABLE fact_sales (
sales_key BIGSERIAL PRIMARY KEY,
date_key INT,
customer_key INT,
product_key INT,
store_key INT,
quantity INT,
sales_amount NUMERIC(12,2)
);

---

## -- STEP 4: LOAD DIMENSION TABLES

-- Load Customer Dimension

INSERT INTO dim_customer
(
customer_id,
customer_name,
city,
country
)
SELECT
customer_id,
first_name || ' ' || last_name,
city,
country
FROM customers;

---

-- Load Product Dimension

INSERT INTO dim_product
(
product_id,
product_name,
category
)
SELECT
product_id,
product_name,
category
FROM products;

---

-- Load Store Dimension

INSERT INTO dim_store
(
store_id,
store_name,
city
)
SELECT
store_id,
store_name,
city
FROM stores;

---

-- Load Date Dimension

INSERT INTO dim_date
SELECT
TO_CHAR(d,'YYYYMMDD')::INT AS date_key,
d AS full_date,
EXTRACT(DAY FROM d),
EXTRACT(MONTH FROM d),
TO_CHAR(d,'Month'),
EXTRACT(QUARTER FROM d),
EXTRACT(YEAR FROM d)
FROM generate_series(
'2025-01-01'::DATE,
'2025-12-31'::DATE,
INTERVAL '1 day'
) d;

---

## -- STEP 5: LOAD FACT TABLE

/*
Business Logic:

Sales Amount =
Quantity × Unit Price
*/

INSERT INTO fact_sales
(
date_key,
customer_key,
product_key,
store_key,
quantity,
sales_amount
)
SELECT
TO_CHAR(o.order_date,'YYYYMMDD')::INT,
dc.customer_key,
dp.product_key,
ds.store_key,
od.quantity,
od.quantity * od.unit_price
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN dim_customer dc
ON o.customer_id = dc.customer_id
JOIN dim_product dp
ON od.product_id = dp.product_id
JOIN dim_store ds
ON o.store_id = ds.store_id;

---

## -- STEP 6: DATA QUALITY CHECKS

-- Check total records loaded

SELECT COUNT(*)
FROM fact_sales;

---

-- Check for NULL values

SELECT *
FROM fact_sales
WHERE sales_amount IS NULL;

---

-- Check duplicate sales records

SELECT
date_key,
customer_key,
product_key,
COUNT(*)
FROM fact_sales
GROUP BY
date_key,
customer_key,
product_key
HAVING COUNT(*) > 1;

---

## -- STEP 7: BUSINESS REPORTING QUERIES

---

## -- REPORT 1: TOTAL COMPANY REVENUE

SELECT
SUM(sales_amount) AS total_revenue
FROM fact_sales;

---

## -- REPORT 2: MONTHLY SALES TREND

SELECT
d.year,
d.month_name,
SUM(f.sales_amount) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY
d.year,
d.month,
d.month_name
ORDER BY
d.year,
d.month;

---

## -- REPORT 3: TOP SELLING PRODUCTS

SELECT
p.product_name,
SUM(f.sales_amount) AS revenue
FROM fact_sales f
JOIN dim_product p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

---

## -- REPORT 4: SALES BY CATEGORY

SELECT
p.category,
SUM(f.sales_amount) AS revenue
FROM fact_sales f
JOIN dim_product p
ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY revenue DESC;

---

## -- REPORT 5: TOP CUSTOMERS

SELECT
c.customer_name,
SUM(f.sales_amount) AS total_spent
FROM fact_sales f
JOIN dim_customer c
ON f.customer_key = c.customer_key
GROUP BY c.customer_name
ORDER BY total_spent DESC;

---

## -- REPORT 6: STORE PERFORMANCE

SELECT
s.store_name,
SUM(f.sales_amount) AS revenue
FROM fact_sales f
JOIN dim_store s
ON f.store_key = s.store_key
GROUP BY s.store_name
ORDER BY revenue DESC;

---

## -- REPORT 7: BEST SELLING PRODUCTS BY QUANTITY

SELECT
p.product_name,
SUM(f.quantity) AS total_units_sold
FROM fact_sales f
JOIN dim_product p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

---

## -- REPORT 8: CUSTOMER SEGMENTATION

SELECT
customer_name,
SUM(sales_amount) AS total_spent,
CASE
WHEN SUM(sales_amount) >= 1000
THEN 'VIP'
WHEN SUM(sales_amount) >= 500
THEN 'Gold'
ELSE 'Regular'
END AS customer_segment
FROM fact_sales f
JOIN dim_customer c
ON f.customer_key = c.customer_key
GROUP BY customer_name;

---

## -- REPORT 9: MONTH OVER MONTH GROWTH

WITH monthly_sales AS
(
SELECT
d.year,
d.month,
SUM(f.sales_amount) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY
d.year,
d.month
)

SELECT
year,
month,
revenue,
LAG(revenue)
OVER(ORDER BY year,month)
AS previous_month,
ROUND(
(
revenue -
LAG(revenue)
OVER(ORDER BY year,month)
)
/
LAG(revenue)
OVER(ORDER BY year,month)
* 100,
2
) AS growth_percentage
FROM monthly_sales;

---

## -- REPORT 10: RUNNING SALES TOTAL

SELECT
d.full_date,
SUM(f.sales_amount) AS daily_sales,
SUM(
SUM(f.sales_amount)
)
OVER(
ORDER BY d.full_date
) AS running_total
FROM fact_sales f
JOIN dim_date d
ON f.date_key = d.date_key
GROUP BY d.full_date
ORDER BY d.full_date;

---

## -- STEP 8: PERFORMANCE OPTIMIZATION

-- Index on Date Key

CREATE INDEX idx_fact_sales_date
ON fact_sales(date_key);

-- Index on Product Key

CREATE INDEX idx_fact_sales_product
ON fact_sales(product_key);

-- Index on Customer Key

CREATE INDEX idx_fact_sales_customer
ON fact_sales(customer_key);

-- Index on Store Key

CREATE INDEX idx_fact_sales_store
ON fact_sales(store_key);

---

## -- PROJECT COMPLETE

/*
Skills Demonstrated

✓ OLTP Data Modeling
✓ Dimensional Modeling
✓ Star Schema Design
✓ ETL Development
✓ Data Warehouse Loading
✓ Data Quality Validation
✓ Analytical SQL
✓ Window Functions
✓ CTEs
✓ Aggregation Queries
✓ Business Reporting
✓ Query Optimization

This represents a simplified end-to-end
Retail Sales Data Warehouse built in PostgreSQL.
*/
