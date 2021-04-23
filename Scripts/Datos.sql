INSERT INTO Cliente(id_cliente,nombre,apellido,correo,telefono,direccion) VALUES
    ()
;

INSERT INTO Empleado(id_empleado,nombre,apellido,correo,telefono) VALUES
    ()
;

INSERT INTO Estado(id_estado, descripcion) VALUES
    ()
;

INSERT INTO Pedido(id_cliente,id_estado) VALUES
    ()
;

INSERT INTO Pizza(id_pizza,nombre,precio) VALUES
    ()
;

INSERT INTO PedidoPizza(id_pedido,id_pizza,cantidad) VALUES
    ()
;

INSERT INTO Ingrediente(id_ingrediente,nombre,precio,stock) VALUES
    ()
;

INSERT INTO PizzaIngrediente(id_pizza,id_ingrediente,cantidad) VALUES
    ()
;

INSERT INTO TipoPago(id_pago,descripcion) VALUES
    ()
;

INSERT INTO OrdenEntrega(id_pedido,id_empleado,id_pago,valor_pedido,costo_entrega,fecha_entrega) VALUES
    ()
;

INSERT INTO PagoEfectivo(id_orden,monto_pagado,cambio) VALUES
    ()
;