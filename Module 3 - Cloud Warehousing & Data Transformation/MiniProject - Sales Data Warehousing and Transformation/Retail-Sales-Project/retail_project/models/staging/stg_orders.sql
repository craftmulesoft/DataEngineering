WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'orders') }}

),

cleaned_data AS (

    SELECT DISTINCT

        CAST(order_id AS INTEGER) AS order_id,

        CAST(customer_id AS INTEGER) AS customer_id,

        CAST(order_date AS DATE) AS order_date

    FROM source_data

)

SELECT
    order_id,
    customer_id,
    order_date
FROM cleaned_data