--Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario devuelva el total abonado en concepto de pagos. Si no hay pagos debe retornar 0.

create procedure FN_PagosxUsuario( @IDUsuario int )
as
begin
	select SUM(P.Importe) from Pagos P
	left join Inscripciones I on I.ID = P.IDInscripcion
	WHERE I.IDUsuario = @IDUsuario
end

dbo.FN_PagosxUsuario(1)