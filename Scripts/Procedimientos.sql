# 1. Crear una pizza
DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_crear_pizza
(IN sp_id_pizza varchar(20), IN sp_nombre varchar(100), IN sp_precio decimal(20,2))
BEGIN
	DECLARE existe int DEFAULT (SELECT COUNT(*) FROM pizzeriadb.Pizza AS p WHERE p.id_pizza = sp_id_pizza);
    
    IF existe > 0 THEN
		SELECT 0 AS Successed, 'El ID enviado ya existe' AS MSG;
    ELSE
		INSERT INTO pizzeriadb.Pizza VALUES(sp_id_pizza, sp_nombre, sp_precio);
		SELECT 1 AS Successed, 'Tu registro fue almacenado' AS MSG;
	END IF;
END$$
DELIMITER ;

# CALL pizzeriadb.sp_crear_pizza ('1', 'Pizza con Piña', 200.00 );

# 2. Agregar ingrediente a una pizza

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_agregar_ingrediente
(IN sp_id_pizza varchar(20), IN sp_id_ingrediente varchar(20), IN sp_cantidad int)
BEGIN
	DECLARE pizza_existe int DEFAULT (SELECT COUNT(*) FROM pizzeriadb.Pizza AS p WHERE p.id_pizza = sp_id_pizza);
	DECLARE ingrediente_existe int DEFAULT (SELECT COUNT(*) FROM pizzeriadb.Ingrediente AS i WHERE i.id_ingrediente = sp_id_ingrediente);
    DECLARE existe int DEFAULT (SELECT COUNT(*) FROM pizzeriadb.PizzaIngrediente AS pi WHERE pi.id_pizza = sp_id_pizza AND pi.id_ingrediente = sp_id_ingrediente);
    
    IF pizza_existe > 0 AND ingrediente_existe > 0 THEN
        IF existe > 0 THEN
			SELECT 0 AS Successed, 'El ID enviado ya existe' AS MSG;
		ELSE
			INSERT INTO pizzeriadb.PizzaIngrediente VALUES(sp_id_pizza, sp_id_ingrediente, sp_cantidad);
			SELECT 1 AS Successed, 'Tu registro fue almacenado' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID enviado de pizza/ingrediente no existe' AS MSG;
	END IF;
END$$
DELIMITER ;

# CALL pizzeriadb.sp_agregar_ingrediente('1', '1', 20 );

# 3 Realizar el Procedimiento Almacenado en el que una orden pasa de ser ordenada a aprobada. Recuerde que aquí debería de pasar una reducción de inventario.

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_aprobar_pedido
(IN sp_id_pedido bigint)
BEGIN
	DECLARE existe int DEFAULT(SELECT COUNT(*) FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    DECLARE estado varchar(20) DEFAULT(SELECT p.id_estado FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    
     IF existe > 0 THEN
		IF estado = '1' THEN
			
            UPDATE pizzeriadb.Pedido AS p SET p.id_estado = '2' WHERE p.id_pedido = sp_id_pedido;
            
            WITH tmp1 AS(
				SELECT 
					p.id_pedido AS 'pedido', 
                    pp.id_pizza AS 'pizza', 
                    pp.cantidad AS 'pizzas_ordenadas' , 
                    pi.cantidad AS 'cantidad_ingrediente_Pizza' , 
					pi.id_ingrediente AS 'ingrediente'
				FROM 
					pizzeriadb.Pedido AS p 
					JOIN pizzeriadb.PedidoPizza AS pp ON p.id_pedido = pp.id_pedido
					JOIN pizzeriadb.PizzaIngrediente AS pi ON pi.id_pizza = pp.id_pizza
					WHERE p.id_pedido = sp_id_pedido
            ) 
            
            UPDATE 
				tmp1 
                JOIN Ingrediente AS i ON i.id_ingrediente = tmp1.ingrediente 
			SET 
				i.stock = i.stock - (tmp1.pizzas_ordenadas * tmp1.cantidad_ingrediente_pizza)
            ;
            
            SELECT 1 AS Successed, 'El pedido ha sido aprobado' AS MSG;
        ELSE
			SELECT 0 AS Successed, 'No se puede actualizar el pedido' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID de pedido no existe' AS MSG;
    END IF;
    
END$$
DELIMITER ;

# CALL pizzeriadb.sp_aprobar_pedido(20);

# 4. Cancelar una orden ya aprobada. 

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_cancelar_pedido
(IN sp_id_pedido bigint)
BEGIN
	DECLARE existe int DEFAULT(SELECT COUNT(*) FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    DECLARE estado varchar(20) DEFAULT(SELECT p.id_estado FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    
     IF existe > 0 THEN
		IF estado = '2' THEN
			
            UPDATE pizzeriadb.Pedido AS p SET p.id_estado = '5' WHERE p.id_pedido = sp_id_pedido;
            
            WITH tmp1 AS(
				SELECT 
					p.id_pedido AS 'pedido', 
                    pp.id_pizza AS 'pizza', 
                    pp.cantidad AS 'pizzas_ordenadas' , 
                    pi.cantidad AS 'cantidad_ingrediente_Pizza' , 
					pi.id_ingrediente AS 'ingrediente'
				FROM 
					pizzeriadb.Pedido AS p 
					JOIN pizzeriadb.PedidoPizza AS pp ON p.id_pedido = pp.id_pedido
					JOIN pizzeriadb.PizzaIngrediente AS pi ON pi.id_pizza = pp.id_pizza
					WHERE p.id_pedido = sp_id_pedido
            ) 
            
            UPDATE 
				tmp1 
                JOIN Ingrediente AS i ON i.id_ingrediente = tmp1.ingrediente 
			SET 
				i.stock = i.stock + (tmp1.pizzas_ordenadas * tmp1.cantidad_ingrediente_pizza)
            ;
            
            SELECT 1 AS Successed, 'El pedido ha sido cancelado con éxito' AS MSG;
        ELSE
			SELECT 0 AS Successed, 'No se puede actualizar el pedido' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID de pedido no existe' AS MSG;
    END IF;
    
END$$
DELIMITER ;

# CALL pizzeriadb.sp_cancelar_pedido(3);

# 5. Convertir una orden a Orden Entrega.

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_generar_orden
(IN sp_id_pedido bigint, IN sp_id_empleado varchar(20), IN sp_id_pago varchar(20), IN sp_valor_pedido decimal (20,2), IN sp_costo_entrega decimal (20,2))
BEGIN
	DECLARE existe int DEFAULT(SELECT COUNT(*) FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    DECLARE estado varchar(20) DEFAULT(SELECT p.id_estado FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    
    IF existe > 0 THEN
		IF estado = '2' THEN
            INSERT INTO pizzeriadb.OrdenEntrega(id_pedido, id_empleado, id_pago, valor_pedido, costo_entrega, fecha_entrega) VALUES(sp_id_pedido, sp_id_empleado, sp_id_pago, sp_valor_pedido, sp_costo_entrega, '1000-01-01 00:00:00');
            SELECT 1 AS Successed, 'Se generó la orden de entrega correctamente' AS MSG;
        ELSE
			SELECT 0 AS Successed, 'No se puede actualizar el pedido' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID de pedido no existe' AS MSG;
    END IF;
END$$
DELIMITER ;

# CALL pizzeriadb.sp_generar_orden(201,'1','2',120.00,20.00);

# 6. Actualizar la orden una vez ha sido entregada. (considera el caso en el que no se sabe si el cliente pagara con efectivo o no)

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_actualizar_entrega
(IN sp_id_pedido bigint)
BEGIN
	DECLARE existe int DEFAULT(SELECT COUNT(*) FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    DECLARE estado varchar(20) DEFAULT(SELECT p.id_estado FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    
    IF existe > 0 THEN
		IF estado = '3' THEN
			UPDATE pizzeriadb.Pedido AS p SET p.id_estado = '4' WHERE p.id_pedido = sp_id_pedido;
            UPDATE pizzeriadb.OrdenEntrega AS o SET o.fecha_entrega = NOW() WHERE o.id_pedido = sp_id_pedido;
            SELECT 1 AS Successed, 'Se actualizó el pedido correctamente' AS MSG;
        ELSE
			SELECT 0 AS Successed, 'No se puede actualizar el pedido' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID de pedido no existe' AS MSG;
    END IF;
END$$
DELIMITER ;

# CALL pizzeriadb.sp_actualizar_entrega(3);

# 7. Agregar un nuevo cliente

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_agregar_cliente
(IN sp_id_cliente varchar(20), IN sp_nombre varchar(100), IN sp_apellido varchar(100), IN sp_correo varchar(100), IN sp_telefono varchar(100), IN sp_direccion varchar(100))
BEGIN
	DECLARE existe int DEFAULT (SELECT COUNT(*) FROM pizzeriadb.Cliente AS c WHERE c.id_cliente = sp_id_cliente);
    
    IF existe > 0 THEN
		SELECT 0 AS Successed, 'El ID enviado ya existe' AS MSG;
    ELSE
		INSERT INTO pizzeriadb.Cliente VALUES(sp_id_cliente, sp_nombre, sp_apellido, sp_correo, sp_telefono, sp_direccion);
		SELECT 1 AS Successed, 'Tu registro fue almacenado' AS MSG;
	END IF;
END $$
DELIMITER ;

# CALL pizzeriadb.sp_agregar_cliente ('1', 'Juan', 'Pérez', 'juan.perez@gmail.com', '9999-9999', 'Col. Altamira');