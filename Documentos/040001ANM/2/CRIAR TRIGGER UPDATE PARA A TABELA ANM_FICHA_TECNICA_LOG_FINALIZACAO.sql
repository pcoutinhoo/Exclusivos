
/****** Object:  Trigger [dbo].[LXU_ANM_PRODUTOS_PRECOS]    Script Date: 16/08/2016 09:47:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[LXU_ANM_TB_BLOQ_FICHA_TECNICA_PA] 
ON [dbo].[ANM_TB_BLOQ_FICHA_TECNICA_PA]
FOR UPDATE NOT FOR REPLICATION
AS

begin


declare  @numrows int,
           @nullcnt int,
           @validcnt int, 
           @errno   int,
           @errmsg  varchar(255)

	 IF UPDATE(FINALIZA)
		BEGIN 
			INSERT INTO ANM_FICHA_TECNICA_LOG_FINALIZACAO
			 
			 SELECT A.PRODUTO,
					B.DATA_FINALIZACAO						AS DATA_FINALIZA_ANTES,
					B.FINALIZA								AS FINALIZA_ANTES,
					A.DATA_FINALIZACAO						AS DATA_FINALIZA_NOVO,
					A.FINALIZA								AS FINALIZA_NOVO,
					GETDATE()								AS DATA_HORA_ALTERAÇÃO,
					CONVERT(VARCHAR(240),SYSTEM_USER)	AS USUARIO_LINX,
					CONVERT(VARCHAR(30),host_name())  	AS NOME_COMPUTADOR
			 FROM inserted A JOIN deleted B ON A.PRODUTO = B.PRODUTO
			 WHERE A.FINALIZA <> B.FINALIZA
		END
	return
error:
    raiserror (@errmsg, 16, 1)
    rollback transaction

end






