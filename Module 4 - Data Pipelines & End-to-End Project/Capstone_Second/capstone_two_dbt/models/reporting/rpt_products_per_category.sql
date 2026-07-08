SELECT

    category,

    COUNT(*) AS total_products

FROM {{ ref('dim_products') }}

GROUP BY category

ORDER BY total_products DESC