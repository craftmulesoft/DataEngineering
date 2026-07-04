WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

)

SELECT DISTINCT

    customer_id,

    customer_name,

    customer_email,

    customer_city,

    customer_country

FROM customers