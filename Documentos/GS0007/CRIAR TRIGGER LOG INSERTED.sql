USE [TESTE_SOMA]
GO
/****** Object:  Trigger [dbo].[LXI_PRODUTOS_PRECO_LOG]    Script Date: 23/09/2016 09:18:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[LXI_ANM_CLIENTE_ATAC_LIMITE_CREDITO] 
ON [dbo].[ANM_CLIENTE_ATAC_LIMITE_CREDITO]
FOR INSERT NOT FOR REPLICATION
AS
/* INSERT trigger on PRODUTOS_PRECO_LOG */
/* default body for LXI_PRODUTOS_PRECO_LOG */
begin
	
 declare  @numrows int,
           @nullcnt int,
           @validcnt int, 
           @errno   int,
           @errmsg  varchar(255)
		  
	-- IF UPDATE(FINALIZA)
		BEGIN 
			INSERT INTO ANM_LOG_CLIENTE_ATAC_LIMITE_CREDITO
			 
			 SELECT A.REDE_LOJAS,
					A.COLECAO,
					A.COD_CLIENTE,
					NULL									AS LIMITE_ANTES,
					A.LIMITE								AS LIMITE_NOVO,
					GETDATE()								AS DATA_HORA_ALTERAÇÃO,
					CONVERT(VARCHAR(240),SYSTEM_USER)		AS USUARIO_LINX,
					CONVERT(VARCHAR(30),host_name())  		AS NOME_COMPUTADOR,
					'I'										AS TRIGGER_ORIGEM
			 FROM inserted A 
			 --JOIN deleted B ON A.PRODUTO = B.PRODUTO
			 --WHERE A.FINALIZA <> B.FINALIZA
		END
	return
error:
    raiserror (@errmsg, 16, 1)
    rollback transaction

end