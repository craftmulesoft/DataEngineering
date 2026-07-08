SELECT

    DATE_TRUNC('MONTH', CURRENT_DATE()) AS sales_month,

    SUM(gross_sales) AS revenue

FROM {{ ref('fact_product_sales') }}

GROUP BY DATE_TRUNC('MONTH', CURRENT_DATE())