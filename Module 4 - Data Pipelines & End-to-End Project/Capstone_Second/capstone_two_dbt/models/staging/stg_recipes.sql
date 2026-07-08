WITH source AS (

    SELECT RAW_DATA
    FROM {{ source('raw', 'raw_recipes') }}

),

flatten_recipes AS (

    SELECT
        VALUE AS recipe
    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:recipes)

)

SELECT

    recipe:id::INTEGER AS recipe_id,

    recipe:name::STRING AS recipe_name,

    recipe:difficulty::STRING AS difficulty,

    recipe:cuisine::STRING AS cuisine,

    recipe:prepTimeMinutes::INTEGER AS prep_time,

    recipe:cookTimeMinutes::INTEGER AS cook_time,

    recipe:servings::INTEGER AS servings

FROM flatten_recipes