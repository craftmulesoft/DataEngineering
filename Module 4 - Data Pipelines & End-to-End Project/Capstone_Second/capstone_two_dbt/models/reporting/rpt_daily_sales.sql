SELECT

    CURRENT_DATE() AS sales_date,

    SUM(gross_sales) AS total_sales,

    COUNT(cart_id) AS total_orders

FROM {{ ref('fact_product_sales') }}

GROUP BY CURRENT_DATE()