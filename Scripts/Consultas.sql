# 6. Distribución de tipo de pago por cliente (usando toda la historia).alter

WITH 

tmp1(id_cliente, conteo) AS 
(
	SELECT c.id_cliente, COUNT(*) FROM pizzeriadb.Cliente AS c JOIN pizzeriadb.Pedido AS p ON c.id_cliente = p.id_cliente
    JOIN pizzeriadb.OrdenEntrega AS o ON p.id_pedido = o.id_pedido
    WHERE o.id_pago = '1'
    GROUP BY c.id_cliente
),

tmp2(id_cliente, conteo) AS
(
	SELECT c.id_cliente, COUNT(*) FROM pizzeriadb.Cliente AS c JOIN pizzeriadb.Pedido AS p ON c.id_cliente = p.id_cliente
    JOIN pizzeriadb.OrdenEntrega AS o ON p.id_pedido = o.id_pedido
    WHERE o.id_pago IN ('2','3')
    GROUP BY c.id_cliente
) 	
SELECT 
	c.id_cliente AS 'ID Cliente',
    COUNT(*) AS 'Conteo de pedidos hechos',
	CONCAT(CAST(CAST((IFNULL(tmp1.conteo,0)) * 100 / COUNT(*) AS decimal(3,0)) AS char), '%')  AS 'Porcentaje de pagos usando efectivo',
    CONCAT(CAST(CAST((IFNULL(tmp2.conteo,0)) * 100 / COUNT(*) AS decimal(3,0)) AS char), '%') AS 'Porcentaje de pagos usando usando otros métodos de pago'
FROM 
	pizzeriadb.Cliente AS c 
    JOIN pizzeriadb.Pedido AS p ON c.id_cliente = p.id_cliente
	JOIN pizzeriadb.OrdenEntrega AS o ON p.id_pedido = o.id_pedido
    LEFT JOIN tmp1 ON c.id_cliente = tmp1.id_cliente
    LEFT JOIN tmp2 ON c.id_cliente = tmp2.id_cliente
GROUP BY c.id_cliente, 'Porcentaje de pagos usando efectivo', 'Porcentaje de pagos usando usando otros métodos de pago'
;
		

# 7. Promedio de cambio utilizado mes a mes en el último año

SELECT 
	YEAR(o.fecha_entrega) AS 'Año',
    MONTH(o.fecha_entrega) AS 'Mes',
    CAST(SUM(cambio) / COUNT(*) AS decimal(20,2)) AS 'Promedio de cambio entregado'
FROM 
	pizzeriadb.OrdenEntrega AS o
    JOIN pizzeriadb.PagoEfectivo AS pe ON o.id_orden = pe.id_orden
WHERE 
	YEAR(o.fecha_entrega) = '2021'
GROUP BY 
	YEAR(o.fecha_entrega), MONTH(o.fecha_entrega)
ORDER BY
	YEAR(o.fecha_entrega) DESC, MONTH(o.fecha_entrega) DESC
;
