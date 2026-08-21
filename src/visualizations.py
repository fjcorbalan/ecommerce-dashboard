import plotly.express as px


# KPIs, para indicadores en la parte superior del dashboard, conectando con kpis.sql
def kpi_timeseries(df, metric):

    fig = px.line(
        df,
        x="purchase_month_year",
        y=metric, #esto es el KPI, metric será el selector para seleccionar los distintos kpis disponibles, aportando dinamismo, simplicidad y calidad
        markers=True,
        title=f"{metric.replace('_', ' ').title()} over time"
    )

    fig.update_layout(
        xaxis_title="Purchase Month",
        yaxis_title=metric.replace("_", " ").title()
    )

    return fig


# Gráfico de barras de categorías, connectando con category_performance.sql
def category_bar(df, metric):

    df = df.sort_values(
        metric,
        ascending=True
    )

    fig = px.bar(
        df,
        x=metric,
        y="category",
        orientation="h",
        title=f"{metric.replace('_', ' ').title()} by Product Category"
    )

    fig.update_layout(
        xaxis_title=metric.replace("_", " ").title(),
        yaxis_title="Product Category"
    )

    return fig

# Gráfico de mapa, connectando con city_performance.sql
def city_map(df, metric):

    fig = px.scatter_map(
        df,
        lat="lat",
        lon="lng",
        size=metric, #también utilizamos el KPI para el tamaño de las burbujas del gráfico
        hover_name="city",
        hover_data=[
            "state",
            "customers",
            "orders",
            "revenue"
        ],
        zoom=3,
        height=600,
        title=f"{metric.replace('_', ' ').title()} by Location"
    )

    fig.update_layout(
        map_style="open-street-map"
    )

    return fig