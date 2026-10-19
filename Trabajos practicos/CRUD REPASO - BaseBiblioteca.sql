USE master;
GO

IF DB_ID('Biblioteca') IS NOT NULL
BEGIN
    ALTER DATABASE Biblioteca SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Biblioteca;
END
GO

CREATE DATABASE Biblioteca;
GO

USE Biblioteca;
GO

/* ---------------------------------------------------------
   Tabla Libros
   --------------------------------------------------------- */
CREATE TABLE Libros
(
    libr_id      INT IDENTITY(1,1) PRIMARY KEY,
    libr_titulo  VARCHAR(100) NOT NULL,
    libr_autor   VARCHAR(60)  NOT NULL,
    libr_anio    INT          NOT NULL,
    libr_stock   INT          NOT NULL DEFAULT 0,

    CONSTRAINT CK_Libros_Stock CHECK (libr_stock >= 0)
);
GO

/* ---------------------------------------------------------
   Datos de prueba
   --------------------------------------------------------- */
INSERT INTO Libros (libr_titulo, libr_autor, libr_anio, libr_stock) VALUES
('Martín Fierro',                     'José Hernández',          1872, 5),
('Ficciones',                         'Jorge Luis Borges',       1944, 3),
('El túnel',                          'Ernesto Sabato',          1948, 2),
('Rayuela',                           'Julio Cortázar',          1963, 4),
('Cien años de soledad',              'Gabriel García Márquez',  1967, 6),
('Mafalda 1',                         'Quino',                   1966, 8),
('El principito',                     'Antoine de Saint-Exupéry',1943, 7),
('Cuentos de la selva',               'Horacio Quiroga',         1918, 4),
('Don Segundo Sombra',                'Ricardo Güiraldes',       1926, 1),
('Harry Potter y la piedra filosofal','J. K. Rowling',           1997, 5),
('El Eternauta',                      'Héctor G. Oesterheld',    1957, 3),
('Las aventuras de Tom Sawyer',       'Mark Twain',              1876, 0);
GO

/* ---------------------------------------------------------
   Procedimientos almacenados

   IMPORTANTE: igual que en las clases 19 y 21, no se usa
   SET NOCOUNT ON en los SP de INSERT, UPDATE y DELETE.
   Si se usara, ExecuteNonQuery devolvería -1 en lugar de la
   cantidad de filas afectadas.
   --------------------------------------------------------- */

-- READ: lista todos los libros
CREATE PROCEDURE sp_Libros_Listar
AS
BEGIN
    SELECT libr_id, libr_titulo, libr_autor, libr_anio, libr_stock
    FROM Libros
    ORDER BY libr_titulo;
END
GO

-- CREATE: da de alta un libro
CREATE PROCEDURE sp_Libros_Insertar
    @titulo  VARCHAR(100),
    @autor   VARCHAR(60),
    @anio    INT,
    @stock   INT
AS
BEGIN
    INSERT INTO Libros (libr_titulo, libr_autor, libr_anio, libr_stock)
    VALUES (@titulo, @autor, @anio, @stock);
END
GO

-- UPDATE: modifica un libro existente
CREATE PROCEDURE sp_Libros_Modificar
    @id      INT,
    @titulo  VARCHAR(100),
    @autor   VARCHAR(60),
    @anio    INT,
    @stock   INT
AS
BEGIN
    UPDATE Libros
    SET libr_titulo = @titulo,
        libr_autor  = @autor,
        libr_anio   = @anio,
        libr_stock  = @stock
    WHERE libr_id = @id;
END
GO

-- DELETE: lo crean los alumnos (sp_Libros_Eliminar)

/* ---------------------------------------------------------
   Pruebas rápidas (descomentar para probar desde SSMS)
   --------------------------------------------------------- */
-- EXEC sp_Libros_Listar;
-- EXEC sp_Libros_Insertar 'Juvenilia', 'Miguel Cané', 1884, 2;
-- EXEC sp_Libros_Modificar 13, 'Juvenilia', 'Miguel Cané', 1884, 4;
-- SELECT COUNT(*) FROM Libros;
