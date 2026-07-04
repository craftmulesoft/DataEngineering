WITH source_data AS (

    SELECT *
    FROM {{ source('raw', 'customers') }}

),

cleaned_data AS (

    SELECT DISTINCT

        CAST(customer_id AS INTEGER) AS customer_id,

        TRIM(first_name) AS customer_first_name,

        TRIM(last_name) AS customer_last_name,

        UPPER(
            CONCAT(
                TRIM(first_name),
                ' ',
                TRIM(last_name)
            )
        ) AS customer_name,

        LOWER(TRIM(email)) AS customer_email,

        INITCAP(TRIM(city)) AS customer_city,

        INITCAP(TRIM(country)) AS customer_country

    FROM source_data

)

SELECT
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_name,
    customer_email,
    customer_city,
    customer_country
FROM cleaned_data