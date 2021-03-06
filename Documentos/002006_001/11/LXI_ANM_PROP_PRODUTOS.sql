
/****** Object:  Trigger [dbo].[LXI_ANM_PROP_PRODUTOS]    Script Date: 25/07/2016 16:35:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE trigger [dbo].[LXI_ANM_PROP_PRODUTOS] 
on [dbo].[PROP_PRODUTOS]
  for INSERT NOT FOR REPLICATION
  as

begin
  declare  @errno   int,  
           @errmsg  varchar(255)
---- #11 - LUCAS MIRANDA - 14/07/2016 - MELHORIA CAD
    if ( select COUNT(*) from inserted where propriedade = '00375' and isnull(VALOR_PROPRIEDADE,'') <> '' ) > 0
    begin
      UPDATE A SET ANM_DATA_STATUS_CAD = convert(varchar(10),getdate(),112)
			   FROM PRODUTOS A 
			   LEFT JOIN INSERTED B ON A.PRODUTO = B.PRODUTO AND B.PROPRIEDADE = '00375'
			   WHERE B.VALOR_PROPRIEDADE IS NOT NULL
    end

---- #11 - LUCAS MIRANDA - 14/07/2016 - MELHORIA CAD
    if ( select COUNT(*) from inserted where propriedade = '00376' and isnull(VALOR_PROPRIEDADE,'') <> '' ) > 0
    begin
      UPDATE A SET ANM_DATA_STATUS_MOST = convert(varchar(10),getdate(),112)
	  --convert(varchar(10),getdate(),112) 
			   FROM PRODUTOS A 
			   LEFT JOIN INSERTED B ON A.PRODUTO = B.PRODUTO AND B.PROPRIEDADE = '00376'
			   WHERE B.VALOR_PROPRIEDADE IS NOT NULL
    end
			
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end


