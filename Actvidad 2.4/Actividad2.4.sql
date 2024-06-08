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

--Listado de países que no tengan usuarios relacionados.

SELECT DISTINCT P.Nombre FROM Paises P
LEFT JOIN Localidades L ON L.IDPais = P.ID
LEFT JOIN Datos_Personales DP ON DP.IDLocalidad = L.ID
WHERE P.ID NOT IN 
(
	SELECT DISTINCT Paises.ID FROM Paises
	INNER JOIN Localidades ON Localidades.IDPais = Paises.ID
	INNER JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
)

--Listado de clases cuya duración sea mayor a la duración promedio.

SELECT * FROM CLASES
WHERE Clases.Duracion > (SELECT AVG(Clases.Duracion) FROM Clases)

--Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los contenidos de tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos C
INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
INNER JOIN Clases CL ON CL.ID = C.IDClase
WHERE C.Tamaño > ( SELECT MAX(C.Tamaño) FROM Contenidos C
					INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
					INNER JOIN Clases CL ON CL.ID = C.IDClase
					WHERE TC.Nombre LIKE 'Audio de alta calidad')

SELECT * FROM TiposContenido INNER JOIN Contenidos ON Contenidos.IDTipo = TiposContenido.ID INNER JOIN Clases ON Clases.ID = Contenidos.IDClase

--Listado de contenidos cuyo tamaño sea menor al tamaño de algún contenido de tipo 'Audio de alta calidad'.

SELECT C.ID FROM Contenidos C
INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
INNER JOIN Clases CL ON CL.ID = C.IDClase
WHERE C.Tamaño > (SELECT MIN(C.Tamaño) FROM Contenidos C
					INNER JOIN TiposContenido TC ON TC.ID = C.IDTipo
					INNER JOIN Clases CL ON CL.ID = C.IDClase
					WHERE TC.Nombre LIKE 'Audio de alta calidad')

--Listado con nombre de país y la cantidad de usuarios de género masculino y la cantidad de usuarios de género femenino que haya registrado.

SELECT DISTINCT P.ID, P.Nombre, 
(SELECT COUNT(*) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'M' AND Paises.ID = P.ID) as Masculinos,
(SELECT COUNT(*) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'F' AND Paises.ID = P.ID) as Femeninos
FROM Paises P
LEFT JOIN Localidades L ON L.IDPais = P.ID
LEFT JOIN Datos_Personales DP ON DP.IDLocalidad = L.ID

--Listado con apellidos y nombres de los usuarios y la cantidad de inscripciones realizadas en el 2019 y la cantidad de inscripciones realizadas en el 2020.

SELECT DISTINCT
DP.Nombres,
DP.Apellidos,
(SELECT COUNT(Inscripciones.ID) FROM Inscripciones
LEFT JOIN Usuarios ON Inscripciones.IDUsuario = Usuarios.ID
WHERE YEAR(Inscripciones.Fecha) = 2019 AND Usuarios.ID = U.ID)
as InscripcionesEn2019,
(SELECT COUNT(Inscripciones.ID) FROM Inscripciones
LEFT JOIN Usuarios ON Inscripciones.IDUsuario = Usuarios.ID
WHERE YEAR(Inscripciones.Fecha) = 2020 AND Usuarios.ID = U.ID)
as InscripcionesEn2020
FROM Datos_Personales DP
INNER JOIN Usuarios U ON DP.ID = U.ID
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID

--Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, la cantidad de subtítulos y la cantidad de texto de video.

SELECT DISTINCT
C.Nombre,
(SELECT COUNT(Idiomas_x_Curso.IDCurso) FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
INNER JOIN FormatosIdioma ON Idiomas_x_Curso.IDFormatoIdioma = FormatosIdioma.ID
INNER JOIN Idiomas ON Idiomas_x_Curso.IDIdioma = Idiomas.ID
WHERE FormatosIdioma.Nombre LIKE 'Audio' AND CURSOS.ID = C.ID
) as IdiomasAudio,
(SELECT COUNT(Idiomas_x_Curso.IDCurso) FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
INNER JOIN FormatosIdioma ON Idiomas_x_Curso.IDFormatoIdioma = FormatosIdioma.ID
INNER JOIN Idiomas ON Idiomas_x_Curso.IDIdioma = Idiomas.ID
WHERE FormatosIdioma.Nombre LIKE 'Subtitulo' AND CURSOS.ID = C.ID
) 
as IdiomasSubtitulo,
(SELECT COUNT(Idiomas_x_Curso.IDCurso) FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
INNER JOIN FormatosIdioma ON Idiomas_x_Curso.IDFormatoIdioma = FormatosIdioma.ID
INNER JOIN Idiomas ON Idiomas_x_Curso.IDIdioma = Idiomas.ID
WHERE FormatosIdioma.Nombre LIKE 'Texto del video' AND CURSOS.ID = C.ID
) 
as IdiomaTexto
FROM Cursos C
LEFT JOIN Idiomas_x_Curso IC ON IC.IDCurso = C.ID
INNER JOIN FormatosIdioma FI ON IC.IDFormatoIdioma = FI.ID
INNER JOIN Idiomas I ON IC.IDIdioma = I.ID

--Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realizó y cantidad de cursos de nivel 'Avanzado' que realizó.

SELECT DISTINCT 
DP.Apellidos,
DP.Nombres,
U.NombreUsuario,
() AS CursosPrincipiantes,
() AS CursosAvanzados
FROM Datos_Personales DP
INNER JOIN Usuarios U ON DP.ID = U.ID
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID
LEFT JOIN Cursos C ON I.IDCurso = C.ID
INNER JOIN Niveles N ON N.ID = C.IDNivel
