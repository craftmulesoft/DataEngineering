WITH source AS (

    SELECT raw_data

    FROM {{ source('raw','raw_products') }}

),

flatten_products AS (

    SELECT value AS product

    FROM source,
        LATERAL FLATTEN(input => raw_data:products)

)

SELECT

    product:id::INTEGER AS product_id,

    product:title::STRING AS product_name,

    product:category::STRING AS category,

    product:brand::STRING AS brand,

    product:price::NUMBER AS price,

    product:rating::FLOAT AS rating,

    product:stock::INTEGER AS stock

FROM flatten_products
