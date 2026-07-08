SELECT DISTINCT

    category,

    ROW_NUMBER() OVER(
        ORDER BY category
    ) AS category_key

FROM {{ ref('stg_products') }}