--Hacer una funci�n llamada FN_PagosxUsuario que a partir de un IDUsuario devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.

create or alter function FN_PagosxUsuario ( @IDUsuario int )
returns money
as
begin
	declare @total money
	select @total = SUM(P.Importe) from Pagos P
	left join Inscripciones I on I.ID = P.IDInscripcion
	WHERE I.IDUsuario = @IDUsuario
	
	if @total is null
	begin
		set @total = 0
	end

	return @total
end

SELECT Usuarios.ID, dbo.FN_PagosxUsuario (Usuarios.ID) FROM Usuarios

--Hacer una funci�n llamada FN_DeudaxUsuario que a partir de un IDUsuario devuelva el total adeudado. Si no hay deuda debe retornar 0.
create or alter function FN_DeudaxUsuario ( @IDUsuario int)
returns money
as
begin

	declare @pagos money
	declare @deudas money

	select @pagos = dbo.FN_PagosxUsuario (@IDUsuario)
	select @deudas = SUM(I.Costo) from Usuarios U left join Inscripciones I on U.ID = I.ID left join Certificaciones C on C.IDInscripcion = I.ID WHERE I.IDUsuario = @IDUsuario
	
	if @deudas is null or @deudas >= 0
	begin
		select @deudas = 0
	end
	else
	begin
		select @deudas = @deudas - @pagos
	end

	return @deudas
end;

select U.ID, dbo.FN_DeudaxUsuario(U.ID) from Usuarios U

--Hacer una funci�n llamada FN_CalcularEdad que a partir de un IDUsuario devuelva la edad del mismo. La edad es un valor entero.
create or alter function FN_CalcularEdad ( @IDUsuario int)
returns int
as
begin
	declare @edad int
	declare @nacimiento date
	select @nacimiento = Datos_Personales.Nacimiento from Datos_Personales where Datos_Personales.ID  = @IDUsuario
	select @edad = YEAR(getdate()) - YEAR(@nacimiento)

	if ( MONTH(getdate()) < MONTH(@nacimiento) ) OR ( MONTH(getdate()) = MONTH(@nacimiento) AND DAY(getdate()) < DAY(@nacimiento) )
	begin
		select @edad = @edad - 1
	end
	
	return @edad
end

select DP.ID, dbo.FN_CalcularEdad(DP.ID) as Edad from Datos_Personales DP

--Hacer una funci�n llamada Fn_PuntajeCurso que a partir de un IDCurso devuelva el promedio de puntaje en concepto de rese�as.

create or alter function Fn_PuntajeCurso ( @IDCurso int )
returns decimal(3,1)
as
begin
	declare @promedio decimal(3,1)

	select @promedio = AVG(Rese�as.Puntaje) from Cursos
	left join Inscripciones on Inscripciones.IDCurso = Cursos.ID
	left join Rese�as on Rese�as.IDInscripcion = Inscripciones.ID
	where Cursos.ID = @IDCurso

	return @promedio
end

select Cursos.ID, dbo.Fn_PuntajeCurso(Cursos.ID) FROM Cursos

--Hacer una vista que muestre por cada usuario el apellido y nombre, una columna llamada Contacto que muestre el celular,
--si no tiene celular el tel�fono, si no tiene tel�fono el email, si no tiene email el domicilio.
--Tambi�n debe mostrar la edad del usuario, el total pagado y el total adeudado.

create or alter view Vw_Usuarios
as
select 
DP.Apellidos,
DP.Nombres,
COALESCE(DP.Celular, DP.Telefono, DP.Email, DP.Domicilio) as Contacto,
dbo.FN_CalcularEdad(U.ID) as Edad,
dbo.FN_PagosxUsuario(U.ID) as TotalPagado,
dbo.FN_DeudaxUsuario(U.ID) as TotalAdeudado
from Usuarios U
inner join Datos_Personales  DP on DP.ID = U.ID 

select * from Vw_Usuarios

--Hacer uso de la vista creada anteriormente para obtener la cantidad de usuarios que adeuden m�s de los que pagaron.

select COUNT(*) from Vw_Usuarios where Vw_Usuarios.TotalAdeudado > Vw_Usuarios.TotalPagado

--Hacer un procedimiento almacenado que permita dar de alta un nuevo curso.
--Debe recibir todos los valores necesarios para poder insertar un nuevo registro.

create or alter procedure SP_NuevoCurso
(
@Nombre varchar(100),
@CostoCurso money,
@CostoCertificacion money,
@Estreno date,
@DebeSerMayorDeEdad bit
)
as
begin
	insert into Cursos (Nombre, CostoCurso, CostoCertificacion, Estreno, DebeSerMayorDeEdad)
	values (@Nombre, @CostoCurso, @CostoCertificacion, @Estreno, @DebeSerMayorDeEdad)
end

EXEC SP_NuevoCurso 'Arte de la doma', 0, 5000, '2020-02-21', 0;

--Hacer un procedimiento almacenado que permita modificar porcentualmente el Costo de Cursada de todos los cursos. 
--El procedimiento debe recibir un valor numérico que representa el valor a aumentar porcentualmente. Por ejemplo, 
--si recibe un 60. Debe aumentar un 60% todos los costos.

create or alter procedure SP_AumentarCostos(@porcentaje float)
as
begin
	set @porcentaje = 1 + @porcentaje/100
	update Cursos
	set CostoCertificacion = CostoCertificacion * @porcentaje,
		CostoCurso = CostoCurso * @porcentaje
end

select * from Cursos

exec SP_AumentarCostos 50;

--Hacer un procedimiento almacenado llamado SP_PagarInscripcion que a partir de un IDInscripcion permita hacer un pago de la inscripción.
--El pago puede ser menor al costo de la inscripción o bien el total del mismo.
--El sistema no debe permitir que el usuario pueda abonar más dinero para una inscripción que el costo de la misma.
--Se debe registrar en la tabla de pagos con la información que corresponda.

create or alter procedure SP_PagarInscripcion (@IDInscripcion int , @importe money)
as
begin
	declare @IDUsuario int
	declare @costo money

	select @IDUsuario = Inscripciones.IDUsuario from Inscripciones where Inscripciones.ID = @IDInscripcion
	select @costo = Inscripciones.Costo from Inscripciones where Inscripciones.ID = @IDInscripcion

	if (@importe > @costo)
	begin
		raiserror('EL PAGO NO PUEDE SER MAYOR AL COSTO DE INSCRIPCION', 16, 0)
		return
	end
	else
	begin
		insert into Pagos (IDInscripcion, Fecha, Importe)
		values (@IDInscripcion, GETDATE(), @importe)
	end


end

exec SP_PagarInscripcion 2, 30000;
select * from Pagos

select Costo from Inscripciones where id = 1

--Hacer un procedimiento almacenado llamado SP_InscribirUsuario que reciba un IDUsuario y un IDCurso y realice la inscripción a dicho curso de ese usuario.
--El procedimiento debe realizar las siguientes comprobaciones:
-- - El usuario no debe registrar deuda para poder inscribirse.
-- - El usuario debe ser mayor de edad si el curso requiere esa condición.
--En caso que estas comprobaciones sean satisfechas entonces registrar la inscripción.
--Determinar el costo de la inscripción al valor actual del curso. Si alguna comprobación no se cumple, indicarlo con un mensaje de error correspondiente.

create or alter procedure SP_InscribirUsuario(@IDUsuario int, @IDCurso int)
as
begin
	declare @deuda money
	declare @edad int
	declare @mayordeedad bit
	select @deuda = dbo.FN_DeudaxUsuario(@IDUsuario)
	select @edad = dbo.FN_CalcularEdad(@IDUsuario)
	select @mayordeedad = DebeSerMayorDeEdad from Cursos where ID = @IDCurso
	
	if (@deuda != 0)
	begin
		raiserror('LA DEUDA DEL USUARIO DEBE SER $0 PARA INSCRIBIRSE NUEVAMENTE',16,0)
		return
	end

	if(@edad<18 AND @mayordeedad = 1)
	begin
		raiserror('EL USUARIO DEBE SER MAYOR DE EDAD PARA INGRESAR A ESTE CURSO',16,0)
		return
	end

	declare @costoinscripcion money
	select @costoinscripcion = CostoCurso from Cursos where ID = @IDCurso
	insert into Inscripciones (IDUsuario,IDCurso,Fecha,Costo)
	values(@IDUsuario, @IDCurso, GETDATE(), @costoinscripcion)

end

exec SP_InscribirUsuario 10, 10;