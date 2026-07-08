WITH source AS (

    SELECT RAW_DATA

    FROM {{ source('raw','raw_products') }}

),

flatten_products AS (

    SELECT VALUE AS product

    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:products)

)

SELECT

    product:id::INTEGER         AS product_id,

    product:title::STRING       AS product_name,

    product:category::STRING    AS category,

    product:brand::STRING       AS brand,

    product:price::NUMBER       AS price,

    product:rating::FLOAT       AS rating,

    product:stock::INTEGER      AS stock

FROM flatten_products