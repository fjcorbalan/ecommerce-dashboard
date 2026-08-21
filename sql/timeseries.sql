-- CTE1: agregando revenue por order
WITH order_revenue AS (

    SELECT
        order_id,
        SUM(payment_value) AS revenue
    FROM order_payments
    GROUP BY order_id

),

--CTE2: unimos el revenue por order de la CTE1, a la tabla de orders donde tenemos fecha, id de cliente, etc; y añadimos una columna con el mes de compra
monthly_orders AS (

    SELECT
        strftime('%Y-%m', o.order_purchase_timestamp) AS purchase_month_year,
        strftime('%m', o.order_purchase_timestamp) AS purchase_month,
        strftime('%Y', o.order_purchase_timestamp) AS purchase_year,

        c.customer_unique_id,
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,

        COALESCE(r.revenue, 0) AS revenue

    FROM orders o

    LEFT JOIN customers c 
        ON o.customer_id = c.customer_id

    LEFT JOIN order_revenue r
        ON o.order_id = r.order_id

    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-11-01'
)

--totalizamos y agrupamos por mes
SELECT
    purchase_month_year,
    purchase_month,
    purchase_year,

    SUM(revenue) AS revenue,

    COUNT(DISTINCT order_id) AS orders,

    COUNT(DISTINCT customer_unique_id) AS customers,

    SUM(revenue) * 1.0
        / COUNT(DISTINCT order_id) AS aov,

    SUM(revenue) * 1.0
        / COUNT(DISTINCT customer_unique_id) AS arpc,

    AVG(
        julianday(order_delivered_customer_date)
        - julianday(order_purchase_timestamp)
    ) AS avg_delivery_days

FROM monthly_orders

GROUP BY purchase_month_year

ORDER BY purchase_month_year;