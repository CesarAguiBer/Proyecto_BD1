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

CREATE TABLE Pedido(
    id_pedido bigint PRIMARY KEY,
    id_cliente bigint NOT NULL,
    id_estado int NOT NULL,
    fecha_creacion timestamp DEFAULT NOW(),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado) 
);

CREATE TABLE Pizza(
id_pizza INT PRIMARY KEY, 
nombre VARCHAR(100) NOT NULL,
precio DECIMAL(5,2) NOT NULL
);

CREATE TABLE PedidoPizza(
id_pizza INT,
id_pedido BIGINT,
cantidad INT NOT NULL,
FOREIGN KEY (id_pizza) REFERENCES Pizza(id_pizza),
FOREIGN KEY (id_pedido) references Pedido(id_pedido),
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
