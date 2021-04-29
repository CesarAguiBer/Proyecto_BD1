# 1. En el último mes, cuales el top 3 de los clientes con mayor número de pedidos. 

SELECT
	c.nombre AS 'Nombre del Cliente',
    c.teléfono AS 'Número de teléfono',
    YEAR(p.fecha_creación) AS 'Año',
    MONTH(p.fecha_creación) AS 'Mes',
    COUNT(*) AS 'Conteo de Pedidos'
FROM 
	pizzeriadb.Cliente AS c 
    JOIN pizzeriadb.Pedido AS p ON c.id_cliente = p.id_cliente
GROUP BY 
	c.nombre, c.teléfono, YEAR(p.fecha_creación), MONTH(p.fecha_creación)
ORDER BY  
	YEAR(p.fecha_creación) DESC, MONTH(p.fecha_creación) DESC, COUNT(*) DESC
LIMIT 3
;

# 2. En el último año, cual ha sido el vendedor con más ventas realizadas
SELECT 
	e.nombre AS 'Nombre del Vendedor',
    e.id_empleado AS 'Número de Empleado',
    YEAR(o.fecha_creación) AS 'Año',
    COUNT(*) AS 'Conteo de pedidos realizados',
    SUM(o.valor_pedido + o.costo_entrega) AS 'Suma de Ventas'
FROM 
	pizzeriadb.Empleado AS e 
    JOIN pizzeriadb.OrdenEntrega AS o ON e.id_empleado = o.id_empleado 
GROUP BY 
	e.nombre, e.id_empleado, YEAR(o.fecha_creación)
ORDER BY 
	YEAR(o.fecha_creación) DESC, SUM(o.valor_pedido + o.costo_entrega) DESC
LIMIT 1
;

# 4. Cantidad de ingredientes por pizza 

SELECT 
	p.nombre AS Pizza,
    COUNT(p.id_pizza) AS 'Cantidad de Ingredientes',
    p.precio AS 'Precio Pizza'
FROM 
	pizzeriadb.Pizza AS p 
    JOIN pizzeriadb.PizzaIngrediente AS pi ON p.id_pizza = pi.id_pizza
GROUP BY p.nombre, p.precio
; 

# 5. Top 5 de los clientes que mas han esperado en recibir sus órdenes (usando toda la historia)

SELECT 
	c.id_cliente AS 'ID Cliente', 
    c.nombre AS 'Nombre', 
    c.teléfono AS 'Teléfono', 
    c.dirección AS 'Dirección',
    COUNT(*) AS 'Número de pedidos hechos',
    SUM(TIMESTAMPDIFF(HOUR, p.fecha_creación, o.fecha_entrega)) AS 'Suma del tiempo esperado'
FROM 
	pizzeriadb.Cliente AS c 
    JOIN pizzeriadb.Pedido AS p ON c.id_cliente = p.id_cliente
    JOIN pizzeriadb.OrdenEntrega AS o ON o.id_pedido = p.id_pedido
GROUP BY 
	c.id_cliente, c.nombre, c.teléfono, c.dirección
ORDER BY
	SUM(TIMESTAMPDIFF(HOUR, p.fecha_creación, o.fecha_entrega)) DESC
LIMIT 5
; 

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

