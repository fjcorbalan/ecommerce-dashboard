
#Abre la conexión con sqlite, ejecuta consulta SQL, y devuelve un dataframe de python


import sqlite3
import pandas as pd


DB_PATH = "data/ecommerce.db" #donde tenemos nuestra base de datos creada desde load_csv_to_sqlite a partir del csv


def get_connection():

    return sqlite3.connect(DB_PATH)


def run_query(sql_query, params=None):

    conn = get_connection()

    df = pd.read_sql_query(
        sql_query, #sql_query será una consulta SQL hecha manualmente con códico, o una referencia a una consulta SQL en la carpeta sql
        conn,
        params=params #para aceptar parámetros de SQL, que nos permitirán utilizar los filtros (Año, mes, ciudad, producto) y el selector de KPIs, en las visualizaciones
    )

    conn.close()

    return df