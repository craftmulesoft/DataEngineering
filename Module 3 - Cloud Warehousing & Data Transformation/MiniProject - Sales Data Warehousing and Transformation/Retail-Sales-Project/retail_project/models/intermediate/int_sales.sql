WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

orders AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

order_items AS (

    SELECT *
    FROM {{ ref('stg_order_items') }}

),

products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

),

sales AS (

    SELECT

        -- Order Information
        o.order_id,
        o.order_date,

        -- Customer Information
        c.customer_id,
        c.customer_name,
        c.customer_email,
        c.customer_city,
        c.customer_country,

        -- Product Information
        p.product_id,
        p.product_name,
        p.product_category,

        -- Sales Information
        oi.order_item_id,
        oi.quantity,
        p.product_price AS unit_price,

        -- Revenue Calculation
        oi.quantity * p.product_price AS revenue

    FROM orders o

    INNER JOIN customers c
        ON o.customer_id = c.customer_id

    INNER JOIN order_items oi
        ON o.order_id = oi.order_id

    INNER JOIN products p
        ON oi.product_id = p.product_id

)

SELECT *

FROM sales