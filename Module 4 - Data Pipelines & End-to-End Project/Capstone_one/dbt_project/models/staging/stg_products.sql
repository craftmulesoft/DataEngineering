SELECT

    id,
    title,
    description,
    category,
    price,
    image,
    rating_rate,
    rating_count

FROM {{ source('raw', 'products') }}