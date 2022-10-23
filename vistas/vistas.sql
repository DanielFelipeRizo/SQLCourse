use NORTHWIND
go
---Crear una vista
CREATE VIEW VIEW_VENTAS
AS
Select c.CustomerID, c.CompanyName, c.Country, o.OrderID
, o.OrderDate, cat.CategoryName, p.ProductName, d.UnitPrice, d.Quantity
, d.UnitPrice * d.Quantity as TotalPartial
from customers as c 
inner join orders as o on c.CustomerID=o.CustomerID
inner join [order details] as d on d.OrderID=o.OrderID
inner join products as p on p.ProductID=d.ProductID
inner join Categories as cat on p.CategoryID=cat.CategoryID
GO
---Usar la vista
SELECT * FROM VIEW_VENTAS
GO
---VER EL SCRIPT QUE ORIGINA UNA VISTA
SP_HELPTEXT select * from VIEW_VENTAS

--MODIFICAR LA VISTA ENCRIPTANDO EL SCRIPT
ALTER VIEW VIEW_VENTAS (CODIGOCLIENTE, COMPA�IA, PAIS, NUMEROORDEN, FECHA
, CATEGORIA, PRODUCTO, PRECIO, CANTIDAD, TOTAL)
WITH ENCRYPTION
AS
Select c.CustomerID, c.CompanyName, c.Country, o.OrderID
, o.OrderDate, cat.CategoryName, p.ProductName, d.UnitPrice, d.Quantity, 
d.UnitPrice * d.Quantity as TotalParcial
from DBO.customers as c 
inner join DBO.orders as o on c.CustomerID=o.CustomerID
inner join DBO.[order details] as d on d.OrderID=o.OrderID
inner join DBO.products as p on p.ProductID=d.ProductID
inner join DBO.Categories as cat on p.CategoryID=cat.CategoryID
GO

---VER EL SCRIPT QUE ORIGINA UNA VISTA ENCRIPTADO
SP_HELPTEXT select * from VIEW_VENTAS

--MODIFICAR LA VISTA VINCULANDOLA A ESQUEMA
--SCHEMABINDING permite vincular las tablas de las que depende la vista
--para que no se eliminen ya que generan la vista

ALTER VIEW VIEW_VENTAS (CODIGOCLIENTE, COMPA�IA, PAIS, NUMEROORDEN, FECHA
, CATEGORIA, PRODUCTO, PRECIO, CANTIDAD, TOTAL)
WITH SCHEMABINDING
AS
Select c.CustomerID, c.CompanyName, c.Country, o.OrderID
, o.OrderDate, cat.CategoryName, p.ProductName, d.UnitPrice, d.Quantity, 
d.UnitPrice * d.Quantity as TotalParcial
from DBO.customers as c 
inner join DBO.orders as o on c.CustomerID=o.CustomerID
inner join DBO.[order details] as d on d.OrderID=o.OrderID
inner join DBO.products as p on p.ProductID=d.ProductID
inner join DBO.Categories as cat on p.CategoryID=cat.CategoryID
GO
DROP TABLE [Order Details]
GO
--MODIFICAR LA VISTA USANDO VIEW_METADATA
--VIEW_METADATA permite que el cliente de programacion(.net por ejemplo) vea la vista 
--como si fuera una tabla
ALTER VIEW VIEW_VENTAS (CODIGOCLIENTE, COMPA�IA, PAIS, NUMEROORDEN, FECHA
, CATEGORIA, PRODUCTO, PRECIO, CANTIDAD, TOTAL)
WITH ENCRYPTION, SCHEMABINDING, VIEW_METADATA
AS
Select c.CustomerID, c.CompanyName, c.Country, o.OrderID
, o.OrderDate, cat.CategoryName, p.ProductName, d.UnitPrice, d.Quantity, 
d.UnitPrice * d.Quantity as TotalParcial
from DBO.customers as c 
inner join DBO.orders as o on c.CustomerID=o.CustomerID
inner join DBO.[order details] as d on d.OrderID=o.OrderID
inner join DBO.products as p on p.ProductID=d.ProductID
inner join DBO.Categories as cat on p.CategoryID=cat.CategoryID
GO

---USO DE WITH CHECK OPTION

CREATE VIEW VIEW_CLIENTESPORPAIS
AS
SELECT CUSTOMERID, COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
FROM CUSTOMERS
WHERE COUNTRY='USA'

--WITH CHECK OPTION verifica si intentamos insertar datos a traves de la vista
--los datos cumplan con la condicion(where) de la vista
ALTER VIEW VIEW_CLIENTESPORPAIS
AS
SELECT CUSTOMERID, COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
FROM CUSTOMERS
WHERE COUNTRY='USA'
WITH CHECK OPTION
GO
---USAR LA VISTA
SELECT * FROM VIEW_CLIENTESPORPAIS
GO
---INSERTAR DATOS A LA VISTA VIEW_CLIENTESPORPAIS
INSERT INTO VIEW_CLIENTESPORPAIS 
(CUSTOMERID, COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY)
VALUES
('ABCD4','LA OTRA, S.A.','JUAN PEREZ','ING','USA')
GO

---VISTAS PARTICIONADAS
--'union' une dos consultas de diferente tabla que tengan las mismas columnas. no muestra valoress repetidos
--'union all' muestra todas las filas asi esten repetidas en las 2 consultas
CREATE VIEW VIEW_CATALOGO
AS
SELECT COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
FROM CUSTOMERS
UNION ALL
SELECT COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
FROM SUPPLIERS
GO
---CREAR UNA VISTA A PARTIR DE UNA VISTA
CREATE VIEW VIEW_LISTAEMPRESAS
AS
SELECT * FROM VIEW_CATALOGO
GO
---USAR LA VISTA

SELECT * FROM VIEW_LISTAEMPRESAS

---CREAR UN INDICE DE TIPO UNIQUE CLUSTERED PARA LA VISTA
--se requiere el indice tipo unique CLUSTERED primero para seguir creando otros indices no CLUSTERED 
--y la vista debe estar enlazada a un esquema.(SCHEMABINDING) 

CREATE UNIQUE CLUSTERED INDEX IDX_VENTAS ON VIEW_VENTAS 
(CODIGOCLIENTE, NUMEROORDEN, PRODUCTO) --no debe tener repetidos por el unique.debe ser un indice compuesto. juntas las 3 columnas no tienen repetidos.
GO
---CREAR UN INDICE NO CLUSTEREADO
CREATE NONCLUSTERED INDEX IDX_COMPANIA ON VIEW_VENTAS
(COMPA�IA)
GO


---VISTAS DEL SISTEMA
---PARA CONSULTAR LOS CONSTRAINT DE NUESTRA BD

SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE --ver CONSTRAINTS de llaves primarias y foranes
.
.

---VISTAS DE ADMINISTRACI�N DINAMICA
--devuelve informacion de todas las esperas encontradas por los subprocesos ejecutados
--se usa para diagnosticas problemas de rendimiento
SELECT WAIT_TYPE, WAIT_TIME_MS FROM SYS.dm_os_wait_stats
