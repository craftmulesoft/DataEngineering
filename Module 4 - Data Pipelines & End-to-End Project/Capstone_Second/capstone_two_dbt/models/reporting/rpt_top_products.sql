SELECT

    p.product_name,

    SUM(f.quantity) AS quantity_sold,

    SUM(f.gross_sales) AS revenue

FROM {{ ref('fact_product_sales') }} f

JOIN {{ ref('dim_products') }} p

ON f.product_id = p.product_id

GROUP BY

    p.product_name

ORDER BY revenue DESC