ecommerce-dashboard/

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


Mapa de schema:

customers
    │
    │ customer_id
    ▼
orders
    │
    ├───────────────► order_items ◄──────────── products
    │                      │                         │
    │                      │                         │
    │                      ▼                         ▼
    │                   sellers              category_translation
    │
    ├───────────────► order_payments
    │
    └───────────────► order_reviews