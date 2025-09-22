-- Crear tabla
CREATE TABLE bdClientes.dbo.clientes (
    clie_id INT IDENTITY(1,1) PRIMARY KEY,
    clie_nombre NVARCHAR(50) NOT NULL,
    clie_apellido NVARCHAR(50) NOT NULL,
    clie_edad INT NOT NULL
);
GO

-- Insertar 10 registros de ejemplo
INSERT INTO bdClientes.dbo.clientes (clie_nombre, clie_apellido, clie_edad) VALUES
('Juan',     'Pérez',     30),
('María',    'Gómez',     25),
('Carlos',   'López',     40),
('Ana',      'Martínez',  22),
('Luis',     'Fernández', 35),
('Sofía',    'Rodríguez', 28),
('Pedro',    'Sánchez',   45),
('Laura',    'Díaz',      32),
('Miguel',   'Ramírez',   27),
('Camila',   'Torres',    29);
GO

-- Verificar datos
SELECT * FROM bdClientes.dbo.clientes;
