WITH source AS (

    SELECT raw_data
    FROM {{ source('raw', 'raw_categories') }}

),

flatten_categories AS (

    SELECT value AS category
    FROM source,
        LATERAL FLATTEN(input => raw_data)

)

SELECT

    category:name::STRING AS category_name,
    category:slug::STRING AS category_slug,
    category:url::STRING AS category_url

FROM flatten_categories
