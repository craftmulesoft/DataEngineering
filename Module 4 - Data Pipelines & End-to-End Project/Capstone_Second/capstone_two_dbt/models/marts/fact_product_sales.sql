SELECT

    cart_id,

    user_id,

    product_id,

    quantity,

    price,

    discounted_total,

    quantity * price AS gross_sales

FROM {{ ref('int_cart_products') }}