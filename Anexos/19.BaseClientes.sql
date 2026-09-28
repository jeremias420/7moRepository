/* =========================================================
   Clase 19 - CRUD de Clientes
   Script de creación de la base de datos "Comercio"

   - Crea la base de datos (si ya existe, la borra y la vuelve a crear).
   - Crea la tabla Clientes.
   - Carga datos de prueba.
   - Crea los procedimientos almacenados que se usan desde C#.

   Se puede ejecutar todas las veces que se quiera para
   volver a dejar la base en su estado inicial.
   ========================================================= */

USE master;
GO

IF DB_ID('Comercio') IS NOT NULL
BEGIN
    ALTER DATABASE Comercio SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Comercio;
END
GO

CREATE DATABASE Comercio;
GO

USE Comercio;
GO

/* ---------------------------------------------------------
   Tabla Clientes
   --------------------------------------------------------- */
CREATE TABLE Clientes
(
    clie_id          INT IDENTITY(1,1) PRIMARY KEY,
    clie_nombre      VARCHAR(50)  NOT NULL,
    clie_apellido    VARCHAR(50)  NOT NULL,
    clie_dni         VARCHAR(10)  NOT NULL UNIQUE,
    clie_email       VARCHAR(100) NULL,
    clie_telefono    VARCHAR(20)  NULL,
    clie_fecha_alta  DATE         NOT NULL DEFAULT GETDATE()
);
GO

/* ---------------------------------------------------------
   Datos de prueba
   --------------------------------------------------------- */
INSERT INTO Clientes (clie_nombre, clie_apellido, clie_dni, clie_email, clie_telefono, clie_fecha_alta) VALUES
('Juan',      'Pérez',     '30123456', 'juan.perez@gmail.com',      '11-4567-1234', '2025-03-10'),
('María',     'González',  '31234567', 'maria.gonzalez@hotmail.com','11-5678-2345', '2025-03-15'),
('Carlos',    'Rodríguez', '28345678', 'crodriguez@yahoo.com',      '11-6789-3456', '2025-04-02'),
('Laura',     'Fernández', '35456789', 'laura.fernandez@gmail.com', '11-7890-4567', '2025-04-20'),
('Diego',     'López',     '33567890', 'diego.lopez@outlook.com',   '11-8901-5678', '2025-05-05'),
('Sofía',     'Martínez',  '40678901', 'sofi.martinez@gmail.com',   '11-9012-6789', '2025-05-18'),
('Martín',    'García',    '29789012', 'mgarcia@empresa.com.ar',    '11-2345-7890', '2025-06-01'),
('Lucía',     'Sánchez',   '38890123', 'lucia.sanchez@gmail.com',   '11-3456-8901', '2025-06-22'),
('Federico',  'Romero',    '32901234', 'fede.romero@hotmail.com',   '11-4567-9012', '2025-07-07'),
('Valentina', 'Díaz',      '42012345', 'valen.diaz@gmail.com',      '11-5678-0123', '2025-07-30'),
('Pablo',     'Álvarez',   '27123450', 'palvarez@yahoo.com',        NULL,           '2025-08-12'),
('Camila',    'Torres',    '41234501', NULL,                        '11-6789-1122', '2025-08-25'),
('Nicolás',   'Ruiz',      '36345012', 'nico.ruiz@gmail.com',       '11-7890-2233', '2025-09-03'),
('Florencia', 'Gómez',     '39450123', 'flor.gomez@outlook.com',    '11-8901-3344', '2025-09-19'),
('Matías',    'Acosta',    '34501234', 'matias.acosta@gmail.com',   '11-9012-4455', '2025-10-01');
GO

/* ---------------------------------------------------------
   Procedimientos almacenados

   IMPORTANTE: no se usa SET NOCOUNT ON en los SP de
   INSERT, UPDATE y DELETE. Si se usara, ExecuteNonQuery
   devolvería -1 en lugar de la cantidad de filas afectadas
   y no podríamos saber desde C# si la operación funcionó.
   --------------------------------------------------------- */

-- READ: lista todos los clientes
CREATE PROCEDURE sp_Clientes_Listar
AS
BEGIN
    SELECT clie_id, clie_nombre, clie_apellido, clie_dni,
           clie_email, clie_telefono, clie_fecha_alta
    FROM Clientes
    ORDER BY clie_apellido, clie_nombre;
END
GO

-- READ: busca por nombre, apellido o DNI
CREATE PROCEDURE sp_Clientes_Buscar
    @texto VARCHAR(50)
AS
BEGIN
    SELECT clie_id, clie_nombre, clie_apellido, clie_dni,
           clie_email, clie_telefono, clie_fecha_alta
    FROM Clientes
    WHERE clie_nombre   LIKE '%' + @texto + '%'
       OR clie_apellido LIKE '%' + @texto + '%'
       OR clie_dni      LIKE '%' + @texto + '%'
    ORDER BY clie_apellido, clie_nombre;
END
GO

-- CREATE: da de alta un cliente
CREATE PROCEDURE sp_Clientes_Insertar
    @nombre   VARCHAR(50),
    @apellido VARCHAR(50),
    @dni      VARCHAR(10),
    @email    VARCHAR(100),
    @telefono VARCHAR(20)
AS
BEGIN
    INSERT INTO Clientes (clie_nombre, clie_apellido, clie_dni, clie_email, clie_telefono)
    VALUES (@nombre, @apellido, @dni, @email, @telefono);
END
GO

-- UPDATE: modifica un cliente existente
CREATE PROCEDURE sp_Clientes_Modificar
    @id       INT,
    @nombre   VARCHAR(50),
    @apellido VARCHAR(50),
    @dni      VARCHAR(10),
    @email    VARCHAR(100),
    @telefono VARCHAR(20)
AS
BEGIN
    UPDATE Clientes
    SET clie_nombre   = @nombre,
        clie_apellido = @apellido,
        clie_dni      = @dni,
        clie_email    = @email,
        clie_telefono = @telefono
    WHERE clie_id = @id;
END
GO

-- DELETE: elimina un cliente
CREATE PROCEDURE sp_Clientes_Eliminar
    @id INT
AS
BEGIN
    DELETE FROM Clientes
    WHERE clie_id = @id;
END
GO

/* ---------------------------------------------------------
   Pruebas rápidas (descomentar para probar desde SSMS)
   --------------------------------------------------------- */
-- EXEC sp_Clientes_Listar;
-- EXEC sp_Clientes_Buscar 'mar';
-- EXEC sp_Clientes_Insertar 'Ana', 'Molina', '43111222', 'ana.molina@gmail.com', '11-1111-2222';
-- EXEC sp_Clientes_Modificar 16, 'Ana', 'Molina', '43111222', 'ana.molina@gmail.com', '11-3333-4444';
-- EXEC sp_Clientes_Eliminar 16;
-- SELECT COUNT(*) FROM Clientes;
