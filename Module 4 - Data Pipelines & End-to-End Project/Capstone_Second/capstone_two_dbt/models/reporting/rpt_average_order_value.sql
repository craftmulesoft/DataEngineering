SELECT

    ROUND(AVG(discounted_total),2) AS average_order_value

FROM {{ ref('fact_carts') }}