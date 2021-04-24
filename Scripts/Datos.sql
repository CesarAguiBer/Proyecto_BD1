INSERT INTO Cliente(id_cliente,nombre,apellido,correo,teléfono,dirección) VALUES
    ("1","Pedro","Guillén","pedro.guillen@gmail.com","9174-8253","Col. Cerro Grande"),
    ("2","María","Estrada","maria.estrada@gmail.com","9625-6394","Col. Altamira")
;

INSERT INTO Empleado(id_empleado,nombre,apellido,correo,teléfono) VALUES
    ("1","Ismael","Barahona","isma.barahona@hotmail.com","9897-5856"),
    ("2","Rodrigo","Pineda","rodri.pineda@outlook.com","3491-2344")
;

INSERT INTO Estado(id_estado, descripción) VALUES
    ("1","Pendiente"),
    ("2", "En proceso"),
    ("3", "Terminado")
;

INSERT INTO Pedido(id_cliente,id_estado) VALUES
    ("1","1"),
    ("2","3")
;

INSERT INTO Pizza(id_pizza,nombre,precio) VALUES
    ("1","Clásica Jamón",120.00),
    ("2","Clásica Pepperoni",120.00)
;

INSERT INTO PedidoPizza(id_pedido,id_pizza,cantidad) VALUES
    (1,"1",2),
    (2,"2",2)
;

INSERT INTO Ingrediente(id_ingrediente,nombre,precio,stock) VALUES
    ("1","Jamón",50.00,500),
    ("2","Pepperoni",45.00,450)
;

INSERT INTO PizzaIngrediente(id_pizza,id_ingrediente,cantidad) VALUES
    ("1","1",15),
    ("2","2",12)
;

INSERT INTO TipoPago(id_pago,descripción) VALUES
    ("1","Efectivo"),
    ("2", "Tarjeta de Crédito"),
    ("3", "Tarjeta de Débito")
;

INSERT INTO OrdenEntrega(id_pedido,id_empleado,id_pago,valor_pedido,costo_entrega,fecha_entrega) VALUES
    (1,"1","1",240.00,20.00,"2021-04-23"),
    (2,"1","3",240.00,20.00,"2021-04-23")
;

INSERT INTO PagoEfectivo(id_orden,monto_pagado,cambio) VALUES
    (1,500.00,240.00)
;