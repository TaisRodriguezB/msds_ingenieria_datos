# Taller 3 - MSDS 6012 Ingenieria de Datos - USFQ
# Grupo 15: Gandhi Mora, Tais Rodriguez
#
# Ejercicio 1: DataFrame de Spark con datos de ventas + agregacion por producto.
# Version PySpark equivalente al notebook ejercicio1.zpln (Zeppelin).
from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.functions import col, sum as spark_sum

spark = SparkSession.builder.appName("ZeppelinDF").master("local[*]").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

data = [
    Row(id=1, producto="Celular", cantidad=2, precio=500, fecha="2025-01-01"),
    Row(id=2, producto="Laptop", cantidad=1, precio=1200, fecha="2025-01-02"),
    Row(id=3, producto="Tablet", cantidad=3, precio=300, fecha="2025-01-03"),
    Row(id=4, producto="Celular", cantidad=1, precio=500, fecha="2025-01-04"),
    Row(id=5, producto="Laptop", cantidad=2, precio=1200, fecha="2025-01-05"),
]

df = spark.createDataFrame(data)
print("=== df.show() ===")
df.show()

ventas_por_producto = df.groupBy("producto").agg(spark_sum(col("cantidad") * col("precio")).alias("total_ventas"))
print("=== ventas_por_producto.show() ===")
ventas_por_producto.show()

spark.stop()
