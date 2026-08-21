ecommerce-dashboard/

Dashboard que mostrará el seguimiento de los KPIs principales en tres bloques fundamentales:

1: Indicadores: en la parte superior mostraremos los KPIs más importantes con su variación con respecto al año anterior
2: Gráfico de barras por categoría de producto: donde mostraremos los mismos kpis por producto
3: Gráfico de mapa: aquí de nuevo mostraremos los kpis de interes por localización de compra

Habrá un Selector de KPI con el cual podremos aportar dinamismo al dashboard, más información en menos espacio

También añadiremos filtros de Año de compra, y ciudad

datos: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Construido con:

- Python
- SQLite
- Plotly
- Streamlit

Estructura:

├── app.py                 ← Aplicación Streamlit
├── requirements.txt       ← Dependencias Python
├── README.md              ← Documentación Proyecto
├── .gitignore             ← Archivos a ignorar por GIT (no es necesario de momento)
│
├── data/                  ← Archivos CSV y fuente de datos SQLite
├── sql/                   ← Consultas SQL (archivos .sql)
├── src/                   ← Módulos reutilizables de Python
├── scripts/               ← Códico único (por ejemplo load CSV cuando recibimos un nuevo archivo CSV)



Flujo:

                PRESENTATION
             ┌───────────────┐
             │ Streamlit App │
             └───────▲───────┘
                     │
             Plotly Gráficos
                     ▲
                     │
          Análisis Estadístico
                     ▲
                     │
            SQL resultados consulta
                     ▲
                     │
           SQLite Database
                     ▲
                     │
                 CSV Dataset





ESQUEMA DE BASE DE DATOS DE COMERCIO ELECTRÓNICO (ECOMMERCE)
Base de datos SQLite:
data/ecommerce.db

TABLAS
customers (clientes)
CSV de origen: olist_customers_dataset.csv

customer_id
Clave primaria para el registro del cliente.
Vinculado a orders.customer_id.

customer_unique_id
Identificador del cliente real.
IMPORTANTE: un customer_unique_id puede aparecer en múltiples
registros de customer_id, así que utiliza COUNT(DISTINCT customer_unique_id)
al calcular el número de clientes.

customer_zip_code_prefix
Prefijo del código postal del cliente.
Se utiliza para vincular a los clientes con la geolocalización.

customer_city (ciudad_del_cliente)
customer_state (estado/provincia_del_cliente)

orders (pedidos)
CSV de origen: olist_orders_dataset.csv

order_id
Clave primaria.
Una fila representa un pedido.

customer_id
Vincula a customers.customer_id.

order_status (estado_del_pedido)

order_purchase_timestamp
Fecha principal utilizada para el análisis de ventas/ingresos.

order_approved_at (fecha_de_aprobación)

order_delivered_carrier_date (fecha_de_entrega_al_transportista)

order_delivered_customer_date
Se utiliza junto con order_purchase_timestamp
para calcular el tiempo de entrega al cliente.

order_estimated_delivery_date (fecha_estimada_de_entrega)

order_payments (pagos_del_pedido)
CSV de origen: olist_order_payments_dataset.csv

order_id
Vincula a orders.order_id.

payment_sequential (secuencia_de_pago)

payment_type (tipo_de_pago)

payment_installments (cuotas_de_pago)

payment_value
Monto del pago.
Se utiliza como la definición de INGRESOS DEL PANEL (DASHBOARD REVENUE).
Para las visualizaciones relativas a category_performance.sql, tomaremos como revenue exclusivamente el precio del producto (price de la tabla olist_order_items_dataset): es decir, asumimos que el freight value también es revenue de la empresa

IMPORTANTE:
Puede haber múltiples filas de pago para un solo pedido.
Por lo tanto, payment_value debe agregarse por order_id
antes de hacer el JOIN con orders al calcular los ingresos.

order_items (artículos_del_pedido)
CSV de origen: olist_order_items_dataset.csv

order_id
Vincula a orders.order_id.

order_item_id
Junto con order_id identifica un artículo del pedido.

product_id
Vincula a products.product_id.

seller_id (id_del_vendedor)

shipping_limit_date (fecha_límite_de_envío)

price
Precio del producto/artículo.
Se utiliza para el análisis de ingresos por producto/categoría.

freight_value
Valor del envío.

products (productos)
CSV de origen: olist_products_dataset.csv

product_id
Clave primaria.
Vincula a order_items.product_id.

product_category_name
Nombre de la categoría del producto en portugués.

product_name_length (longitud_del_nombre)
product_description_length (longitud_de_la_descripción)
product_photos_qty (cantidad_de_fotos)
product_weight_g (peso_en_gramos)
product_length_cm (longitud_en_cm)
product_height_cm (altura_en_cm)
product_width_cm (ancho_en_cm)

products_english_name (nombre_de_productos_en_inglés)
CSV de origen: product_category_name_translation.csv

product_category_name
Vincula a products.product_category_name.

product_category_name_english
Traducción al inglés de la categoría del producto.

geolocation (geolocalización)
CSV de origen: olist_geolocation_dataset.csv

geolocation_zip_code_prefix
Prefijo del código postal.

geolocation_lat
Latitud.

geolocation_lng
Longitud.

geolocation_city (ciudad)
geolocation_state (estado/provincia)

IMPORTANTE:
Puede haber múltiples filas de geolocalización para el mismo prefijo de código postal.
Por lo tanto, el panel agrega la latitud y la longitud
utilizando AVG() antes de hacer el JOIN con customers.

RELACIONES
customers
customer_id
│
▼
orders
order_id
├──────────────► order_payments.order_id
│
└──────────────► order_items.order_id

order_items
product_id
│
▼
products
product_id
│
▼
products_english_name
product_category_name
▲
│
products.product_category_name

customers
customer_zip_code_prefix
│
▼
geolocation
geolocation_zip_code_prefix

RUTAS ANALÍTICAS PRINCIPALES
INGRESOS
orders
↓
order_payments
↓
SUM(payment_value)

PEDIDOS
orders
↓
COUNT(DISTINCT order_id)

CLIENTES
orders
↓
customers
↓
COUNT(DISTINCT customer_unique_id)

ANÁLISIS DE CATEGORÍAS
orders
↓
order_items
↓
products
↓
products_english_name

ANÁLISIS GEOGRÁFICO
orders
↓
customers
↓
geolocation

DEFINICIONES DE NEGOCIO IMPORTANTES
Ingresos (Revenue)
SUM(payment_value)

Pedidos (Orders)
COUNT(DISTINCT order_id)

Clientes (Customers)
COUNT(DISTINCT customer_unique_id)

AOV (Valor Promedio del Pedido)
Ingresos / Pedidos

ARPC (Ingreso Promedio por Cliente)
Ingresos / Clientes Distintos

Promedio de Días de Entrega
AVG(
julianday(order_delivered_customer_date)
- julianday(order_purchase_timestamp)
)

Ingresos por Categoría de Producto
SUM(order_items.price)

Período del informe del panel (Dashboard reporting period)
Enero de 2017 - Octubre de 2018

Período del informe actual (Current reporting period)
Enero de 2018 - Octubre de 2018

Comparación interanual (YoY comparison)
Enero-Octubre de 2018
frente a
Enero-Octubre de 2017






