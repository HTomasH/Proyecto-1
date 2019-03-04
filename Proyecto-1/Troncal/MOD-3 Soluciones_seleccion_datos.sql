---   Obtener todos los clientes.

--    1.  Primero con todos sus datos.

--    2.  Ahora repite la consulta mostrando solo la persona de contacto, direcci�n, c�digo postal, ciudad y pa�s.

---   Obtener determinada informaci�n de los clientes.

--    1.  Lista de pa�ses en los que tenemos clientes.

--    2.  Lista de ciudades y poblaciones en las que tenemos clientes.

--    3.  Repite ambas consultas a�adiendo `distinct` y compara los resultados obtenidos antes y ahora: �tienes el mismo n�mero de resultados?, �a qu� se debe?, �en qu� condiciones ser�n iguales?.

---   Haz una consulta que devuelva el contacto y cargo de los clientes. Para hacerlo emplea un alias de tabla "C" para nombrar los campos.

---   Haz una consulta que devuelva la empresa, el contacto y cargo de los clientes. Cambia el nombre de las columnas empresa y cargo por "Nombre de la empresa" y "Cargo del contacto" (Pista: acu�rdate del car�cter especial para nombres de campos con espacios...).

---   Muestra el listado de productos empleando un alias de tabla "P" y mostrando el campo nombre mediante dicho alias. Adem�s cambia el nombre del campo por "Nombre del producto".

---   Prueba esta consulta:
--        select Ciudad Pais from Clientes
--    Comprueba si est� bien y corr�gela en caso contrario.

select
	Ciudad,
	Pais
from Clientes

---   Escribe una serie de consultas que muestren el nombre de todos los productos y a mayores lo siguiente:

select
	Nombre
from Productos

--1. En primer lugar incluye el identificador de la categor�a `CategoriaID`.

select
	Nombre,
	CategoriaID
from Productos

--2. Repite la consulta cambiando `CategoriaID` por el nombre que figura en la siguiente tabla, poniendo el texto `Other` en aquellos casos que no figure nada en la tabla. El campo deber� llamarse *Categor�a*.
--|CategoriaID|Nombre|
--|--- |--- |
--|1|Beverages|
--|2|Condiments|
--|3|Confections|
--|4|Dairy Products|
--|55|Grains/Cereals|

select
	Nombre,
	case CategoriaID
		when 1 then 'Beverages'
		when 2 then 'Condiments'
		when 3 then 'Confections'
		when 4 then 'Dairy Products'
		when 55 then 'Grains/Cereals'
		else 'Other'
	end as Categoria
from Productos

--3. Repite la consulta anterior a�adiendo un campo que muestre *Producto de campa�a* para aquellos de las categor�as 1,7 y 8, y  *Producto NO de campa�a* para el resto. El campo deber� llamarse *EnCampa�a*.

select
	Nombre,
	case CategoriaID
		when 1 then 'Beverages'
		when 2 then 'Condiments'
		when 3 then 'Confections'
		when 4 then 'Dairy Products'
		when 55 then 'Grains/Cereals'
		else 'Other'
	end as Categoria,
	iif(CategoriaID in (1,7,8), 'Producto de campa�a', 'Producto NO de campa�a') as EnCampana
from Productos

--4. Repite las tres consultas ordenando los resultados por:
--    -   Primero por el nombre de producto.

select
	Nombre,
	CategoriaID
from Productos
order by Nombre

--    -   Despu�s ordena primero por la descripci�n de la categor�a seguido del nombre del producto.

select
	Nombre,
	case CategoriaID
		when 1 then 'Beverages'
		when 2 then 'Condiments'
		when 3 then 'Confections'
		when 4 then 'Dairy Products'
		when 55 then 'Grains/Cereals'
		else 'Other'
	end as Categoria
from Productos
order by Categoria, Nombre

--    -   En la �ltima, haz una ordenaci�n en primer lugar por si est� *EnCampa�a*, seguido del nombre del producto.

select
	Nombre,
	case CategoriaID
		when 1 then 'Beverages'
		when 2 then 'Condiments'
		when 3 then 'Confections'
		when 4 then 'Dairy Products'
		when 55 then 'Grains/Cereals'
		else 'Other'
	end as Categoria,
	iif(CategoriaID in (1,7,8), 'Producto de campa�a', 'Producto NO de campa�a') as EnCampana
from Productos
order by EnCampana, Nombre

---   Obtener nuevamente id de cliente, persona de contacto, direcci�n, c�digo postal, ciudad y pa�s de los clientes.

select
	ClienteID,
	Contacto,
	Direccion,
	CodPostal,
	Ciudad,
	Pais
from Clientes

--    1.  Primero de aquellos cuyo pa�s sea *Brazil*.

select
	ClienteID,
	Contacto,
	Direccion,
	CodPostal,
	Ciudad,
	Pais
from Clientes
where Pais = 'Brazil'

--    2.  Repite la consulta mostrando los que son de *Brazil*, _UK_ o _USA_ (real�zala de dos formas distintas).

select
	ClienteID,
	Contacto,
	Direccion,
	CodPostal,
	Ciudad,
	Pais
from Clientes
where Pais = 'Brazil' or Pais = 'UK' or Pais = 'USA'

select
	ClienteID,
	Contacto,
	Direccion,
	CodPostal,
	Ciudad,
	Pais
from Clientes
where Pais in ('Brazil', 'UK', 'USA')

--    3.  Muestra solo aquellos cuyo contacto empiece por la letra _A_.

select
	ClienteID,
	Contacto,
	Direccion,
	CodPostal,
	Ciudad,
	Pais
from Clientes
where Contacto like 'A%'

---   Obtener el nombre, apellidos y fecha de nacimiento de los empleados ordenados por apellido que:
--    1.  No tienen superior jer�rquico.

select
	Nombre,
	Apellidos,
	FechaNacimiento
from Empleados
where SuperiorID is null
order by Apellidos

--    2.  Tienen superior jer�rquico y fueron contratados antes del 2004.

select
	Nombre,
	Apellidos,
	FechaNacimiento
from Empleados
where SuperiorID is not null and FechaNacimiento < '20040101'
order by Apellidos

--    3.  Su tel�fono empieza por 555, sin incluir el prefijo.

select
	Nombre,
	Apellidos,
	FechaNacimiento
from Empleados
where Telefono like '%)%555%'
order by Apellidos

---   Muestra los �ltimos 20 pedidos (id del pedido y fecha de pedido) empleando dos m�todos diferentes.

select top(20) PedidoID, FechaPedido
from Pedidos
order by FechaPedido


--USO DE OFFSET 

select PedidoID, FechaPedido
from Pedidos
order by FechaPedido
offset 0 rows
fetch next 20 rows only

---   Muestra el 10% de los productos, teniendo en cuenta que deben salir los m�s caros.

select top(10) percent *
from Productos
order by PrecioUnitario desc
