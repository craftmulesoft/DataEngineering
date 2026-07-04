WITH base As (
    SELECT 
       o.order_id,
       c.name AS customer_name,
       o.order_date,
       s.status AS order_status,
       DATE_DIFF('hour', s.shipped_at, s.delivered_at) AS delivery_hours
    from {{ ref('stg_order') }} o
    JOIN {{ ref('stg_shipments') }} s ON o.order_id = s.order_id
    JOIN {{ ref('stg_customer') }} c ON o.customer_id = c.customer_id
)

SELECT *
   CASE WHEN status = 'shipped' AND delivery_hours > 48 THEN 'DELAYED' ELSE status END AS order_status
FROM base;