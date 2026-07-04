WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'products') }}

),

cleaned_data AS (

    SELECT DISTINCT

        CAST(product_id AS INTEGER) AS product_id,

        TRIM(product_name) AS product_name,

        INITCAP(TRIM(category)) AS product_category,

        CAST(
            COALESCE(price, 0)
            AS NUMBER(10,2)
        ) AS product_price

    FROM source_data

)

SELECT
    product_id,
    product_name,
    product_category,
    product_price
FROM cleaned_data