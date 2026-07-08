WITH source AS (

    SELECT RAW_DATA

    FROM {{ source('raw','raw_carts') }}

),

flatten_carts AS (

    SELECT VALUE AS cart

    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:carts)

)

SELECT

    cart:id::INTEGER AS cart_id,

    cart:userId::INTEGER AS user_id,

    cart:total::NUMBER AS total,

    cart:discountedTotal::NUMBER AS discounted_total,

    cart:totalProducts::INTEGER AS total_products,

    cart:totalQuantity::INTEGER AS total_quantity,

    cart:products AS products

FROM flatten_carts