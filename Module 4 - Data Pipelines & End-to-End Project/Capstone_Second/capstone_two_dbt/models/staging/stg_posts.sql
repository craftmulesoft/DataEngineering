WITH source AS (

    SELECT RAW_DATA
    FROM {{ source('raw', 'raw_posts') }}

),

flatten_posts AS (

    SELECT
        VALUE AS post_data
    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:posts)

)

SELECT

    post_data:id::INTEGER AS post_id,

    post_data:userId::INTEGER AS user_id,

    post_data:title::STRING AS title,

    post_data:body::STRING AS body,

    post_data:views::INTEGER AS views

FROM flatten_posts