SELECT

    category,

    COUNT(*) AS total_products,

    ROUND(AVG(price), 2) AS average_price,

    ROUND(AVG(rating_rate), 2) AS average_rating,

    SUM(rating_count) AS total_reviews,

    MIN(price) AS minimum_price,

    MAX(price) AS maximum_price

FROM {{ ref('int_products') }}

GROUP BY category