
with main as (
    SELECT 
        o.*,
        c.*,
        pay.*,
        i.*,
        prod.*,
        g.*,
        e.*
    FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.customer_id
        LEFT JOIN order_payments pay ON o.order_id = pay.order_id
        LEFT JOIN order_items i ON o.order_id = i.order_id
        LEFT JOIN products prod ON i.product_id = prod.product_id
        LEFT JOIN products_english_name e ON prod.product_category_name = e.product_category_name
        LEFT JOIN geolocation g ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix

)

select DISTINCT date(order_purchase_timestamp)
from main
order by order_purchase_timestamp


;


