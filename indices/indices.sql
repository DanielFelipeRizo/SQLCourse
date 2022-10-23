select * from Ciudadano

SELECT nom1,nom2,ape1,ape2
from ciudadano where NOM1='Victor' and APE1='Cardenas'
--borrar los planes de memoria  de la consulta de cache en el buffer
DBCC FREEPROCCACHE WITH NO_INFOMSGS;
DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;

--crear un indice clusteriado
create clustered index CL_NOMBRE on CIUDADANO(NOM1)

--crear un indice no agrupado
create nonclustered index CL_APELLIDO on CIUDADANO(APE1,APE2)

--incluir nom1 dentro del indice
create nonclustered index NIDX_APELLIDOS on individuo(APE1,APE2) include(nom1)

--crear un indice no agrupado con datos de indice unicos
create unique nonclustered index CL_APELLIDO on CIUDADANO(APE1,APE2)

--saber la fragmentacion de una tabla y sus indices
DBCC SHOWCONTIG ('DBO.CIUDADANO')