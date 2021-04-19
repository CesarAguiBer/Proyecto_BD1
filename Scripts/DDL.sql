CREATE TABLE Cliente(
    id_cliente bigint PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(100) NOT NULL,
    telefono varchar(100) NOT NULL,
    direccion varchar(100) NOT NULL
);

CREATE TABLE Empleado(
    id_empleado nvarchar(20) PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(100) NOT NULL,
    telefono varchar(100) NOT NULL
);

CREATE TABLE Estado(
    id_estado int PRIMARY KEY,
    descripcion varchar(100)
);

CREATE TABLE Pedido(
    id_pedido bigint PRIMARY KEY,
    id_cliente bigint NOT NULL,
    id_estado int NOT NULL,
    fecha_creacion timestamp DEFAULT NOW(),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) 
);

CREATE TABLE Pizza(
    id_pizza int PRIMARY KEY, 
    nombre varchar(100) NOT NULL,
    precio decimal(20,2) NOT NULL
);

CREATE TABLE PedidoPizza(
    id_pedido bigint NOT NULL,
    id_pizza int NOT NULL,
    cantidad int NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_pizza) REFERENCES Pizza(id_pizza),
    PRIMARY KEY(id_pedido, id_pizza)
);

CREATE TABLE Ingrediente(
    id_ingrediente bigint PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    precio decimal(20,2) NOT NULL,
    stock int NOT NULL
);

CREATE TABLE PizzaIngrediente(
    id_pizza  int NOT NULL,
    id_ingrediente bigint NOT NULL,
    cantidad int NOT NULL,
    FOREIGN KEY(id_pizza) REFERENCES Pizza(id_pizza),
    FOREIGN KEY(id_ingrediente) REFERENCES  Ingrediente(id_ingrediente),
    PRIMARY KEY(id_pizza,id_ingrediente)    
);

CREATE TABLE TipoPago(
    id_pago bigint PRIMARY KEY,
    descripcion varchar(100)
);

CREATE TABLE OrdenEntrega(
    id_orden bigint PRIMARY KEY,
    id_pedido bigint NOT NULL,
    id_empleado bigint NOT NULL,
    id_pago bigint NOT NULL, 
    valor_pedido decimal(20,2) NOT NULL, 
    costo_entrega decimal(20,2) NOT NULL,  
    fecha_creacion datetime NOT NULL, 
    fecha_entrega datetime NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado),
    FOREIGN KEY (id_pago) REFERENCES TipoPago(id_pago)  
);

CREATE TABLE PagoEfectivo(
    id_orden bigint NOT NULL,
    monto_pagado decimal(20,2) NOT NULL,
    cambio decimal(20,2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES OrdenEntrega(id_orden),
    PRIMARY KEY (id_orden)
);
