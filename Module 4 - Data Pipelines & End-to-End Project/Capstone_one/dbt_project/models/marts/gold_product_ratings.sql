SELECT

    id,

    title,

    category,

    price,

    rating_rate,

    rating_count,

    rating_category,

    review_volume,

    DENSE_RANK() OVER (
        ORDER BY rating_rate DESC,
                 rating_count DESC
    ) AS product_rank

FROM {{ ref('int_products') }}