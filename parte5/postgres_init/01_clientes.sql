-- Fuente 3 (PostgreSQL): dimension de clientes
CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY,
  nombre_cliente VARCHAR(100),
  ciudad VARCHAR(50),
  segmento VARCHAR(20)
);

INSERT INTO clientes (id_cliente, nombre_cliente, ciudad, segmento) VALUES
(1, 'Ana Torres', 'Quito', 'Individual'),
(2, 'Carlos Vega', 'Guayaquil', 'Individual'),
(3, 'Empresa Andina S.A.', 'Quito', 'Empresa'),
(4, 'María López', 'Cuenca', 'Individual'),
(5, 'Distribuidora Sur Ltda.', 'Loja', 'Empresa'),
(6, 'Jorge Ramírez', 'Quito', 'Individual'),
(7, 'Comercial Pacífico', 'Manta', 'Empresa'),
(8, 'Lucía Fernández', 'Ambato', 'Individual'),
(9, 'Grupo Oriente S.A.', 'Tena', 'Empresa'),
(10, 'Pedro Castillo', 'Ibarra', 'Individual');
