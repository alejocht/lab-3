--create database SUBE
--go
use SUBE

create table Usuarios(
	ID bigint identity(1,1) not null primary key,
	Apellidos varchar(100) not null,
	Nombres varchar(100) not null,
	DNI int not null,
	FechaNacimiento date not null,
	Domicilio varchar(100) not null,
	Estado bit not null default 1
)
create table Tarjetas(
	ID bigint identity(1,1) not null primary key,
	IDUsuario bigint foreign key references Usuarios(ID) not null,
	FechaAlta date not null,
	Estado bit not null default 1
)
alter table Tarjetas
add Saldo money not null default 0

create table Lineas(
		ID int identity(1,1) not null primary key,
		Codigo varchar(8) null unique,
		Nombre varchar(100) not null,
		Domicilio varchar(100) not null
)
create table Colectivos(
	ID int identity(1,1) not null primary key,
	Interno int not null,
	IDLinea int not null foreign key references Lineas(ID),
	unique(Interno, IDLinea)
)
create table Viajes(
	ID bigint identity(1,1) not null primary key,
	FechaHora datetime not null,
	IDColectivo int not null foreign key references Colectivos(ID),
	IDTarjeta bigint not null foreign key references Tarjetas(ID),
	Importe money not null
)
create table Movimientos(
	ID bigint identity(1,1) not null primary key,
	FechaHora datetime not null,
	IDTarjeta bigint not null foreign key references Tarjetas(ID),
	Importe money not null,
	Tipo char not null
)

INSERT INTO Usuarios (Apellidos, Nombres, DNI, FechaNacimiento, Domicilio, Estado) VALUES
('González', 'Juan Carlos', 12345678, '1985-07-15', 'Av. Siempre Viva 123', 1),
('Fernández', 'María Eugenia', 23456789, '1990-05-21', 'Calle Falsa 456', 1),
('Martínez', 'José Luis', 34567890, '1982-09-30', 'Pasaje Los Olmos 789', 1),
('Rodríguez', 'Ana Sofía', 45678901, '1995-12-12', 'Boulevard del Sol 321', 1),
('López', 'Pedro Miguel', 56789012, '1978-02-25', 'Av. Libertador 654', 1),
('García', 'Lucía Victoria', 67890123, '1987-03-14', 'Calle de la Paz 987', 1),
('Sánchez', 'Carlos Alberto', 78901234, '1992-06-18', 'Av. Los Pinos 741', 1),
('Ramírez', 'Laura Isabel', 89012345, '1980-08-08', 'Callejón del Río 852', 1),
('Torres', 'Miguel Ángel', 90123456, '1989-11-22', 'Plaza Mayor 963', 1),
('Flores', 'Andrea Patricia', 12345098, '1984-04-27', 'Camino Real 147', 1);
INSERT INTO Tarjetas (IDUsuario, FechaAlta, Estado) VALUES
(1, '2023-01-15', 1),
(2, '2023-02-20', 1),
(3, '2023-03-25', 1),
(4, '2023-04-30', 1),
(5, '2023-05-10', 1),
(6, '2023-06-15', 1),
(7, '2023-07-20', 1),
(8, '2023-08-25', 1),
(9, '2023-09-30', 1),
(10, '2023-10-05', 1);
INSERT INTO Lineas (Codigo, Nombre, Domicilio) VALUES
('L123456', 'Linea Norte', 'Av. Libertad 123'),
('L234567', 'Linea Sur', 'Calle Principal 456'),
('L345678', 'Linea Este', 'Av. Independencia 789'),
('L456789', 'Linea Oeste', 'Calle Secundaria 321'),
('L567890', 'Linea Centro', 'Plaza Mayor 654'),
('L678901', 'Linea Suburbana', 'Camino Vecinal 987'),
('L789012', 'Linea Universitaria', 'Av. Universidad 741'),
('L890123', 'Linea Rural', 'Ruta Nacional 852'),
('L901234', 'Linea Industrial', 'Polígono Industrial 963'),
('L012345', 'Linea Turística', 'Boulevard Turístico 147');
INSERT INTO Colectivos (Interno, IDLinea) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(6, 3),
(7, 4),
(8, 4),
(9, 5),
(10, 5),
(11, 6),
(12, 6),
(13, 7),
(14, 7),
(15, 8),
(16, 8),
(17, 9),
(18, 9),
(19, 10),
(20, 10);
INSERT INTO Viajes (FechaHora, IDColectivo, IDTarjeta, Importe) VALUES
('2024-01-01 08:15:00', 1, 1, 30.00),
('2024-01-01 09:30:00', 2, 2, 25.50),
('2024-01-01 10:45:00', 3, 3, 40.00),
('2024-01-01 12:00:00', 4, 4, 35.75),
('2024-01-01 13:15:00', 5, 5, 28.00),
('2024-01-01 14:30:00', 6, 6, 32.50),
('2024-01-01 15:45:00', 7, 7, 27.00),
('2024-01-01 17:00:00', 8, 8, 31.25),
('2024-01-01 18:15:00', 9, 9, 29.50),
('2024-01-01 19:30:00', 10, 10, 26.75),
('2024-01-02 08:15:00', 11, 1, 30.00),
('2024-01-02 09:30:00', 12, 2, 25.50),
('2024-01-02 10:45:00', 13, 3, 40.00),
('2024-01-02 12:00:00', 14, 4, 35.75),
('2024-01-02 13:15:00', 15, 5, 28.00),
('2024-01-02 14:30:00', 16, 6, 32.50),
('2024-01-02 15:45:00', 17, 7, 27.00),
('2024-01-02 17:00:00', 18, 8, 31.25),
('2024-01-02 18:15:00', 19, 9, 29.50),
('2024-01-02 19:30:00', 20, 10, 26.75);
INSERT INTO Movimientos (FechaHora, IDTarjeta, Importe, Tipo) VALUES
('2024-01-01 08:00:00', 1, 100.00, 'C'),
('2024-01-01 08:30:00', 2, 50.00, 'D'),
('2024-01-01 09:00:00', 3, 150.00, 'C'),
('2024-01-01 09:30:00', 4, 75.00, 'D'),
('2024-01-01 10:00:00', 5, 200.00, 'C'),
('2024-01-01 10:30:00', 6, 100.00, 'D'),
('2024-01-01 11:00:00', 7, 250.00, 'C'),
('2024-01-01 11:30:00', 8, 125.00, 'D'),
('2024-01-01 12:00:00', 9, 300.00, 'C'),
('2024-01-01 12:30:00', 10, 150.00, 'D'),
('2024-01-02 08:00:00', 1, 50.00, 'C'),
('2024-01-02 08:30:00', 2, 25.00, 'D'),
('2024-01-02 09:00:00', 3, 75.00, 'C'),
('2024-01-02 09:30:00', 4, 37.50, 'D'),
('2024-01-02 10:00:00', 5, 100.00, 'C'),
('2024-01-02 10:30:00', 6, 50.00, 'D'),
('2024-01-02 11:00:00', 7, 125.00, 'C'),
('2024-01-02 11:30:00', 8, 62.50, 'D'),
('2024-01-02 12:00:00', 9, 150.00, 'C'),
('2024-01-02 12:30:00', 10, 75.00, 'D');

--A) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma debe contener:
--Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

create or alter view vw_PuntoA 
as 
select U.Apellidos, U.Nombres, T.ID as NumeroTarjeta, T.Estado as EstadoTarjeta, T.Saldo from Usuarios U
inner join Tarjetas T on U.ID = T.IDUsuario

select * from vw_PuntoA

--B) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma debe contener:
--Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje, número de interno y nombre de la línea.

create or alter view vw_PuntoB
as
select U.Apellidos, U.Nombres, T.ID as NumeroTarjeta, cast(V.FechaHora as date) as FechaViaje, V.Importe, C.Interno as NumeroInterno, L.Nombre as Linea from Usuarios U
inner join Tarjetas T on T.IDUsuario = U.ID
inner join Viajes V on V.IDTarjeta = T.ID
inner join Colectivos C on C.ID = V.IDColectivo
inner join Lineas L on L.ID = C.IDLinea

select * from vw_PuntoB

--C) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta.
--La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado (históricamente),
--cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.

create or alter view vw_PuntoC
as
select 
U.Apellidos,
U.Nombres,
(select COUNT(*) from Viajes where Viajes.IDTarjeta = T.ID) as CantidadDeViajes,
(select COALESCE(SUM(M.Importe),0) from Movimientos M WHERE M.Tipo like 'C' and M.IDTarjeta = T.ID) as TotalDineroAcreditado,
(select COUNT(*) FROM Movimientos M WHERE M.IDTarjeta = T.ID and M.Tipo like 'C') as CantidadRecargas,
(select AVG(M.Importe) from Movimientos M WHERE M.Tipo like 'C' and M.IDTarjeta = T.ID) as ImportePromedioRecarga,
T.Estado as Estado
from Tarjetas T
inner join Usuarios U on T.IDUsuario = U.ID

select * from vw_PuntoC

--A) Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario en el sistema.
--El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de nacimiento y los datos del domicilio del usuario.

create or alter procedure sp_Agregar_Usuario (
@DNI int,
@Apellido varchar(100),
@Nombre varchar(100),
@Nacimiento date,
@Domicilio varchar(100))
as
begin
	begin try
	begin transaction
		insert into Usuarios(DNI,Apellidos,Nombres,FechaNacimiento,Domicilio) values (@DNI, @Apellido,@Nombre,@Nacimiento,@Domicilio)
	commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end

EXEC sp_Agregar_Usuario 45003725, 'Chavez Tolosa','Alejo','2003-04-11','Lisandro de la Torre 1676'

select * from Usuarios

--B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El procedimiento solo debe recibir el DNI del usuario.
--Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).
--Dar de alta la nueva tarjeta del usuario
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)

create or alter procedure sp_Agregar_Tarjeta(
@ID int)
as
begin
	begin try
		begin transaction
		update Tarjetas set Estado = 0 where Tarjetas.IDUsuario = @ID
		declare @saldo money
		select @saldo = Tarjetas.Saldo from Tarjetas where Tarjetas.IDUsuario = @ID
		if (@saldo is null)
		begin
			 set @saldo = 0
		end
		insert into Tarjetas (IDUsuario, FechaAlta, Estado, Saldo) VALUES(@ID, GETDATE(), 1, @saldo)	
		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end

EXEC sp_Agregar_Tarjeta 2

select * from Tarjetas

--C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta en particular.
--El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de línea.
--El procedimiento deberá:
--Descontar el saldo
--Registrar el viaje
--Registrar el movimiento de débito
--NOTA: Una tarjeta no puede tener una deuda que supere los $2000.


create or alter procedure sp_Agregar_Viaje(@IDTarjeta bigint, @Importe money, @Interno int, @IDlinea int)
as
begin
	begin try
		begin transaction
			declare @saldoAntes money
			select @saldoAntes = saldo from Tarjetas where ID = @IDTarjeta
			if((@saldoAntes - @Importe) < -2000)
			begin
				raiserror('La deuda no puede ser mayor a $2000', 16, 0)
				return
			end
			update Tarjetas set saldo = Saldo - @Importe where ID = @IDTarjeta
			declare @IDColectivo int
			select @IDColectivo = ID from Colectivos where @Interno = Colectivos.Interno and @IDlinea = Colectivos.IDLinea
			insert into Viajes(FechaHora,IDColectivo,IDTarjeta,Importe) values (GETDATE(),@IDColectivo,@IDTarjeta,@Importe)
			insert into Movimientos(FechaHora,IDTarjeta,importe,tipo) values (GETDATE(),@IDTarjeta,@Importe,'D')
		commit transaction
	end try
	begin catch
		print error_message() 
		rollback transaction
	end catch
end

exec sp_Agregar_Viaje 1,2000,1,1

select * from Tarjetas
select * from Viajes
select * from Movimientos

--D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de crédito a una tarjeta en particular.
--El procedimiento debe recibir: El número de tarjeta y el importe a recargar. Modificar el saldo de la tarjeta.

create or alter procedure sp_Agregar_Saldo (@IDTarjeta bigint, @Importe money)
as
begin
	begin try
		begin transaction
			if(@Importe <= 0)
			begin	
				raiserror('La acreditacion debe ser positiva',16,0)
				return
			end
			insert into Movimientos(FechaHora,IDTarjeta,importe,tipo) values (GETDATE(),@IDTarjeta,@Importe,'C')
			update Tarjetas set Saldo = Saldo + @Importe where ID = @IDTarjeta
		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end

exec sp_Agregar_Saldo 1,100

select * from tarjetas
select * from Movimientos

--E) Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que elimine un usuario del sistema.
--La eliminación deberá ser 'en cascada'.
--Esto quiere decir que para cada usuario primero deberán eliminarse todos los viajes y recargas de sus respectivas tarjetas.
--Luego, todas sus tarjetas y por último su registro de usuario.

create or alter procedure sp_Baja_Fisica_Usuario(@ID bigint)
as
begin
	begin try
		begin transaction
			declare @tarjetausuario bigint
			select @tarjetausuario = ID from Tarjetas where IDUsuario = @ID
			delete Viajes where IDTarjeta = @tarjetausuario
			delete Movimientos where IDTarjeta = @tarjetausuario
			delete Tarjetas where IDUsuario = @ID
			delete Usuarios where ID = @ID
		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
end

exec sp_Baja_Fisica_Usuario 2

select * from Viajes
select * from Movimientos
select * from Tarjetas
select * from Usuarios



