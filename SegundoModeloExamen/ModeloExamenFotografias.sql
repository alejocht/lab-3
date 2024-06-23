 --1) Hacer un procedimiento almacenado llamado SP_Descalificar que reciba un ID de
 --fotografía y realice la descalificación de la misma. También debe eliminar todas las
 --votaciones registradas a la fotografía en cuestión. Sólo se puede descalificar una
 --fotografía si pertenece a un concurso no finalizado.
 --(20 puntos)

 create or alter procedure SP_Descalificar (@IDFotografia bigint)
 as
 begin
	begin try
		begin transaction
			declare @IDConcurso bigint
			select @IDConcurso = IDConcurso from Fotografias where ID = @IDFotografia

			declare @FechaFin date
			select @FechaFin = Fin from Concursos where ID = @IDConcurso

			if(GETDATE() > @FechaFin)
			begin
				raiserror('Error: El concurso ya fue finalizado',16,1)
				return
			end

			update Fotografias set Descalificada = 1 where ID = @IDFotografia
			delete Votaciones where IDFotografia = @IDFotografia

		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
 end

 --2) Al insertar una fotografía verificar que el usuario creador de la fotografía tenga el
 --ranking suficiente para participar en el concurso. También se debe verificar que el
 --concurso haya iniciado y no finalizado. Si ocurriese un error, mostrarlo con un
 --mensaje aclaratorio. De lo contrario, insertar el registro teniendo en cuenta que la
 --fecha de publicación es la fecha y hora del sistema.
 --(30 puntos)

 create or alter trigger tr_insert on Fotografias
 after insert
 as
 begin
	begin try
		begin transaction
			declare @promedio decimal(5,2)
			declare @fechaInicio date
			declare @fechaFin date
			declare @IDConcurso bigint
			declare @IDFotografia bigint
			declare @RankingMinimo decimal(5,2)
			declare @IDRegistro bigint

			select @IDFotografia = ID from inserted
			select @IDConcurso = IDConcurso from inserted
			select @fechaFin = Fin, @fechaInicio = Inicio from Concursos where ID = @IDConcurso
			select @promedio = AVG(Puntaje) from Votaciones where IDFotografia = @IDFotografia
			select @RankingMinimo = RankingMinimo from Concursos where ID = @IDConcurso
			select @IDRegistro = ID from inserted

			if(@promedio < @RankingMinimo)
			begin
				raiserror('No tiene Ranking suficiente para este Concurso',16,1)
				return
			end

			if(GETDATE() not between @fechaInicio and @fechaFin)
			begin
				raiserror('Las inscripciones a este concurso no estan disponibles en este momento',16,1)
				return
			end

			update Fotografias set Publicacion = GETDATE() where ID = @IDRegistro

		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
 end

 -- 3) Al insertar una votación, verificar que el usuario que vota no lo haga más de una vez
 --para el mismo concurso ni se pueda votar a sí mismo. Tampoco puede votar una
 --fotografía descalificada. Si ninguna validación lo impide insertar el registro, de lo
 --contrario, informar un mensaje de error.
 --(20 puntos)

 create or alter trigger tr_insert_Votaciones on Votaciones
 after insert
 as
 begin
	begin try
		begin transaction
			declare @IDUsuariovotante bigint
			declare @IDConcurso bigint
			declare @IDFotografia bigint
			declare @IDUsuarioFotografia bigint
			declare @VotosXConcurso int

			select @IDUsuariovotante = IDVotante, @IDFotografia = IDFotografia from inserted
			select @IDConcurso = IDConcurso, @IDUsuarioFotografia = IDParticipante from Fotografias where ID = @IDFotografia

			select @VotosXConcurso = COUNT(*) from Votaciones inner join Fotografias on Votaciones.IDFotografia = Fotografias.ID where Fotografias.IDConcurso = @IDConcurso
			
			if(@VotosXConcurso > 1)
			begin
				raiserror('El Usuario ya voto en este Concurso',16,1)
				return
			end

			if(@IDUsuariovotante = @IDUsuarioFotografia)
			begin
				raiserror('El Usuario no puede votarse a si mismo',16,1)
				return
			end

			if((select Descalificada from Fotografias where ID = @IDFotografia) = 1)
			begin
				raiserror('No se puede votar Fotografias descalificadas',16,1)
				return
			end

		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
 end

 -- 4) Hacer un listado en el que se obtenga: ID de participante, apellidos y nombres de los
 --participantes que hayan registrado al menos dos fotografías descalificadas.
 --(10 puntos)

 select distinct ID as IDParticipante, Apellidos, Nombres from Participantes where (select COUNT(*) from Fotografias where IDParticipante = Participantes.ID and Descalificada = 1) >= 2

 -- 5) Agregar las tablas y restricciones que sean necesarias para poder registrar las
 --denuncias que un usuario hace a una fotografía. Debe poder registrar cuando realiza
 --la denuncia incluyendo fecha y hora. Se debe asegurar que se conozcan los datos del
 --usuario que denuncia la fotografía, como el usuario que publicó la fotografía y la
 --fotografía denunciada. También debe registrarse obligatoriamente un comentario a
 --la denuncia y una categoría de denuncia. Las categorías de denuncia habitualmente
 --son: Suplantación de identidad, Contenido inapropiado, Infringimiento de derechos
 --de autor, etc. Un usuario solamente puede denunciar una fotografía una vez.
 --(20 puntos)

 create table Categorias_Denuncias(
	ID int not null primary key,
	Nombre varchar(100) not null
 )

 create table Denuncias(
	ID bigint not null primary key,
	IDFotografia bigint not null foreign key references Fotografias(ID),
	IDDenunciante bigint not null foreign key references Participantes(ID),
	IDDenunciado bigint not null foreign key references Participantes(ID),
	FechaHora datetime not null,
	Comentario varchar(500) not null,
	IDCategoria int not null foreign key references Categorias_Denuncias(ID)
 )

 create or alter trigger tr_insert_denuncias on Denuncias
 after insert
 as
 begin
	begin try
		begin transaction
			declare @IDFotografia bigint
			declare @IDDenunciante bigint
			declare @IDDenunciado bigint
			declare @DenunciasDelusuarioAlaFotografia int
			declare @IDInsertado bigint
			select @IDFotografia = IDFotografia, @IDDenunciante = IDDenunciante from inserted
			select @IDDenunciado = IDParticipante from Fotografias where ID = @IDFotografia
			select @DenunciasDelusuarioAlaFotografia = COUNT(*) from Denuncias where @IDFotografia = IDFotografia and @IDDenunciante = IDDenunciante
			select @IDInsertado = ID from inserted

			if(@DenunciasDelusuarioAlaFotografia > 1)
			begin
				raiserror('El usuario solo puede denunciar una vez la fotografia',16,1)
				return
			end

			update Denuncias set IDDenunciado = @IDDenunciado where ID = @IDInsertado
			
		commit transaction
	end try
	begin catch
		print error_message()
		rollback transaction
	end catch
 end