select * from Clientes
SELECT * FROM Categorias


/*  Pr�cticas propuestas para el m�dulo 4
 
 En este m�dulo hemos estudiado c�mo realizar consultas contra varias tablas.
 Para que te familiarices con el manejo de varias tablas a la vez, combin�ndolo con todo lo aprendido anteriormente, 
 te proponemos que realices las siguientes consultas por ti mismo, de modo que puedas afianzar la teor�a:

	*	Obt�n el nombre de todos los productos junto con el nombre de la categor�a a la que pertenecen.

	*	Prueba esta consulta, comprueba si est� bien y corr�gela en caso contrario:

		select ClienteID, Empresa, PedidoID
		from Clientes
		inner join Pedidos on Clientes.ClienteID = Pedidos.ClienteID

*	Partiendo de la consulta anterior:

	1.	A�ade al resultado que se muestren el n�mero de producto, la cantidad y el precio unitario del detalle del pedido, 
	    pero manteniendo la informaci�n que se muestra hasta este momento.

	2.	Incluye tambi�n el nombre del producto.

*	Obtener determinada informaci�n de los empleados.

	1.	Muestra el identificador, cargo, nombre y apellidos de todos los empleados.
	2.	A�ade el cargo, nombre y apellidos del superior jer�rquico.
	3.	Aseg�rate de que se muestren los datos de todo el personal.

*	Obtener el listado de clientes (Empresa, Contacto y Cargo) junto con los pedidos que han hecho (PedidoID y FechaPedido)

	1.	Aseg�rate de que se muestran todos los clientes, tengan pedido realizado o no.
	2.	Filtra la consulta para que muestre tan solo aquellos que no 
	3.	tengan ning�n pedido realizado.
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

-- n�mero de producto, la cantidad y el precio unitario del detalle del pedido,


--NOTA MAGISTRAL DEL CURSO :  el inner join que hacemos  en segundo lugar esta pillando la tabla
--                            que tiene a la izquierda es decir el detalle de pedidos esta pillando la tabla de Pedidos
select Clientes.ClienteID, Clientes.Empresa, Pedidos.PedidoID,
       DetallePedidos.ProductoID, DetallePedidos.Cantidad, DetallePedidos.PrecioUnitario   
from 
Clientes   inner join  Pedidos         on Clientes.ClienteID  = Pedidos.ClienteID
           inner join  DetallePedidos  on Pedidos.PedidoID  =  DetallePedidos.PedidoID 

-------------------------------------------------------------------

-- 2.	Incluye tambi�n el nombre del producto.

--NOTA MAGISTRAL DEL CURSO :  el inner join que hacemos  en segundo lugar esta pillando la tabla
--                            que tiene a la izquierda es decir el detalle de pedidos esta pillando la tabla de Pedidos
select Clientes.ClienteID, Clientes.Empresa, Pedidos.PedidoID,
       DetallePedidos.ProductoID, DetallePedidos.Cantidad, DetallePedidos.PrecioUnitario , Productos.Nombre  
from 
Clientes        inner join  Pedidos         on Clientes.ClienteID  = Pedidos.ClienteID
                inner join  DetallePedidos  on Pedidos.PedidoID  =  DetallePedidos.PedidoID 
				inner join  Productos       on DetallePedidos.ProductoID = Productos.ProductoID

----------------------------------------------------------------------------------

-- Obtener determinada informaci�n de los empleados.--
-- Ahora entiendo lo del superior, el superior no est� en otra tabla
-- es el ID del empleado el cual es su superior 

	--1.	Muestra el identificador, cargo, nombre y apellidos de todos los empleados.
	--2.	A�ade el cargo, nombre y apellidos del superior jer�rquico.
	--3.	Aseg�rate de que se muestren los datos de todo el personal.

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
	
	-->> ESTE FUE EL �NICO QUE NO SAQUE... ESTABA PONIENDO  emple1.EmpleadoID = emple2.EmpleadoID 
	
	----------------------------------------------------------------------------------

--		Obtener el listado de clientes (Empresa, Contacto y Cargo) junto con los pedidos que han hecho (PedidoID y FechaPedido)

--	1.	Aseg�rate de que se muestran todos los clientes, tengan pedido realizado o no.
--	2.	Filtra la consulta para que muestre tan solo aquellos que no tengan ning�n pedido realizado.


  select cli.ClienteID ,empresa, cli.contacto, cli.cargo,
          pedi.PedidoId , pedi.FechaPedido
  from 
  Clientes as cli  join Pedidos as pedi on cli.ClienteID = pedi.ClienteID 

  -- ESTA SELECT SACA  830 REGISTROS   FALTAN DOS CLIENTES 

		  --22	Customer DTDMN	Bueno, Janaina Burdan, Neville	Accounting Manager	NULL	NULL
		  --57	Customer WVAXS	Tollevsen, Bj�rn	            Owner	            NULL	NULL
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

  --	2.	Filtra la consulta para que muestre tan solo aquellos que no tengan ning�n pedido realizado.

  select cli.ClienteID , cli.empresa, cli.contacto, cli.cargo,
         pedi.PedidoId , pedi.FechaPedido
  from 
  Clientes as cli  left  join Pedidos as pedi on cli.ClienteID = pedi.ClienteID
  WHERE pedi.ClienteID  IS NULL 

  --NOTA MAGISTRAL DEL CURSO :  el  NULL es un valor en si mismo por lo cual podemos preguntar por el PERO OJO  con la PARTICULA IS 
  --                            con el signo de igual  =   NO FUNCIONA 