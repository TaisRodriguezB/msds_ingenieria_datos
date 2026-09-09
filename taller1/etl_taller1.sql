-- ============================================================
-- Taller en clase 1 - Parte 4 (ETL)
-- Fuente 1: tablas de MySQL (hechos_ventas + dim_producto, ya
--           generadas por init_ejerciciodw.sql)
-- Fuente 2: tabla descuentos_categoria (regla de negocio nueva,
--           no existe en la base original del profesor)
-- Transformaciones: TRIM (limpieza), JOIN (combinacion),
--           columna calculada monto_neto (enriquecimiento),
--           GROUP BY (agregacion)
-- Destino: tabla nueva resumen_ventas_categoria
-- ============================================================

USE ejerciciodw;

CREATE TABLE descuentos_categoria (
  categoria_producto VARCHAR(50) PRIMARY KEY,
  descuento_pct DECIMAL(5,2)
);

INSERT INTO descuentos_categoria (categoria_producto, descuento_pct) VALUES
('Electrónica', 5),
('Muebles', 10),
('Electrodomésticos', 8),
('Decoración', 12),
('Cocina', 6);

CREATE TABLE resumen_ventas_categoria AS
SELECT
  TRIM(p.categoria_producto) AS categoria_producto,
  SUM(h.unidades_vendidas)   AS unidades_vendidas,
  SUM(h.monto_venta)         AS monto_bruto,
  d.descuento_pct,
  ROUND(SUM(h.monto_venta) * (1 - d.descuento_pct/100), 2) AS monto_neto
FROM hechos_ventas h
JOIN dim_producto p ON h.id_producto = p.id_producto
JOIN descuentos_categoria d ON TRIM(p.categoria_producto) = TRIM(d.categoria_producto)
GROUP BY p.categoria_producto, d.descuento_pct;

SELECT * FROM resumen_ventas_categoria ORDER BY monto_neto DESC;
