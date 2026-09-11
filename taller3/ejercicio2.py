# Taller 3 - MSDS 6012 Ingenieria de Datos - USFQ
# Grupo 15: Gandhi Mora, Tais Rodriguez
#
# Ejercicio 2: RDD + Spark SQL sobre el dataset UCI "Bank Marketing".
# Version PySpark equivalente al notebook ejercicio2.zpln (Zeppelin).
from pyspark.sql import SparkSession, Row

spark = SparkSession.builder.appName("ZeppelinBank").master("local[*]").getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("ERROR")

# Dataset real UCI "Bank Marketing" (bank-full.csv, 45,211 registros) ya disponible
# localmente (bankfull_dia4.csv) en vez de descargarlo de archive.ics.uci.edu
# (bloqueado por la politica de red del sandbox). Mismo dataset, formato CSV
# con encabezado y separado por comas en vez de punto y coma.
bankText = sc.textFile("bankfull_dia4.csv")
header = bankText.first()

bank = (
    bankText.filter(lambda line: line != header)
    .map(lambda s: s.split(","))
    .map(lambda s: Row(age=int(s[0]), job=s[1], marital=s[2], education=s[3], balance=int(s[5])))
)

bank.toDF().createOrReplaceTempView("bank")

print("=== select age, count(1) from bank group by age order by age (primeras 15 filas) ===")
spark.sql("select age, count(1) from bank group by age order by age").show(15)

print("=== select marital, count(1) from bank group by marital ===")
spark.sql("select marital, count(1) from bank group by marital").show()

print("=== select job, count(1) from bank group by job order by count(1) desc ===")
spark.sql("select job, count(1) from bank group by job order by count(1) desc").show(20)

spark.stop()
