/****** Object:  Trigger [dbo].[LXU_ANM_PROP_PRODUCAO_ORDEM_SERVICO]    Script Date: 23/11/2016 18:17:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[LXU_ANM_PROP_PRODUCAO_ORDEM_SERVICO] ON [dbo].[PROP_PRODUCAO_ORDEM_SERVICO] FOR UPDATE
AS
BEGIN
	DECLARE @numrows int, @nullcnt int, @validcnt int, @errno int, @errmsg varchar(255)
	SELECT @numrows = @@rowcount


------ DATA ENTREGA/AJUSTADA - LUCAS MIRANDA - 23/11/2016
------ CHAMADO: 384162

if EXISTS( SELECT TOP 1 VALOR_PROPRIEDADE FROM Inserted A 
		 WHERE A.PROPRIEDADE = '00046'
			AND len(ltrim(rtrim(VALOR_PROPRIEDADE))) < 10
			 ) 
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Ano da Data Entrega está no formato errado. Favor Corrigir!'
      goto error
    end

if EXISTS( SELECT top 1 valor_propriedade 
		   FROM Inserted 
		   WHERE PROPRIEDADE = '00046' 
		   and substring(VALOR_PROPRIEDADE,7,11) < cast(year(getdate())-1 as varchar(4))
			 ) 
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Ano da Data Entrega com Ano anterior a '+cast(year(getdate())-1 as varchar(4))+'!!!'
      goto error
    end

if EXISTS( SELECT TOP 1 VALOR_PROPRIEDADE FROM Inserted A 
		 WHERE A.PROPRIEDADE = '00047'
			AND len(ltrim(rtrim(VALOR_PROPRIEDADE))) < 10
			 ) 
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Ano da Data Ajustada está no formato errado. Favor Corrigir!'
      goto error
    end

if EXISTS( SELECT top 1 valor_propriedade 
		   FROM Inserted 
		   WHERE PROPRIEDADE = '00047' 
		   and substring(VALOR_PROPRIEDADE,7,11) < cast(year(getdate())-1 as varchar(4))
			 ) 
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Ano da Data Ajustada com Ano anterior a '+cast(year(getdate())-1 as varchar(4))+'!!!'
      goto error
    end
------
	
	BEGIN TRY 
		SELECT CONVERT(NUMERIC(14,2),VALOR_PROPRIEDADE) FROM INSERTED WHERE PROPRIEDADE = '00053'
		RETURN
	END TRY
	BEGIN CATCH
		SELECT @errno = 30007, @errmsg = 'Impossível salvar, valor do frete não é um número. Favor corrigir!'
		GOTO error 
	END CATCH	
	
	if ( SELECT COUNT(*) FROM Inserted A 
			JOIN PRODUCAO_OS_TAREFAS B ON A.ORDEM_SERVICO = B.ORDEM_SERVICO
			JOIN PRODUCAO_ORDEM C ON B.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
		 WHERE A.PROPRIEDADE = '00052' AND C.STATUS <> 'E' AND
		       A.VALOR_PROPRIEDADE <> C.FILIAL_PRODUCAO ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Salvar, Filial esta diferente da Filial Ent. da OP.'+CHAR(13)+CHAR(13)
      goto error
    end

	if ( SELECT COUNT(*) FROM Inserted A 
			JOIN PRODUCAO_ORDEM_SERVICO B ON A.ORDEM_SERVICO = B.ORDEM_SERVICO
		  WHERE A.PROPRIEDADE = '00046' ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Alterar Entrega, já foi cadastrado.'+CHAR(13)+CHAR(13)
      goto error
    end


	return
error:
    raiserror @errno @errmsg
    rollback transaction

END

