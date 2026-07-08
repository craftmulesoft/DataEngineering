SELECT

    product_id,

    product_name,

    brand,

    category,

    price,

    rating,

    stock

FROM {{ ref('stg_products') }}