SELECT DISTINCT

    company_name,

    department,

    job_title,

    ROW_NUMBER() OVER(
        ORDER BY company_name
    ) AS company_key

FROM {{ ref('stg_users') }}