SELECT

    company_name,

    COUNT(*) AS employees

FROM {{ ref('dim_company') }}

GROUP BY company_name

ORDER BY employees DESC