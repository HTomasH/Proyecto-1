--MODIFICANDO PARA GIT  1

---   Obtener un listado de todos los productos, mostrando el identificador y un campo con el texto: "El precio unitario del producto `Nombre` es `PrecioUnitario` €".

select concat('El precio unitario del producto ', Nombre,' es ', PrecioUnitario, ' €')
from Productos

---   Obtener un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) cumpliendo una serie de prerrequisitos:
--    1.  La fecha de pedido tiene que estar entre el 1 de abril de 2007 y 30 de noviembre de 2007, pero tienen que introducirse con el formato día/mes/año.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	EnvioPoblacion
from Pedidos
where FechaPedido between parse('01/04/2007' as date using 'es-ES') and parse('30/11/2007' as date using 'es-ES')

--    2.  Entre la fecha de pedido y la de envío tienen que haber transcurrido más de 30 días.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	EnvioPoblacion
from Pedidos
where datediff(dd, FechaPedido, FechaEnvio) > 30

--    3.  Si no existe población, debe mostrar el texto _'Sin población'_.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	coalesce(EnvioPoblacion,'Sin población')
from Pedidos

---   Obtener el listado de clientes (identificador, empresa, contacto, teléfono y fax) donde mostremos el teléfono y el fax como un valor entero, eliminando guiones, paréntesis y espacios.

select
	ClienteID,
	Empresa,
	Contacto,
	cast(replace(replace(replace(replace(replace(Telefono,'-',''),'(',''),')',''),' ',''),'.','') as bigint),
	cast(replace(replace(replace(replace(replace(Fax,'-',''),'(',''),')',''),' ',''),'.','') as bigint)
from Clientes

---   Obtener nuevamente un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) junto con una serie de datos calculados:
--    1.  Campo `Envio` que muestre _Urgente_ si transcurre menos de 7 días entre la fecha de pedido y la de envío, _Prioritario_ si son entre 8 y 14 días y _Normal_ para el resto.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	EnvioPoblacion,
	case
		when datediff(dd, FechaPedido, FechaEnvio) <= 7 then 'Urgente'
		when datediff(dd, FechaPedido, FechaEnvio) <= 14 then 'Prioritario'
		else 'Normal'
	end as Envio
from Pedidos

--    2.  En el caso que la población sea un valor _null_, tiene que poner _N/A_.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	coalesce(EnvioPoblacion, 'N/A'),
	case
		when datediff(dd, FechaPedido, FechaEnvio) <= 7 then 'Urgente'
		when datediff(dd, FechaPedido, FechaEnvio) <= 14 then 'Prioritario'
		else 'Normal'
	end as Envio
from Pedidos

--    3.  Campo `Periodo` que indique trimestre del año y año del pedido de la forma _año/trimestre_.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	coalesce(EnvioPoblacion, 'N/A'),
	case
		when datediff(dd, FechaPedido, FechaEnvio) <= 7 then 'Urgente'
		when datediff(dd, FechaPedido, FechaEnvio) <= 14 then 'Prioritario'
		else 'Normal'
	end as Envio,
	concat(year(FechaPedido),'/',datepart(qq,FechaPedido)) as Periodo
from Pedidos

--    4.  Deben ordenarse los pedidos en primer lugar por `Periodo` en ascendente y a continuación por `FechaPedido` en descendente.

select
	PedidoID,
	FechaPedido,
	FechaEnvio,
	coalesce(EnvioPoblacion, 'N/A'),
	case
		when datediff(dd, FechaPedido, FechaEnvio) <= 7 then 'Urgente'
		when datediff(dd, FechaPedido, FechaEnvio) <= 14 then 'Prioritario'
		else 'Normal'
	end as Envio,
	concat(year(FechaPedido),'/',datepart(qq,FechaPedido)) as Periodo
from Pedidos
order by Periodo, FechaPedido desc

---   Obtener un listado de clientes:
--    1.  Mostrar `Empresa`, `Contacto` y `Cargo`.

select
	Empresa,
	Contacto,
	Cargo
from Clientes

--    2.  En el nombre de la `Empresa`, omitir el texto 'Customer'.

select
	replace(Empresa,'Customer ',''),
	Contacto,
	Cargo
from Clientes

--    3.  Añadir dos campos calculados:
--        - Un campo `SeccionCP` donde mostraremos _Seccion1_ si el código postal es par y _Seccion2_ si es impar. 

select
	replace(Empresa,'Customer ',''),
	Contacto,
	Cargo,
	iif(CodPostal % 2 = 0, 'Seccion1', 'Seccion2') as SeccionCP
from Clientes

--        - Un campo `NombrePila` que debe mostrar lo que está después de la coma en el `Contacto`.

select
    substring(Contacto,	patindex('%, %', Contacto) + 2, len(Contacto)) as NombrePila,
	replace(Empresa,'Customer ',''),
	Contacto,
	Cargo,
	iif(CodPostal % 2 = 0, 'Seccion1', 'Seccion2') as SeccionCP
from Clientes
















---   Crea una función que devuelva un listado con los proveedores que tiene un producto.
--    El producto que debe calcular se lo indicaremos mediante un parámetro.

create function ListadoProveedores (@Producto as nvarchar(50))
returns table
return
	select p.*
	from Proveedores as p
		inner join ProveedoresProducto as pp on p.ProveedorID = pp.ProveedorID
		inner join Productos as prd on pp.ProductoID = prd.ProductoID
	where prd.Nombre = @Producto;

--    Probar a obtener los proveedores de los productos 'Product QMVUN' y 'Product KSZOI'. 

select * from ListadoProveedores('Product QMVUN')
select * from ListadoProveedores('Product KSZOI')
