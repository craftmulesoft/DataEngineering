/*=========================================================
 POSTGRESQL DATA WAREHOUSE DESIGN EXAMPLES

 Covers:
 1. Flat Schema
 2. Star Schema
 3. Snowflake Schema
 4. Galaxy Schema
 5. Fact Tables
 6. Dimension Tables
 7. CTE Variations

 Author: Example Real World Retail System
=========================================================*/


/**********************************************************
 DATABASE 1: FLAT SCHEMA
 Flat schema keeps all data in one large table.
 No normalization.
**********************************************************/

CREATE DATABASE flat_schema_db;

-- Connect to database:
-- \c flat_schema_db


CREATE TABLE sales_flat (

    sale_id SERIAL PRIMARY KEY,

    customer_name VARCHAR(100),
    customer_city VARCHAR(100),
    customer_country VARCHAR(100),

    product_name VARCHAR(100),
    category VARCHAR(100),

    employee_name VARCHAR(100),

    sale_date DATE,

    quantity INT,
    price NUMERIC(10,2)

);



/* Insert sample flat data */

INSERT INTO sales_flat
(customer_name,customer_city,customer_country,
 product_name,category,
 employee_name,
 sale_date,quantity,price)

VALUES

('John Smith','London','UK',
 'Laptop','Electronics',
 'David',
 '2026-01-10',2,1500),


('Anna Lee','Paris','France',
 'Phone','Electronics',
 'Mary',
 '2026-01-15',1,900);



/**********************************************************
 DATABASE 2: STAR SCHEMA

 Fact table in center.
 Dimension tables around it.

 Structure:

             dim_customer
                   |
dim_product -- fact_sales -- dim_date
                   |
             dim_employee

**********************************************************/


CREATE DATABASE star_schema_db;


-- \c star_schema_db


CREATE TABLE dim_customer (

customer_id SERIAL PRIMARY KEY,

customer_name VARCHAR(100),
city VARCHAR(100),
country VARCHAR(100)

);



CREATE TABLE dim_product (

product_id SERIAL PRIMARY KEY,

product_name VARCHAR(100),
category VARCHAR(100),
price NUMERIC(10,2)

);



CREATE TABLE dim_employee (

employee_id SERIAL PRIMARY KEY,

employee_name VARCHAR(100),
department VARCHAR(100)

);



CREATE TABLE dim_date (

date_id SERIAL PRIMARY KEY,

full_date DATE,
year INT,
month INT,
day INT

);



/*
FACT TABLE

Stores business measurements.

Measures:
quantity
sales_amount

Foreign keys connect dimensions.
*/


CREATE TABLE fact_sales (

sale_id SERIAL PRIMARY KEY,

customer_id INT REFERENCES dim_customer(customer_id),

product_id INT REFERENCES dim_product(product_id),

employee_id INT REFERENCES dim_employee(employee_id),

date_id INT REFERENCES dim_date(date_id),


quantity INT,

sales_amount NUMERIC(10,2)

);



/* Insert dimensions */


INSERT INTO dim_customer
(customer_name,city,country)
VALUES

('John','London','UK'),
('Sara','Rome','Italy');



INSERT INTO dim_product
(product_name,category,price)
VALUES

('Laptop','Computer',1500),
('Keyboard','Accessory',100);



INSERT INTO dim_employee
(employee_name,department)

VALUES

('David','Sales'),
('Mary','Sales');



INSERT INTO dim_date
(full_date,year,month,day)

VALUES

('2026-01-01',2026,1,1),
('2026-01-02',2026,1,2);



/* Insert fact data */


INSERT INTO fact_sales
(customer_id,
 product_id,
 employee_id,
 date_id,
 quantity,
 sales_amount)

VALUES

(1,1,1,1,2,3000),

(2,2,2,2,3,300);





/**********************************************************
 DATABASE 3: SNOWFLAKE SCHEMA


 Normalized dimensions.

 Product dimension is separated:

dim_product
      |
dim_category


Customer:

dim_customer
      |
dim_city
      |
dim_country


**********************************************************/


CREATE DATABASE snowflake_schema_db;


-- \c snowflake_schema_db



CREATE TABLE dim_country (

country_id SERIAL PRIMARY KEY,

country_name VARCHAR(100)

);



CREATE TABLE dim_city (

city_id SERIAL PRIMARY KEY,

city_name VARCHAR(100),

country_id INT REFERENCES dim_country(country_id)

);



CREATE TABLE dim_customer (

customer_id SERIAL PRIMARY KEY,

customer_name VARCHAR(100),

city_id INT REFERENCES dim_city(city_id)

);



CREATE TABLE dim_category (

category_id SERIAL PRIMARY KEY,

category_name VARCHAR(100)

);



CREATE TABLE dim_product (

product_id SERIAL PRIMARY KEY,

product_name VARCHAR(100),

category_id INT REFERENCES dim_category(category_id)

);



CREATE TABLE fact_orders (

order_id SERIAL PRIMARY KEY,

customer_id INT REFERENCES dim_customer(customer_id),

product_id INT REFERENCES dim_product(product_id),

order_date DATE,

quantity INT,

amount NUMERIC(10,2)

);



/* Insert Snowflake data */


INSERT INTO dim_country(country_name)

VALUES

('USA'),
('Germany');



INSERT INTO dim_city(city_name,country_id)

VALUES

('New York',1),
('Berlin',2);



INSERT INTO dim_customer(customer_name,city_id)

VALUES

('Mike',1),
('Tom',2);



INSERT INTO dim_category(category_name)

VALUES

('Electronics'),
('Furniture');



INSERT INTO dim_product(product_name,category_id)

VALUES

('Laptop',1),
('Chair',2);



INSERT INTO fact_orders
(customer_id,product_id,order_date,quantity,amount)

VALUES

(1,1,'2026-02-01',1,2000),

(2,2,'2026-02-02',5,500);






/**********************************************************
 DATABASE 4: GALAXY SCHEMA


 Multiple fact tables sharing dimensions.


 Facts:

 fact_sales
 fact_inventory


 Shared:

 dim_product
 dim_store
 dim_date


**********************************************************/


CREATE DATABASE galaxy_schema_db;


-- \c galaxy_schema_db



CREATE TABLE dim_store (

store_id SERIAL PRIMARY KEY,

store_name VARCHAR(100),

location VARCHAR(100)

);



CREATE TABLE dim_product (

product_id SERIAL PRIMARY KEY,

product_name VARCHAR(100),

category VARCHAR(100)

);



CREATE TABLE dim_date (

date_id SERIAL PRIMARY KEY,

date_value DATE

);



/* FACT TABLE 1 */

CREATE TABLE fact_sales (

sale_id SERIAL PRIMARY KEY,

store_id INT REFERENCES dim_store(store_id),

product_id INT REFERENCES dim_product(product_id),

date_id INT REFERENCES dim_date(date_id),

quantity INT,

amount NUMERIC(10,2)

);



/* FACT TABLE 2 */

CREATE TABLE fact_inventory (

inventory_id SERIAL PRIMARY KEY,

store_id INT REFERENCES dim_store(store_id),

product_id INT REFERENCES dim_product(product_id),

date_id INT REFERENCES dim_date(date_id),

stock_quantity INT

);



INSERT INTO dim_store(store_name,location)

VALUES

('Main Store','Addis Ababa');



INSERT INTO dim_product(product_name,category)

VALUES

('Phone','Electronics');



INSERT INTO dim_date(date_value)

VALUES

('2026-03-01');



INSERT INTO fact_sales
(store_id,product_id,date_id,quantity,amount)

VALUES

(1,1,1,10,9000);



INSERT INTO fact_inventory
(store_id,product_id,date_id,stock_quantity)

VALUES

(1,1,1,50);





/**********************************************************
 CTE EXAMPLES

 Common Table Expressions
**********************************************************/


/*
1. SIMPLE CTE

Temporary result set
*/

WITH sales_total AS

(

SELECT
product_id,
SUM(amount) total_sales

FROM fact_sales

GROUP BY product_id

)

SELECT *

FROM sales_total;





/*
2. MULTIPLE CTE

One CTE uses another CTE
*/


WITH product_sales AS

(

SELECT
product_id,
SUM(amount) total

FROM fact_sales

GROUP BY product_id

),

high_sales AS

(

SELECT *

FROM product_sales

WHERE total > 1000

)

SELECT *

FROM high_sales;





/*
3. CTE WITH JOIN
*/


WITH customer_orders AS

(

SELECT

c.customer_name,
SUM(o.amount) total

FROM dim_customer c

JOIN fact_orders o

ON c.customer_id=o.customer_id


GROUP BY c.customer_name

)


SELECT *

FROM customer_orders;





/*
4. CTE WITH AGGREGATION
*/


WITH avg_sales AS

(

SELECT

AVG(amount) average_sale

FROM fact_sales

)


SELECT *

FROM avg_sales;





/*
5. RECURSIVE CTE

Example:
Employee hierarchy

*/


CREATE TABLE employee_tree

(

employee_id INT PRIMARY KEY,

employee_name VARCHAR(100),

manager_id INT

);



INSERT INTO employee_tree VALUES

(1,'CEO',NULL),

(2,'Manager',1),

(3,'Developer',2);



WITH RECURSIVE hierarchy AS

(

SELECT

employee_id,

employee_name,

manager_id

FROM employee_tree

WHERE manager_id IS NULL


UNION ALL


SELECT

e.employee_id,

e.employee_name,

e.manager_id


FROM employee_tree e


JOIN hierarchy h

ON e.manager_id=h.employee_id

)


SELECT *

FROM hierarchy;





/*
6. CTE WITH INSERT
*/


WITH new_customer AS

(

SELECT

'New Client' name

)


INSERT INTO dim_customer(customer_name)

SELECT name

FROM new_customer;





/*
7. CTE WITH UPDATE
*/


WITH update_product AS

(

SELECT product_id

FROM dim_product

WHERE product_name='Phone'

)


UPDATE dim_product

SET category='Mobile'

WHERE product_id IN

(
SELECT product_id
FROM update_product
);





/*
8. CTE WITH DELETE
*/


WITH delete_data AS

(

SELECT product_id

FROM dim_product

WHERE product_name='Chair'

)


DELETE FROM dim_product

WHERE product_id IN

(

SELECT product_id

FROM delete_data

);



/**********************************************************

END OF COMPLETE DATA WAREHOUSE SQL EXAMPLE

**********************************************************/