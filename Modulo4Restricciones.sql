---Usando Northwind
Use NORTHWIND
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
---Insertando datos sin incluir direccion
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate)
values
(20180101, 3454356,'Carlos', 'Garcia', '01-01-1999')
go

---Insertando datos sin incluyendo direccion pero enviando el parametro como default
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180102, 3454356,'Claudia', 'Hernandez', '01-01-1999', DEFAULT)
go
---Consultando la tabla
Select * from Student


---Restriccion Check
Alter Table Student
add constraint ck_birthdate2 check (datediff(year,birthdate,getdate())>=18)
go
---Comprobando la restriccion Check, no debe permitir este dato por la fecha
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180103, 3454355,'Miguel', 'Garcia', '01-01-2015', DEFAULT)
go
---Comprobando la restriccion Check, si debe permitir este dato por la fecha
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180103, 3454355,'Miguel', 'Garcia', '01-01-1915', DEFAULT)
go

--Vamos a borrar los datos de la tabla
Delete from Student
---Restriccion Unique
Alter Table Student
add constraint U_socialsecurity Unique (socialsecuritynumber)
go
---Insertando un nuevo dato
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate)
values
(20180101, 3454356,'Carlos', 'Garcia', '01-01-1999')
go
--Insertando otro dato pero con el mismo socialsecuritynumber, no lo debe permitir
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180102, 3454356,'Claudia', 'Hernandez', '01-01-1999', DEFAULT)
go
--Si cambiamos el socialsecuritynumber, lo debe permitir
Insert into Student (StudentId,socialsecuritynumber, firstname, lastname, birthdate,
[address])
values
(20180102, 3454399,'Claudia', 'Hernandez', '01-01-1999', DEFAULT)
go

--Otra forma de usar la Restriccion Default
Alter Table Student
add constraint Df_addresss Default ('Ciudad') for [address]
go

---Crear la tabla Clase
Create table ClassAssign
(
ClassId bigint not null primary key,
StudentId bigint,
Classname varchar(150),
)

--Restriccion Default
Alter Table ClassAssign
add constraint FK_Student_class foreign key (StudentId) references
Student (StudentId) on Update Cascade on Delete no Action
go

---Ingresando a ClassAssign un StudentID que no existe, no lo debe permitir
Select * from Student
go
Insert into ClassAssign (ClassId, StudentId, ClassName)
values
(24,98798798, 'Matematica Avanzada')

---Ingresando a ClassAssign un StudentID que si existe, si debe permitir
Select * from Student
go
Insert into ClassAssign (ClassId, StudentId, ClassName)
values
(24,20180108, 'Matematica Avanzada')
go