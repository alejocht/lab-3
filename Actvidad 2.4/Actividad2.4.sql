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

