WITH source AS (

    SELECT raw_data
    FROM {{ source('raw', 'raw_quotes') }}

),

flatten_quotes AS (

    SELECT value AS quote_data
    FROM source,
        LATERAL FLATTEN(input => raw_data:quotes)

)

SELECT

    quote_data:id::INTEGER AS quote_id,
    quote_data:quote::STRING AS quote,
    quote_data:author::STRING AS author

FROM flatten_quotes
