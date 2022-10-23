Use Master
go
---Crear una base de datos de ejemplo
Create database Courses
---Usando Courses
Use Courses
go
---Creando La tabla Estudiante
Create table Student
(
StudentId bigint not null primary key,
socialsecuritynumber bigint,
firstname varchar(150) not null,
lastname varchar(150),
[address] varchar(150) default('Ciudad'),
birthdate date
)
go
--Insertando unos datos
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180103, 3454355,'Miguel', 'Garcia', '01-01-2015', DEFAULT)
go
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate)
values
(20180104, 3454356,'Ana', 'Alfaro', '01-01-1915')
go

---Restriccion Check
Alter Table Student
with nocheck
add constraint ck_birthdate2 check (datediff(year,birthdate,getdate())>=18)
go
---Deshabilitar la restriccion check
Alter table Student
nocheck
constraint ck_birthdate2
go
---Insertando un dato que con fecha que no cumple con la restriccion 
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate)
values
(20180134, 3454334,'Pedro', 'Galindo', '01-05-2017')
go
---Borrar la restriccion check
Alter table Student
drop constraint ck_birthdate2
go
---Crear una restricción que no compruebe los datos ya ingresados
Alter Table Student
with nocheck
add constraint ck_birthdate2 check (datediff(year,birthdate,getdate())>=18)
go
---Crear la tabla AsignacionClase
Create table ClassAssign
(
ClassId bigint not null primary key,
StudentId bigint,
Classname varchar(150),
)

--Restriccion de llave foranea
Alter Table ClassAssign
add constraint FK_Student_class foreign key (StudentId) references
Student (StudentId) on Update Cascade on Delete no Action
go
---Revisar constraint de la tabla
sp_helpconstraint student
--Consultar los datos de la tabla student y classassign
Select * from Student
Select * from ClassAssign
--Consultar restricciones
sp_helpconstraint ClassAssign
go
--Deshabilitar la restriccion de llave foranea
Alter table ClassAssign
nocheck
constraint FK_Student_class

--Insertar datos a classassign
Insert into ClassAssign(ClassId,StudentId,Classname)
values
(1,20170101,'Matematica Avanzada')
go

--Deshabilitar el identity-----------------------------------------
---nueva tabla
Create table Class
(ClassId int identity(1,1) not null primary key,
Name varchar(100)
)
go
---Insertar un dato
Insert into Class (Name)
values ('Matemática avanzada')
--deshabilitar el identity_insert
Set identity_insert dbo.Class ON
--Insertar el dato insertando la columna classId
Insert into Class (ClassId,Name)
values (2,'Finanzas')
--Insertar datos a la nueva tabla
Insert into Class (ClassId, Name)
values (3,'Contabilidad')

--deshabilitar el identity_insert
Set identity_insert dbo.Class Off
---Consultando la tabla
Select * from Student