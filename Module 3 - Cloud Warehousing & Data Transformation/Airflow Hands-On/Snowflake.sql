CREATE DATABASE ecommerce_db;
USE DATABASE ecommerce_db;

CREATE SCHEMA raw;
CREATE SCHEMA analytics;

-- RAW tables
CREATE OR REPLACE TABLE raw.orders (
  order_id STRING,
  customer_id STRING,
  order_date DATE
);

CREATE OR REPLACE TABLE raw.shipments(
 shipment_id STRING,
 order_id STRING,
 status STRING,
 shipped_at TIMESTAMP,
 delivered_at TIMESTAMP
);

CREATE OR REPLACE TABLE raw.customers (
 customer_id STRING,
 name STRING,
 email STRING
);

SELECT 1;

SELECT * FROM raw.orders;

SELECT * FROM raw.customers;

SELECT * FROM raw.shipments;