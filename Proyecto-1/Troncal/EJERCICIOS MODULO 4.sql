select * from Clientes
SELECT * FROM Categorias


/*  Prácticas propuestas para el módulo 4
 
 En este módulo hemos estudiado cómo realizar consultas contra varias tablas.
 Para que te familiarices con el manejo de varias tablas a la vez, combinándolo con todo lo aprendido anteriormente, 
 te proponemos que realices las siguientes consultas por ti mismo, de modo que puedas afianzar la teoría:

	*	Obtén el nombre de todos los productos junto con el nombre de la categoría a la que pertenecen.

	*	Prueba esta consulta, comprueba si está bien y corrígela en caso contrario:

		select ClienteID, Empresa, PedidoID
		from Clientes
		inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

*	Partiendo de la consulta anterior:

	1.	Añade al resultado que se muestren el número de producto, la cantidad y el precio unitario del detalle del pedido, 
	    pero manteniendo la información que se muestra hasta este momento.

	2.	Incluye también el nombre del producto.

*	Obtener determinada información de los empleados.

	1.	Muestra el identificador, cargo, nombre y apellidos de todos los empleados.
	2.	Añade el cargo, nombre y apellidos del superior jerárquico.
	3.	Asegúrate de que se muestren los datos de todo el personal.

*	Obtener el listado de clientes (Empresa, Contacto y Cargo) junto con los pedidos que han hecho (PedidoID y FechaPedido)

	1.	Asegúrate de que se muestran todos los clientes, tengan pedido realizado o no.
	2.	Filtra la consulta para que muestre tan solo aquellos que no 
	3.	tengan ningún pedido realizado.
*/

SELECT  produ.nombre as [PRODUCTO], cate.nombre AS [CATEGORIA]
from productos as produ  join Categorias as cate  on  produ.CategoriaID = cate.CategoriaID

--------------------------------------

select Clientes.ClienteID, Clientes.Empresa, Pedidos.PedidoID
from 
Clientes inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID


select * from pedidos   --TOTAL 830 
SELECT * FROM DetallePedidos --  TOTAL 2155 

-------------------------------------------------------------------

-- número de producto, la cantidad y el precio unitario del detalle del pedido,


--NOTA MAGISTRAL DEL CURSO :  el inner join que hacemos  en segundo lugar esta pillando la tabla
--                            que tiene a la izquierda es decir el detalle de pedidos esta pillando la tabla de Pedidos
select Clientes.ClienteID, Clientes.Empresa, Pedidos.PedidoID,
       DetallePedidos.ProductoID, DetallePedidos.Cantidad, DetallePedidos.PrecioUnitario   
from 
Clientes   inner join  Pedidos         on Clientes.ClienteID  = Pedidos.ClienteID
           inner join  DetallePedidos  on Pedidos.PedidoID  =  DetallePedidos.PedidoID 

-------------------------------------------------------------------

-- 2.	Incluye también el nombre del producto.

--NOTA MAGISTRAL DEL CURSO :  el inner join que hacemos  en segundo lugar esta pillando la tabla
--                            que tiene a la izquierda es decir el detalle de pedidos esta pillando la tabla de Pedidos
select Clientes.ClienteID, Clientes.Empresa, Pedidos.PedidoID,
       DetallePedidos.ProductoID, DetallePedidos.Cantidad, DetallePedidos.PrecioUnitario , Productos.Nombre  
from 
Clientes        inner join  Pedidos         on Clientes.ClienteID  = Pedidos.ClienteID
                inner join  DetallePedidos  on Pedidos.PedidoID  =  DetallePedidos.PedidoID 
				inner join  Productos       on DetallePedidos.ProductoID = Productos.ProductoID

----------------------------------------------------------------------------------

-- Obtener determinada información de los empleados.--
-- Ahora entiendo lo del superior, el superior no está en otra tabla
-- es el ID del empleado el cual es su superior 

	--1.	Muestra el identificador, cargo, nombre y apellidos de todos los empleados.
	--2.	Añade el cargo, nombre y apellidos del superior jerárquico.
	--3.	Asegúrate de que se muestren los datos de todo el personal.

	select * from Empleados 

	 --------------- >>> JOER  COMO SACO  LOS DATOS DEL SUPERIOR?????

	select emple1.EmpleadoID,	
	       emple1.Nombre,	
		   emple1.Apellidos, 
		   emple1.Cargo, 
		   emple2.SuperiorID, 
		   emple2.Nombre, 
		   emple2.Apellidos, 
		   emple2.Cargo 
	from Empleados as emple1  inner join Empleados as emple2  on emple1.SuperiorID = emple2.EmpleadoID  
	
	-->> ESTE FUE EL ÚNICO QUE NO SAQUE... ESTABA PONIENDO  emple1.EmpleadoID = emple2.EmpleadoID 
	
	----------------------------------------------------------------------------------

--		Obtener el listado de clientes (Empresa, Contacto y Cargo) junto con los pedidos que han hecho (PedidoID y FechaPedido)

--	1.	Asegúrate de que se muestran todos los clientes, tengan pedido realizado o no.
--	2.	Filtra la consulta para que muestre tan solo aquellos que no tengan ningún pedido realizado.


  select cli.ClienteID ,empresa, cli.contacto, cli.cargo,
          pedi.PedidoId , pedi.FechaPedido
  from 
  Clientes as cli  join Pedidos as pedi on cli.ClienteID = pedi.ClienteID 

  -- ESTA SELECT SACA  830 REGISTROS   FALTAN DOS CLIENTES 

		  --22	Customer DTDMN	Bueno, Janaina Burdan, Neville	Accounting Manager	NULL	NULL
		  --57	Customer WVAXS	Tollevsen, Bjørn	            Owner	            NULL	NULL
    --ESTOS DOS CLIENTE NO TIENEN PEDIDOS POR ESO NO LOS SACA, AL UTILIZAR LEFT FUERZO A QUE SALGAN TODOS LOS REGISTROS 
	--DE CLIENTIES INDEPENDIENTEMENTE DE SI TIENEN PEDIDOS O NO 

  select * from Clientes



  select cli.ClienteID , cli.empresa, cli.contacto, cli.cargo,
         pedi.PedidoId , pedi.FechaPedido
  from 
  Clientes as cli  left  join Pedidos as pedi on cli.ClienteID = pedi.ClienteID
  
  --ESTA CON LEFT  SACA 832 REGISTROS, TODOS !!

  select * from PEDIDOS WHERE  ClienteID  NOT IN ( 22, 57 )

  ----------------------------------------------------------------

  --	2.	Filtra la consulta para que muestre tan solo aquellos que no tengan ningún pedido realizado.

  select cli.ClienteID , cli.empresa, cli.contacto, cli.cargo,
         pedi.PedidoId , pedi.FechaPedido
  from 
  Clientes as cli  left  join Pedidos as pedi on cli.ClienteID = pedi.ClienteID
  WHERE pedi.ClienteID  IS NULL 

  --NOTA MAGISTRAL DEL CURSO :  el  NULL es un valor en si mismo por lo cual podemos preguntar por el PERO OJO  con la PARTICULA IS 
  --                            con el signo de igual  =   NO FUNCIONA 