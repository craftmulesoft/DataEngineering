WITH source AS (

    SELECT raw_data
    FROM {{ source('raw', 'raw_comments') }}

),

flatten_comments AS (

    SELECT value AS comment_data
    FROM source,
        LATERAL FLATTEN(input => raw_data:comments)

)

SELECT

    comment_data:id::INTEGER AS comment_id,
    comment_data:body::STRING AS comment,
    comment_data:postId::INTEGER AS post_id,
    comment_data:user.id::INTEGER AS user_id,
    comment_data:user.username::STRING AS username

FROM flatten_comments
