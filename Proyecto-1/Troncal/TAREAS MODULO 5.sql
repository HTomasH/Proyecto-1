
---------------------------------------------------------------------------------------------------------------
--------------     APUNTES DE MODULO 5
----------------------------------------------------------------------------------------------------------


--CAST


select DetallePedidos.PedidoID,
replace(   cast(PrecioUnitario as nVarchar(10) ) , '.'   ,      ',')    as importe
from DetallePedidos

-- REEMPLAZO  PUNTOS DECIMALES POR COMAS DECIMALES 
select DetallePedidos.PedidoID,
parse(replace(cast(PrecioUnitario as nVarchar(10) ), '.', ',')  as decimal(18,2) using 'es-ES') as importe
from DetallePedidos

--ISNULL

select
	ClienteID,
	Empresa,
	Poblacion,
	isnull(Poblacion, 'No tiene') as [Con isnull]
from Clientes



-- COALESCE(expression [ ,...n ])

select
	ClienteID,
	Empresa,
	Poblacion,
	coalesce(Poblacion, 'No tiene') as [Con isnull]
from Clientes

select
	PedidoID,
	EmpleadoID,
	TransportistaID,
	nullif(EmpleadoID, TransportistaID)
from Pedidos



select
	database_id,
	object_id,
	index_id,
	index_type_desc,
	avg_fragmentation_in_percent
from sys.dm_db_index_physical_stats(  db_id('CursoSQL') ,null,null,null,null)



select
	db.database_id,
	db.name,
	idx.database_id,
	idx.object_id,
	idx.index_id,
	idx.index_type_desc,
	idx.avg_fragmentation_in_percent
from sys.databases as db
	inner join sys.dm_db_index_physical_stats(null,null,null,null,null)  as idx    on   db.database_id = idx.database_id
where db.name = 'master' or db.name = 'CursoSQL'


select
	db.database_id,
	db.name,
	idx.database_id,
	idx.object_id,
	idx.index_id,
	idx.index_type_desc,
	idx.avg_fragmentation_in_percent
from sys.databases as db
	inner join sys.dm_db_index_physical_stats( db.database_id , null,null,null,null) as  idx
where db.name = 'master' or db.name = 'CursoSQL'



select
	db.database_id,
	db.name,
	idx.database_id,
	idx.object_id,
	idx.index_id,
	idx.index_type_desc,
	idx.avg_fragmentation_in_percent
from sys.databases as db
	cross apply sys.dm_db_index_physical_stats(db.database_id,null,null,null,null) as idx
where db.name = 'master' or db.name = 'CursoSQL'


-------- Crear nuestras propias funciones
----------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------
-- Función	ESCALAR definida por el usuario.
-- Nos permite crear funciones que devuelven un único valor de igual modo que cualquier otra función escalar del sistema.
-----------------------------------------------------------------------------------------------------------------------------

	CREATE FUNCTION <esquema>.<nombre_de_la_función> (<lista_de_parámetros>)
	RETURNS <tipo_dato_devuelto>
	AS
	BEGIN
		-- conjunto de instrucciones
		RETURN <valor_o_variable>;
	END;


	create function CalculaTotal( @cantidad int, @importe money)
	returns money
	as
	begin
		return @cantidad * @importe;
	end;

	select
		PedidoID,
		dbo.CalculaTotal(Cantidad, PrecioUnitario) as Importe
	from DetallePedidos

------------------------------------------------------------------------------------------------------------------------------
--	Función INLINE definida por el usuario.
--  En las funciones inline ya no devuelve un único valor, sino una tabla virtual que podemos crear a partir de una consulta.
-------------------------------------------------------------------------------------------------------------------------------

--> Nota MUY IMPORTANTE : la definición de la tabla no genera una tabla real en nuestra base de datos, 
--  sino que es una variable en memoria, y de hecho el nombretabla debe comenzar por arroba (@).

	SINTAXIS :
		CREATE FUNCTION <esquema>.<nombre_de_la_función> (<lista_de_parámetros>)
		RETURNS TABLE
		AS
		RETURN 
		(
			-- instrucción select
		);


   -->JODER CON ESTA PUTA FUNCION  NO ESTABA BIEN  ESCRITA  LE FALTABA ES   AS  a la operacion de mutiplicación 
	
	create function ObtenerDetalle(@pedido int)
	returns table	
	as  
	return
		(   select ProductoID, Cantidad * PrecioUnitario as IMPORTE 
		    from DetallePedidos  where PedidoID = @pedido  ) ;

    
	select * from ObtenerDetalle(10250)

  -->AQUI EL ASUNTO DE APPLY  ES COJONUDO, NOS DEVUELVE TODA LA TABLA CON LA OPERACION HECHA 

	select
		 p.PedidoID,
		 p.FechaPedido,
		 dt.ProductoID, 
		 dt.importe --  OJO  que este campo y este alias -dt-  es el que hace referencia a la tabla temporal devuelta por la función 
	from Pedidos as p
		 cross apply ObtenerDetalle(p.PedidoID) as dt


--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


------------------------------------------------------------------------------------
--> Función de MULTIPLES INSTRUCCIONES  instrucciones definida por el usuario
-----------------------------------------------------------------------------------


		CREATE FUNCTION <esquema>.<nombre_de_la_función> (<lista_de_parámetros>)
		RETURNS <nombre_tabla> TABLE
		(
			<definición_de_la_tabla>
		)
		AS
		BEGIN
			-- conjunto de instrucciones para calcular lo que tenemos que devolver
			-- instrucción insert para insertar datos en <nombre_tabla>
			RETURN;
		END;



		create function ObtenerDetalleMultiple(	@pedido int	)
		returns @resultado table
		(
			Producto int,
			Cantidad int,
			Precio money,
			Total money
		)
		as
		begin
			insert into @resultado(Producto, Cantidad, Precio, Total)  --INSERTA EN LA TABLA TEMPORAL-"FICTICIA" ESTOS CAMPOS 
				select
					ProductoID,
					Cantidad,
					PrecioUnitario,
					dbo.CalculaTotal(Cantidad, PrecioUnitario) --> ESTA LLAMANDO A LA QAUE HEMOS CREADO ANTERIORMENTE (HASTA 32 LLAMADAS EN BUCLE) 
				from DetallePedidos where PedidoID = @pedido 
			return;
		end;


select * from ObtenerDetalleMultiple(10250)


--xxxxxxxxxxxxxxxxxxxxxxxxxxx

-- truco con   CTL+ MAYUSCULAS + R   SE REFRESCA EL   INTELLICENSE 

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


DROP FUNCTION <esquema>.<nombre_de_la_función>

alter function ObtenerDetalle
(
    @pedido int
)
returns table
as
return
(
	select
        ProductoID,
        dbo.CalculaTotal(Cantidad, PrecioUnitario) as Importe
	from DetallePedidos where PedidoID = @pedido
);

Si comprobamos la ejecución, advertimos que no hay cambio alguno, puesto que simplemente hemos modificado el comportamiento interno de la función mediante el alter.

select
	p.PedidoID,
	p.FechaPedido,
	dt.ProductoID,
	dt.Importe
from Pedidos as p
	cross apply ObtenerDetalle(p.PedidoID) as dt

drop function dbo.CalculaTotal;
drop function dbo.ObtenerDetalle;
drop function dbo.ObtenerDetalleMultiple;


select * from Categorias








------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------  -TAREAS MODULO 5 -----------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
/*
Prácticas propuestas para el módulo 5
En este módulo hemos estudiado las funciones.
Dentro de ellas hemos visto tanto las que nos proporciona el sistema como la forma de crear nuestras propias funciones.

Para ayudar a que te familiarices con los diferentes tipos y con su uso, te proponemos que realices
las siguientes consultas por ti mismo, a través de las cuales irás afianzando la teoría y familiarizándote con las funciones más habituales:

* Obtener un listado de todos los productos, mostrando el identificador y un campo con el texto: "El precio unitario del producto Nombre es PrecioUnitario €".

* Obtener un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) cumpliendo una serie de prerrequisitos:
	1.	La fecha de pedido tiene que estar entre el 1 de abril de 2007 y 30 de noviembre de 2007, pero tienen que introducirse con el formato día/mes/año.
	2.	Entre la fecha de pedido y la de envío tienen que haber transcurrido más de 30 días.
	3.	Si no existe población, debe mostrar el texto 'Sin población'.


•	Obtener el listado de clientes (identificador, empresa, contacto, teléfono y fax) 
    donde mostremos el teléfono y el fax como un valor entero, eliminando guiones, paréntesis y espacios.


•	Obtener nuevamente un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) 
    junto con una serie de datos calculados:
	1.	Campo Envio que muestre Urgente si transcurre menos de 7 días entre la fecha de pedido y la de envío, 
	    Prioritario si son entre 8 y 14 días y Normal para el resto.
	2.	En el caso que la población sea un valor null, tiene que poner N/A.
	3.	Campo Periodo que indique trimestre del año y año del pedido de la forma año/trimestre.
	4.	Deben ordenarse los pedidos en primer lugar por Periodo en ascendente y a continuación por FechaPedido en descendente.

•	Obtener un listado de clientes:
	1.	Mostrar Empresa, Contacto y Cargo.
	2.	En el nombre de la Empresa, omitir el texto 'Customer'.
	3.	Añadir dos campos calculados:
		Un campo SeccionCP donde mostraremos Seccion1 si el código postal es par y Seccion2 si es impar.
		Un campo NombrePila que debe mostrar lo que está después de la coma en el Contacto.

   * Crea una función que devuelva un listado con los proveedores que tiene un producto.

	El producto que debe calcular se lo indicaremos mediante un parámetro.
	Probar a obtener los proveedores de los productos 'Product QMVUN' y 'Product KSZOI'.

*/ 

 --------------------- TAREA 1 
--Obtener un listado de todos los productos, mostrando el identificador y un 
--campo con el texto: "El precio unitario del producto Nombre es PrecioUnitario €".

	SELECT ProductoID, + 'El nombre del producto : '  + cast(pe.Nombre as nvarchar(10)) + '  El precio unitario es :  ' + cast(pe.PrecioUnitario as nvarchar(10))   +  '€'    
	FROM  PRODUCTOS  as pe    


	--Lo uno con  CONCAT  haciendo conversión. 
	SELECT ProductoID, 
		   concat('El nombre del producto : ' , cast(pe.Nombre as nvarchar(10)) , '  El precio unitario es :  ' ,  cast(pe.PrecioUnitario as nvarchar(10))  ,  ' €'  )  
	FROM  PRODUCTOS  as pe  

	--CON DOS COJONES,  EL CONCAT LO UNE SIN TENER QUE HACER LA CONVERSION !!!
	SELECT ProductoID, 
		   concat('El nombre del producto : ' , pe.Nombre  , '  El precio unitario es :  ' ,  pe.PrecioUnitario   ,  ' €'  )  
	FROM  PRODUCTOS  as pe  


--------------------- TAREA 2 
-- Obtener un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) cumpliendo una serie de prerrequisitos:

--1.	La fecha de pedido tiene que estar entre el 1 de abril de 2007 y 30 de noviembre de 2007, pero tienen que introducirse con el formato día/mes/año.
--2.	Entre la fecha de pedido y la de envío tienen que haber transcurrido más de 30 días.
--3.	Si no existe población, debe mostrar el texto 'Sin población'.

	select pe.PedidoID, 
		   format(pe.FechaPedido   , 'd', 'es-ES') as [FECHA PEDIDO] ,  
		   format(pe.FechaEnvio    , 'd', 'es-ES') as [FECHA ENVIO],   
		   isnull(pe.EnvioPoblacion, 'Sin Poblacion') as [Con isnull]  
	from pedidos as pe 
	where  pe.FechaPedido  between  '20070401'  and '20071130'	 
	and pe.FechaEnvio  >  dateadd( DD           , 30        , FechaPedido        )   
	--                           (dia-mes o año , incremento, Campo a incrementar)



--------------------- TAREA 3 
-- Obtener el listado de clientes (identificador, empresa, contacto, teléfono y fax) 
-- donde mostremos el teléfono y el fax como un valor entero, eliminando guiones, paréntesis y espacios.

	-- CON DOS COJONES, REPLACE MULTIPLE de varios caracteres a la vez.
		select cli.clienteId,
			   cli.empresa, 
			   cli.contacto, 			   
			   replace(replace( cli.telefono, '(', '')   ,  '-', '' )                     
		from Clientes as cli 

		


--------------------- TAREA  4 
/*
•	Obtener nuevamente un listado de pedidos (identificador, fecha de pedido, fecha de envío y población de envío) 
    junto con una serie de datos calculados

	1.	Campo Envio que muestre Urgente si transcurre menos de 7 días  	    entre la fecha de pedido y la de envío, 
	    Prioritario si son entre 8 y 14 días 
		y Normal para el resto.

	XXX 2.	En el caso que la población sea un valor null, tiene que poner N/A.
	
	xxx 3.	Campo Periodo que indique trimestre del año y año del pedido de la forma año/trimestre.
	
	XXX4.	Deben ordenarse los pedidos en primer lugar por Periodo en ascendente y a continuación por FechaPedido en descendente.

*/

		select
			PedidoID,
			FechaPedido,
			FechaEnvio,
			isnull(EnvioPoblacion, 'N/A') as [Poblacion],  			
			-- Para comparar FECHAS 
			case
				when datediff(dd, FechaPedido, FechaEnvio) <= 7 then 'Urgente'
				when datediff(dd, FechaPedido, FechaEnvio) <= 14 then 'Prioritario'
				else 'Normal'
			end as Envio,
			-- esto es lo mismo que el  AS pero con Campo = 
			periodo =  CONCAT( DATEPART(yy,FechaPedido) , '/' ,DATEPART(qq, FechaPedido ) ) 
		from Pedidos
		order by  Periodo DESC,   FechaPedido DESC 
		
	
		--	case
		--		when DATEPART(qq, FechaPedido ) = 1  then CONCAT( DATEPART(yy,FechaPedido) , '/' ,DATEPART(qq, FechaPedido ) )  --'Tri UNO'
		--		when DATEPART(qq, FechaPedido ) = 2  then 'Tri DOS'
		--		when DATEPART(qq, FechaPedido ) = 3  then 'Tri TRES'
		--		when DATEPART(qq, FechaPedido ) = 4  then 'Tri CUATRO'
		--		else 'mierdas'
		--	end as Periodo
			
		-- PRINT DATEPART(qq, '2006-10-01 00:00:00.000' ) 

		
		
--------------------- TAREA 5 
/*
		Obtener un listado de clientes:
	1.	Mostrar Empresa, Contacto y Cargo.
	2.	En el nombre de la Empresa, omitir el texto 'Customer'.
	3.	Añadir dos campos calculados:

		Un campo SeccionCP donde mostraremos Seccion1 si el código postal es par y Seccion2 si es impar.
		
		Un campo NombrePila que debe mostrar lo que está después de la coma en el Contacto.
  */ 
   
   
   select       	  	 	  
	  REPLACE(Empresa, 'Customer', '')  as [Empresa],   --Esta es la forma del igual =  EmpresaX = REPLACE(Empresa, 'Customer', ''),	  
	  NombrePila =  SUBSTRING(Contacto, PATINDEX('%,%', Contacto)  , 30),  -- le pongo 30 como es la máxima longuitud acierto de todas todas , 
	                                                                       -- Pero la forma elegante es indicando el LEN  len(Contacto)
	  SeccionCP  =   iif( ( codpostal % 2) = 0,  'Seccion-1'  , 'Seccion-2' ) ,  
	  Cargo 
	from clientes

	
	
--------------------- TAREA 6 ------------------------------------------------------------

/*
	Crea una función que devuelva un listado con los proveedores que tienen un producto.

	El producto que debe buscar se lo indicaremos mediante un parámetro.
	
	Probar a obtener los proveedores de los productos 'Product QMVUN' y 'Product KSZOI'.
*/
		

		
    -- Errores : Hay que devolver la tabla completa de proveedores y no solo dos campos.... parezco idiota 
	--           Hago los join de la tabla intermedia  con la tablas con los datos 
	--           El filtro va en el sitio donde puedo buscar, es decir en el nombre que me llega como parametro 
	
	-- ERROR fundamental :  Tengo perdida la costubre de hacer inner, en HB siempre buscabamos....
	--                      y no termino de caer en esa opción 


		create function ListadoProveedores (@Producto as nvarchar(50))
		returns table
		return
			select p.*
			from Proveedores as p
				inner join ProveedoresProducto as pp  on p.ProveedorID = pp.ProveedorID
				inner join Productos           as prd on pp.ProductoID = prd.ProductoID
			where prd.Nombre = @Producto;


	create function Calasparra (@Producto nvarchar(50))   --No es necesario poner el AS , funciona igual 
		returns table
		return
			select p.*
			from Proveedores as p
				inner join ProveedoresProducto as pp  on p.ProveedorID = pp.ProveedorID
				inner join Productos           as prd on pp.ProductoID = prd.ProductoID
			where prd.Nombre = @Producto;


        --select * from ListadoProveedores('Lentejas') 
		select * from ListadoProveedores('Product KSZOI') 

		--select * from Productos
		


/*




