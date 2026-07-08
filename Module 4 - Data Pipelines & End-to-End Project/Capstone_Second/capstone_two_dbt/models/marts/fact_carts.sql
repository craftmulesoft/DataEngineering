SELECT

    cart_id,

    user_id,

    total,

    discounted_total,

    total_products,

    total_quantity

FROM {{ ref('stg_carts') }}