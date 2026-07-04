WITH sales AS (

    SELECT *
    FROM {{ ref('int_sales') }}

)

SELECT

    order_id,

    customer_id,

    product_id,

    order_item_id,

    order_date,

    quantity,

    unit_price,

    revenue

FROM sales