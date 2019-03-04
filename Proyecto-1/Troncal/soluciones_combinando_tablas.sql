---   Obt�n el nombre de todos los productos junto con el nombre de la categor�a a la que pertenecen.

select
	p.Nombre as producto,
	c.Descripcion as categoria
from Productos as p
	inner join Categorias as c on p.CategoriaID = c.CategoriaID

---   Prueba esta consulta, comprueba si est� bien y corr�gela en caso contrario:
--select ClienteID, Empresa, PedidoID
--from Clientes
--	inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

select Clientes.ClienteID, Empresa, PedidoID
from Clientes
	inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

---   Partiendo de la consulta anterior:
--    1. A�ade al resultado que se muestren el n�mero de producto, la cantidad y el precio unitario del detalle del pedido, pero manteniendo la informaci�n que se muestra hasta este momento.
    
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

--    2. Incluye tambi�n el nombre del producto.
    
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

---   Obtener determinada informaci�n de los empleados.
--    1. Muestra el identificador, cargo, nombre y apellidos de todos los empleados.

select
	EmpleadoID,
	Cargo,
	Nombre,
	Apellidos
from Empleados

--    2. A�ade el cargo, nombre y apellidos del superior jer�rquico.

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

--    3. Aseg�rate de que se muestren los datos de todo el personal.

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
--    1. Aseg�rate de que se muestran todos los clientes, tengan pedido realizado o no.

select
	c.Empresa,
	c.Contacto,
	c.Cargo,
	p.PedidoID,
	p.FechaPedido
from Clientes as c
	left join Pedidos as p on p.ClienteID = c.ClienteID

--    2. Filtra la consulta para que muestre tan solo aquellos que no tengan ning�n pedido realizado.

select
	c.Empresa,
	c.Contacto,
	c.Cargo,
	p.PedidoID,
	p.FechaPedido
from Clientes as c
	left join Pedidos as p on p.ClienteID = c.ClienteID
where p.PedidoID is null
