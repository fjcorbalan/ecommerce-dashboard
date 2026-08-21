-- CTE1: agregando revenue por order
WITH order_revenue AS (

    SELECT
        order_id,
        SUM(payment_value) AS revenue
    FROM order_payments
    GROUP BY order_id

),

--CTE2: agregando el revenue de la CTE1, por mes de compra
monthly_revenue AS (

    SELECT

        strftime('%Y-%m', o.order_purchase_timestamp) AS month,

        SUM(COALESCE(r.revenue, 0)) AS revenue

    FROM orders o

    LEFT JOIN order_revenue r
        ON o.order_id = r.order_id

    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-11-01'

    GROUP BY
        strftime('%Y-%m', o.order_purchase_timestamp)
),

--CTE3: agregando el revenue de la CTE1, por mes de compra
current_vs_previous AS (

    SELECT

        current.month,

        current.revenue AS current_revenue,

        previous.revenue AS previous_year_revenue

    FROM monthly_revenue current

    LEFT JOIN monthly_revenue previous

        ON substr(current.month, 6, 2)
           = substr(previous.month, 6, 2)

        AND CAST(substr(previous.month, 1, 4) AS INTEGER)
            = CAST(substr(current.month, 1, 4) AS INTEGER) - 1

)

SELECT

    month,

    current_revenue,

    previous_year_revenue,

    (
        current_revenue - previous_year_revenue
    ) * 1.0
    / NULLIF(previous_year_revenue, 0) AS yoy

FROM current_vs_previous

WHERE month >= '2018-01'
  AND month <= '2018-10'

ORDER BY month;