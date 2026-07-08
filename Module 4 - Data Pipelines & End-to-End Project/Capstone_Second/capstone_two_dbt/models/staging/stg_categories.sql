WITH source AS (

    SELECT RAW_DATA
    FROM {{ source('raw', 'raw_categories') }}

),

flatten_categories AS (

    SELECT VALUE AS category
    FROM source,
    LATERAL FLATTEN(input => RAW_DATA)

)

SELECT

    category:name::STRING AS category_name,
    category:slug::STRING AS category_slug,
    category:url::STRING  AS category_url

FROM flatten_categories