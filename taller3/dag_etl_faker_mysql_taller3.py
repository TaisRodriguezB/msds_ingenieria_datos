"""
Taller 3 - MSDS 6012 Ingenieria de Datos - USFQ
Grupo 15: Gandhi Mora, Tais Rodriguez

DAG "DAG + DB": genera datos falsos con Faker y los carga en MySQL,
en tres tareas encadenadas (crear_tabla -> generar_y_cargar_datos -> verificar_carga).
"""
from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.mysql.hooks.mysql import MySqlHook
from faker import Faker
import random

MYSQL_CONN_ID = "mysql_taller3"
TABLE_NAME = "clientes_streaming"
N_ROWS = 500

default_args = {
    "owner": "grupo15",
    "retries": 1,
}


def crear_tabla():
    hook = MySqlHook(mysql_conn_id=MYSQL_CONN_ID)
    hook.run(
        f"""
        CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nombre VARCHAR(100),
            email VARCHAR(150),
            ciudad VARCHAR(100),
            monto_compra DECIMAL(10,2),
            fecha_registro DATETIME
        )
        """
    )


def generar_y_cargar_datos():
    fake = Faker()
    hook = MySqlHook(mysql_conn_id=MYSQL_CONN_ID)
    filas = [
        (
            fake.name(),
            fake.email(),
            fake.city(),
            round(random.uniform(10, 2000), 2),
            fake.date_time_this_year(),
        )
        for _ in range(N_ROWS)
    ]
    hook.insert_rows(
        table=TABLE_NAME,
        rows=filas,
        target_fields=["nombre", "email", "ciudad", "monto_compra", "fecha_registro"],
    )


def verificar_carga():
    hook = MySqlHook(mysql_conn_id=MYSQL_CONN_ID)
    total = hook.get_first(f"SELECT COUNT(*) FROM {TABLE_NAME}")[0]
    print(f"Filas totales en {TABLE_NAME}: {total}")


with DAG(
    dag_id="dag_etl_faker_mysql_taller3",
    description="Taller 3 - ETL Faker -> MySQL (DAG + DB)",
    default_args=default_args,
    schedule_interval=None,
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=["taller3", "streaming"],
) as dag:

    t1 = PythonOperator(task_id="crear_tabla", python_callable=crear_tabla)
    t2 = PythonOperator(task_id="generar_y_cargar_datos", python_callable=generar_y_cargar_datos)
    t3 = PythonOperator(task_id="verificar_carga", python_callable=verificar_carga)

    t1 >> t2 >> t3
