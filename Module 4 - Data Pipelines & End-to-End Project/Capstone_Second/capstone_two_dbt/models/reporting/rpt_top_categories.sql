SELECT

    p.category,

    SUM(f.gross_sales) AS total_sales,

    SUM(f.quantity) AS quantity_sold

FROM {{ ref('fact_product_sales') }} f

JOIN {{ ref('dim_products') }} p

ON f.product_id = p.product_id

GROUP BY

    p.category

ORDER BY total_sales DESC