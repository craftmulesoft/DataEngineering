SELECT

    difficulty,

    COUNT(*) AS total_recipes

FROM {{ ref('stg_recipes') }}

GROUP BY difficulty

ORDER BY total_recipes DESC