CREATE TABLE Cliente(
    id_cliente bigint PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(100) NOT NULL,
    telefono varchar(100) NOT NULL,
    direccion varchar(100) NOT NULL
);

CREATE TABLE Estado(
    id_estado int PRIMARY KEY,
    descripcion varchar(100)
);