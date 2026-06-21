/*****************************************************************************************
    POSTGRESQL COMPREHENSIVE SQL SCRIPT
    Covers:
    ✓ DDL Statements (CREATE, ALTER, DROP, TRUNCATE)
    ✓ DML Statements (INSERT, UPDATE, DELETE)
    ✓ DQL Statements (SELECT)
    ✓ PostgreSQL Data Types
    ✓ Constraints
    ✓ Auto Increment (GENERATED AS IDENTITY)
    ✓ Keys (Primary, Foreign, Unique, Composite)
    ✓ Aliases
    ✓ SELECT INTO
    ✓ INSERT INTO
    ✓ CASE Expression

    Real World Scenario:
    E-Commerce System
*****************************************************************************************/


/*****************************************************************************************
    DDL - CREATE DATABASE
*****************************************************************************************/

-- Create database
CREATE DATABASE ecommerce_db;

-- Connect to database
-- \c ecommerce_db;


/*****************************************************************************************
    DDL - CREATE TABLES
*****************************************************************************************/

-- Customer table
CREATE TABLE customers (
    customer_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),

    birth_date DATE,

    credit_limit NUMERIC(12,2) DEFAULT 0,

    is_active BOOLEAN DEFAULT TRUE,

    registration_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    profile_json JSONB,

    customer_uuid UUID DEFAULT gen_random_uuid()
);


-- Address table
CREATE TABLE addresses (
    address_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    customer_id INTEGER NOT NULL,

    country VARCHAR(100),
    city VARCHAR(100),
    street VARCHAR(200),

    postal_code CHAR(10),

    CONSTRAINT fk_customer_address
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
);


-- Department table
CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    department_name VARCHAR(100) UNIQUE NOT NULL
);


-- Employee table
CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    first_name VARCHAR(50),
    last_name VARCHAR(50),

    email VARCHAR(100) UNIQUE,

    salary NUMERIC(12,2),

    hire_date DATE,

    department_id INTEGER,

    CONSTRAINT fk_department
        FOREIGN KEY(department_id)
        REFERENCES departments(department_id)
);


-- Product Categories
CREATE TABLE categories (
    category_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    category_name VARCHAR(100) UNIQUE NOT NULL
);


-- Products
CREATE TABLE products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    category_id INTEGER NOT NULL,

    product_name VARCHAR(200) NOT NULL,

    description TEXT,

    price NUMERIC(10,2) CHECK(price > 0),

    quantity_in_stock INTEGER CHECK(quantity_in_stock >= 0),

    manufacture_date DATE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_category
        FOREIGN KEY(category_id)
        REFERENCES categories(category_id)
);


-- Orders
CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    customer_id INTEGER NOT NULL,

    order_date DATE DEFAULT CURRENT_DATE,

    total_amount NUMERIC(12,2),

    status VARCHAR(20)
        CHECK(status IN ('PENDING','SHIPPED','DELIVERED','CANCELLED')),

    CONSTRAINT fk_order_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
);


-- Order Details
CREATE TABLE order_details (

    order_id BIGINT,
    product_id BIGINT,

    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2),

    -- Composite Primary Key
    CONSTRAINT pk_order_details
        PRIMARY KEY(order_id, product_id),

    CONSTRAINT fk_order
        FOREIGN KEY(order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_product
        FOREIGN KEY(product_id)
        REFERENCES products(product_id)
);


-- Suppliers
CREATE TABLE suppliers (
    supplier_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    supplier_name VARCHAR(100) UNIQUE,

    contact_person VARCHAR(100),

    phone VARCHAR(30)
);


-- Product Supplier Mapping
CREATE TABLE product_suppliers (

    product_id BIGINT,
    supplier_id INTEGER,

    supply_price NUMERIC(10,2),

    -- Composite Key
    PRIMARY KEY(product_id, supplier_id),

    FOREIGN KEY(product_id)
        REFERENCES products(product_id),

    FOREIGN KEY(supplier_id)
        REFERENCES suppliers(supplier_id)
);


/*****************************************************************************************
    INSERT INTO (DML)
*****************************************************************************************/

-- Departments
INSERT INTO departments(department_name)
VALUES
('IT'),
('Finance'),
('Sales'),
('HR');


-- Categories
INSERT INTO categories(category_name)
VALUES
('Electronics'),
('Furniture'),
('Books');


-- Customers
INSERT INTO customers
(
    first_name,
    last_name,
    email,
    phone,
    birth_date,
    credit_limit
)
VALUES
(
    'John',
    'Smith',
    'john@email.com',
    '0911111111',
    '1990-05-10',
    5000
),
(
    'Sara',
    'Johnson',
    'sara@email.com',
    '0922222222',
    '1995-08-20',
    10000
);


-- Employees
INSERT INTO employees
(
    first_name,
    last_name,
    email,
    salary,
    hire_date,
    department_id
)
VALUES
(
    'Michael',
    'Brown',
    'michael@company.com',
    3500,
    '2023-01-01',
    1
);


/*****************************************************************************************
    INSERT INTO ... SELECT
*****************************************************************************************/

-- Create backup table
CREATE TABLE customer_backup
(
    customer_id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Copy data
INSERT INTO customer_backup
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customers;


/*****************************************************************************************
    DML - UPDATE
*****************************************************************************************/

-- Increase salary
UPDATE employees
SET salary = salary * 1.10
WHERE department_id = 1;


-- Update order status
UPDATE orders
SET status = 'SHIPPED'
WHERE order_id = 1;


/*****************************************************************************************
    DML - DELETE
*****************************************************************************************/

-- Delete cancelled orders
DELETE FROM orders
WHERE status = 'CANCELLED';


/*****************************************************************************************
    DQL - SELECT
*****************************************************************************************/

-- Retrieve all customers
SELECT *
FROM customers;


-- Select specific columns
SELECT
    first_name,
    last_name,
    email
FROM customers;


-- DISTINCT
SELECT DISTINCT city
FROM addresses;


-- WHERE
SELECT *
FROM products
WHERE price > 1000;


-- ORDER BY
SELECT *
FROM products
ORDER BY price DESC;


-- LIMIT
SELECT *
FROM products
LIMIT 5;


/*****************************************************************************************
    SQL ALIASES
*****************************************************************************************/

SELECT
    c.customer_id AS customer_number,
    c.first_name AS first,
    c.last_name AS last
FROM customers AS c;


/*****************************************************************************************
    JOINS
*****************************************************************************************/

-- INNER JOIN
SELECT
    c.first_name,
    o.order_id,
    o.total_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;


-- LEFT JOIN
SELECT
    c.first_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;


-- RIGHT JOIN
SELECT
    c.first_name,
    o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;


-- FULL JOIN
SELECT
    c.first_name,
    o.order_id
FROM customers c
FULL JOIN orders o
ON c.customer_id = o.customer_id;


/*****************************************************************************************
    AGGREGATE FUNCTIONS
*****************************************************************************************/

SELECT COUNT(*) AS total_customers
FROM customers;


SELECT AVG(price) AS average_price
FROM products;


SELECT MIN(price) AS minimum_price
FROM products;


SELECT MAX(price) AS maximum_price
FROM products;


SELECT SUM(total_amount) AS total_sales
FROM orders;


/*****************************************************************************************
    GROUP BY
*****************************************************************************************/

SELECT
    department_id,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;


/*****************************************************************************************
    HAVING
*****************************************************************************************/

SELECT
    department_id,
    COUNT(*) AS total_employees
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5;


/*****************************************************************************************
    CASE EXPRESSION
*****************************************************************************************/

SELECT
    employee_id,
    first_name,
    salary,

    CASE
        WHEN salary >= 10000 THEN 'Executive'
        WHEN salary >= 5000 THEN 'Senior'
        WHEN salary >= 3000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS employee_grade

FROM employees;


/*****************************************************************************************
    SELECT INTO
    Creates a new table from query results
*****************************************************************************************/

SELECT
    customer_id,
    first_name,
    last_name,
    email
INTO active_customers
FROM customers
WHERE is_active = TRUE;


/*****************************************************************************************
    ALTER TABLE STATEMENTS
*****************************************************************************************/

-- Add column
ALTER TABLE customers
ADD COLUMN loyalty_points INTEGER DEFAULT 0;


-- Add constraint
ALTER TABLE customers
ADD CONSTRAINT chk_loyalty_points
CHECK(loyalty_points >= 0);


-- Rename column
ALTER TABLE customers
RENAME COLUMN loyalty_points TO reward_points;


-- Change data type
ALTER TABLE customers
ALTER COLUMN reward_points TYPE BIGINT;


-- Set default value
ALTER TABLE customers
ALTER COLUMN reward_points SET DEFAULT 100;


-- Drop default value
ALTER TABLE customers
ALTER COLUMN reward_points DROP DEFAULT;


-- Set NOT NULL
ALTER TABLE customers
ALTER COLUMN reward_points SET NOT NULL;


-- Drop NOT NULL
ALTER TABLE customers
ALTER COLUMN reward_points DROP NOT NULL;


-- Rename table
ALTER TABLE customer_backup
RENAME TO customer_archive;


/*****************************************************************************************
    TRUNCATE TABLE
*****************************************************************************************/

-- Remove all rows
TRUNCATE TABLE customer_archive;


-- Remove rows and restart identity
TRUNCATE TABLE customer_archive RESTART IDENTITY;


-- Truncate multiple tables
TRUNCATE TABLE
order_details,
orders;


/*****************************************************************************************
    DROP STATEMENTS
*****************************************************************************************/

-- Drop constraint
ALTER TABLE customers
DROP CONSTRAINT chk_loyalty_points;


-- Drop column
ALTER TABLE customers
DROP COLUMN reward_points;


-- Drop table
DROP TABLE customer_archive;


-- Drop table with dependencies
DROP TABLE order_details CASCADE;


-- Drop database
-- DROP DATABASE ecommerce_db;


/*****************************************************************************************
    CONSTRAINTS SUMMARY
*****************************************************************************************/

-- PRIMARY KEY
-- customer_id

-- FOREIGN KEY
-- customer_id references customers

-- UNIQUE
-- email

-- NOT NULL
-- first_name

-- CHECK
-- price > 0

-- DEFAULT
-- CURRENT_TIMESTAMP

-- COMPOSITE PRIMARY KEY
-- (order_id, product_id)


/*****************************************************************************************
    DATA TYPES USED
*****************************************************************************************/

-- SMALLINT
-- INTEGER
-- BIGINT

-- NUMERIC(12,2)

-- VARCHAR(n)
-- CHAR(n)
-- TEXT

-- BOOLEAN

-- DATE
-- TIMESTAMP

-- UUID

-- JSONB

/*****************************************************************************************
    END OF SCRIPT
*****************************************************************************************/