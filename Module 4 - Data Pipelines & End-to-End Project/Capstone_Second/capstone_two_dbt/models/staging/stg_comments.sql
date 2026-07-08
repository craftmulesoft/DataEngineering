WITH source AS (

    SELECT RAW_DATA
    FROM {{ source('raw', 'raw_comments') }}

),

flatten_comments AS (

    SELECT VALUE AS comment_data
    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:comments)

)

SELECT

    comment_data:id::INTEGER            AS comment_id,
    comment_data:body::STRING           AS comment,
    comment_data:postId::INTEGER        AS post_id,
    comment_data:user.id::INTEGER       AS user_id,
    comment_data:user.username::STRING  AS username

FROM flatten_comments