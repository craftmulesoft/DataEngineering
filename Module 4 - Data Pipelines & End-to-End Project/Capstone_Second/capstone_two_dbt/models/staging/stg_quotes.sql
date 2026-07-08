WITH source AS (

    SELECT RAW_DATA
    FROM {{ source('raw', 'raw_quotes') }}

),

flatten_quotes AS (

    SELECT VALUE AS quote_data
    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:quotes)

)

SELECT

    quote_data:id::INTEGER         AS quote_id,
    quote_data:quote::STRING       AS quote,
    quote_data:author::STRING      AS author

FROM flatten_quotes