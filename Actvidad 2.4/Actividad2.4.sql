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

--Listado con nombres de los cursos y la cantidad de idiomas de cada tipo. Es decir, la cantidad de idiomas de audio, la cantidad de subt�tulos y la cantidad de texto de video.

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

--Listado con apellidos y nombres de los usuarios, nombre de usuario y cantidad de cursos de nivel 'Principiante' que realiz� y cantidad de cursos de nivel 'Avanzado' que realiz�.

SELECT DISTINCT 
DP.Apellidos,
DP.Nombres,
U.NombreUsuario,
(SELECT COUNT(Cursos.IDNivel) FROM Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
LEFT JOIN Cursos ON Inscripciones.IDCurso = Cursos.ID
INNER JOIN Niveles ON Niveles.ID = Cursos.IDNivel
WHERE Niveles.Nombre LIKE 'Principiante' AND Usuarios.ID = U.ID)
AS CursosPrincipiantes,
(SELECT COUNT(Cursos.IDNivel) FROM Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
LEFT JOIN Cursos ON Inscripciones.IDCurso = Cursos.ID
INNER JOIN Niveles ON Niveles.ID = Cursos.IDNivel
WHERE Niveles.Nombre LIKE 'Avanzado' AND Usuarios.ID = U.ID)
AS CursosAvanzados
FROM Datos_Personales DP
INNER JOIN Usuarios U ON DP.ID = U.ID
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID
LEFT JOIN Cursos C ON I.IDCurso = C.ID
INNER JOIN Niveles N ON N.ID = C.IDNivel

--Listado con nombre de los cursos y la recaudaci�n de inscripciones de usuarios de g�nero femenino que se inscribieron y la recaudaci�n de inscripciones de usuarios de g�nero masculino.

SELECT DISTINCT
C.Nombre,
(SELECT
SUM(Inscripciones.Costo)
from Cursos 
LEFT JOIN Inscripciones  on Inscripciones.IDCurso = Cursos.ID
INNER JOIN Usuarios ON Usuarios.ID = Inscripciones.IDUsuario
INNER JOIN Datos_Personales ON Datos_Personales.ID = Usuarios.ID
WHERE Datos_Personales.Genero LIKE 'F' AND Cursos.ID = C.ID)
as RecaudacionFemenina,
(SELECT
SUM(Inscripciones.Costo)
from Cursos 
LEFT JOIN Inscripciones  on Inscripciones.IDCurso = Cursos.ID
INNER JOIN Usuarios ON Usuarios.ID = Inscripciones.IDUsuario
INNER JOIN Datos_Personales ON Datos_Personales.ID = Usuarios.ID
WHERE Datos_Personales.Genero LIKE 'M' AND Cursos.ID = C.ID)
as RecaudacionMasculina
from Cursos C
LEFT JOIN Inscripciones I on I.IDCurso = C.ID
LEFT JOIN Usuarios U ON U.ID = I.IDUsuario
LEFT JOIN Datos_Personales DP ON DP.ID = U.ID
--Listado con nombre de pa�s de aquellos que hayan registrado m�s usuarios de g�nero masculino que de g�nero femenino.

SELECT AUX.Nombre FROM
(SELECT DISTINCT
P.Nombre,
(SELECT COUNT(Datos_Personales.ID) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'M' AND Paises.ID = P.ID)
as Masculinos,
(SELECT COUNT(Datos_Personales.ID) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'F' AND Paises.ID = P.ID)
as Femeninos
FROM Paises P
LEFT JOIN Localidades L ON L.IDPais = P.ID
LEFT JOIN Datos_Personales DP ON DP.IDLocalidad = L.ID) as AUX
WHERE Masculinos > Femeninos

--Listado con nombre de pa�s de aquellos que hayan registrado m�s usuarios de g�nero masculino que de g�nero femenino pero que haya registrado al menos un usuario de g�nero femenino.

SELECT AUX.Nombre FROM
(SELECT DISTINCT
P.Nombre,
(SELECT COUNT(Datos_Personales.ID) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'M' AND Paises.ID = P.ID)
as Masculinos,
(SELECT COUNT(Datos_Personales.ID) FROM Paises
LEFT JOIN Localidades ON Localidades.IDPais = Paises.ID
LEFT JOIN Datos_Personales ON Datos_Personales.IDLocalidad = Localidades.ID
WHERE Datos_Personales.Genero LIKE 'F' AND Paises.ID = P.ID)
as Femeninos
FROM Paises P
LEFT JOIN Localidades L ON L.IDPais = P.ID
LEFT JOIN Datos_Personales DP ON DP.IDLocalidad = L.ID) as AUX
WHERE Masculinos > Femeninos AND Femeninos >= 1

--Listado de cursos que hayan registrado la misma cantidad de idiomas de audio que de subt�tulos.
SELECT AUX.Nombre FROM
(SELECT DISTINCT
C.Nombre,
(SELECT COUNT(Idiomas_x_Curso.IDFormatoIdioma) FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
LEFT JOIN FormatosIdioma ON FormatosIdioma.ID = Idiomas_x_Curso.IDFormatoIdioma
LEFT JOIN Idiomas ON Idiomas.ID = Idiomas_x_Curso.IDIdioma
WHERE FormatosIdioma.Nombre LIKE 'Audio' AND Cursos.ID = C.ID)
AS Audio,
(SELECT COUNT(Idiomas_x_Curso.IDFormatoIdioma) FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
LEFT JOIN FormatosIdioma ON FormatosIdioma.ID = Idiomas_x_Curso.IDFormatoIdioma
LEFT JOIN Idiomas ON Idiomas.ID = Idiomas_x_Curso.IDIdioma
WHERE FormatosIdioma.Nombre LIKE 'Subtitulo' AND Cursos.ID = C.ID)
AS Subtitulo
FROM Cursos C
LEFT JOIN Idiomas_x_Curso IC ON IC.IDCurso = C.ID
LEFT JOIN FormatosIdioma FI ON FI.ID = IC.IDFormatoIdioma
LEFT JOIN Idiomas I ON I.ID = IC.IDIdioma) AS AUX
WHERE AUX.Audio = AUX.Subtitulo

--Listado de usuarios que hayan realizado m�s cursos en el a�o 2018 que en el 2019 y a su vez m�s cursos en el a�o 2019 que en el 2020.

SELECT AUX.NombreUsuario FROM
(SELECT DISTINCT
U.NombreUsuario,
(SELECT COUNT(Inscripciones.ID) 
FROM Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
WHERE YEAR(Inscripciones.Fecha) = 2018 AND Usuarios.ID = U.ID)
AS Cursos2018,
(SELECT COUNT(Inscripciones.ID) 
FROM Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
WHERE YEAR(Inscripciones.Fecha) = 2019 AND Usuarios.ID = U.ID)
AS Cursos2019,
(SELECT COUNT(Inscripciones.ID) 
FROM Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
WHERE YEAR(Inscripciones.Fecha) = 2020 AND Usuarios.ID = U.ID)
AS Cursos2020
FROM Usuarios U
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID) AS AUX
WHERE AUX.Cursos2018 > AUX.Cursos2019 AND AUX.Cursos2019 > AUX.Cursos2020

-- Listado de apellido y nombres de usuarios que hayan realizado cursos pero nunca se hayan certificado.
-- Aclaraci�n: Listado con apellidos y nombres de usuarios que hayan realizado al menos un curso y no se hayan certificado nunca.

SELECT AUX.Apellidos, AUX.Nombres FROM
(SELECT DISTINCT 
DP.Apellidos,
DP.Nombres,
(select COUNT(Inscripciones.ID) from Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
WHERE Usuarios.ID = U.ID)
AS Inscripciones,
(select COUNT(Certificaciones.IDInscripcion) from Usuarios
LEFT JOIN Inscripciones ON Inscripciones.IDUsuario = Usuarios.ID
LEFT JOIN Certificaciones ON Certificaciones.IDInscripcion = Inscripciones.ID
WHERE Usuarios.ID = U.ID)
AS Certificaciones
FROM Datos_Personales DP
LEFT JOIN Usuarios U ON DP.ID = U.ID
LEFT JOIN Inscripciones I ON I.IDUsuario = U.ID) AS AUX
WHERE AUX.Certificaciones = 0 AND Inscripciones >= 1






