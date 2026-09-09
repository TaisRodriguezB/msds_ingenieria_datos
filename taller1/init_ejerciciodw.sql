-- ============================================================
-- ejerciciodw — script de inicialización (Semana 1, Taller en clase 1)
-- Reconstruido verbatim a partir de script_día_3.pdf y script_dia_4_parte_1.pdf
-- Se ejecuta automáticamente si se coloca en /docker-entrypoint-initdb.d/
-- ============================================================

CREATE DATABASE IF NOT EXISTS ejerciciodw
DEFAULT CHARACTER SET = 'utf8mb4';

USE ejerciciodw;

-- IMPORTANTE: fuerza a que el cliente envíe/reciba en utf8mb4.
-- Sin esta línea, si ejecutas el script con un cliente cuyo charset
-- por defecto no es utf8mb4 (muy común en mysql CLI / algunos GUIs),
-- las tildes y la ñ se guardan mal-codificadas ("doble UTF-8") y las
-- comparaciones/joins por categoria_producto o nombre_region fallan
-- en silencio (0 filas emparejadas, sin ningún error).
SET NAMES utf8mb4;

-- ------------------------------------------------------------
-- Paso 1: Tablas de origen (OLTP)
-- ------------------------------------------------------------

-- Tabla de ventas
CREATE TABLE ventas (
  id_venta INT PRIMARY KEY AUTO_INCREMENT,
  fecha_venta DATE,
  id_producto INT,
  id_region INT,
  cantidad INT,
  precio_unitario DECIMAL(10, 2),
  monto_total DECIMAL(10, 2)
);

-- Tabla de productos
CREATE TABLE productos (
  id_producto INT PRIMARY KEY AUTO_INCREMENT,
  nombre_producto VARCHAR(100),
  categoria_producto VARCHAR(50),
  precio DECIMAL(10, 2)
);

-- Tabla de regiones
CREATE TABLE regiones (
  id_region INT PRIMARY KEY AUTO_INCREMENT,
  nombre_region VARCHAR(50),
  pais VARCHAR(50)
);

-- Tabla de calendario (fechas)
CREATE TABLE calendario (
  id_tiempo INT PRIMARY KEY AUTO_INCREMENT,
  fecha DATE,
  anio INT,
  mes INT,
  dia INT,
  dia_semana VARCHAR(20),
  semana INT
);

-- ------------------------------------------------------------
-- Datos de ejemplo (originales + extras dados en clase)
-- ------------------------------------------------------------

-- Productos (33 filas, id_producto 1-33)
INSERT INTO productos (nombre_producto, categoria_producto, precio) VALUES
('Laptop', 'Electrónica', 1000.00),
('Smartphone', 'Electrónica', 500.00),
('Escritorio', 'Muebles', 200.00),
('Tablet', 'Electrónica', 300.00),
('Televisor', 'Electrónica', 800.00),
('Impresora', 'Electrónica', 150.00),
('Silla de Oficina', 'Muebles', 100.00),
('Cama', 'Muebles', 500.00),
('Refrigerador', 'Electrodomésticos', 700.00),
('Microondas', 'Electrodomésticos', 120.00),
('Auriculares', 'Electrónica', 50.00),
('Mouse', 'Electrónica', 20.00),
('Teclado', 'Electrónica', 30.00),
('Monitor', 'Electrónica', 250.00),
('Sofá', 'Muebles', 600.00),
('Mesa de Comedor', 'Muebles', 400.00),
('Lámpara', 'Decoración', 45.00),
('Cuadro Decorativo', 'Decoración', 60.00),
('Colchón', 'Muebles', 350.00),
('Ventilador', 'Electrodomésticos', 80.00),
('Licuadora', 'Electrodomésticos', 100.00),
('Tostadora', 'Electrodomésticos', 70.00),
('Plancha', 'Electrodomésticos', 40.00),
('Cámara Fotográfica', 'Electrónica', 900.00),
('Bocina Bluetooth', 'Electrónica', 120.00),
('Cargador Portátil', 'Electrónica', 40.00),
('Espejo', 'Decoración', 75.00),
('Cajonera', 'Muebles', 150.00),
('Escritorio Gamer', 'Muebles', 300.00),
('Juego de Ollas', 'Cocina', 200.00),
('Horno Eléctrico', 'Cocina', 250.00),
('Cafetera', 'Cocina', 100.00),
('Lámpara de Pie', 'Decoración', 120.00);

-- Regiones (33 filas, id_region 1-33)
INSERT INTO regiones (nombre_region, pais) VALUES
('Norte', 'México'),
('Sur', 'México'),
('Centro', 'México'),
('Este', 'México'),
('Oeste', 'México'),
('Noreste', 'México'),
('Noroeste', 'México'),
('Sureste', 'México'),
('Suroeste', 'México'),
('Centro-Sur', 'México'),
('Altiplano', 'México'),
('Pacífico', 'México'),
('Golfo', 'México'),
('Bajío', 'México'),
('Norte Chico', 'México'),
('Sur Profundo', 'México'),
('Occidente', 'México'),
('Istmo', 'México'),
('Peninsula', 'México'),
('Caribe', 'México'),
('Central', 'México'),
('Metropolitana', 'México'),
('Fronteriza', 'México'),
('Desértica', 'México'),
('Sierra Madre', 'México'),
('Selva', 'México'),
('Costa', 'México'),
('Altas Montañas', 'México'),
('Llanura Costera', 'México'),
('Región Lagunera', 'México'),
('Mixteca', 'México'),
('Tehuantepec', 'México'),
('Tierra Caliente', 'México');

-- Fechas / calendario (32 filas, del 2025-01-01 al 2025-02-01)
INSERT INTO calendario (fecha, anio, mes, dia, dia_semana, semana) VALUES
('2025-01-01', 2025, 1, 1, 'Miércoles', 1),
('2025-01-02', 2025, 1, 2, 'Jueves', 1),
('2025-01-03', 2025, 1, 3, 'Viernes', 1),
('2025-01-04', 2025, 1, 4, 'Sábado', 1),
('2025-01-05', 2025, 1, 5, 'Domingo', 1),
('2025-01-06', 2025, 1, 6, 'Lunes', 2),
('2025-01-07', 2025, 1, 7, 'Martes', 2),
('2025-01-08', 2025, 1, 8, 'Miércoles', 2),
('2025-01-09', 2025, 1, 9, 'Jueves', 2),
('2025-01-10', 2025, 1, 10, 'Viernes', 2),
('2025-01-11', 2025, 1, 11, 'Sábado', 2),
('2025-01-12', 2025, 1, 12, 'Domingo', 2),
('2025-01-13', 2025, 1, 13, 'Lunes', 3),
('2025-01-14', 2025, 1, 14, 'Martes', 3),
('2025-01-15', 2025, 1, 15, 'Miércoles', 3),
('2025-01-16', 2025, 1, 16, 'Jueves', 3),
('2025-01-17', 2025, 1, 17, 'Viernes', 3),
('2025-01-18', 2025, 1, 18, 'Sábado', 3),
('2025-01-19', 2025, 1, 19, 'Domingo', 3),
('2025-01-20', 2025, 1, 20, 'Lunes', 4),
('2025-01-21', 2025, 1, 21, 'Martes', 4),
('2025-01-22', 2025, 1, 22, 'Miércoles', 4),
('2025-01-23', 2025, 1, 23, 'Jueves', 4),
('2025-01-24', 2025, 1, 24, 'Viernes', 4),
('2025-01-25', 2025, 1, 25, 'Sábado', 4),
('2025-01-26', 2025, 1, 26, 'Domingo', 4),
('2025-01-27', 2025, 1, 27, 'Lunes', 5),
('2025-01-28', 2025, 1, 28, 'Martes', 5),
('2025-01-29', 2025, 1, 29, 'Miércoles', 5),
('2025-01-30', 2025, 1, 30, 'Jueves', 5),
('2025-01-31', 2025, 1, 31, 'Viernes', 5),
('2025-02-01', 2025, 2, 1, 'Sábado', 5);

-- Ventas (32 filas)
INSERT INTO ventas (fecha_venta, id_producto, id_region, cantidad, precio_unitario, monto_total) VALUES
('2025-01-01', 1, 1, 5, 1000.00, 5000.00),
('2025-01-02', 2, 2, 3, 500.00, 1500.00),
('2025-01-03', 3, 3, 10, 200.00, 2000.00),
('2025-01-04', 4, 4, 2, 100.00, 200.00),
('2025-01-05', 5, 5, 3, 500.00, 1500.00),
('2025-01-06', 6, 6, 1, 700.00, 700.00),
('2025-01-07', 7, 7, 5, 120.00, 600.00),
('2025-01-08', 8, 8, 4, 50.00, 200.00),
('2025-01-09', 9, 9, 10, 20.00, 200.00),
('2025-01-10', 10, 10, 8, 30.00, 240.00),
('2025-01-11', 11, 11, 2, 250.00, 500.00),
('2025-01-12', 12, 12, 1, 600.00, 600.00),
('2025-01-13', 13, 13, 7, 400.00, 2800.00),
('2025-01-14', 14, 14, 6, 45.00, 270.00),
('2025-01-15', 15, 15, 3, 60.00, 180.00),
('2025-01-16', 16, 16, 1, 350.00, 350.00),
('2025-01-17', 17, 17, 3, 80.00, 240.00),
('2025-01-18', 18, 18, 5, 100.00, 500.00),
('2025-01-19', 19, 19, 2, 70.00, 140.00),
('2025-01-20', 20, 20, 8, 40.00, 320.00),
('2025-01-21', 21, 1, 4, 900.00, 3600.00),
('2025-01-22', 22, 2, 7, 120.00, 840.00),
('2025-01-23', 23, 3, 9, 40.00, 360.00),
('2025-01-24', 24, 4, 6, 75.00, 450.00),
('2025-01-25', 25, 5, 5, 150.00, 750.00),
('2025-01-26', 26, 6, 8, 300.00, 2400.00),
('2025-01-27', 27, 7, 10, 200.00, 2000.00),
('2025-01-28', 28, 8, 4, 250.00, 1000.00),
('2025-01-29', 29, 9, 3, 100.00, 300.00),
('2025-01-30', 30, 10, 8, 120.00, 960.00),
('2025-01-31', 1, 11, 5, 1000.00, 5000.00),
('2025-02-01', 2, 12, 2, 500.00, 1000.00);

-- ------------------------------------------------------------
-- Paso 2: Tablas de destino (Data Warehouse — esquema estrella)
-- ------------------------------------------------------------

CREATE TABLE dim_producto (
  id_producto INT PRIMARY KEY,
  nombre_producto VARCHAR(100),
  categoria_producto VARCHAR(50)
);

CREATE TABLE dim_region (
  id_region INT PRIMARY KEY,
  nombre_region VARCHAR(50),
  pais VARCHAR(50)
);

CREATE TABLE dim_tiempo (
  id_tiempo INT PRIMARY KEY AUTO_INCREMENT,
  fecha DATE,
  anio INT,
  mes INT,
  dia INT,
  dia_semana VARCHAR(20),
  semana INT
);

CREATE TABLE hechos_ventas (
  id_venta INT PRIMARY KEY AUTO_INCREMENT,
  id_producto INT,
  id_tiempo INT,
  id_region INT,
  unidades_vendidas INT,
  monto_venta DECIMAL(10, 2),
  FOREIGN KEY (id_producto) REFERENCES dim_producto(id_producto),
  FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
  FOREIGN KEY (id_region) REFERENCES dim_region(id_region)
);

-- ------------------------------------------------------------
-- Paso 3: ETL — transformación y carga de origen -> DW
-- ------------------------------------------------------------

INSERT INTO dim_producto (id_producto, nombre_producto, categoria_producto)
SELECT id_producto, nombre_producto, categoria_producto
FROM productos;

INSERT INTO dim_region (id_region, nombre_region, pais)
SELECT id_region, nombre_region, pais
FROM regiones;

INSERT INTO dim_tiempo (fecha, anio, mes, dia, dia_semana, semana)
SELECT fecha, anio, mes, dia, dia_semana, semana
FROM calendario;

INSERT INTO hechos_ventas (id_producto, id_tiempo, id_region, unidades_vendidas, monto_venta)
SELECT
  v.id_producto,
  t.id_tiempo,
  v.id_region,
  v.cantidad,
  v.monto_total
FROM ventas v
JOIN calendario t ON v.fecha_venta = t.fecha;

-- ------------------------------------------------------------
-- Vista de análisis mensual (usada en el material del Día 3)
-- ------------------------------------------------------------
CREATE VIEW ventas_mensuales AS
SELECT
  t.anio,
  t.mes,
  p.categoria_producto,
  SUM(h.monto_venta) AS total_ventas
FROM hechos_ventas h
JOIN dim_tiempo t ON h.id_tiempo = t.id_tiempo
JOIN dim_producto p ON h.id_producto = p.id_producto
GROUP BY t.anio, t.mes, p.categoria_producto;
