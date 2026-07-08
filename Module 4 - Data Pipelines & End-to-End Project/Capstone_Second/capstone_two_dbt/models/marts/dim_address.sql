SELECT DISTINCT

    city,

    state,

    country,

    ROW_NUMBER() OVER(
        ORDER BY city
    ) AS address_key

FROM {{ ref('stg_users') }}