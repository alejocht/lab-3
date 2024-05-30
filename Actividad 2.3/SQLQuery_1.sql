--Funciones de resumen
-- USE UnivSemana5_1
-- go
 -- Punto 1
 Select COUNT(*) FROM Cursos
 -- Punto 2
 SELECT COUNT(*) FROM Usuarios
 -- Punto 3
 SELECT AVG(c.Costo) FROM Certificaciones c
 -- Punto 4
 SELECT AVG(r.Puntaje) FROM Reseñas r
 -- Punto 5
 SELECT MIN(Estreno) FROM Cursos
 -- Punto 6
 SELECT MIN(c.Costo) FROM Certificaciones c
 -- Punto 7
 SELECT SUM(c.Costo) FROM Certificaciones c
 -- Punto 8
 SELECT SUM(Pagos.Importe) FROM Pagos
 -- Punto 9
 SELECT COUNT(*) FROM Cursos WHERE Cursos.IDNivel = 5 
 -- Punto 10
 SELECT SUM(Pagos.Importe) FROM Pagos WHERE YEAR(Pagos.Fecha) = 2020
 -- Punto 11
 SELECT COUNT(*) FROM Usuarios
 INNER JOIN Instructores_x_Curso ON Instructores_x_Curso.IDUsuario = Usuarios.ID
 -- Punto 12
 SELECT DISTINCT COUNT(*) FROM Certificaciones
 -- Punto 13
 SELECT Paises.Nombre Pais , COUNT(Usuarios.ID) FROM Usuarios
 INNER JOIN Datos_Personales ON Usuarios.ID = Datos_Personales.ID
 INNER JOIN Localidades ON Datos_Personales.IDLocalidad = Localidades.ID
 INNER JOIN Paises ON Localidades.IDPais = Paises.ID
 GROUP BY Paises.Nombre
 -- Punto 14
 SELECT
 D.Apellidos AS apellidos,
 D.Nombres AS nombres,
 MAX(P.Importe) AS MaximoImporte
 FROM Datos_Personales D
 INNER JOIN Usuarios ON D.ID = Usuarios.ID
 INNER JOIN Inscripciones ON Usuarios.ID = Inscripciones.IDUsuario
 INNER JOIN Pagos P ON Inscripciones.ID = P.IDInscripcion
 GROUP BY 
 D.Apellidos,
 D.Nombres
 HAVING MAX(P.Importe) > 7500
 -- Punto 15
 SELECT 
 D.Apellidos,
 D.Nombres,
 MAX(I.Costo) AS CostoMaximo
 FROM Datos_Personales D
 INNER JOIN Usuarios ON Usuarios.ID = D.ID
 LEFT JOIN Inscripciones I ON I.IDUsuario = Usuarios.ID
 GROUP BY
     D.Apellidos,
     D.Nombres
 ORDER BY D.Apellidos ASC
 -- Punto 16
 SELECT
 C.Nombre,
 N.Nombre AS Nivel,
 COUNT(Clases.ID) AS Clases,
 SUM(Clases.Duracion) AS DuracionTotal
 FROM Cursos C
 LEFT JOIN Niveles N ON N.ID = C.IDNivel
 INNER JOIN Clases ON C.ID = Clases.IDCurso
 GROUP BY 
     C.Nombre,
     N.Nombre
 ORDER BY C.Nombre ASC
-- Punto 17
SELECT 
C.Nombre,
COUNT(Cont.ID) AS CantidadContenidos
FROM Cursos C
INNER JOIN Clases ON Clases.IDCurso = C.ID
INNER JOIN Contenidos Cont ON Clases.ID = Cont.IDClase
GROUP BY C.Nombre
HAVING COUNT(Cont.ID) > 10
-- Punto 18
SELECT
Cursos.Nombre,
Idiomas.Nombre,
COUNT(Idiomas_x_Curso.IDFormatoIdioma) AS CantidadFormatos
FROM Cursos
INNER JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
INNER JOIN FormatosIdioma ON FormatosIdioma.ID = Idiomas_x_Curso.IDFormatoIdioma
INNER JOIN Idiomas ON Idiomas.ID = Idiomas_x_Curso.IDIdioma
GROUP BY Cursos.Nombre, Idiomas.Nombre
-- Punto 19
SELECT
Cursos.Nombre,
COUNT(Distinct Idiomas_x_Curso.IDIdioma) as CantidadIdiomas
FROM Cursos
LEFT JOIN Idiomas_x_Curso ON Idiomas_x_Curso.IDCurso = Cursos.ID
GROUP BY Cursos.Nombre
ORDER BY Cursos.Nombre ASC
-- Punto 20
SELECT
Categorias.Nombre,
COUNT(DISTINCT Categorias_x_Curso.IDCurso) As CursosAsociados
FROM Categorias
INNER JOIN Categorias_x_Curso ON Categorias.ID = Categorias_x_Curso.IDCategoria
GROUP BY Categorias.Nombre
-- Punto 21
SELECT
TiposContenido.Nombre,
COUNT(Contenidos.ID) AS CantidadContenidos
FROM TiposContenido
LEFT JOIN Contenidos ON TiposContenido.ID = Contenidos.IDTipo
GROUP BY TiposContenido.Nombre
-- Punto 22
SELECT
Cursos.Nombre AS Nombre,
Niveles.Nombre AS Nivel,
Cursos.Estreno AS FechaEstreno,
SUM(Inscripciones.Costo) As TotalAcumulado
FROM Cursos
LEFT JOIN Niveles ON Cursos.IDNivel = Niveles.ID 
INNER JOIN Inscripciones ON Cursos.ID = Inscripciones.IDCurso
group by Cursos.Nombre, Niveles.Nombre, Cursos.Estreno
order by Cursos.Nombre asc
-- Punto 23
SELECT *
FROM Cursos c
LEFT JOIN Inscripciones i ON c.ID = i.IDCurso
INNER JOIN Usuarios u ON u.ID = i.IDUsuario
WHERE c.CostoCurso < 10000
order by c.Nombre asc

SELECT 
c.Nombre,
c.CostoCurso,
c.CostoCertificacion,
COUNT(distinct u.ID) as CantidadUsuarios
FROM Cursos c
LEFT JOIN Inscripciones i ON c.ID = i.IDCurso
LEFT JOIN Usuarios u ON u.ID = i.IDUsuario
WHERE c.CostoCurso < 10000000
group by 
c.Nombre,
c.CostoCurso,
c.CostoCertificacion
HAVING COUNT(distinct u.ID) < 5
order by c.Nombre asc

SELECT
c.Nombre,
i.IDUsuario
from Inscripciones i
right join Cursos c on i.IDCurso = c.ID
order by c.Nombre asc

SELECT 
*
FROM Cursos c
LEFT JOIN Inscripciones i ON c.ID = i.IDCurso
INNER JOIN Usuarios u ON u.ID = i.IDUsuario

SELECT 
*
FROM Cursos c
WHERE c.Nombre like '%Comportamiento%'

-- Punto 24
SELECT TOP 1
c.Nombre,
c.Estreno,
n.Nombre as Nivel,
SUM(i.Costo) as Acumulado
FROM Cursos c
inner JOIN Niveles n ON c.IDNivel = n.ID
LEFT JOIN Inscripciones i ON i.IDCurso = c.ID
group by 
c.Nombre,
c.Estreno,
n.Nombre
order by Acumulado desc

--SELECT 
--c.Nombre,
--c.Estreno,
--n.Nombre as Nivel,
--i.*
--FROM Cursos c
--inner JOIN Niveles n ON c.IDNivel = n.ID
--LEFT JOIN Inscripciones i ON i.IDCurso = c.ID
--order by c.Nombre asc

-- Punto 25
SELECT TOP 1
i.Nombre,
COUNT(*) as Cantidad
FROM Idiomas i
inner JOIN Idiomas_x_Curso on i.ID = Idiomas_x_Curso.IDIdioma
inner join FormatosIdioma on Idiomas_x_Curso.IDFormatoIdioma = FormatosIdioma.ID
where FormatosIdioma.Nombre like 'Subtitulo'
group by i.Nombre
order by Cantidad desc

-- Punto 26
SELECT
Cursos.Nombre,
AVG(Reseñas.Puntaje)
From Cursos
left join Inscripciones on Inscripciones.IDCurso = Cursos.ID
left join Reseñas on Reseñas.IDInscripcion = Inscripciones.ID
where Reseñas.Inapropiada = 0
group by Cursos.Nombre

-- Punto 27
SELECT
Usuarios.NombreUsuario,
COUNT(Reseñas.Puntaje) as Inapropiadas
FROM Usuarios
left join Inscripciones on Inscripciones.IDUsuario = Usuarios.ID
left join Reseñas on Reseñas.IDInscripcion = Inscripciones.ID
where Reseñas.Inapropiada = 1
group by Usuarios.NombreUsuario

--select
--*
--from Reseñas

-- Punto 28
SELECT
Cursos.Nombre  as Curso,
Datos_Personales.Nombres,
Datos_Personales.Apellidos,
COUNT(Inscripciones.ID) AS Reincidencias
from Inscripciones
inner join Usuarios on Usuarios.ID = Inscripciones.IDUsuario
inner join Datos_Personales on Usuarios.ID = Datos_Personales.ID
inner join Cursos on Inscripciones.IDCurso = Cursos.ID
group by Cursos.Nombre, Datos_Personales.Nombres, Datos_Personales.Apellidos


SELECT * FROM Inscripciones WHERE Inscripciones.IDUsuario = 22
SELECT * FROM Usuarios INNER JOIN Datos_Personales ON Datos_Personales.ID = Usuarios.ID

-- Punto 29
SELECT
Datos_Personales.Apellidos,
Datos_Personales.Nombres,
Datos_Personales.Email,
SUM(Clases.Duracion) AS DuracionTotal
from Inscripciones
inner join Usuarios on Inscripciones.IDUsuario = Usuarios.ID
inner join Datos_Personales on Usuarios.ID = Datos_Personales.ID
inner join Cursos on Inscripciones.IDCurso = Cursos.ID
inner join Clases on Clases.IDCurso = Cursos.ID
group by Datos_Personales.Apellidos,
Datos_Personales.Nombres,
Datos_Personales.Email
having SUM(Clases.Duracion) > 400

-- Punto 30
SELECT
Cursos.Nombre,
SUM(Cursos.CostoCurso + Cursos.CostoCertificacion) AS Recaudacion
FROM Inscripciones
inner join cursos on Cursos.ID = Inscripciones.IDCurso
group by Cursos.Nombre
order by Recaudacion Desc

SELECT
*
from Inscripciones
inner join cursos on Cursos.ID = Inscripciones.IDCurso