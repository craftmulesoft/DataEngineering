WITH carts AS (

    SELECT *

    FROM {{ ref('stg_carts') }}

),

flatten_products AS (

    SELECT

        cart_id,

        user_id,

        VALUE AS product

    FROM carts,
    LATERAL FLATTEN(input => products)

)

SELECT

    cart_id,

    user_id,

    product:id::INTEGER AS product_id,

    product:quantity::INTEGER AS quantity,

    product:price::NUMBER AS price,

    product:discountedTotal::NUMBER AS discounted_total

FROM flatten_products