-- ============================================================
-- Taller en clase 1 - Parte 5 (ETL con 4 fuentes)
-- Tabla puente: conecta cada venta (MySQL) con su cliente (Postgres)
-- y su canal de venta (MongoDB), ya que las 3 fuentes no comparten
-- una llave natural. El mapeo es determinista, generado con
-- (id_venta - 1) % 10 + 1 para cliente y (id_venta - 1) % 4 + 1 para canal,
-- para poder unir en KNIME sin depender de una relacion real en los datos.
-- ============================================================
USE ejerciciodw;

CREATE TABLE IF NOT EXISTS ventas_cliente_canal (
  id_venta INT PRIMARY KEY,
  id_cliente INT,
  id_canal INT
);

INSERT INTO ventas_cliente_canal (id_venta, id_cliente, id_canal) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 1),
(6, 6, 2),
(7, 7, 3),
(8, 8, 4),
(9, 9, 1),
(10, 10, 2),
(11, 1, 3),
(12, 2, 4),
(13, 3, 1),
(14, 4, 2),
(15, 5, 3),
(16, 6, 4),
(17, 7, 1),
(18, 8, 2),
(19, 9, 3),
(20, 10, 4),
(21, 1, 1),
(22, 2, 2),
(23, 3, 3),
(24, 4, 4),
(25, 5, 1),
(26, 6, 2),
(27, 7, 3),
(28, 8, 4),
(29, 9, 1),
(30, 10, 2),
(31, 1, 3),
(32, 2, 4);
