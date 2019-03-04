drop table if exists Tabla2;
drop table if exists Tabla1;

create table OUTERTabla1(
	Tabla1ID int primary key not null,
	Valor nvarchar(50)
)

create table OUTERTabla2(
	Tabla2ID int identity(1,1) primary key not null,
	Valor nvarchar(50),
	Tabla1ID int,
	constraint fk_tabla1_tabla2
		foreign key (Tabla1ID) references OUTERtabla1(Tabla1ID)
)

insert into OUTERtabla1(Tabla1ID,Valor)
values	(1,'Registro1'),
		(2,'Registro2'),
		(3,'Registro3'),
		(4,'Registro4'),
		(5,'Registro5');

insert into OUTERTabla2(Valor, Tabla1ID)
values	('Registro1',1),
		('Registro2',3),
		('Registro3',3),
		('Registro4',5),
		('Registro5',1),
		('Registro6',2),
		('Registro7',2),
		('Registro8',2),
		('Registro9',5),
		('Registro10',2),
		('Registro11',null),
		('Registro12',null),
		('Registro13',1),
		('Registro14',1),
		('Registro15',null);


select * from OUTERtabla1 
select * from OUTERtabla2



select
    t1.Tabla1ID,
    t1.Valor as [Valor tabla1],
    t2.Tabla2ID,
    t2.Valor as [Valor tabla2]
from 
    OUTERTabla1 as t1 left outer join OUTERTabla2 as t2  on t1.Tabla1ID = t2.Tabla1ID 

--13 registros

select
    t1.Tabla1ID,
    t1.Valor as [Valor tabla1],
    t2.Tabla2ID,
    t2.Valor as [Valor tabla2]
from 
    OUTERTabla1 as t1 left  join OUTERTabla2 as t2  on t1.Tabla1ID = t2.Tabla1ID 

--13 registros  ME DA IGUAL PONER OUTER  me salen los 13 registros UTILIZANDO LEFT 


select
    t1.Tabla1ID,
    t1.Valor as [Valor tabla1],
    t2.Tabla2ID,
    t2.Valor as [Valor tabla2]
from 
    OUTERTabla1 as t1  join OUTERTabla2 as t2  on t1.Tabla1ID = t2.Tabla1ID 

	--12 registros   AQUI HAY DIFERENCIA no sale un registro

	-- Este no sale, pero creo que es por el LEFT no por lo del  outer.... NO LO ENTIENDO 
	4	Registro4	NULL	NULL




	select * from OUTERtabla1 ,  OUTERtabla2



select *
from OUTERTabla1 as t1
    cross join OUTERTabla2 as t2



select
    emp.Nombre,
    emp.Apellidos,
    sup.Nombre as [Nombre superior],
    sup.Apellidos as [Apellidos superior]
from Empleados as emp
    inner join Empleados as sup  on emp.SuperiorID = sup.EmpleadoID



