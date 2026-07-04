WITH sales AS (

    SELECT *
    FROM {{ ref('int_sales') }}

)

SELECT

    product_id,

    product_name,

    product_category,

    unit_price,

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(quantity) AS units_sold,

    SUM(revenue) AS total_revenue,

    DENSE_RANK() OVER (

        ORDER BY SUM(revenue) DESC

    ) AS best_selling_rank

FROM sales

GROUP BY

    product_id,

    product_name,

    product_category,

    unit_price