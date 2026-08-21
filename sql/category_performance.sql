--Para gráfico de barras de categorías
--Única consulta donde creamos una tabla por categoría, con los kpis de interés de otras tablas
SELECT

    pe.product_category_name_english AS category,

    SUM(oi.price) AS product_revenue,

    COUNT(DISTINCT oi.order_id) AS orders,

    COUNT(DISTINCT c.customer_unique_id) AS customers,

    SUM(oi.price) * 1.0
        / COUNT(DISTINCT oi.order_id) AS aov,

    SUM(oi.price) * 1.0
        / COUNT(DISTINCT c.customer_unique_id) AS arpc

FROM order_items oi

INNER JOIN orders o
    ON oi.order_id = o.order_id


LEFT JOIN customers c 
        ON o.customer_id = c.customer_id


LEFT JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN products_english_name pe
    ON p.product_category_name = pe.product_category_name

WHERE o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-11-01'

GROUP BY
    pe.product_category_name_english

ORDER BY product_revenue DESC;