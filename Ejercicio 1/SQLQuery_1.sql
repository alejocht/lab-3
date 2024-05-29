/*use primer_ejercicio
drop TABLE Empleados
GO*/
use primer_ejercicio
GO
CREATE TABLE Idiomas(
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(Nombre)
)
CREATE TABLE Nivel(
    IDNivel SMALLINT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY(IDNivel)
)
CREATE TABLE Empleados(
    DNI SMALLINT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Idioma VARCHAR(50) NOT NULL,
    Nivel SMALLINT NOT NULL,
    PRIMARY KEY(DNI, Idioma),
    CONSTRAINT FK_IDIOMA FOREIGN KEY (Idioma)
    REFERENCES Idiomas (Nombre),
    CONSTRAINT FK_NIVEL FOREIGN KEY (Nivel)
    REFERENCES Nivel (IDNivel)
    
)
