---   Obtén el nombre de todos los productos junto con el nombre de la categoría a la que pertenecen.

select
	p.Nombre as producto,
	c.Descripcion as categoria
from Productos as p
	inner join Categorias as c on p.CategoriaID = c.CategoriaID

---   Prueba esta consulta, comprueba si está bien y corrígela en caso contrario:
--select ClienteID, Empresa, PedidoID
--from Clientes
--	inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

select Clientes.ClienteID, Empresa, PedidoID
from Clientes
	inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

---   Partiendo de la consulta anterior:
--    1. Añade al resultado que se muestren el número de producto, la cantidad y el precio unitario del detalle del pedido, pero manteniendo la información que se muestra hasta este momento.
    
select
	c.ClienteID,
	c.Empresa,
	p.PedidoID,
	dt.ProductoID,
	dt.Cantidad,
	dt.PrecioUnitario
from Clientes as c
	inner join Pedidos as p on c.ClienteID = p.ClienteID
	inner join DetallePedidos as dt on dt.PedidoID = p.PedidoID

--    2. Incluye también el nombre del producto.
    
select
	c.ClienteID,
	c.Empresa,
	p.PedidoID,
	dt.ProductoID,
	prd.Nombre,
	dt.Cantidad,
	dt.PrecioUnitario
from Clientes as c
	inner join Pedidos as p on c.ClienteID = p.ClienteID
	inner join DetallePedidos as dt on dt.PedidoID = p.PedidoID
	inner join Productos as prd on dt.ProductoID = prd.ProductoID

---   Obtener determinada información de los empleados.
--    1. Muestra el identificador, cargo, nombre y apellidos de todos los empleados.

select
	EmpleadoID,
	Cargo,
	Nombre,
	Apellidos
from Empleados

--    2. Añade el cargo, nombre y apellidos del superior jerárquico.

select
	emp.EmpleadoID,
	emp.Cargo,
	emp.Nombre,
	emp.Apellidos,
	sup.Cargo,
	sup.Nombre,
	sup.Apellidos
from Empleados as emp
	inner join Empleados as sup on emp.SuperiorID = sup.EmpleadoID

--    3. Asegúrate de que se muestren los datos de todo el personal.

select
	emp.EmpleadoID,
	emp.Cargo,
	emp.Nombre,
	emp.Apellidos,
	sup.Cargo,
	sup.Nombre,
	sup.Apellidos
from Empleados as emp
	left outer join Empleados as sup on emp.SuperiorID = sup.EmpleadoID

--- Obtener el listado de clientes (`Empresa`, `Contacto` y `Cargo`) junto con los pedidos que han hecho (`PedidoID` y `FechaPedido`)
--    1. Asegúrate de que se muestran todos los clientes, tengan pedido realizado o no.

select
	c.Empresa,
	c.Contacto,
	c.Cargo,
	p.PedidoID,
	p.FechaPedido
from Clientes as c
	left join Pedidos as p on p.ClienteID = c.ClienteID

--    2. Filtra la consulta para que muestre tan solo aquellos que no tengan ningún pedido realizado.

select
	c.Empresa,
	c.Contacto,
	c.Cargo,
	p.PedidoID,
	p.FechaPedido
from Clientes as c
	left join Pedidos as p on p.ClienteID = c.ClienteID
where p.PedidoID is null
