USE MASTER
GO
Create DATABASE Corporacion
on Primary
(name=CorporacionData, Filename='C:\Data\CorporacionData.mdf'
, size=50MB, Filegrowth=25%)
log on
(name=CorporacionLog, Filename='C:\Data\CorporacionLog.mdf'
, size=25MB, Filegrowth=25%)
go
---Filegroups
Alter database Corporacion
add filegroup CorpoParte1
go
Alter database Corporacion
add filegroup CorpoParte2
go
Alter database Corporacion
add filegroup CorpoParte3
go
--agregar archivos al filegroup
Alter database Corporacion
add file (name=Corporacion1, Filename='C:\Data\Corporacion1.ndf'
, size=50MB, Filegrowth=25%) to filegroup CorpoParte1
go
Alter database Corporacion
add file (name=Corporacion2, Filename='C:\Data\Corporacion2.ndf'
, size=50MB, Filegrowth=25%) to filegroup CorpoParte2
go
Alter database Corporacion
add file (name=Corporacion3, Filename='C:\Data\Corporacion3.ndf'
, size=50MB, Filegrowth=25%) to filegroup CorpoParte3
go
---Creando la funcion de particion
USE Corporacion
GO
CREATE PARTITION FUNCTION FUNCIONDEPARTICION (BIGINT)
AS RANGE LEFT FOR VALUES (500,1000)
GO
--Creando el Esquema de la particion
CREATE PARTITION SCHEME SCHEMAPARTICION AS PARTITION FUNCIONDEPARTICION
TO (CorpoParte1, CorpoParte2, CorpoParte3)
GO
--Crear la tabla
CREATE TABLE CLIENTE
( CODIGO BIGINT NOT NULL PRIMARY KEY,
NOMBRE VARCHAR(200),
APELLIDO VARCHAR(200)
) ON SCHEMAPARTICION(CODIGO)
GO
--INSERTAR DATOS
INSERT INTO CLIENTE (CODIGO, NOMBRE, APELLIDO) VALUES
(1,'Jose', 'Garcia'),(2,'Ana','Perez'),
(501,'Jose', 'Alfaro'),(502,'Ana','Acuña'),
(1001,'Amado', 'Juarez'),(1002,'Claudia','Hernandez')

--verificar las particiones donde se almacenan estos datos
SELECT CODIGO, NOMBRE APELLIDO, $partition.FUNCIONDEPARTICION(CODIGO)
AS PARTICION FROM CLIENTE

--Creando un indice particionado
CREATE NONCLUSTERED INDEX IDX_APELLIDO
ON CLIENTE (APELLIDO)
ON SCHEMAPARTICION(CODIGO)
GO
--Insertando nuevos Datos
INSERT INTO CLIENTE (CODIGO, NOMBRE, APELLIDO) VALUES
(2001,'Luis', 'Maldonado'),(2002,'Lucas','Garcia'),
(2501,'Domingo', 'Perez'),(2502,'Consuelo','Acuña'),
(3001,'Ingrid', 'Juarez'),(3002,'Claudia','Bran')

---Comprobando los datos insertados
SELECT * FROM CLIENTE

--Creando una nueva particion
Alter database Corporacion
add filegroup CorpoParte4
go
--agregar archivos al filegroup
Alter database Corporacion
add file (name=Corporacion4, Filename='C:\Data\Corporacion4.ndf'
, size=50MB, Filegrowth=25%) to filegroup CorpoParte4

---MODIFICAR LA FUNCION Y EL ESQUEMA DE LA PARTICION
ALTER PARTITION SCHEME SCHEMAPARTICION NEXT USED CorpoParte4
go
ALTER PARTITION FUNCTION FUNCIONDEPARTICION() SPLIT RANGE (2000)
GO
--verificar los datos en sus respectivas  particiones 
SELECT CODIGO, NOMBRE APELLIDO, $partition.FUNCIONDEPARTICION(CODIGO)
AS PARTICION FROM CLIENTE

--Unir nuevamente las particiones

ALTER PARTITION FUNCTION FUNCIONDEPARTICION() MERGE RANGE(2000)
GO
--verificar los datos en sus respectivas particiones 
SELECT CODIGO, NOMBRE APELLIDO, $partition.FUNCIONDEPARTICION(CODIGO)
AS PARTICION FROM CLIENTE














