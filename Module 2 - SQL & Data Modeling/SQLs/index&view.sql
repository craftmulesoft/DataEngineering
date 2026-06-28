-- ==========================================================
-- PostgreSQL Banking Database
-- Topics Covered:
-- ✔ Database
-- ✔ Schema
-- ✔ Tables
-- ✔ Constraints
-- ✔ Primary Keys
-- ✔ Foreign Keys
-- ✔ Sample Data
-- ✔ Indexes
-- ✔ Views
-- ✔ CREATE OR REPLACE VIEW
-- ✔ DROP VIEW
-- ==========================================================

-------------------------------------------------------------
-- Create Database
-------------------------------------------------------------
CREATE DATABASE banking_db;

-- Connect to the database (psql only)
-- \c banking_db

-------------------------------------------------------------
-- Create Schema
-------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS bank;

SET search_path TO bank;

-------------------------------------------------------------
-- Customers
-------------------------------------------------------------
CREATE TABLE customers
(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-------------------------------------------------------------
-- Branches
-------------------------------------------------------------
CREATE TABLE branches
(
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    manager_name VARCHAR(100)
);

-------------------------------------------------------------
-- Accounts
-------------------------------------------------------------
CREATE TABLE accounts
(
    account_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance NUMERIC(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'Active',
    opened_date DATE,

    CONSTRAINT fk_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_branch
        FOREIGN KEY(branch_id)
        REFERENCES branches(branch_id),

    CONSTRAINT chk_balance
        CHECK(balance >= 0)
);

-------------------------------------------------------------
-- Transactions
-------------------------------------------------------------
CREATE TABLE transactions
(
    transaction_id SERIAL PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(200),

    CONSTRAINT fk_account
        FOREIGN KEY(account_id)
        REFERENCES accounts(account_id),

    CONSTRAINT chk_amount
        CHECK(amount > 0)
);

-------------------------------------------------------------
-- Loans
-------------------------------------------------------------
CREATE TABLE loans
(
    loan_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_amount NUMERIC(12,2),
    interest_rate NUMERIC(5,2),
    loan_status VARCHAR(20),
    issue_date DATE,

    CONSTRAINT fk_loan_customer
        FOREIGN KEY(customer_id)
        REFERENCES customers(customer_id)
);

-------------------------------------------------------------
-- Insert Branches
-------------------------------------------------------------
INSERT INTO branches
(branch_name, city, manager_name)
VALUES
('Addis Ababa Main Branch','Addis Ababa','Abebe Bekele'),
('Bole Branch','Addis Ababa','Sara Ali'),
('Adama Branch','Adama','John Tesfaye'),
('Hawassa Branch','Hawassa','Helen Desta'),
('Bahir Dar Branch','Bahir Dar','Samuel Tadesse');

-------------------------------------------------------------
-- Insert Customers
-------------------------------------------------------------
INSERT INTO customers
(first_name,last_name,email,phone,city)
VALUES
('Abel','Mekonnen','abel@gmail.com','0911000001','Addis Ababa'),
('Sara','Ahmed','sara@gmail.com','0911000002','Adama'),
('Samuel','Bekele','samuel@gmail.com','0911000003','Hawassa'),
('Liya','Tesfaye','liya@gmail.com','0911000004','Addis Ababa'),
('Daniel','Kebede','daniel@gmail.com','0911000005','Bahir Dar'),
('Hana','Solomon','hana@gmail.com','0911000006','Addis Ababa'),
('Biruk','Alemu','biruk@gmail.com','0911000007','Adama'),
('Marta','Yohannes','marta@gmail.com','0911000008','Hawassa'),
('Elias','Demissie','elias@gmail.com','0911000009','Dire Dawa'),
('Rahel','Assefa','rahel@gmail.com','0911000010','Bahir Dar');

-------------------------------------------------------------
-- Insert Accounts
-------------------------------------------------------------
INSERT INTO accounts
(customer_id,branch_id,account_number,account_type,balance,status,opened_date)
VALUES
(1,1,'100001','Savings',25000,'Active','2023-01-10'),
(2,2,'100002','Checking',15000,'Active','2023-03-15'),
(3,3,'100003','Savings',40000,'Active','2024-01-01'),
(4,1,'100004','Checking',7000,'Inactive','2022-06-20'),
(5,5,'100005','Savings',90000,'Active','2021-05-10'),
(6,2,'100006','Savings',12000,'Active','2023-07-14'),
(7,3,'100007','Checking',18000,'Active','2022-09-25'),
(8,4,'100008','Savings',45000,'Active','2024-02-18'),
(9,4,'100009','Checking',8500,'Active','2023-11-12'),
(10,5,'100010','Savings',67000,'Active','2022-12-05');

-------------------------------------------------------------
-- Insert Transactions
-------------------------------------------------------------
INSERT INTO transactions
(account_id,transaction_type,amount,transaction_date,description)
VALUES
(1,'Deposit',5000,'2025-01-01 09:00','Salary'),
(1,'Withdrawal',1000,'2025-01-02 10:30','ATM Withdrawal'),
(2,'Deposit',3000,'2025-01-05 11:15','Cash Deposit'),
(3,'Transfer',7000,'2025-01-07 14:20','Mobile Banking'),
(4,'Deposit',2000,'2025-01-08 09:30','Cash Deposit'),
(5,'Withdrawal',500,'2025-01-10 16:45','POS Purchase'),
(6,'Deposit',6000,'2025-01-12 08:40','Salary'),
(7,'Transfer',2500,'2025-01-13 12:00','Bank Transfer'),
(8,'Withdrawal',4000,'2025-01-15 17:10','ATM Withdrawal'),
(9,'Deposit',1500,'2025-01-17 09:50','Cash Deposit'),
(10,'Transfer',8000,'2025-01-20 13:30','Online Banking'),
(2,'Withdrawal',2500,'2025-01-22 15:10','Shopping'),
(5,'Deposit',10000,'2025-01-24 10:20','Business Income'),
(6,'Transfer',3500,'2025-01-25 18:00','Rent Payment'),
(8,'Deposit',5000,'2025-01-28 11:40','Bonus');

-------------------------------------------------------------
-- Insert Loans
-------------------------------------------------------------
INSERT INTO loans
(customer_id,loan_amount,interest_rate,loan_status,issue_date)
VALUES
(1,500000,12.50,'Approved','2024-01-10'),
(2,250000,10.50,'Pending','2024-02-15'),
(5,700000,11.00,'Approved','2023-11-20'),
(7,350000,12.00,'Rejected','2024-05-11'),
(9,450000,13.25,'Approved','2025-01-02');

-------------------------------------------------------------
-- INDEXES
-------------------------------------------------------------

CREATE INDEX idx_customer_last_name
ON customers(last_name);

CREATE INDEX idx_customer_city
ON customers(city);

CREATE INDEX idx_account_number
ON accounts(account_number);

CREATE INDEX idx_account_balance
ON accounts(balance);

CREATE INDEX idx_transaction_date
ON transactions(transaction_date);

CREATE INDEX idx_transaction_account
ON transactions(account_id);

CREATE INDEX idx_customer_city_lastname
ON customers(city,last_name);

CREATE UNIQUE INDEX idx_customer_email
ON customers(email);

-------------------------------------------------------------
-- VIEW 1
-------------------------------------------------------------
CREATE VIEW customer_accounts AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    a.account_number,
    a.account_type,
    a.balance,
    a.status,
    b.branch_name
FROM customers c
JOIN accounts a
ON c.customer_id = a.customer_id
JOIN branches b
ON a.branch_id = b.branch_id;

-------------------------------------------------------------
-- VIEW 2
-------------------------------------------------------------
CREATE VIEW transaction_history AS
SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_number,
    t.transaction_type,
    t.amount,
    t.transaction_date,
    t.description
FROM transactions t
JOIN accounts a
ON t.account_id = a.account_id
JOIN customers c
ON a.customer_id = c.customer_id;

-------------------------------------------------------------
-- VIEW 3
-------------------------------------------------------------
CREATE VIEW customer_loans AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_amount,
    l.interest_rate,
    l.loan_status,
    l.issue_date
FROM customers c
JOIN loans l
ON c.customer_id=l.customer_id;

-------------------------------------------------------------
-- CREATE OR REPLACE VIEW
-------------------------------------------------------------
CREATE OR REPLACE VIEW customer_accounts AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city,
    a.account_number,
    a.account_type,
    a.balance,
    a.status,
    b.branch_name,
    c.email
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN branches b
    ON a.branch_id = b.branch_id;

-------------------------------------------------------------
-- SAMPLE QUERIES
-------------------------------------------------------------

SELECT * FROM customer_accounts;

SELECT * FROM transaction_history;

SELECT * FROM customer_loans;

SELECT *
FROM customers
WHERE last_name='Bekele';

SELECT *
FROM customers
WHERE city='Addis Ababa'
AND last_name='Tesfaye';

SELECT *
FROM accounts
WHERE account_number='100003';

SELECT *
FROM accounts
WHERE balance > 30000;

SELECT *
FROM transactions
WHERE transaction_date >= '2025-01-10';

-------------------------------------------------------------
-- DROP VIEW Example
-------------------------------------------------------------
DROP VIEW customer_loans;

-------------------------------------------------------------
-- Show Tables
-------------------------------------------------------------
SELECT table_name
FROM information_schema.tables
WHERE table_schema='bank';

-------------------------------------------------------------
-- Show Views
-------------------------------------------------------------
SELECT table_name
FROM information_schema.views
WHERE table_schema='bank';

-------------------------------------------------------------
-- Show Indexes
-------------------------------------------------------------
SELECT indexname
FROM pg_indexes
WHERE schemaname='bank';

-------------------------------------------------------------
-- End of Script
-------------------------------------------------------------