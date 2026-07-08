SELECT

    user_id,

    first_name,

    last_name,

    age,

    gender,

    email,

    phone,

    username,

    birth_date,

    height,

    weight,

    blood_group,

    eye_color,

    image_url

FROM {{ ref('stg_users') }}