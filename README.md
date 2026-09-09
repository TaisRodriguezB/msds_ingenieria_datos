# msds_ingenieria_datos

Repositorio de trabajo para **MSDS 6012 — Ingeniería de Datos** (USFQ, Prof. Juan Pablo Zaldumbide).

## Estructura

```
msds_ingenieria_datos/
├── taller1/
│   ├── init_ejerciciodw.sql       # Crea y puebla la base ejerciciodw (fuentes + esquema estrella)
│   ├── docker-compose.yml         # Levanta MySQL 8 + Adminer con la base ya inicializada
│   ├── descuentos_categoria.csv   # Segunda fuente de datos (referencia, no se usa para cargar)
│   └── etl_taller1.sql            # Solución del ETL (Parte 4 del taller)
└── parte5/
    ├── docker-compose.yml         # Levanta PostgreSQL + MongoDB (fuentes 3 y 4)
    ├── postgres_init/01_clientes.sql   # Dimensión clientes (PostgreSQL)
    ├── mongo_init/init.js              # Dimensión canal de venta (MongoDB)
    ├── calendario.csv                  # Dimensión tiempo (CSV)
    ├── bridge_ventas_cliente_canal.sql # Tabla puente venta-cliente-canal (MySQL)
    ├── Taller1_Parte5.knwf              # Workflow de KNIME (ETL completo)
    └── Informe-Ejecutivo-Taller1-Parte5.pdf  # Informe ejecutivo del proceso
```

## Taller 1 — cómo correrlo

```bash
cd taller1
docker compose up -d
```

Esto crea la base `ejerciciodw` en un contenedor de MySQL, con las tablas de origen (`ventas`, `productos`, `regiones`, `calendario`) y el esquema estrella (`dim_producto`, `dim_region`, `dim_tiempo`, `hechos_ventas`) ya poblados. MySQL queda en `localhost:3306` (usuario `root`, password `root`) y Adminer disponible en `http://localhost:8080`.

## Taller 1 — Parte 4 (ETL): qué se pidió y cómo se resolvió

La Parte 4 del taller pide un flujo ETL con al menos **2 fuentes de datos**, **4 técnicas de transformación** y **1 destino** final.

**Decisión de enfoque:** en vez de KNIME, se resolvió con SQL directo desde VSCode (extensión Database Client), conectado a la misma base `ejerciciodw`. El resultado final —dos fuentes combinadas, cuatro transformaciones aplicadas y una tabla nueva de destino— es equivalente a construir el mismo flujo con nodos visuales; solo cambia la herramienta usada para expresarlo.

| Requisito | Cómo se cumple |
|---|---|
| Fuente 1 | Tablas `hechos_ventas` + `dim_producto` de `ejerciciodw` (ventas ya generadas en el Día 3/4 del curso) |
| Fuente 2 | Tabla nueva `descuentos_categoria`: un % de descuento por categoría de producto — una regla de negocio que no existe en la base original del profesor |
| Transformación 1 | `TRIM()` sobre `categoria_producto` — limpieza/estandarización de texto antes de cruzar las fuentes |
| Transformación 2 | `JOIN` entre ventas y descuentos por categoría — combinación de fuentes |
| Transformación 3 | Columna calculada `monto_neto = monto_venta * (1 - descuento_pct/100)` — enriquecimiento de datos |
| Transformación 4 | `GROUP BY categoria_producto` con `SUM()` — agregación |
| Destino | Tabla nueva `resumen_ventas_categoria`, creada con `CREATE TABLE ... AS SELECT` |

El script completo está en [`taller1/etl_taller1.sql`](taller1/etl_taller1.sql).

### Resultado (verificado)

| Categoría | Unidades vendidas | Monto bruto | Descuento | Monto neto |
|---|---:|---:|---:|---:|
| Electrónica | 56 | 22,670.00 | 5% | 21,536.50 |
| Electrodomésticos | 46 | 5,560.00 | 8% | 5,115.20 |
| Muebles | 32 | 4,770.00 | 10% | 4,293.00 |
| Decoración | 18 | 2,740.00 | 12% | 2,411.20 |
| Cocina | 8 | 960.00 | 6% | 902.40 |
| **Total** | **160** | **36,700.00** | — | **34,258.30** |

El monto bruto total (36,700.00) coincide con `SELECT SUM(monto_venta) FROM hechos_ventas`, confirmando que ninguna venta se perdió ni se duplicó en el cruce entre las dos fuentes.

## Taller 1 — Parte 5 (individual): flujo ETL en KNIME con 4 fuentes y modelo estrella

A diferencia de la Parte 4, aquí el taller exige explícitamente usar **nodos de KNIME** para el flujo completo, con **al menos 4 fuentes de datos heterogéneas** y un **modelo estrella de al menos 5 dimensiones + 1 tabla de hechos**.

### Fuentes usadas

| # | Tecnología | Contenido | Filas |
|---|---|---|---:|
| 1 | CSV | `parte5/calendario.csv` — dimensión tiempo | 32 |
| 2 | MySQL (`ejerciciodw`) | ventas, productos, regiones + tabla puente | 32 / 33 / 33 / 32 |
| 3 | PostgreSQL (`clientes_db`) | catálogo de clientes | 10 |
| 4 | MongoDB (`ejerciciodw`) | colección `canal_venta` | 4 |

Levantar las fuentes de Postgres y Mongo (MySQL ya viene de `taller1/`):

```bash
cd parte5
docker compose up -d
```

### Modelo estrella resultante (en MySQL `ejerciciodw`)

- `dim_tiempo_p5`, `dim_producto_p5`, `dim_region_p5`, `dim_cliente_p5`, `dim_canal_venta_p5` (dimensiones)
- `hechos_ventas_360` (tabla de hechos, 5 llaves foráneas + 3 medidas)

Se usó el sufijo `_p5` en las dimensiones que replican conceptos del Taller 1 (tiempo, producto, región) para no chocar con las tablas ya existentes en la misma base `ejerciciodw`.

### Workflow de KNIME

El flujo completo (extracción de las 4 fuentes, transformación con nodos `Joiner`, `String to Date&Time`, `String Manipulation` y `Column Filter`, y carga con `DB Writer`) está en [`parte5/Taller1_Parte5.knwf`](parte5/Taller1_Parte5.knwf).

### Informe ejecutivo

El proceso completo, el diseño del DW, los problemas reales encontrados durante la construcción (y su solución) y la verificación final están documentados en [`parte5/Informe-Ejecutivo-Taller1-Parte5.pdf`](parte5/Informe-Ejecutivo-Taller1-Parte5.pdf).
