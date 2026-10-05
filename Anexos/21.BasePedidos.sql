/* =========================================================
   Clase 21 - CRUD de Pedidos
   Script que agrega la tabla Pedidos a la base de datos "Comercio"

   REQUISITO: haber ejecutado antes 19.BaseClientes.sql
   (la tabla Pedidos se relaciona con la tabla Clientes).

   - Crea la tabla Pedidos (si ya existe, la borra y la vuelve a crear).
   - Carga pedidos de prueba.
   - Crea los procedimientos almacenados que se usan desde C#.

   Se puede ejecutar todas las veces que se quiera para
   volver a dejar los pedidos en su estado inicial.
   ========================================================= */

USE master;
GO

IF DB_ID('Comercio') IS NULL
BEGIN
    RAISERROR('No existe la base de datos Comercio. Ejecutar primero 19.BaseClientes.sql', 16, 1);
    SET NOEXEC ON;
END
GO

USE Comercio;
GO

/* ---------------------------------------------------------
   Si el script ya se ejecutó antes, se borra todo lo que
   crea para volver a empezar desde cero.
   --------------------------------------------------------- */
DROP PROCEDURE IF EXISTS sp_Pedidos_Listar;
DROP PROCEDURE IF EXISTS sp_Pedidos_Insertar;
DROP PROCEDURE IF EXISTS sp_Pedidos_Modificar;
DROP PROCEDURE IF EXISTS sp_Pedidos_Eliminar;
DROP PROCEDURE IF EXISTS sp_Clientes_Combo;
DROP TABLE IF EXISTS Pedidos;
GO

/* ---------------------------------------------------------
   Tabla Pedidos
   Cada pedido pertenece a un cliente (clave foránea).
   --------------------------------------------------------- */
CREATE TABLE Pedidos
(
    pedi_id             INT IDENTITY(1,1) PRIMARY KEY,
    pedi_clie_id        INT          NOT NULL,
    pedi_descripcion    VARCHAR(100) NOT NULL,
    pedi_cantidad       INT          NOT NULL,
    pedi_estado         VARCHAR(20)  NOT NULL DEFAULT 'Pendiente',
    pedi_fecha_entrega  DATE         NOT NULL,

    CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (pedi_clie_id)
        REFERENCES Clientes (clie_id),
    CONSTRAINT CK_Pedidos_Cantidad CHECK (pedi_cantidad > 0),
    CONSTRAINT CK_Pedidos_Estado CHECK (pedi_estado IN ('Pendiente', 'En proceso', 'Entregado', 'Cancelado'))
);
GO

/* ---------------------------------------------------------
   Datos de prueba
   Los pedidos se asocian a los clientes buscándolos por DNI,
   así funciona aunque los ID de los clientes hayan cambiado.
   --------------------------------------------------------- */
INSERT INTO Pedidos (pedi_clie_id, pedi_descripcion, pedi_cantidad, pedi_estado, pedi_fecha_entrega)
SELECT c.clie_id, p.descripcion, p.cantidad, p.estado, p.fecha_entrega
FROM (VALUES
    ('30123456', 'Notebook 15 pulgadas',     1, 'Entregado',  '2026-09-10'),
    ('31234567', 'Impresora multifunción',   1, 'Entregado',  '2026-09-18'),
    ('28345678', 'Mouse inalámbrico',        3, 'Cancelado',  '2026-09-25'),
    ('35456789', 'Monitor 24 pulgadas',      2, 'Entregado',  '2026-09-30'),
    ('30123456', 'Teclado mecánico',         1, 'En proceso', '2026-10-08'),
    ('33567890', 'Disco SSD 1 TB',           2, 'En proceso', '2026-10-10'),
    ('40678901', 'Auriculares con micrófono',4, 'Pendiente',  '2026-10-14'),
    ('29789012', 'Router Wi-Fi',             1, 'Pendiente',  '2026-10-16'),
    ('38890123', 'Cartuchos de tinta',       6, 'Pendiente',  '2026-10-20'),
    ('34501234', 'Silla de oficina',         2, 'Pendiente',  '2026-10-23'),
    ('31234567', 'Resma de papel A4',       10, 'Pendiente',  '2026-10-28'),
    ('42012345', 'Webcam Full HD',           1, 'Pendiente',  '2026-11-04')
) AS p (dni, descripcion, cantidad, estado, fecha_entrega)
INNER JOIN Clientes c ON c.clie_dni = p.dni
ORDER BY p.fecha_entrega;
GO

/* ---------------------------------------------------------
   Procedimientos almacenados

   IMPORTANTE: igual que en la clase 19, no se usa
   SET NOCOUNT ON en los SP de INSERT, UPDATE y DELETE.
   Si se usara, ExecuteNonQuery devolvería -1 en lugar de la
   cantidad de filas afectadas.
   --------------------------------------------------------- */

-- Para el ComboBox: ID del cliente y el texto que se va a mostrar
CREATE PROCEDURE sp_Clientes_Combo
AS
BEGIN
    SELECT clie_id,
           clie_apellido + ', ' + clie_nombre AS cliente
    FROM Clientes
    ORDER BY clie_apellido, clie_nombre;
END
GO

-- READ: lista todos los pedidos junto con el nombre del cliente
CREATE PROCEDURE sp_Pedidos_Listar
AS
BEGIN
    SELECT p.pedi_id,
           p.pedi_clie_id,
           c.clie_apellido + ', ' + c.clie_nombre AS cliente,
           p.pedi_descripcion,
           p.pedi_cantidad,
           p.pedi_estado,
           p.pedi_fecha_entrega
    FROM Pedidos p
    INNER JOIN Clientes c ON c.clie_id = p.pedi_clie_id
    ORDER BY p.pedi_fecha_entrega;
END
GO

-- CREATE: da de alta un pedido
CREATE PROCEDURE sp_Pedidos_Insertar
    @clie_id        INT,
    @descripcion    VARCHAR(100),
    @cantidad       INT,
    @estado         VARCHAR(20),
    @fecha_entrega  DATE
AS
BEGIN
    INSERT INTO Pedidos (pedi_clie_id, pedi_descripcion, pedi_cantidad, pedi_estado, pedi_fecha_entrega)
    VALUES (@clie_id, @descripcion, @cantidad, @estado, @fecha_entrega);
END
GO

-- UPDATE: modifica un pedido existente
CREATE PROCEDURE sp_Pedidos_Modificar
    @id             INT,
    @clie_id        INT,
    @descripcion    VARCHAR(100),
    @cantidad       INT,
    @estado         VARCHAR(20),
    @fecha_entrega  DATE
AS
BEGIN
    UPDATE Pedidos
    SET pedi_clie_id       = @clie_id,
        pedi_descripcion   = @descripcion,
        pedi_cantidad      = @cantidad,
        pedi_estado        = @estado,
        pedi_fecha_entrega = @fecha_entrega
    WHERE pedi_id = @id;
END
GO

-- DELETE: elimina un pedido
CREATE PROCEDURE sp_Pedidos_Eliminar
    @id INT
AS
BEGIN
    DELETE FROM Pedidos
    WHERE pedi_id = @id;
END
GO

SET NOEXEC OFF;
GO

/* ---------------------------------------------------------
   Pruebas rápidas (descomentar para probar desde SSMS)
   --------------------------------------------------------- */
-- EXEC sp_Clientes_Combo;
-- EXEC sp_Pedidos_Listar;
-- EXEC sp_Pedidos_Insertar 15, 'Pendrive 64 GB', 2, 'Pendiente', '2026-10-30';
-- EXEC sp_Pedidos_Modificar 13, 15, 'Pendrive 64 GB', 3, 'En proceso', '2026-11-02';
-- EXEC sp_Pedidos_Eliminar 13;
-- SELECT COUNT(*) FROM Pedidos;
