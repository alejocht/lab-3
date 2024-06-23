CREATE DATABASE MODELO_EXAMEN
GO
USE MODELO_EXAMEN

CREATE TABLE Materiales(
    IDMaterial SMALLINT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
)
CREATE TABLE Piezas(
    IDPieza BIGINT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(500) NOT NULL,
    IDMaterial SMALLINT NOT NULL FOREIGN KEY REFERENCES Materiales(IDMaterial),
    MedidaMinima DECIMAL(5,2) NOT NULL,
    MedidaMaxima DECIMAL(5,2) NOT NULL,
    CostoUnitarioProduccion MONEY NOT NULL
)
CREATE TABLE Operarios(
    IDOperario BIGINT NOT NULL PRIMARY KEY,
    Nombres VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(50) NOT NULL,
    AnioNacimiento SMALLINT NOT NULL,
    AnioAlta SMALLINT NOT NULL
)
CREATE TABLE Produccion(
    IDProduccion BIGINT NOT NULL,
    IDOperario BIGINT NOT NULL FOREIGN KEY REFERENCES Operarios(IDOperario),
    IDPieza BIGINT NOT NULL FOREIGN KEY REFERENCES Piezas(IDPieza),
    Fecha DATE NOT NULL,
    Medida DECIMAL(5,3) NOT NULL,
    Cantidad INT NOT NULL,
    CostoTotal MONEY NOT NULL
)

--1) La fábrica quiere evitar que empleados sin experiencia mayor a 5 años puedan
-- generar producciones de piezas cuyo costo unitario de producción supere los $ 15.
-- Hacer un trigger que asegure esta comprobación para registros de producción cuya
-- fecha sea mayor a la actual. En caso de poder registrar la información, calcular el
-- costo total de producción.
-- (30 puntos)

CREATE OR ALTER TRIGGER TR_PUNTO_1 ON Produccion
AFTER INSERT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			declare @fechaProduccion date
			select @fechaProduccion = Fecha from inserted
			
			declare @IDPieza bigint
			select @IDPieza = IDPieza from inserted

			declare @costodelapieza money
			select @costodelapieza = CostoUnitarioProduccion from Piezas where IDPieza = @IDPieza

			if(@fechaProduccion > GETDATE())
			begin
				declare @IDOperario bigint
				declare @experiencia int
				
				select @IDOperario = IDOperario from inserted
				set @experiencia = year(GETDATE()) - (select AnioAlta from Operarios where IDOperario = @IDOperario)
				
				if(@experiencia <= 5 and @costodelapieza > 15)
				begin
					raiserror('ERROR: No se cumplen las condiciones para cargar la produccion',16,0)
					return
				end
			end

			declare @IDProduccion bigint
			select @IDProduccion = IDProduccion from inserted
			declare @Cantidad int
			select @Cantidad = Cantidad from inserted

			update Produccion set CostoTotal = (@costodelapieza * @Cantidad) where IDProduccion = @IDProduccion

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH
END

 --2) Hacer un listado que permita visualizar el nombre del material, el nombre de la pieza
 --y la cantidad de operarios que nunca produjeron esta pieza.
 --(20 puntos)

 create or alter view vw_Punto_2
 as
 select
 Materiales.Nombre AS NombreMaterial,
 Piezas.Nombre AS NombrePieza,
 (select COUNT(distinct IDOperario)
 from Operarios
 where IDOperario not in
 (select IDOperario
 from Produccion
 where IDPieza = Piezas.IDPieza
 )
 )  as OperariosQueNoloProdujeron
 from Materiales
 inner join Piezas on Materiales.IDMaterial = Piezas.IDMaterial

--  3) Hacer un procedimiento almacenado llamado Punto_3 que reciba el nombre de un
-- material y un valor porcentual (admite 2 decimales) y modifique el precio unitario de
-- producción a partir de este valor porcentual a todas las piezas que sean de este
-- material.
-- Por ejemplo:
--Si el procedimiento recibe 'Acero' y 50. Debe aumentar el precio unitario de
-- producción de todas las piezas de acero en un 50%.
--Si el procedimiento recibe 'Vidrio' y-25. Debe disminuir el precio unitario de
-- producción de todas las piezas de vidrio en un 25%.
-- NOTA: No se debe permitir hacer un descuento del 100% ni un aumento mayor al
-- 1000%.
-- (20 puntos)

create or alter procedure Punto_3 (@nombre varchar(50), @porcentaje decimal(5,2))
as
begin
	begin try
		begin transaction
			if(@porcentaje = -100.00 or @porcentaje >= 1000.00)
			begin
				raiserror('Porcentaje fuera de rango',16,0)
				return
			end
			declare @IDMaterial smallint
			select @IDMaterial = IDMaterial from Materiales where Nombre like @nombre

			update Piezas set CostoUnitarioProduccion = CostoUnitarioProduccion * (1 + @porcentaje/ 100) where IDMaterial = @IDMaterial
		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end

 --4) Hacer un procedimiento almacenado llamado Punto_4 que reciba dos fechas y
 --calcule e informe el costo total de todas las producciones que se registraron entre
 --esas fechas.
 --(10 puntos)

 create or alter procedure Punto_4 (@fecha1 date, @fecha2 date)
 as
 begin
	if(@fecha1 > @fecha2)
	begin
		select SUM(CostoTotal) from Produccion where Fecha between @fecha2 and @fecha1
	end
	else
	begin
		select SUM(CostoTotal) from Produccion where Fecha between @fecha1 and @fecha2
	end	
 end

 --5) Hacer unlistado que permita visualizar el nombre de cada material y el costo total de
 --las producciones estropeadas de ese material. Sólo listar aquellos registros que
 --totalicen un costo total mayor a $100.
 --(20 puntos)

 create or alter view Punto_5
 as
 select
 M.Nombre,
 (select SUM(CostoTotal) from Produccion
 inner join Piezas on Piezas.IDPieza = Produccion.IDPieza
 where IDMaterial = M.IDMaterial and
 Medida not between MedidaMinima and MedidaMaxima) as CostoTotalEstropeado
 from Materiales M


 INSERT INTO Materiales (IDMaterial, Nombre) VALUES
(1, 'Acero'),
(2, 'Aluminio'),
(3, 'Cobre'),
(4, 'Plástico'),
(5, 'Vidrio');

INSERT INTO Piezas (IDPieza, Nombre, IDMaterial, MedidaMinima, MedidaMaxima, CostoUnitarioProduccion) VALUES
(1001, 'Tornillo', 1, 0.50, 1.50, 0.10),
(1002, 'Tuerca', 1, 0.30, 1.00, 0.05),
(1003, 'Arandela', 2, 0.10, 0.80, 0.02),
(1004, 'Clavo', 3, 1.00, 3.00, 0.07),
(1005, 'Perno', 1, 2.00, 4.00, 0.15);

INSERT INTO Operarios (IDOperario, Nombres, Apellidos, AnioNacimiento, AnioAlta) VALUES
(5001, 'Juan', 'Pérez', 1985, 2010),
(5002, 'Ana', 'Gómez', 1990, 2012),
(5003, 'Luis', 'Martínez', 1978, 2005),
(5004, 'Carlos', 'López', 1982, 2008),
(5005, 'María', 'Rodríguez', 1995, 2015);

INSERT INTO Produccion (IDProduccion, IDOperario, IDPieza, Fecha, Medida, Cantidad, CostoTotal) VALUES
(20001, 5001, 1001, '2023-01-15', 1.20, 100, 10.00),
(20002, 5002, 1002, '2023-02-20', 0.90, 200, 10.00),
(20003, 5003, 1003, '2023-03-10', 0.70, 150, 3.00),
(20004, 5004, 1004, '2023-04-25', 2.50, 250, 17.50),
(20005, 5005, 1005, '2023-05-30', 3.50, 50, 7.50);


insert into Produccion (IDProduccion, IDOperario, IDPieza, Fecha, Medida, Cantidad, CostoTotal) values (20006, 5001, 1001, '2025-01-15', 1.20, 100, 0.00)
select * from Produccion

select * from vw_Punto_2

select * from Piezas where IDMaterial = 1
exec Punto_3 'Acero', 50

exec Punto_4 '2021-01-15', '2026-01-15'

select * from Punto_5
