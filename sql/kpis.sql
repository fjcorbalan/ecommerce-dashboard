-- KPIs, para indicadores en la parte superior del dashboard

-- CTE1: agregando revenue por order
WITH order_revenue AS (

    SELECT
        order_id,
        SUM(payment_value) AS revenue
    FROM order_payments
    GROUP BY order_id

),

-- CTE2: unimos el revenue por order a orders y customers
order_metrics AS (

    SELECT
        c.customer_unique_id,
        o.order_id,
        o.customer_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        r.revenue

    FROM orders o

    LEFT JOIN customers c
        ON o.customer_id = c.customer_id

    LEFT JOIN order_revenue r
        ON o.order_id = r.order_id

    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-11-01'

),

-- CTE3: calculamos los KPIs para cada año
yearly_kpis AS (

    SELECT

        strftime('%Y', order_purchase_timestamp) AS purchase_year,

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

    FROM order_metrics

    GROUP BY purchase_year

),

-- CTE4: juntamos 2018 con 2017 para poder calcular YoY
current_vs_previous AS (

    SELECT

        current.purchase_year,

        current.revenue AS revenue_current,
        previous.revenue AS revenue_previous,

        current.orders AS orders_current,
        previous.orders AS orders_previous,

        current.customers AS customers_current,
        previous.customers AS customers_previous,

        current.aov AS aov_current,
        previous.aov AS aov_previous,

        current.arpc AS arpc_current,
        previous.arpc AS arpc_previous,

        current.avg_delivery_days AS avg_delivery_days_current,
        previous.avg_delivery_days AS avg_delivery_days_previous

    FROM yearly_kpis current

    LEFT JOIN yearly_kpis previous

        ON CAST(previous.purchase_year AS INTEGER)
           = CAST(current.purchase_year AS INTEGER) - 1

)

-- Resultado final: KPIs actuales + valores LY + variación YoY
SELECT

    purchase_year,

    revenue_current,
    revenue_previous,

    (
        revenue_current - revenue_previous
    ) * 1.0
    / NULLIF(revenue_previous, 0) AS revenue_yoy,


    orders_current,
    orders_previous,

    (
        orders_current - orders_previous
    ) * 1.0
    / NULLIF(orders_previous, 0) AS orders_yoy,


    customers_current,
    customers_previous,

    (
        customers_current - customers_previous
    ) * 1.0
    / NULLIF(customers_previous, 0) AS customers_yoy,


    aov_current,
    aov_previous,

    (
        aov_current - aov_previous
    ) * 1.0
    / NULLIF(aov_previous, 0) AS aov_yoy,


    arpc_current,
    arpc_previous,

    (
        arpc_current - arpc_previous
    ) * 1.0
    / NULLIF(arpc_previous, 0) AS arpc_yoy,


    avg_delivery_days_current,
    avg_delivery_days_previous,

    (
        avg_delivery_days_current - avg_delivery_days_previous
    ) * 1.0
    / NULLIF(avg_delivery_days_previous, 0) AS avg_delivery_days_yoy

FROM current_vs_previous

WHERE purchase_year = '2018';