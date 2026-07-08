WITH source AS (

    SELECT RAW_DATA

    FROM {{ source('raw','raw_users') }}

),

flatten_users AS (

    SELECT
        VALUE AS user_data

    FROM source,
    LATERAL FLATTEN(input => RAW_DATA:users)

)

SELECT

    user_data:id::INTEGER               AS user_id,

    user_data:firstName::STRING         AS first_name,

    user_data:lastName::STRING          AS last_name,

    user_data:maidenName::STRING        AS maiden_name,

    user_data:age::INTEGER              AS age,

    user_data:gender::STRING            AS gender,

    user_data:email::STRING             AS email,

    user_data:phone::STRING             AS phone,

    user_data:username::STRING          AS username,

    user_data:bloodGroup::STRING        AS blood_group,

    user_data:eyeColor::STRING          AS eye_color,

    user_data:birthDate::DATE           AS birth_date,

    user_data:height::FLOAT             AS height,

    user_data:weight::FLOAT             AS weight,

    user_data:image::STRING             AS image_url,
    user_data:company.name::STRING AS company_name,
    user_data:company.department::STRING AS department,
    user_data:company.title::STRING AS job_title,
    user_data:address.city::STRING AS city,
    user_data:address.state::STRING AS state,
    user_data:address.country::STRING AS country

FROM flatten_users