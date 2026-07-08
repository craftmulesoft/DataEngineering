SELECT

    user_id,

    COUNT(*) AS total_posts

FROM {{ ref('stg_posts') }}

GROUP BY user_id

ORDER BY total_posts DESC