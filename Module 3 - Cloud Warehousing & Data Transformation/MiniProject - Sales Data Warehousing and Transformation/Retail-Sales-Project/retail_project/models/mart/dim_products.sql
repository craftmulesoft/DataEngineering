WITH products AS (

    SELECT *
    FROM {{ ref('stg_products') }}

)

SELECT DISTINCT

    product_id,

    product_name,

    product_category,

    product_price

FROM products