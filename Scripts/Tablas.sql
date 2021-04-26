CREATE TABLE Cliente(
    id_cliente varchar(20) PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(100) NOT NULL,
    teléfono varchar(100) NOT NULL,
    dirección varchar(100) NOT NULL
);

CREATE TABLE Empleado(
    id_empleado varchar(20) PRIMARY KEY,
    nombre  varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    correo varchar(100) NOT NULL,
    teléfono varchar(100) NOT NULL
);

CREATE TABLE Estado(
    id_estado varchar(20) PRIMARY KEY,
    descripción varchar(100)
);

CREATE TABLE Pedido(
    id_pedido bigint AUTO_INCREMENT PRIMARY KEY,
    id_cliente varchar(20) NOT NULL,
    id_estado varchar(20) NOT NULL,
    fecha_creación datetime DEFAULT NOW(),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) 
);

CREATE TABLE Pizza(
    id_pizza varchar(20) PRIMARY KEY, 
    nombre varchar(100) NOT NULL,
    precio decimal(20,2) NOT NULL
);

CREATE TABLE PedidoPizza(
    id_pedido bigint NOT NULL,
    id_pizza varchar(20) NOT NULL,
    cantidad int NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_pizza) REFERENCES Pizza(id_pizza),
    PRIMARY KEY(id_pedido, id_pizza)
);

CREATE TABLE Ingrediente(
    id_ingrediente varchar(20) PRIMARY KEY,
    nombre varchar(100) NOT NULL,
    precio decimal(20,2) NOT NULL,
    stock int NOT NULL
);

CREATE TABLE PizzaIngrediente(
    id_pizza varchar(20) NOT NULL,
    id_ingrediente varchar(20) NOT NULL,
    cantidad int NOT NULL,
    FOREIGN KEY(id_pizza) REFERENCES Pizza(id_pizza),
    FOREIGN KEY(id_ingrediente) REFERENCES  Ingrediente(id_ingrediente),
    PRIMARY KEY(id_pizza,id_ingrediente)    
);

CREATE TABLE TipoPago(
    id_pago varchar(20) PRIMARY KEY,
    descripción varchar(100)
);

CREATE TABLE OrdenEntrega(
    id_orden bigint AUTO_INCREMENT PRIMARY KEY,
    id_pedido bigint NOT NULL,
    id_empleado varchar(20) NOT NULL,
    id_pago varchar(20) NOT NULL, 
    valor_pedido decimal(20,2) NOT NULL, 
    costo_entrega decimal(20,2) NOT NULL,  
    fecha_creación datetime DEFAULT NOW(), 
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
