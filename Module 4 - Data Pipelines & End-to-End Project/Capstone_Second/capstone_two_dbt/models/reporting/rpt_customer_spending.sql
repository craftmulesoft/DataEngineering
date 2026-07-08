SELECT

    u.user_id,

    u.first_name,

    u.last_name,

    COUNT(f.cart_id) AS total_orders,

    SUM(f.discounted_total) AS total_spent,

    AVG(f.discounted_total) AS average_order_value

FROM {{ ref('fact_carts') }} f

JOIN {{ ref('dim_users') }} u
ON f.user_id = u.user_id

GROUP BY

    u.user_id,

    u.first_name,

    u.last_name