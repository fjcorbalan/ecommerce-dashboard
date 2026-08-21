-- Para gráfico de mapa
-- CTE1: agregando revenue por order
WITH order_revenue AS (
    SELECT
        order_id,
        SUM(payment_value) AS revenue
    FROM order_payments
    GROUP BY order_id
),

-- CTE 2: Deduplicamos códigos postales calculando la media de latitud y longitud por código postal
clean_geolocation AS (
    SELECT
        --convirtiendo el campo código postal a un número entero ya que era un número decimal
        PRINTF('%05d', CAST(geolocation_zip_code_prefix AS INT)) AS zip_code_prefix, 
        AVG(geolocation_lat) AS lat,
        AVG(geolocation_lng) AS lng
    FROM geolocation
    GROUP BY 1
)

SELECT
    --convirtiendo el campo código postal a un número entero ya que era un número decimal, del mismo modo que hacemos en clean_geolocation
    PRINTF('%05d', CAST(c.customer_zip_code_prefix AS INT)) AS customer_zip_code, 
    c.customer_city AS city,
    c.customer_state AS state,
    
    g.lat,
    g.lng,

    COUNT(DISTINCT c.customer_unique_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(COALESCE(r.revenue, 0)) AS revenue

FROM orders o

INNER JOIN customers c
    ON o.customer_id = c.customer_id

LEFT JOIN clean_geolocation g
    ON PRINTF('%05d', CAST(c.customer_zip_code_prefix AS INT)) = g.zip_code_prefix

LEFT JOIN order_revenue r
    ON o.order_id = r.order_id

WHERE o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-11-01'

--Para agrupar, no necesariamente tenemos que explicitar el nombre de los campos, en este caso nos referimos a las las cinco primeras variables n estamos consultando (las no numéricas)
GROUP BY
    1, 2, 3, 4, 5 

ORDER BY revenue DESC;