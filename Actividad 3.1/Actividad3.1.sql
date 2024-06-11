--Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.

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

--Hacer una función llamada FN_DeudaxUsuario que a partir de un IDUsuario devuelva el total adeudado. Si no hay deuda debe retornar 0.
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

--


