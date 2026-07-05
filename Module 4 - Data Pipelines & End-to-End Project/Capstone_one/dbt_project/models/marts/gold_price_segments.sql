SELECT

    price_segment,

    price_band,

    COUNT(*) AS total_products,

    ROUND(AVG(price), 2) AS average_price,

    ROUND(AVG(rating_rate), 2) AS average_rating

FROM {{ ref('int_products') }}

GROUP BY

    price_segment,
    price_band