SELECT

    id,
    title,
    description,
    category,
    image,
    price,
    rating_rate,
    rating_count,

    -- Price Segmentation
    CASE
        WHEN price < 50 THEN 'Budget'
        WHEN price < 100 THEN 'Standard'
        ELSE 'Premium'
    END AS price_segment,

    -- Rating Classification
    CASE
        WHEN rating_rate >= 4.5 THEN 'Excellent'
        WHEN rating_rate >= 4.0 THEN 'Good'
        WHEN rating_rate >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END AS rating_category,

    -- Review Volume
    CASE
        WHEN rating_count >= 300 THEN 'Very High'
        WHEN rating_count >= 150 THEN 'High'
        WHEN rating_count >= 50 THEN 'Medium'
        ELSE 'Low'
    END AS review_volume,

    -- Price Band
    CASE
        WHEN price < 25 THEN '0 - 25'
        WHEN price < 50 THEN '25 - 50'
        WHEN price < 100 THEN '50 - 100'
        WHEN price < 250 THEN '100 - 250'
        ELSE '250+'
    END AS price_band

FROM {{ ref('stg_products') }}