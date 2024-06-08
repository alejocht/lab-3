--Listado con apellidos y nombres de los usuarios que no se hayan inscripto
--a cursos durante el a�o 2019.

SELECT DISTINCT DP.Nombres, DP.Apellidos from Usuarios U
left join Inscripciones I on i.IDUsuario = u.ID
inner join Datos_Personales DP on DP.ID = U.ID
WHERE I.IDUsuario NOT IN (
	SELECT DISTINCT i.IDUsuario from Usuarios U
	left join Inscripciones I on i.IDUsuario = u.ID
	inner join Datos_Personales DP on DP.ID = U.ID
	WHERE YEAR(I.Fecha) = 2019
)

--query para comprobar

select * from Inscripciones 
inner join Usuarios on Inscripciones.IDUsuario = Usuarios.ID
inner join Datos_Personales on Datos_Personales.ID = Usuarios.ID
order by Datos_Personales.Nombres asc

--Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ning�n pago.

select DISTINCT dp.Nombres, dp.Apellidos from Datos_Personales DP
inner join Usuarios U on U.ID = DP.ID
left join Inscripciones I on I.IDUsuario = U.ID
left join Pagos P on P.IDInscripcion = I.ID
WHERE U.ID NOT IN 
(
SELECT distinct u.ID FROM Datos_Personales DP
inner join Usuarios U on U.ID = DP.ID
inner join Inscripciones I on I.IDUsuario = U.ID
inner join Pagos P on P.IDInscripcion = I.ID
) AND I.ID IS NOT NULL

--query de toda las tablas
SELECT * FROM Datos_Personales DP
LEFT join Usuarios U on U.ID = DP.ID
LEFT join Inscripciones I on I.IDUsuario = U.ID
LEFT join Pagos P on P.IDInscripcion = I.ID

--query de comprobacion
select DP.Nombres, DP.Apellidos, COUNT(i.ID) as inscripciones, COUNT(p.id) as pagos FROM Datos_Personales DP
LEFT join Usuarios U on U.ID = DP.ID
LEFT join Inscripciones I on I.IDUsuario = U.ID
LEFT join Pagos P on P.IDInscripcion = I.ID
group by DP.Nombres, DP.Apellidos
having COUNT(p.id) = 0

--Listado de pa�ses que no tengan usuarios relacionados.

SELECT DISTINCT P.Nombre FROM Paises P
LEFT JOIN Localidades L ON L.IDPais = P.ID
LEFT JOIN Datos_Personales DP ON DP.IDLocalidad = L.ID
WHERE P.ID NOT IN 
(
	SELECT DISTINCT Paises.ID FROM Paises
	INNER JOIN Localidades ON Localidades.IDPais = Paises.ID
	INNER JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
)

--Listado de clases cuya duraci�n sea mayor a la duraci�n promedio.

SELECT * FROM CLASES
WHERE Clases.Duracion > (SELECT AVG(Clases.Duracion) FROM Clases)

--Listado de contenidos cuyo tama�o sea mayor al tama�o de todos los contenidos de tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos C
INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
INNER JOIN Clases CL ON CL.ID = C.IDClase
WHERE C.Tama�o > ( SELECT MAX(C.Tama�o) FROM Contenidos C
					INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
					INNER JOIN Clases CL ON CL.ID = C.IDClase
					WHERE TC.Nombre LIKE 'Audio de alta calidad')

SELECT * FROM TiposContenido INNER JOIN Contenidos ON Contenidos.IDTipo = TiposContenido.ID INNER JOIN Clases ON Clases.ID = Contenidos.IDClase

--Listado de contenidos cuyo tama�o sea menor al tama�o de alg�n contenido de tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos C
INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
INNER JOIN Clases CL ON CL.ID = C.IDClase
WHERE C.Tama�o > (SELECT MIN(C.Tama�o) FROM Contenidos C
					INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
					INNER JOIN Clases CL ON CL.ID = C.IDClase
					WHERE TC.Nombre LIKE 'Audio de alta calidad')

--Listado con nombre de pa�s y la cantidad de usuarios de g�nero masculino y la cantidad de usuarios de g�nero femenino que haya registrado.


