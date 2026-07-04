WITH sales AS (

    SELECT *
    FROM {{ ref('int_sales') }}

)

SELECT

    customer_id,

    customer_name,

    customer_email,

    customer_city,

    customer_country,

    COUNT(DISTINCT order_id) AS total_orders,

    COUNT(DISTINCT product_id) AS products_purchased,

    SUM(quantity) AS total_quantity,

    SUM(revenue) AS total_revenue,

    ROUND(AVG(revenue),2) AS average_order_value

FROM sales

GROUP BY

    customer_id,

    customer_name,

    customer_email,

    customer_city,

    customer_country