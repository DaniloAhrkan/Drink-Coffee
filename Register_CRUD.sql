-------------------------------------------------------------------------
--Cria a tabela t_alunos
	if not exists(select * from INFORMATION_SCHEMA.tables where table_name = 't_alunos') 
	begin
	create table t_alunos
	(
		id_alunos integer identity(1,1) constraint PK_id_alunos primary key,
		nome_completo varchar(255) not null,
		data_de_nascimento varchar(10) not null,
		idade int null,
		inserir_genero int,
		email varchar(40),
		objetivo_da_graduacao varchar(1000) null
	)
	end
	go
-------------------------------------------------------------------------

-- drop table t_alunos

-------------------------------------------------------------------------
--Cria a Tabela t_genero
	if not exists(select * from INFORMATION_SCHEMA.tables where table_name = 't_genero')
	begin
	create table t_genero
	(
		id_genero integer identity(1,1)constraint PK_id_genero primary key,
		inserir_genero varchar(30)
	)

	end
	go
-------------------------------------------------------------------------



-------------------------------------------------------------------------
--Cria o FK caso ele não exista

	if not exists(select * from sys.foreign_keys where parent_object_id = OBJECT_ID('t_alunos') and name = 'FK_inserir_genero')
	begin
		alter table t_alunos
		add constraint FK_inserir_genero foreign key(inserir_genero) references t_genero(id_genero)
	end
	go
-------------------------------------------------------------------------

-- drop table t_genero

-------------------------------------------------------------------------
--Caso o masculino e feminino não estao criados, ele cria

	if not exists(select * from t_genero where inserir_genero = 'Masculino')
	begin
		insert into t_genero(inserir_genero) values('Masculino')
	end
	go

	if not exists(select * from t_genero where inserir_genero = 'Feminino')
	begin
		insert into t_genero(inserir_genero) values('Feminino')
	end
	go

	if not exists(select * from t_genero where inserir_genero = 'Feminino')
	begin
		insert into t_genero(inserir_genero) values('Transsexual')
	end
	go
-------------------------------------------------------------------------



-------------------------------------------------------------------------
--Cria Procedure para retornar genero é a dos Alunos para Aplicação
	if OBJECT_ID('sp_retorna_alunos') is not null
	begin
		drop procedure sp_retorna_alunos
	end
	go

	create procedure sp_retorna_alunos
	as
	begin 
		--Retorna os dados Localizados na t_alunos
		select * from t_alunos
	end
	go
	sp_retorna_alunos
	go
-------------------------------------------------------------------------
	if OBJECT_ID('sp_retorna_genero') is not null
	begin
		drop procedure sp_retorna_genero
	end
	go

	create procedure sp_retorna_genero
	as
	begin
		--Retorna os dados Localizados na t_genero
		select * from t_genero
	end
	go
	sp_retorna_genero
-------------------------------------------------------------------------



-------------------------------------------------------------------------
--Cria Procedure para inserir genero

	if OBJECT_ID('sp_inserir_genero') is not null
	begin

		drop procedure sp_inserir_genero
	end
	go

	create procedure sp_inserir_genero
	(
		@inserir_genero varchar(30)
	)
	as
	begin
		insert into t_genero(inserir_genero) values(@inserir_genero)
	end
	go
-------------------------------------------------------------------------

	-- ---------------------------------------------------------------
	-- CRIA FUNÇÃO QUE VALIDA SE UM TEXTO NAO CONTÉM NÚMEROS: 
	-- ---------------------------------------------------------------
	IF OBJECT_ID('FN_VALIDA_TEXTO_SEM_NUMERO') IS NOT NULL
	BEGIN
		DROP FUNCTION FN_VALIDA_TEXTO_SEM_NUMERO
	END
	GO

	CREATE FUNCTION FN_VALIDA_TEXTO_SEM_NUMERO
	(
		@TEXTO_A_VALIDAR VARCHAR(255)
	)
	RETURNS VARCHAR(30)
	AS
	BEGIN
		DECLARE @TEXTO_APENAS VARCHAR(30)
	
		SELECT @TEXTO_APENAS =
			CASE 
				WHEN @TEXTO_A_VALIDAR LIKE '%[0-9]%' 
				THEN 'POSSUI NUMEROS' 
				ELSE 'NÃO POSSUI NUMEROS' 
			END

		-- RETORNA: 0 --> POSSUI NÚMEROS NO TEXTO INFORMADO 
		-- RETORNA: 1 --> SOMENTE TEXTO( NÃO POSSUI NO TEXTO INFORMADO
		RETURN @TEXTO_APENAS
	END
	GO
	select dbo.FN_VALIDA_TEXTO_SEM_NUMERO ('1')
	-------------------------------------------------------------------------

	-- ---------------------------------------------------------------
	-- REGRA DE NEGÓCIO 4 - RETORNAR CARACTERES RESTANTES
	-- ---------------------------------------------------------------
	-- ---------------------------------------------------------------
	-- CRIA FUNÇÃO QUE RETORNA QUANTIDADE RESTANTES DISPONÍVES: 
	-- ---------------------------------------------------------------
	IF OBJECT_ID('FN_RESTAM_N_VALORES') IS NOT NULL
	BEGIN
		DROP FUNCTION FN_RESTAM_N_VALORES
	END
	GO

	CREATE FUNCTION FN_RESTAM_N_VALORES
	(
		@TEXTO_DIGITADO VARCHAR(1000),
		@QUANTIDADE_LIMITE INTEGER
	)
	RETURNS INTEGER
	AS
	BEGIN
		DECLARE @QUANTIDADE_DIGITADA INTEGER
		DECLARE @TOTAL_RESTANTE INTEGER

		SELECT @QUANTIDADE_DIGITADA = LEN( @TEXTO_DIGITADO )

		SET @TOTAL_RESTANTE = @QUANTIDADE_LIMITE - @QUANTIDADE_DIGITADA
	
		RETURN @TOTAL_RESTANTE
	END
	GO
	SELECT dbo.FN_RESTAM_N_VALORES( 'Professor Rodrigo Monteiro' , 1000 )
	-------------------------------------------------------------------------

	----------------------------------------------------------
	-- CRIA PROCEDURE PARA RETORNAR DADOS DOS ALUNOS
	----------------------------------------------------------
	IF OBJECT_ID('SP_RETORNA_DADOS_ALUNOS') IS NOT NULL
	BEGIN
		DROP PROCEDURE SP_RETORNA_DADOS_ALUNOS
	END
	GO

	CREATE PROCEDURE SP_RETORNA_DADOS_ALUNOS
	(
		@nome_completo VARCHAR(255) = ''
	)
	AS
	BEGIN
		IF @nome_completo = ''
			BEGIN
				SELECT * FROM t_alunos
			END
		ELSE
			BEGIN
				SELECT * FROM t_alunos WHERE nome_completo LIKE '%'+ @nome_completo + '%'
			END
	END
	GO
	SP_RETORNA_DADOS_ALUNOS 'Rodrigo'
	-------------------------------------------------------------------------

	----------------------------------------------------------
	-- CRIA PROCEDURE PARA RETORNAR DADOS DOS ALUNOS
	----------------------------------------------------------
	IF OBJECT_ID('SP_RETORNA_DADOS_ALUNOS') IS NOT NULL
	BEGIN
		DROP PROCEDURE SP_RETORNA_DADOS_ALUNOS
	END
	GO

	CREATE PROCEDURE SP_RETORNA_DADOS_ALUNOS
	(
		@NOME VARCHAR(255) = ''
	)
	AS
	BEGIN
		IF @NOME = ''
			BEGIN
				SELECT * FROM T_ALUNOS
			END
		ELSE
			BEGIN
				SELECT * FROM T_ALUNOS WHERE NOME_COMPLETO LIKE '%'+ @NOME + '%'
			END
	END

	GO

	----------------------------------------------------------
	-- CRIA PROCEDURE PARA INSERIR DADOS DOS ALUNOS
	----------------------------------------------------------
	IF OBJECT_ID('SP_INSERE_DADOS_ALUNOS') IS NOT NULL
	BEGIN
		DROP PROCEDURE SP_INSERE_DADOS_ALUNOS
	END
	GO

	CREATE PROCEDURE SP_INSERE_DADOS_ALUNOS
	(
		@NOME_COMPLETO			VARCHAR(255),
		@DATA_DE_NASCIMENTO		VARCHAR(10),
		@IDADE					INTEGER,
		@OBJETIVO_DA_GRADUACAO	VARCHAR(1000),
		@FK_ID_GENERO			INTEGER,
		@email varchar(40)
	)
	AS
	BEGIN
	SET NOCOUNT ON

	-- ---------------------------------------------------------------
	-- SE O CAMPO "NOME COMPLETO" FOR NULO OU VAZIO, RETORNA ERRO:
	-- ---------------------------------------------------------------
	IF ISNULL( LTRIM(RTRIM(@NOME_COMPLETO)), '' ) = '' 
		BEGIN
			-- ---------------------------------------------------------------
			-- SE NOME FOR NULO OU VAZIO, RETORNA ERRO:
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo [Nome Completo] deve ser preenchido.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- ---------------------------------------------------------------
	-- SE O CAMPO "DATA_DE_NASCIMENTO" FOR NULO OU VAZIO, RETORNA ERRO:
	-- ---------------------------------------------------------------
	IF ISNULL( LTRIM(RTRIM(@DATA_DE_NASCIMENTO)), '' ) = '' 
		BEGIN
			-- ---------------------------------------------------------------
			-- SE DATA DE NASCIMENTO FOR NULO OU VAZIO, RETORNA ERRO:
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo [Data de Nascimento] deve ser preenchido.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- ---------------------------------------------------------------
	-- SE O CAMPO "ID_GENERO" FOR NULO OU VAZIO, RETORNA ERRO:
	-- ---------------------------------------------------------------
	IF ISNULL( @FK_ID_GENERO, 0 ) <= 0 
		BEGIN
			-- ---------------------------------------------------------------
			-- SE DATA DE NASCIMENTO FOR NULO OU VAZIO, RETORNA ERRO:
			-- ---------------------------------------------------------------
			PRINT 'Erro: o Id do Gênero deve ser informado.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END
	IF ISNULL( LTRIM(RTRIM(@email)), '' ) = '' 
		BEGIN
			-- ---------------------------------------------------------------
			-- SE Email FOR NULO OU VAZIO, RETORNA ERRO:
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo [E-mail] deve ser preenchido.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END
	-- Erro
-------------------------------------------------------------------------

	-- ----------------------------------------------------------------
	-- REGRA DE NEGÓCIO 2
	-- ----------------------------------------------------------------
	-- NÃO DEVERÁ SER ACEITO NÚMEROS NO CAMPO [NOME_COMPLETO]
	-- ----------------------------------------------------------------
	DECLARE @TEXTO_APENAS VARCHAR(30)

	-- FUNÇÃO [FN_VALIDA_TEXTO_SEM_NUMERO ]
	EXECUTE @TEXTO_APENAS = FN_VALIDA_TEXTO_SEM_NUMERO @NOME_COMPLETO

	IF @TEXTO_APENAS = 'POSSUI NUMEROS'
		BEGIN
			-- ---------------------------------------------------------------
			-- SE EXISTE NUMEROS NO CAMPO NOME COMPLETO RETORNA ERRO:
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo Nome Completo deve ser preenchido sem números'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- -----------------------------------------------------------------------
	-- VALIDA FORMATO DATA ( DD/MM/AAAA
	-- -----------------------------------------------------------------------
	DECLARE @DATA_INVALIDA BIT
	SET @DATA_INVALIDA = 0

	IF ISNUMERIC(LEFT(@DATA_DE_NASCIMENTO, 2)) = 0
		BEGIN
			SET @DATA_INVALIDA = 1
		END 
	
	IF ISNUMERIC(SUBSTRING(@DATA_DE_NASCIMENTO, 4, 2 )) = 0
		BEGIN
			SET @DATA_INVALIDA = 1
		END 

	IF ISNUMERIC(RIGHT(@DATA_DE_NASCIMENTO, 4 )) = 0
		BEGIN
			SET @DATA_INVALIDA = 1
		END 

	IF SUBSTRING(@DATA_DE_NASCIMENTO, 3, 1 ) != '/'
		BEGIN
			SET @DATA_INVALIDA = 1
		END

	IF SUBSTRING(@DATA_DE_NASCIMENTO, 6, 1 ) != '/'
		BEGIN
			SET @DATA_INVALIDA = 1
		END

	IF @DATA_INVALIDA = 1
		BEGIN
			-- ---------------------------------------------------------------
			-- SE ALGUMA DAS VALIDACOES FOI POSITIVA, RETORNA ERRO
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo Data de Nascimento está fora do padrão DD/MM/AAAA.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- POSSIBILIDADE DE VALIDAR SE DIGITOS DO MÊS ENTRE 1 E 12

	-- POSSIBILIDADE DE VALIDAR SE DIGITOS DO MÊS ENTRE 1 E 31
-------------------------------------------------------------------------
-- -----------------------------------------------------------------------
	-- REGRA DE NEGÓCIO 3:
	-- -----------------------------------------------------------------------
	-- NUMERO DE CARACTERES POSSÍVEIS É (10) SENDO 8 NUMEROS E 2 ALFANUMERICOS(/)
	-- -----------------------------------------------------------------------

	IF LEN(@DATA_DE_NASCIMENTO) != 10
		BEGIN
			-- ---------------------------------------------------------------
			-- SE DATA DE NASCIMENTO FOR MENOR QUE 1950, RETORNA ERRO
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo Data de Nascimento informado deve conter 10 caracteres( DD/MM/AAAA ).'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- -----------------------------------------------------------------------
	-- REGRA DE NEGÓCIO 3:
	-- -----------------------------------------------------------------------
	-- MENOR DATA A SER ACEITA É 01/01/2015
	-- -----------------------------------------------------------------------

	IF RIGHT(@DATA_DE_NASCIMENTO, 4 ) < 1950
		BEGIN
			-- ---------------------------------------------------------------
			-- SE DATA DE NASCIMENTO FOR MENOR QUE 1950, RETORNA ERRO
			-- ---------------------------------------------------------------
			PRINT 'Erro: o campo Data de Nascimento informado deve ser maior que 01/01/1950.'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END

	-- -----------------------------------------------------------------------
	-- REGRA DE NEGÓCIO 4:
	-- -----------------------------------------------------------------------
	-- A IDADE DEVERÁ SER CALCULADA AUTOMATICAMENTE
	-- -----------------------------------------------------------------------
	
	DECLARE @DATA_CONVERTIDA VARCHAR(10)
	SET @DATA_CONVERTIDA = RIGHT(@DATA_DE_NASCIMENTO, 4) + '-' + 
							  SUBSTRING(@DATA_DE_NASCIMENTO, 4, 2 )+ '-' +
							  LEFT(@DATA_DE_NASCIMENTO, 2)   
							  	
	-- SELECT @DATA_CONVERTIDA 
	SET @IDADE = DATEDIFF( YEAR, @DATA_CONVERTIDA  , GETDATE() )
	-- SELECT @IDADE 
	-- -----------------------------------------------------------------------
	-- VALIDA SE O ID DO GÊNERO INFORMADO COINCIDE COM A TABELA DE GENEROS
	-- -----------------------------------------------------------------------
	IF NOT EXISTS( SELECT * FROM T_GENERO WHERE ID_GENERO = @FK_ID_GENERO )
		BEGIN
			-- ---------------------------------------------------------------
			-- SE ALGUMA DAS VALIDACOES FOI POSITIVA, RETORNA ERRO
			-- ---------------------------------------------------------------
			PRINT 'ERRO DE SISTEMA: o campo ID_GENERO informado deve existir na tabela T_GENERO'

			-- ---------------------------------------------------------------
			-- SAI DA PROCEDURE
			-- ---------------------------------------------------------------
			RETURN
		END
	
	----------------------------------------------------------------------------
	-- FINALMENTE INSERE OS DADOS!!!
	----------------------------------------------------------------------------
	BEGIN TRY
		INSERT INTO [T_ALUNOS]
		(
			NOME_COMPLETO,
			DATA_DE_NASCIMENTO,
			IDADE,
			inserir_genero,
			email,
			OBJETIVO_DA_GRADUACAO
			


		)
		VALUES
		(
			@NOME_COMPLETO,
			@DATA_DE_NASCIMENTO,
			@IDADE,
			@FK_ID_GENERO,
			@email,
			@OBJETIVO_DA_GRADUACAO
			
		)

		PRINT 'Registro inserido com sucesso na tabela [T_DADOS_ALUNOS] com o Id:' + CAST( @@IDENTITY AS VARCHAR(20) )

	END TRY
	BEGIN CATCH
		-- ---------------------------------------------------------------
		-- SE ALGUMA DAS VALIDACOES FOI POSITIVA, RETORNA ERRO
		-- ---------------------------------------------------------------
		SELECT ERROR_MESSAGE()
		
	END CATCH	

END
GO
