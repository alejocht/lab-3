--Listado con apellidos y nombres de los usuarios que no se hayan inscripto
--a cursos durante el año 2019.

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

--Listado con apellidos y nombres de los usuarios que se hayan inscripto a cursos pero no hayan realizado ningún pago.

SELECT DISTINCT * from Usuarios U
inner join Inscripciones I on i.IDUsuario = u.ID
inner join Datos_Personales DP on DP.ID = U.ID
left join Pagos P on P.IDInscripcion = I.ID
WHERE U.ID NOT IN
(
SELECT DISTINCT U.ID from Usuarios U
inner join Datos_Personales DP on DP.ID = U.ID
inner join Inscripciones I on i.IDUsuario = u.ID
inner join Pagos P on P.IDInscripcion = I.ID
)

SELECT DISTINCT * from Usuarios U
inner join Inscripciones I on i.IDUsuario = u.ID
inner join Datos_Personales DP on DP.ID = U.ID
left join Pagos P on P.IDInscripcion = I.ID
ORDER BY DP.Apellidos, DP.Nombres DESC
