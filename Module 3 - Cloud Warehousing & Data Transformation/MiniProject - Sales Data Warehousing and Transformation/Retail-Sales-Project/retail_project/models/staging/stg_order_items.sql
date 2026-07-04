WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'order_items') }}

),

cleaned_data AS (

    SELECT DISTINCT

        CAST(order_item_id AS INTEGER) AS order_item_id,

        CAST(order_id AS INTEGER) AS order_id,

        CAST(product_id AS INTEGER) AS product_id,

        CAST(
            COALESCE(quantity, 0)
            AS INTEGER
        ) AS quantity

    FROM source_data

)

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity
FROM cleaned_data