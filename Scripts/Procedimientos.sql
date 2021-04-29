# 5. Convertir una orden a Orden Entrega.

DELIMITER $$
CREATE PROCEDURE pizzeriadb.sp_generar_orden
(IN sp_id_pedido bigint, IN sp_id_empleado varchar(20), IN sp_id_pago varchar(20), IN sp_valor_pedido decimal (20,2), IN sp_costo_entrega decimal (20,2))
BEGIN
	DECLARE existe int DEFAULT(SELECT COUNT(*) FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    DECLARE estado varchar(20) DEFAULT(SELECT p.id_estado FROM pizzeriadb.Pedido AS p WHERE p.id_pedido = sp_id_pedido);
    
    IF existe > 0 THEN
		IF estado = '1' THEN
			UPDATE pizzeriadb.Pedido AS p SET p.id_estado = '2' WHERE p.id_pedido = sp_id_pedido;
            INSERT INTO pizzeriadb.OrdenEntrega(id_pedido, id_empleado, id_pago, valor_pedido, costo_entrega, fecha_entrega) VALUES(sp_id_pedido, sp_id_empleado, sp_id_pago, sp_valor_pedido, sp_costo_entrega, '1000-01-01 00:00:00');
            SELECT 1 AS Successed, 'Se actualizó el pedido y se generó la orden de entrega correctamente' AS MSG;
        ELSE
			SELECT 0 AS Successed, 'No se puede actualizar el pedido' AS MSG;
        END IF;
    ELSE
		SELECT 0 AS Successed, 'El ID de pedido no existe' AS MSG;
    END IF;
END$$
DELIMITER ;

# CALL pizzeriadb.sp_generar_orden(201,'1','2',120.00,20.00);

